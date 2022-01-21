package main

import (
	"net/http"
)

func health(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("ok"))
}

func main() {
	http.Handle("/", http.FileServer(http.Dir("/html")))
	http.HandleFunc("/health", health)
	if err := http.ListenAndServe(":5000", nil); err != nil {
		panic(err)
	}
}
