package main

import (
	"context"
	"log"
	"net/http"
	"time"
	"strings" 
	"strconv"
	"os"

	"github.com/go-redis/redis/v8"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	ctx           = context.Background()
	redisClient   *redis.Client
	redisMemUsage = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "redis_memory_usage_bytes",
		Help: "Current memory usage in bytes by Redis",
	})
	connectedClients = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "redis_connected_clients",
		Help: "Number of clients connected to Redis",
	})
)

func init() {
	prometheus.MustRegister(redisMemUsage)
	prometheus.MustRegister(connectedClients)

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

func main() {
	go recordRedisMetrics()

	http.Handle("/metrics", promhttp.Handler())
	log.Println("Exporter is running on port 2112")
	http.ListenAndServe(":2112", nil)
}
