FROM golang:1.19 AS base

# Set destination for COPY
WORKDIR /app

# Download Go modules
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY cmd ./cmd/
COPY pkg ./pkg/

# Build
RUN CGO_ENABLE=0 GOOS=linux go build -o bin/webrtc-server -ldflags "-s -w" cmd/server/main.go


# Discard the sourcecode and only keep configs and the executable in the final stage
FROM golang:1.19
WORKDIR /app
COPY --from=base /app/bin/webrtc-server ./bin/webrtc-server
RUN mkdir /app/configs
RUN touch /app/configs/config.ini
RUN rm /app/configs/config.ini
#COPY web ./web/

# Run
CMD ["bin/webrtc-server"]
