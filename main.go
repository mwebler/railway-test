package main

import (
	"fmt"
	"net/http"
)

func index(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Received request from", r.RemoteAddr)
	fmt.Fprintf(w, "Hello, World!")
}

func main() {
	http.HandleFunc("/", index)
	fmt.Println("Starting server on port 8080")
	http.ListenAndServe(":8080", nil)
}
