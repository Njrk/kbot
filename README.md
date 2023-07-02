# Open-telemetry observability

Sample configuration for Kbot that send logs to [OpenTelemetry Collector] and metrics to [OpenTelemetry Collector] or [Prometheus].

## Prerequisites

- [Docker]
- [Docker Compose]

## How to run

1. Add telegram token
```bash
read -s TELE_TOKEN
export TELE_TOKEN
```
2. Add a password for Grafana
```bash
read -s GF_PASSWORD
export GF_PASSWORD
```
3. Run docker-compose
```bash
docker-compose -f otel/docker-compose.yaml up -d
```
## Demo

Created data sources:  
![Data source](.data/gf1.png)

Explore metrics Prometheus:  
![Explore metrics](.data/gf2.png)

Explore logs Loki:  
![Explore logs](.data/gf3.png)

Log parsing:  
![Log parsing](.data/gf4.png)
