package main

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/RogueConsultingDev/mime-common/http/middlewares"
)

type Response struct {
	Message string `json:"message"`
}

func CreateRouter() *gin.Engine {
	router := gin.New()
	router.Use(middlewares.LoggingMiddleware(), gin.Recovery())

	router.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, Response{Message: "Hello World"})
	})

	return router
}
