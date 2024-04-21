package main

import (
	"fmt"
	"math/rand"
	"net/http"
	"os"
)

func index(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Received request from", r.RemoteAddr)
	fmt.Fprintf(w, "Hello, World!")
}

func status(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Received request from", r.RemoteAddr)
	fmt.Fprintf(w, "OK")
}

func cache(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Received request from", r.RemoteAddr)
	fmt.Fprintf(w, "Cache this response: %d", rand.Intn(1000))
}

func main() {
	http.HandleFunc("/", index)
	http.HandleFunc("/status", status)
	http.HandleFunc("/cache-this", cache)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Println("Starting server on port", port)
	http.ListenAndServe(":"+port, nil)
}
