package main

import (
	"context"
	"log"
	"net/http"
	"time"
	"strings" 
	"strconv"
	"os"
	"path/filepath"


	"github.com/go-redis/redis/v8"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	metricsv "k8s.io/metrics/pkg/client/clientset/versioned"
	corev1 "k8s.io/api/core/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/apimachinery/pkg/api/resource"
	"k8s.io/client-go/rest"
)

var (
	ctx           = context.Background()
	redisClient   *redis.Client
	redisMemUsage = prometheus.NewGauge(
		prometheus.GaugeOpts{
		Name: "redis_memory_usage_bytes",
		Help: "Current memory usage in bytes by Redis",
		}
	)
	connectedClients = prometheus.NewGauge(
		prometheus.GaugeOpts{
		Name: "redis_connected_clients",
		Help: "Number of clients connected to Redis",
		}
	)

	podCPUUsage = prometheus.NewGaugeVec(
		prometheus.GaugeOpts{
			Name: "pod_cpu_usage_cores",
			Help: "Current CPU usage of the pod in cores.",
		},
		[]string{"pod", "namespace"},
	)
	podMemoryUsage = prometheus.NewGaugeVec(
		prometheus.GaugeOpts{
			Name: "pod_memory_usage_bytes",
			Help: "Current memory usage of the pod in bytes.",
		},
		[]string{"pod", "namespace"},
	)
	podStatus = prometheus.NewGaugeVec(
		prometheus.GaugeOpts{
			Name: "pod_status",
			Help: "Current status of the pod: Running=1, Pending=0, Failed=-1.",
		},
		[]string{"pod", "namespace"},
	)
	podEventWarnings = prometheus.NewGaugeVec(
		prometheus.GaugeOpts{
			Name: "pod_event_warnings",
			Help: "Count of warning or error events for the pod.",
		},
		[]string{"pod", "namespace"},
	)

)

func init() {
	prometheus.MustRegister(redisMemUsage)
	prometheus.MustRegister(connectedClients)
	prometheus.MustRegister(podCPUUsage)
	prometheus.MustRegister(podMemoryUsage)
	prometheus.MustRegister(podStatus)
	prometheus.MustRegister(podEventWarnings)

	redisClient = redis.NewClient(&redis.Options{
		Addr: "redis-master.default:6379", 
		Password: os.Getenv("REDIS_PASSWORD"),
	})
}

func recordRedisMetrics() {
	for {
		// Memóriahasználat lekérése
		info, err := redisClient.Info(ctx, "memory").Result()
		if err != nil {
			log.Printf("Error getting Redis memory info: %v", err)
			continue
		} else {
			log.Printf("Redis memory info: %s", info) 
		}
		redisMemUsage.Set(parseMemoryUsage(info))

		// Kapcsolódó kliensek száma
		clientInfo, err := redisClient.Info(ctx, "clients").Result()
		if err != nil {
			log.Printf("Error getting Redis client info: %v", err)
			continue
		} else {
			log.Printf("Redis client info: %s", clientInfo) 
		}
		connectedClients.Set(parseConnectedClients(clientInfo))

		time.Sleep(10 * time.Second)
	}
}

func parseMemoryUsage(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "used_memory:") {
			// Leválasztjuk a "used_memory:" előtagot, hogy csak az értéket kapjuk meg
			valueStr := strings.TrimPrefix(line, "used_memory:")
			valueStr = strings.TrimSpace(valueStr)
			log.Println("Memoryline értéke: ")
			log.Println(line)
			log.Println("MemoryValueSTR értéke:")
			log.Println(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing used_memory: %v", err)
				return 0.0
			}
			return value
		}
	}
	log.Println("used_memory not found in Redis memory info")
	return 0.0
}


func parseConnectedClients(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "connected_clients:") {
			// Leválasztjuk a "connected_clients:" előtagot, hogy csak az értéket kapjuk meg
			valueStr := strings.TrimPrefix(line, "connected_clients:")
			valueStr = strings.TrimSpace(valueStr)
			log.Println("Connectline értéke: ")
			log.Println(line)
			log.Println("ConnectValueSTR értéke:")
			log.Println(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing connected_clients: %v", err)
				return 0.0
			}
			return value
		}
	}
	log.Println("connected_clients not found in Redis client info")
	return 0.0 
}

func updatePodResourceMetrics(metricsClient *metricsv.Clientset, podName, namespace string) {
	podMetrics, err := metricsClient.MetricsV1beta1().PodMetricses(namespace).Get(context.TODO(), podName, metav1.GetOptions{})
	if err != nil {
		log.Printf("Error fetching metrics for pod %s: %v", podName, err)
		return
	}

	for _, container := range podMetrics.Containers {
		cpuUsage := parseResourceQuantity(container.Usage["cpu"])
		memoryUsage := parseResourceQuantity(container.Usage["memory"])

		podCPUUsage.WithLabelValues(podName, namespace).Set(cpuUsage / 1e9) 
		podMemoryUsage.WithLabelValues(podName, namespace).Set(memoryUsage) 
	}
}

func updatePodStatus(kubeClient *kubernetes.Clientset, podName, namespace string) {
	pod, err := kubeClient.CoreV1().Pods(namespace).Get(context.TODO(), podName, metav1.GetOptions{})
	if err != nil {
		log.Printf("Error fetching pod %s status: %v", podName, err)
		return
	}
	/*
	1 for Running.
    0 for Pending.
    -1 for Failed.
	*/
	status := 0.0 
	switch pod.Status.Phase {
	case corev1.PodRunning:
		status = 1.0
	case corev1.PodFailed:
		status = -1.0
	}

	podStatus.WithLabelValues(podName, namespace).Set(status)
}

func updatePodEventWarnings(kubeClient *kubernetes.Clientset, podName, namespace string) {
	events, err := kubeClient.CoreV1().Events(namespace).List(context.TODO(), metav1.ListOptions{
		FieldSelector: "involvedObject.name=" + podName,
	})
	if err != nil {
		log.Printf("Error fetching events for pod %s: %v", podName, err)
		return
	}

	warningCount := 0.0
	for _, event := range events.Items {
		if event.Type == "Warning" || event.Type == "Error" {
			warningCount++
		}
	}

	podEventWarnings.WithLabelValues(podName, namespace).Set(warningCount)
}

func parseResourceQuantity(quantity resource.Quantity) float64 {
	value, ok := quantity.AsInt64()
	if !ok {
		log.Printf("Error converting resource quantity: %v", quantity)
		return 0.0
	}
	return float64(value)
}

func homeDir() string {
	if h := os.Getenv("HOME"); h != "" {
		return h
	}
	return "/root"
}

func collectPodMetrics(kubeClient *kubernetes.Clientset, metricsClient *metricsv.Clientset, podName, namespace string) {
	for {
		updatePodResourceMetrics(metricsClient, podName, namespace)
		updatePodStatus(kubeClient, podName, namespace)
		updatePodEventWarnings(kubeClient, podName, namespace)
		time.Sleep(30 * time.Second)
	}
}

func recordKubernetesMetrics() {
	var config *rest.Config
	var err error

	if os.Getenv("KUBERNETES_SERVICE_HOST") != "" {
		config, err = rest.InClusterConfig()
		if err != nil {
			log.Fatalf("Error creating in-cluster config: %v", err)
		}
	} else {
		kubeconfig := filepath.Join(homeDir(), ".kube", "config")
		config, err = clientcmd.BuildConfigFromFlags("", kubeconfig)
		if err != nil {
			log.Fatalf("Error building kubeconfig: %v", err)
		}
	}

	kubeClient, err := kubernetes.NewForConfig(config)
	if err != nil {
		log.Fatalf("Error creating Kubernetes client: %v", err)
	}
	metricsClient, err := metricsv.NewForConfig(config)
	if err != nil {
		log.Fatalf("Error creating Metrics client: %v", err)
	}

	go collectPodMetrics(kubeClient, metricsClient, "redis-master-0", "default")
	go collectPodMetrics(kubeClient, metricsClient, "redis-replicas-0", "default")
}

func main() {
	go recordRedisMetrics()
	go recordKubernetesMetrics()

	http.Handle("/metrics", promhttp.Handler())
	log.Println("Exporter is running on port 2112")
	http.ListenAndServe(":2112", nil)
}
