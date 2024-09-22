# First stage - Build the Go app
FROM golang:1.22.5 AS base

WORKDIR /app

# Copy the go.mod file and download dependencies
COPY go.mod .

RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go application
RUN go build -o main .

# Final stage - Use a minimal distroless image
FROM gcr.io/distroless/base

# Copy the Go binary and static files from the build stage
COPY --from=base /app/main .
COPY --from=base /app/static ./static

# Expose port 8080
EXPOSE 8080

# Command to run the Go application
CMD ["./main"]
