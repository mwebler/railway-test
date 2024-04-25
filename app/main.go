package main

import (
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"os"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	httpRequestDuration = prometheus.NewHistogramVec(prometheus.HistogramOpts{
		Name:    "http_request_duration_seconds",
		Help:    "Duration of HTTP requests.",
		Buckets: prometheus.ExponentialBucketsRange(0.1, 5000, 10), // Adjust bucket sizes as needed
	}, []string{"route"})
)

func init() {
	prometheus.MustRegister(httpRequestDuration)
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	log.SetOutput(os.Stdout) // Ensuring all logs are sent to standard output
}

func loggingAndMetricsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		defer func() {
			duration := time.Since(start).Seconds()
			httpRequestDuration.WithLabelValues(r.URL.Path, w.).Observe(duration)
			log.Printf("HTTP Access Log: method=%s url=%s status=%d ip=%s duration=%.3f seconds\n",
				r.Method, r.URL.Path, http.StatusOK, r.RemoteAddr, duration)
		}()
		next.ServeHTTP(w, r)
	})
}

func main() {
	mux := http.NewServeMux()

	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Cache-Control", "no-store")
		w.Write([]byte("Hello, World!"))
	})

	mux.HandleFunc("/status", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Cache-Control", "no-store")
		w.Write([]byte("OK"))
	})

	mux.HandleFunc("/cache-this", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Cache-Control", "public, max-age=60")
		response := fmt.Sprintf("Cache this response for 60s: %d", rand.Intn(1000))
		w.Write([]byte(response))
	})

	mux.Handle("/metrics", promhttp.Handler())

	// Apply the middleware to all handlers
	decoratedMux := loggingAndMetricsMiddleware(mux)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	log.Printf("Starting server on port %s\n", port)
	log.Fatal(http.ListenAndServe(":"+port, decoratedMux))
}
