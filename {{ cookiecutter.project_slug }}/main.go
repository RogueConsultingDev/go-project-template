//go:build !test

package main

import (
	"fmt"
	"os"
)

func main() {
	router := CreateRouter()

	if err := router.Run("0.0.0.0:8080"); err != nil {
		fmt.Fprintf(os.Stderr, "Error running server: %s\n", err)
	}
}
