package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/go-redis/redis/v8"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	corev1 "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/api/resource"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
	metricsv "k8s.io/metrics/pkg/client/clientset/versioned"
)

var (
	ctx         = context.Background()
	redisClient *redis.Client
	//! Redis metrics
	redisMemUsage = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_memory_usage_bytes", // TODO fix 0 values
			Help: "Current memory usage in bytes by Redis (Bytes). This includes all memory allocations by Redis.",
		},
	)
	connectedClients = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_connected_clients",
			Help: "Number of clients connected to Redis (Count). This indicates the number of active connections.",
		},
	)
	cacheHitRate = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_cache_hit_rate",
			Help: "Cache hit rate of Redis (Ratio). This is the ratio of successful key lookups to total key lookups.",
		},
	)
	evictedKeys = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_evicted_keys",
			Help: "Number of keys evicted due to memory pressure (Count). This indicates how many keys were removed to free up memory.",
		},
	)
	expiredKeys = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_expired_keys",
			Help: "Number of keys that have expired (Count). This indicates how many keys have reached their expiration time.",
		},
	)
	keyspaceHits = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_keyspace_hits",
			Help: "Number of successful key lookups (Count). This indicates how many times a key was found in the database.",
		},
	)
	keyspaceMisses = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_keyspace_misses",
			Help: "Number of failed key lookups (Count). This indicates how many times a key was not found in the database.",
		},
	)
	totalCommandsProcessed = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_total_commands_processed",
			Help: "Total number of commands processed by the server (Count). This indicates the total workload handled by Redis.",
		},
	)
	instantaneousOpsPerSec = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_instantaneous_ops_per_sec",
			Help: "Number of commands processed per second (Ops/Sec). This indicates the current throughput of Redis.",
		},
	)
	replicationLag = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_replication_lag",
			Help: "Lag between master and replica nodes (Milliseconds). This indicates the delay in data replication.", // TODO fix incorrect implemantion logic off scrapping the value, the goal is to get how many bites does the replica is behind the master in bytes! Conjuction with the master_repl_offset and the slave_repl_offset.
		},
	)
	masterLinkStatus = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_master_link_status",
			Help: "Indicates whether the master-replica link is up (1) or down (0).",
		},
	)
	connectedSlaves = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_connected_slaves",
			Help: "Number of connected replicas (Count). This indicates how many replica nodes are connected to the master.",
		},
	)
	blockedClients = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_blocked_clients",
			Help: "Number of clients waiting for blocking commands (Count). This indicates how many clients are waiting for a blocking operation to complete.",
		},
	)
	rssMemoryUsage = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_rss_memory_usage_bytes",
			Help: "RSS (Resident Set Size) memory usage in bytes by Redis (Bytes). This indicates the amount of memory occupied by Redis in RAM.",
		},
	)
	memoryFragmentationRatio = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_memory_fragmentation_ratio",
			Help: "Memory fragmentation ratio of Redis (Ratio). This indicates the ratio of memory allocated by Redis to the memory actually used.",
		},
	)
	latency = prometheus.NewGauge(
		prometheus.GaugeOpts{
			Name: "redis_latency_seconds",
			Help: "Latency of Redis in seconds (Seconds). This indicates the time taken to process a command.",
		},
	)
	//! Kubernetes metrics
	podCPUUsage = prometheus.NewGaugeVec(
		prometheus.GaugeOpts{
			Name: "pod_cpu_usage_cores", // TODO fix 0 values, and rename to pod_cpu_usage_millicores, and convert to millicores, see https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu
			Help: "Current CPU usage of the pod in cores (Cores). This indicates the amount of CPU resources used by the pod.",
		},
		[]string{"pod", "namespace"},
	)
	podMemoryUsage = prometheus.NewGaugeVec(
		prometheus.GaugeOpts{
			Name: "pod_memory_usage_bytes",
			Help: "Current memory usage of the pod in bytes (Bytes). This indicates the amount of memory used by the pod.",
		},
		[]string{"pod", "namespace"},
	)
	podStatus = prometheus.NewGaugeVec(
		prometheus.GaugeOpts{
			Name: "pod_status", // TODO fix -1, 0 values are not showing up in Prometheus, even when forced recreate in lens see https://prometheus.io/docs/practices/naming/#metric-names
			Help: "Current status of the pod: Running=1, Pending=0, Failed=-1 (Status). This indicates the current state of the pod.",
		},
		[]string{"pod", "namespace"},
	)
	podEventWarnings = prometheus.NewGaugeVec(
		prometheus.GaugeOpts{
			Name: "pod_event_warnings",
			Help: "Count of warning or error events for the pod (Count). This indicates the number of warning or error events associated with the pod.",
		},
		[]string{"pod", "namespace"},
	)
)

func init() {
	prometheus.MustRegister(redisMemUsage)
	prometheus.MustRegister(connectedClients)
	prometheus.MustRegister(cacheHitRate)
	prometheus.MustRegister(evictedKeys)
	prometheus.MustRegister(expiredKeys)
	prometheus.MustRegister(keyspaceHits)
	prometheus.MustRegister(keyspaceMisses)
	prometheus.MustRegister(totalCommandsProcessed)
	prometheus.MustRegister(instantaneousOpsPerSec)
	prometheus.MustRegister(replicationLag)
	prometheus.MustRegister(masterLinkStatus)
	prometheus.MustRegister(connectedSlaves)
	prometheus.MustRegister(blockedClients)
	prometheus.MustRegister(rssMemoryUsage)
	prometheus.MustRegister(memoryFragmentationRatio)
	prometheus.MustRegister(latency)
	prometheus.MustRegister(podCPUUsage)
	prometheus.MustRegister(podMemoryUsage)
	prometheus.MustRegister(podStatus)
	prometheus.MustRegister(podEventWarnings)

	redisClient = redis.NewClient(&redis.Options{
		Addr:     "redis-master.default:6379",
		Password: os.Getenv("REDIS_PASSWORD"),
	})
}

func recordRedisMetrics() {
	for {
		// * Memóriahasználat lekérése
		info, err := redisClient.Info(ctx, "memory").Result()
		if err != nil {
			log.Printf("Error getting Redis memory info: %v", err)
			continue
		} else {
			log.Printf("Redis memory info: %s", info)
		}

		// * Kapcsolódó kliensek száma
		clientInfo, err := redisClient.Info(ctx, "clients").Result()
		if err != nil {
			log.Printf("Error getting Redis client info: %v", err)
			continue
		} else {
			log.Printf("Redis client info: %s", clientInfo)
		}
		replicationInfo, err := redisClient.Info(ctx, "replication").Result()
		if err != nil {
			log.Printf("Error getting Redis client info: %v", err)
			continue
		} else {
			log.Printf("Redis client info: %s", replicationInfo)
		}
		//* Cache hit rate, evicted keys, expired keys, keyspace hits and misses, total commands processed, instantaneous ops per sec, replication lag, connected slaves
		stats, err := redisClient.Info(ctx, "default").Result()
		if err != nil {
			log.Printf("Error getting Redis stats info: %v", err)
			continue
		}

		/* Latency
		latencyInfo, err := redisClient.Info(ctx, "latency").Result()
		if err != nil {
			log.Printf("Error getting Redis latency info: %v", err)
			continue
		}
		*/

		redisMemUsage.Set(parseMemoryUsage(info))
		connectedClients.Set(parseConnectedClients(clientInfo))
		// * New Redis metrics
		cacheHitRate.Set(parseCacheHitRate(stats))
		evictedKeys.Set(parseEvictedKeys(stats))
		expiredKeys.Set(parseExpiredKeys(stats))
		keyspaceHits.Set(parseKeyspaceHits(stats))
		keyspaceMisses.Set(parseKeyspaceMisses(stats))
		totalCommandsProcessed.Set(parseTotalCommandsProcessed(stats))
		instantaneousOpsPerSec.Set(parseInstantaneousOpsPerSec(stats))
		replicationLag.Set(parseReplicationLag(stats))
		masterLinkStatus.Set(parseMasterLinkStatus(replicationInfo))
		connectedSlaves.Set(parseConnectedSlaves(stats))
		blockedClients.Set(parseBlockedClients(stats))
		rssMemoryUsage.Set(parseRSSMemoryUsage(stats))
		memoryFragmentationRatio.Set(parseMemoryFragmentationRatio(stats))
		latency.Set(parseLatency(stats))

		time.Sleep(10 * time.Second)
	}
}

func parseMemoryUsage(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "used_memory:") {
			// * Leválasztjuk a "used_memory:" előtagot, hogy csak az értéket kapjuk meg
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
			// * Leválasztjuk a "connected_clients:" előtagot, hogy csak az értéket kapjuk meg
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
	   ! 1 for Running.
	   ! 0 for Pending.
	   ! -1 for Failed.
	*/
	status := 0.0
	switch pod.Status.Phase {
	case corev1.PodRunning:
		status = 1.0
	case corev1.PodFailed:
		status = 0.0
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

func parseCacheHitRate(info string) float64 {
	lines := strings.Split(info, "\n")
	var hits, misses float64
	for _, line := range lines {
		if strings.HasPrefix(line, "keyspace_hits:") {
			valueStr := strings.TrimPrefix(line, "keyspace_hits:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing keyspace_hits: %v", err)
				return 0.0
			}
			hits = value
		}
		if strings.HasPrefix(line, "keyspace_misses:") {
			valueStr := strings.TrimPrefix(line, "keyspace_misses:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing keyspace_misses: %v", err)
				return 0.0
			}
			misses = value
		}
	}
	if hits+misses == 0 {
		return 0.0
	}
	return hits / (hits + misses)
}

func parseEvictedKeys(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "evicted_keys:") {
			valueStr := strings.TrimPrefix(line, "evicted_keys:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing evicted_keys: %v", err)
				return 0.0
			}
			return value
		}
	}
	log.Println("evicted_keys not found in Redis stats info")
	return 0.0
}

func parseExpiredKeys(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "expired_keys:") {
			valueStr := strings.TrimPrefix(line, "expired_keys:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing expired_keys: %v", err)
				return 0.0
			}
			return value
		}
	}
	log.Println("expired_keys not found in Redis stats info")
	return 0.0
}

func parseKeyspaceHits(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "keyspace_hits:") {
			valueStr := strings.TrimPrefix(line, "keyspace_hits:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing keyspace_hits: %v", err)
				return 0.0
			}
			return value
		}
	}
	log.Println("keyspace_hits not found in Redis stats info")
	return 0.0
}

func parseKeyspaceMisses(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "keyspace_misses:") {
			valueStr := strings.TrimPrefix(line, "keyspace_misses:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing keyspace_misses: %v", err)
				return 0.0
			}
			return value
		}
	}
	log.Println("keyspace_misses not found in Redis stats info")
	return 0.0
}

func parseTotalCommandsProcessed(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "total_commands_processed:") {
			valueStr := strings.TrimPrefix(line, "total_commands_processed:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing total_commands_processed: %v", err)
				return 0.0
			}
			return value
		}
	}
	log.Println("total_commands_processed not found in Redis stats info")
	return 0.0
}

func parseInstantaneousOpsPerSec(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "instantaneous_ops_per_sec:") {
			valueStr := strings.TrimPrefix(line, "instantaneous_ops_per_sec:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing instantaneous_ops_per_sec: %v", err)
				return 0.0
			}
			return value
		}
	}
	log.Println("instantaneous_ops_per_sec not found in Redis stats info")
	return 0.0
}

func parseReplicationLag(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "master_repl_offset:") {
			valueStr := strings.TrimPrefix(line, "master_repl_offset:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing master_repl_offset: %v", err)
				return 0.0
			}
			return value
		}
	}
	log.Println("master_repl_offset not found in Redis stats info")
	return 0.0
}

func parseMasterLinkStatus(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "master_link_status:") {
			valueStr := strings.TrimPrefix(line, "master_link_status:")
			valueStr = strings.TrimSpace(valueStr)

			if valueStr == "up" {
				return 1.0 //! Master link is active
			} else if valueStr == "down" {
				return 0.0 //! Master link is down
			}
		}
	}
	log.Println("master_link_status not found in Redis replication info")
	return 0.0
}

func parseConnectedSlaves(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "connected_slaves:") {
			valueStr := strings.TrimPrefix(line, "connected_slaves:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing connected_slaves: %v", err)
				return 0.0
			}
			return value
		}
	}
	log.Println("connected_slaves not found in Redis stats info")
	return 0.0
}

func parseBlockedClients(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "blocked_clients:") {
			valueStr := strings.TrimPrefix(line, "blocked_clients:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing blocked_clients: %v", err)
				return 0.0
			}
			return value
		}
	}
	log.Println("blocked_clients not found in Redis client info")
	return 0.0
}

func parseRSSMemoryUsage(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "used_memory_rss:") {
			valueStr := strings.TrimPrefix(line, "used_memory_rss:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing used_memory_rss: %v", err)
				return 0.0
			}
			return value
		}
	}
	log.Println("used_memory_rss not found in Redis memory info")
	return 0.0
}

func parseMemoryFragmentationRatio(info string) float64 {
	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "mem_fragmentation_ratio:") {
			valueStr := strings.TrimPrefix(line, "mem_fragmentation_ratio:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing mem_fragmentation_ratio: %v", err)
				return 0.0
			}
			return value
		}
	}
	log.Println("mem_fragmentation_ratio not found in Redis memory info")
	return 0.0
}

func parseLatency(info string) float64 {
	var eventloopDurationSum, eventloopCycles float64

	lines := strings.Split(info, "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, "eventloop_duration_sum:") {
			valueStr := strings.TrimPrefix(line, "eventloop_duration_sum:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing eventloop_duration_sum: %v", err)
				return 0.0
			}
			eventloopDurationSum = value
		}
		if strings.HasPrefix(line, "eventloop_cycles:") {
			valueStr := strings.TrimPrefix(line, "eventloop_cycles:")
			valueStr = strings.TrimSpace(valueStr)
			value, err := strconv.ParseFloat(valueStr, 64)
			if err != nil {
				log.Printf("Error parsing eventloop_cycles: %v", err)
				return 0.0
			}
			eventloopCycles = value
		}
	}
	if eventloopDurationSum == 0 || eventloopCycles == 0 {
		log.Println("Could not find valid event loop metrics.")
		return 0.0
	}
	instanceLatency := eventloopDurationSum / eventloopCycles
	return instanceLatency / 1000
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
