FROM quay.io/projectquay/golang:1.20 as builder
WORKDIR /go/src/app
COPY . .
ARG CGO_ENABLED
ARG TARGETARCH
ARG TARGETOS
RUN make build CGO_ENABLED=$CGO_ENABLED TARGETARCH=$TARGETARCH TARGETOS=$TARGETOS

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./kbot", "start"]