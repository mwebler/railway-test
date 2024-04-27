FROM golang:1.22 as builder

# Set the Current Working Directory inside the container
WORKDIR /app


# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

# Stage 2: Build a small image
FROM alpine:latest

# install python for supervisord management
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python

# Install Grafana Agent
RUN wget https://github.com/grafana/agent/releases/download/v0.40.4/grafana-agent-linux-amd64.zip && \
    unzip grafana-agent-linux-amd64.zip && \
    mv grafana-agent-linux-amd64 /usr/local/bin/grafana-agent && \
    chmod +x /usr/local/bin/grafana-agent && \
    rm grafana-agent-linux-amd64.zip

# Install node_exporter
RUN wget https://github.com/prometheus/node_exporter/releases/download/v1.8.0/node_exporter-1.8.0.linux-amd64.tar.gz && \
    tar xvfz node_exporter-1.8.0.linux-amd64.tar.gz && \
    mv node_exporter-1.8.0.linux-amd64/node_exporter /usr/local/bin/ && \
    rm -rf node_exporter-1.8.0.linux-amd64.tar.gz node_exporter-1.8.0.linux-amd64

# Install system dependencies required for runtime
RUN apk --no-cache add ca-certificates supervisor libc6-compat

# Set working directory
WORKDIR /root/

# Copy the binary and monitoring tools from the builder stage
COPY --from=builder /app/main .

# Copy the Grafana Agent and Supervisor configuration files
COPY config/grafana-agent-config.yaml /etc/grafana-agent-config.yaml
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/manage-supervisord /usr/local/bin/manage-supervisord
RUN chmod +x /usr/local/bin/manage-supervisord

# Expose the port the app runs on
ARG PORT
EXPOSE ${PORT}

# Command to run Supervisor
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
