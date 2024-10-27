package main

import (
	"log"
	"net/http"
	"time"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	opsProcessed := prometheus.NewCounter(prometheus.CounterOpts{
		Name: "myapp_processed_ops_total",
		Help: "The total number of processed events",
	})

	prometheus.MustRegister(opsProcessed)

	go func() {
		for {
			opsProcessed.Inc()
			log.Println("Incremented myapp_processed_ops_total")
			time.Sleep(2 * time.Second)
		}
	}()

	http.Handle("/metrics", promhttp.Handler())
	log.Println("Exporter is running on port 2112")
	http.ListenAndServe(":2112", nil)
}
