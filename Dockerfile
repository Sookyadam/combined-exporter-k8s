FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o myapp_exporter
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/myapp_exporter .
CMD ["./myapp_exporter"]
