package main

import (
	"fmt"
	"math/rand"
	"net/http"
	"os"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func logMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Info().Msg("hi")
		next.ServeHTTP(w, r)

	})
}

func index(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Received request from", r.RemoteAddr)
	w.Header().Set("Cache-Control", "no-store")
	fmt.Fprintf(w, "Hello, World!")
}

func status(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Received request from", r.RemoteAddr)
	w.Header().Set("Cache-Control", "no-store")
	fmt.Fprintf(w, "OK")
}

func cache(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Received request from", r.RemoteAddr)
	w.Header().Set("Cache-Control", "public, max-age=60")
	fmt.Fprintf(w, "Cache this response for 60s: %d", rand.Intn(1000))
}

func main() {
	zerolog.TimeFieldFormat = zerolog.TimeFormatUnix

	http.HandleFunc("/status", status)
	http.HandleFunc("/cache-this", cache)
	http.HandleFunc("/", index)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Println("Starting server on port", port)
	http.ListenAndServe(":"+port, nil)
}