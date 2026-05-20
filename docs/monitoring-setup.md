Here is the **COMPLETE SINGLE DOCUMENT** combining both of your implementation guides. Every line, every dashboard, every query, every configuration is preserved.

---

# 🚀 **COMPLETE GRAFANA DASHBOARD IMPLEMENTATION & OBSERVABILITY STACK GUIDE**

## **Production-Grade Monitoring System for BloggySpace**

This is your **single source of truth** for setting up, configuring, and running your entire monitoring stack. It contains 100% of both implementation documents.

---

# 📚 **TABLE OF CONTENTS**

1. [Architecture Overview](#architecture-overview)
2. [Quick Start: Grafana Folders](#quick-start-grafana-folders)
3. [Dashboard 1: Production Overview](#dashboard-1-production-overview)
4. [Dashboard 2: Host Overview](#dashboard-2-host-overview)
5. [Dashboard 3: Container Resources](#dashboard-3-container-resources)
6. [Dashboard 4: Django API Metrics](#dashboard-4-django-api-metrics)
7. [Dashboard 5: PostgreSQL Database](#dashboard-5-postgresql-database)
8. [Dashboard 6: Nginx Performance](#dashboard-6-nginx-performance)
9. [Dashboard 7: User Analytics](#dashboard-7-user-analytics)
10. [Dashboard 8: Content Metrics](#dashboard-8-content-metrics)
11. [Dashboard 9: Log Explorer](#dashboard-9-log-explorer)
12. [Dashboard 10: Alert Status](#dashboard-10-alert-status)
13. [Dashboard 11: Capacity Planning](#dashboard-11-capacity-planning)
14. [SLOs, SLIs & SLA Definitions](#slos-slis--sla-definitions)
15. [Alert Rules & Slack Integration](#alert-rules--slack-integration)
16. [Query Reference Library](#query-reference-library)
17. [Alertmanager Configuration](#alertmanager-configuration)
18. [Maintenance & Runbooks](#maintenance--runbooks)
19. [Implementation Checklist](#implementation-checklist)

---

# 🏗️ **1. ARCHITECTURE OVERVIEW**

## **1.1 Component Stack**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           OBSERVABILITY STACK                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                         DATA COLLECTION                              │    │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐            │    │
│  │  │cAdvisor  │  │   Node   │  │  Django  │  │  Nginx   │            │    │
│  │  │Container │  │ Exporter │  │  Metrics │  │  Logs    │            │    │
│  │  │ Metrics  │  │   Host   │  │  Django  │  │  Access  │            │    │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘            │    │
│  │       │             │             │             │                   │    │
│  │       └─────────────┼─────────────┼─────────────┘                   │    │
│  │                     ▼             ▼                                 │    │
│  │              ┌──────────┐   ┌──────────┐                           │    │
│  │              │Prometheus│   │   Alloy  │                           │    │
│  │              │ Metrics  │   │   Log    │                           │    │
│  │              │ Storage  │   │ Collector│                           │    │
│  │              └────┬─────┘   └────┬─────┘                           │    │
│  │                   │             │                                   │    │
│  │                   ▼             ▼                                   │    │
│  │              ┌──────────┐   ┌──────────┐                           │    │
│  │              │          │   │   Loki   │                           │    │
│  │              │ Grafana  │◄──│   Log    │                           │    │
│  │              │   UI     │   │ Storage  │                           │    │
│  │              └──────────┘   └──────────┘                           │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                          ALERTING                                    │    │
│  │                                                                       │    │
│  │  Prometheus ──► Alertmanager ──► Slack (#alerts)                    │    │
│  │                     │                                                │    │
│  │                     └──► PagerDuty (on-call rotation)               │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## **1.2 Access URLs**

| Service | URL | Credentials |
|---------|-----|-------------|
| **Grafana** | `http://grafana.bloggyspace.local:8080` | admin / admin |
| **Prometheus** | `http://prometheus.bloggyspace.local:8080` | No auth |
| **Portainer** | `http://portainer.bloggyspace.local:8080` | First-time setup |
| **Loki API** | `http://loki:3100` | Internal only |

---

# 📁 **2. QUICK START: GRAFANA FOLDERS**

```bash
# In Grafana UI:
1. Click "Dashboards" (left sidebar)
2. Click "New" → "New folder"
3. Create these folders in order:

Folder 1: "00-Production Overview"
Folder 2: "01-Infrastructure"  
Folder 3: "02-Services"
Folder 4: "03-Business"
Folder 5: "04-Logs"
Folder 6: "05-Alerts"
Folder 7: "06-Capacity"
```

## **Complete Folder Hierarchy**

```
GRAFANA DASHBOARDS
│
├── 📁 00-Production Overview (1 dashboard)
│   └── 📊 Production Overview - Single pane of glass for everything
│
├── 📁 01-Infrastructure (3 dashboards)
│   ├── 📊 Host Overview - Server CPU, memory, disk, network
│   ├── 📊 Container Resources - Per-container CPU, memory, I/O
│   └── 📊 Prometheus Stats - Scrape health, targets, performance
│
├── 📁 02-Services (3 dashboards)
│   ├── 📊 Django API - Request rate, latency, errors, endpoints
│   ├── 📊 PostgreSQL Database - Connections, TPS, cache, locks
│   └── 📊 Nginx Performance - Active connections, status codes
│
├── 📁 03-Business (2 dashboards)
│   ├── 📊 User Analytics - DAU/WAU/MAU, registrations, retention
│   └── 📊 Content Metrics - Posts, comments, likes, engagement
│
├── 📁 04-Logs (1 dashboard)
│   └── 📊 Log Explorer - Centralized log viewing with Loki
│
├── 📁 05-Alerts (2 dashboards)
│   ├── 📊 Active Alerts - Current firing alerts with severity
│   └── 📊 Alert History - Historical alert trends and resolution
│
└── 📁 06-Capacity (2 dashboards)
    ├── 📊 Resource Trends - CPU/Memory/Disk usage over time
    └── 📊 Growth Forecasts - Predictions for next 30/60/90 days
```

---

# 📊 **3. DASHBOARD 1: PRODUCTION OVERVIEW**

### **Location:** `00-Production Overview` → `Production Overview`

### **Purpose:** Single pane of glass for everything

### **Row 1: Health Status**
```yaml
Type: Stat panels in a row

Panel 1: Overall Availability
Query: avg(up{job="backend"}) * 100
Unit: percent
Thresholds: 99.9 = green, 99 = yellow, <99 = red

Panel 2: Active Incidents
Query: count(ALERTS{alertstate="firing"})
Thresholds: 0 = green, >0 = red

Panel 3: Service Uptime (Backend)
Query: time() - container_start_time_seconds{container="dev-backend-1"}
Unit: seconds (convert to days/hours)

Panel 4: Current Error Rate
Query: (sum(rate(django_http_responses_total{status=~"5.."}[5m])) / sum(rate(django_http_responses_total[5m]))) * 100
Unit: percent
Thresholds: <1 = green, 1-5 = yellow, >5 = red
```

### **Row 2: Business Metrics**
```yaml
Type: Stat panels

Panel 1: Active Users (Last 5 min)
Query: sum(rate(django_http_requests_total{path=~".*login.*", method="POST"}[5m])) * 5
Unit: users

Panel 2: New Users (Last 24h)
Query: increase(django_user_registrations_total[24h])
Unit: users

Panel 3: Posts Created (Last 24h)
Query: increase(django_post_created_total[24h])
Unit: posts

Panel 4: Engagement Rate
Query: (rate(django_like_total[5m]) + rate(django_comment_created_total[5m])) / rate(django_http_requests_total[5m]) * 100
Unit: percent
```

### **Row 3: Performance SLIs**
```yaml
Type: Time series graphs

Panel 1: API Latency (P50, P95, P99)
Queries:
- histogram_quantile(0.50, rate(django_http_requests_latency_seconds_bucket[5m]))
- histogram_quantile(0.95, rate(django_http_requests_latency_seconds_bucket[5m]))
- histogram_quantile(0.99, rate(django_http_requests_latency_seconds_bucket[5m]))
Unit: seconds
Legend: P50, P95, P99

Panel 2: Error Rate by Status
Query: sum(rate(django_http_responses_total[5m])) by (status)
Legend: {{status}}
Unit: requests/sec

Panel 3: Throughput (Requests/sec)
Query: sum(rate(django_http_requests_total[5m]))
Unit: req/s
```

### **Row 4: Resource Usage**
```yaml
Type: Time series graphs

Panel 1: CPU Usage by Container
Query: sum(rate(container_cpu_usage_seconds_total{container!="", container!="cadvisor", container!="prometheus"}[5m])) by (container)
Legend: {{container}}
Unit: cores

Panel 2: Memory Usage by Container
Query: sum(container_memory_working_set_bytes{container!="", container!="cadvisor"}) by (container)
Unit: bytes (use auto format)
Legend: {{container}}
```

### **Panel: Log Errors**
```yaml
Type: Logs panel
Query (Loki): {service="backend"} |= "ERROR"
```

---

# 🖥️ **4. DASHBOARD 2: HOST OVERVIEW**

### **Location:** `01-Infrastructure` → `Host Overview`

### **Quick Import:**
```bash
ID: 1860
Datasource: Prometheus
```

### **Or create manually:**

### **Row 1: System Overview**
```yaml
Panel 1: CPU Usage (Total)
Query: 100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
Unit: percent
Alert Threshold: > 80%

Panel 2: Memory Usage
Query: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
Unit: percent
Alert Threshold: > 85%

Panel 3: Disk Usage (/)
Query: (node_filesystem_size_bytes{mountpoint="/"} - node_filesystem_free_bytes{mountpoint="/"}) / node_filesystem_size_bytes{mountpoint="/"} * 100
Unit: percent
Alert Threshold: > 80%

Panel 4: Load Average (5 min)
Query: node_load5
Unit: load
Alert Threshold: > # of CPU cores
```

### **Row 2: Detailed Resources**
```yaml
Panel 1: CPU per Core
Query: avg(rate(node_cpu_seconds_total[5m])) by (cpu, mode)

Panel 2: Memory Breakdown
Query: node_memory_MemTotal_bytes - node_memory_MemFree_bytes - node_memory_Buffers_bytes - node_memory_Cached_bytes

Panel 3: Disk I/O
Query: rate(node_disk_read_bytes_total[5m]) - rate(node_disk_written_bytes_total[5m])

Panel 4: Network Traffic
Query: rate(node_network_receive_bytes_total{device!="lo"}[5m]) / 1024 / 1024
```

---

# 🐳 **5. DASHBOARD 3: CONTAINER RESOURCES**

### **Location:** `01-Infrastructure` → `Container Resources`

### **Quick Import:**
```bash
ID: 14282
Datasource: Prometheus
```

### **Key panels to add manually:**

```yaml
Panel: Container Restarts
Query: changes(container_start_time_seconds{container!=""}[1h])
Alert: > 3 restarts = warning

Panel: Container Uptime
Query: time() - container_start_time_seconds{container!=""}
Legend: {{container}}

Panel: CPU per Container
Query: sum(rate(container_cpu_usage_seconds_total{container!=""}[5m])) by (container)
Unit: cores

Panel: Memory per Container
Query: sum(container_memory_working_set_bytes{container!=""}) by (container)
Unit: bytes
```

### **Import Dashboard ID 11074 - Prometheus Stats**
```bash
1. Dashboards → New → Import
2. Enter ID: 11074
3. Click "Load"
4. Select Prometheus datasource
5. Click "Import"
6. Move to folder: "01-Infrastructure"
```

---

# 🔧 **6. DASHBOARD 4: DJANGO API METRICS**

### **Location:** `02-Services` → `Django API`

### **Create from scratch:**

### **Row 1: Request Volume**
```yaml
Panel 1: Total Requests (Rate)
Query: sum(rate(django_http_requests_total[5m]))
Unit: req/s

Panel 2: Requests by Method
Query: sum(rate(django_http_requests_total[5m])) by (method)
Legend: {{method}}
Unit: req/s

Panel 3: Requests by Endpoint (Top 10)
Query: topk(10, sum(rate(django_http_requests_total[5m])) by (path))
Legend: {{path}}
Unit: req/s
```

### **Row 2: Performance**
```yaml
Panel 1: Response Time Percentiles
Queries:
- histogram_quantile(0.50, rate(django_http_requests_latency_seconds_bucket[5m]))
- histogram_quantile(0.95, rate(django_http_requests_latency_seconds_bucket[5m]))
- histogram_quantile(0.99, rate(django_http_requests_latency_seconds_bucket[5m]))
Legend: P50, P95, P99

Panel 2: Slow Endpoints (P95 > 500ms)
Query: histogram_quantile(0.95, rate(django_http_requests_latency_seconds_bucket[5m])) > 0.5

Panel 3: Response Time Heatmap
Query: sum(rate(django_http_requests_latency_seconds_bucket[5m])) by (le)
```

### **Row 3: Errors**
```yaml
Panel 1: Error Rate by Endpoint
Query: topk(5, sum(rate(django_http_responses_total{status=~"5.."}[5m])) by (path))

Panel 2: Error Percentage over Time
Query: (sum(rate(django_http_responses_total{status=~"5.."}[5m])) / sum(rate(django_http_responses_total[5m]))) * 100

Panel 3: Status Code Distribution
Query: sum(rate(django_http_responses_total[5m])) by (status)
```

### **SLO Targets for Django API:**
```yaml
Error Rate (5xx): < 0.1%
P99 Latency: < 500ms
P95 Latency: < 200ms
Availability: > 99.9%
```

---

# 🗄️ **7. DASHBOARD 5: POSTGRESQL DATABASE**

### **Location:** `02-Services` → `PostgreSQL`

```yaml
Row 1: Connection Health
Panel 1: Active Connections
Query: sum(pg_stat_database_numbackends) by (datname)
Alert: > 100 = warning

Panel 2: Connection Utilization
Query: (sum(pg_stat_database_numbackends) / pg_settings_max_connections) * 100
Unit: percent
Alert: > 80% = warning

Row 2: Performance
Panel 1: Transactions Per Second
Query: rate(pg_stat_database_xact_commit[5m]) + rate(pg_stat_database_xact_rollback[5m])

Panel 2: Cache Hit Ratio
Query: (pg_stat_database_blks_hit / (pg_stat_database_blks_hit + pg_stat_database_blks_read)) * 100
Unit: percent
Alert: < 99% = warning

Panel 3: Transaction Rollback Rate
Query: rate(pg_stat_database_xact_rollback[5m])

Row 3: Query Performance
Panel 1: Slow Queries (P95)
Query: histogram_quantile(0.95, rate(pg_stat_statements_mean_time_bucket[5m]))

Panel 2: Deadlocks
Query: rate(pg_stat_database_deadlocks[5m])
Alert: > 0 = critical

Panel 3: Database Size
Query: pg_database_size_bytes
Unit: bytes
```

---

# 🌐 **8. DASHBOARD 6: NGINX PERFORMANCE**

### **Location:** `02-Services` → `Nginx`

```yaml
Row 1: Traffic
Panel 1: Active Connections
Query: nginx_connections_active
Alert: > 1000 = warning

Panel 2: Requests per Second
Query: rate(nginx_http_requests_total[5m])

Panel 3: Request Processing Time (P95)
Query: histogram_quantile(0.95, rate(nginx_http_request_duration_seconds_bucket[5m]))

Row 2: Response Status
Panel 1: Status Code Distribution
Query: sum(rate(nginx_http_requests_total[5m])) by (status)

Panel 2: 5xx Errors
Query: sum(rate(nginx_http_requests_total{status=~"5.."}[5m]))
Alert: > 10/minute = critical

Panel 3: 4xx Errors
Query: sum(rate(nginx_http_requests_total{status=~"4.."}[5m]))
```

---

# 👥 **9. DASHBOARD 7: USER ANALYTICS**

### **Location:** `03-Business` → `User Analytics`

```yaml
Row 1: User Growth
Panel 1: Total Registered Users
Query: django_user_count

Panel 2: New Users (Daily)
Query: increase(django_user_registrations_total[24h])

Panel 3: User Growth Rate (Weekly)
Query: increase(django_user_registrations_total[7d])

Row 2: User Activity
Panel 1: Daily Active Users (DAU)
Query: increase(django_http_requests_total{user_authenticated="true"}[24h])

Panel 2: Weekly Active Users (WAU)
Query: increase(django_http_requests_total{user_authenticated="true"}[7d])

Panel 3: Monthly Active Users (MAU)
Query: increase(django_http_requests_total{user_authenticated="true"}[30d])

Panel 4: Stickiness (DAU/MAU)
Query: (increase(django_http_requests_total{user_authenticated="true"}[24h]) / increase(django_http_requests_total{user_authenticated="true"}[30d])) * 100
Unit: percent

Row 3: Engagement
Panel 1: Actions per User
Query: rate(django_http_requests_total{user_authenticated="true"}[5m]) / django_user_count

Panel 2: Retention (Returning Users)
Query: django_returning_users_total / django_user_count * 100

Panel 3: Login Success Rate
Query: (sum(rate(django_auth_success_total[5m])) / sum(rate(django_auth_attempts_total[5m]))) * 100

Panel 4: Conversion Rate (Signup/Visit)
Query: (django_signup_completed_total / django_visit_total) * 100
```

### **Business SLO Targets:**
```yaml
DAU growth: > 5% month-over-month
Stickiness: > 25% (DAU/MAU)
Login Success Rate: > 99.5%
User Retention (Week 2): > 40%
```

---

# 📝 **10. DASHBOARD 8: CONTENT METRICS**

### **Location:** `03-Business` → `Content Metrics`

```yaml
Row 1: Content Creation
Panel 1: Posts Created (Last 24h)
Query: increase(django_post_created_total[24h])

Panel 2: Posts per Hour (Heatmap)
Query: sum(rate(django_post_created_total[1h])) by (hour)

Panel 3: Comments per Minute
Query: rate(django_comment_created_total[1m])

Panel 4: Likes per Minute
Query: rate(django_like_total[1m])

Row 2: Interaction
Panel 1: Comments per Post (Average)
Query: django_comment_created_total / django_post_created_total

Panel 2: Likes per Post (Average)
Query: django_like_total / django_post_created_total

Panel 3: Engagement Rate
Query: (rate(django_like_total[5m]) + rate(django_comment_created_total[5m])) / rate(django_http_requests_total[5m]) * 100

Panel 4: Most Liked Posts (Top 5)
Query: topk(5, increase(django_like_total[24h]) by (post_id))

Panel 5: Most Commented Posts (Top 5)
Query: topk(5, increase(django_comment_created_total[24h]) by (post_id))
```

---

# 📜 **11. DASHBOARD 9: LOG EXPLORER**

### **Location:** `04-Logs` → `Log Explorer`

### **Just use Explore tab, but create a dashboard with:**

```yaml
Panel 1: Log Volume by Service
Query (Loki): sum(count_over_time({service=~".+"}[5m])) by (service)
Type: Bar gauge

Panel 2: Error Log Rate
Query (Loki): count_over_time({service="backend"} |= "ERROR"[5m])
Alert: > 100/minute = critical

Panel 3: Log Level Distribution
Query (Loki): sum(count_over_time({container="dev-backend-1"} | json | level != ""[5m])) by (level)
Type: Pie chart

Panel 4: Recent Error Logs (Table)
Query (Loki): {service="backend"} |= "ERROR" | json | line_format "{{.message}}"
Type: Logs panel

Panel 5: Warning Logs Rate
Query (Loki): count_over_time({service="backend"} |= "WARNING"[5m])
```

### **Common Loki Queries:**
```log
# All logs from backend
{container="dev-backend-1"}

# All logs from nginx
{container="dev-nginx-1"}

# Error logs only
{container="dev-backend-1"} |= "ERROR"

# Warning or Error logs
{container="dev-backend-1"} |~ "(ERROR|WARNING)"

# JSON formatted logs (parse level)
{container="dev-backend-1"} | json | level = "error"

# Logs containing specific text
{service="backend"} |= "Database timeout"

# Logs in last 5 minutes
{container="dev-backend-1"} | within 5m

# Filter by service label
{service="backend"} |= "ERROR"

# Regex pattern matching
{container="dev-backend-1"} |~ "User.*logged in"

# Exclude patterns
{container="dev-backend-1"} != "health check"
```

---

# 🚨 **12. DASHBOARD 10: ALERT STATUS**

### **Location:** `05-Alerts` → `Alert Status`

```yaml
Panel 1: Active Alerts
Query: ALERTS{alertstate="firing"}
Type: Table
Columns: alertname, severity, instance, description

Panel 2: Alert History (Last 24h)
Query: changes(ALERTS[24h])

Panel 3: Alert Severity Distribution
Query: count(ALERTS{alertstate="firing"}) by (severity)
Type: Pie chart

Panel 4: Alerts Over Time
Query: count(ALERTS{alertstate="firing"}) by (alertname)
Type: Time series
```

### **Dashboard 10b: Alert History**
### **Location:** `05-Alerts` → `Alert History`

```yaml
Panel 1: Alert Firing Duration
Query: max(ALERTS_for_duration{alertstate="firing"}) by (alertname)

Panel 2: Resolved Alerts (Last 7 days)
Query: count(ALERTS{alertstate="resolved"}[7d]) by (alertname)

Panel 3: Mean Time to Resolution (MTTR)
Query: avg(ALERTS_for_duration{alertstate="resolved"}) by (alertname)
```

---

# 📈 **13. DASHBOARD 11: CAPACITY PLANNING**

### **Location:** `06-Capacity` → `Capacity Planning`

```yaml
Row 1: Growth Forecasts
Panel 1: User Growth (Next 30 days)
Query: predict_linear(django_user_count[30d], 86400 * 30)
Type: Time series with prediction

Panel 2: Storage Growth (Next 90 days)
Query: predict_linear(pg_database_size_bytes[90d], 86400 * 90)

Panel 3: Request Volume Forecast (Next 30 days)
Query: predict_linear(rate(django_http_requests_total[30d]), 86400 * 30)

Row 2: Resource Trends
Panel 1: CPU Trend (7 days)
Query: avg(rate(container_cpu_usage_seconds_total[1h])) over time

Panel 2: Memory Trend (7 days)
Query: avg(container_memory_working_set_bytes) over time

Panel 3: Disk Usage Trend (7 days)
Query: (node_filesystem_size_bytes - node_filesystem_free_bytes) / node_filesystem_size_bytes * 100

Row 3: Predictions
Panel 4: When will disk be full?
Query: (predict_linear(node_filesystem_free_bytes{mountpoint="/"}[6h], 3600 * 24 * 30) < 0)

Panel 5: When will CPU exceed 80%?
Query: (predict_linear(avg(rate(container_cpu_usage_seconds_total{container="dev-backend-1"}[5m]))[7d], 3600 * 24 * 30) > 0.8)

Panel: Text panel with calculations
"When will we need more resources?"
- Current growth rate: ___%
- Estimated resource exhaustion in: ___ days
- Recommended action: Scale up by ___ on ___
```

### **Dashboard 11b: Resource Trends**
### **Location:** `06-Capacity` → `Resource Trends`

```yaml
Panel 1: Monthly Resource Usage Heatmap
Query: avg(rate(container_cpu_usage_seconds_total[1d])) by (day, container)

Panel 2: Year-over-Year Comparison
Query: avg(rate(container_cpu_usage_seconds_total[30d])) offset 1y

Panel 3: Peak Usage Times
Query: max_over_time(avg(rate(container_cpu_usage_seconds_total[5m]))[24h])
```

---

# 📊 **14. SLOS, SLIS & SLA DEFINITIONS**

## **14.1 Service Level Indicators (SLIs)**

| SLI | Measurement | Query | Target |
|-----|-------------|-------|--------|
| **Availability** | % of successful requests | `sum(rate(django_http_responses_total{status!~"5.."}[5m])) / sum(rate(django_http_responses_total[5m])) * 100` | 99.9% |
| **Latency** | P99 response time | `histogram_quantile(0.99, rate(django_http_requests_latency_seconds_bucket[5m]))` | < 500ms |
| **Throughput** | Requests per second | `sum(rate(django_http_requests_total[5m]))` | Monitor only |
| **Error Rate** | % of 5xx responses | `(sum(rate(django_http_responses_total{status=~"5.."}[5m])) / sum(rate(django_http_responses_total[5m]))) * 100` | < 0.1% |

## **14.2 Service Level Objectives (SLOs)**

| Service | SLO | Time Period | Measurement |
|---------|-----|-------------|-------------|
| **API Availability** | 99.9% | Monthly | 43.8 min downtime allowed |
| **API Latency (P99)** | 500ms | Rolling 30 days | 99th percentile |
| **API Error Rate** | 0.1% | Rolling 7 days | % of 5xx responses |
| **Database Uptime** | 99.95% | Monthly | 21.9 min downtime allowed |
| **Login Success** | 99.5% | Rolling 24h | Successful logins / total attempts |

## **14.3 Service Level Agreement (SLA) - If Paid Tier**

| Tier | Availability | Credits |
|------|--------------|---------|
| **Gold** | 99.99% | 10% downtime credit |
| **Silver** | 99.9% | 5% downtime credit |
| **Bronze** | 99.5% | No credit |

## **14.4 Error Budget Calculation**

```bash
Error Budget = 100% - SLO Target
Example: For 99.9% SLO = 0.1% error budget

Monthly Error Budget in Minutes:
- 99.9% SLO = 43.8 minutes
- 99.95% SLO = 21.9 minutes  
- 99.99% SLO = 4.38 minutes

Query to track error budget burn:
(1 - (sum(rate(django_http_responses_total{status!~"5.."}[30d])) / sum(rate(django_http_responses_total[30d])))) > 0.001
```

## **14.5 SLO Dashboard Queries**

```yaml
# Availability SLI (last 30 days)
sum(rate(django_http_responses_total{status!~"5.."}[30d])) / sum(rate(django_http_responses_total[30d])) * 100

# Latency SLI (P99 last 30 days)
histogram_quantile(0.99, rate(django_http_requests_latency_seconds_bucket[30d]))

# Error Budget (remaining %)
1 - ((1 - (sum(rate(django_http_responses_total{status!~"5.."}[30d])) / sum(rate(django_http_responses_total[30d])))) / 0.001)

# Error Budget Burn Rate (last hour)
(1 - (sum(rate(django_http_responses_total{status!~"5.."}[1h])) / sum(rate(django_http_responses_total[1h])))) / 0.001
```

---

# 🚨 **15. ALERT RULES & SLACK INTEGRATION**

## **15.1 Alert Rules Configuration**

**File:** `docker/dev/monitoring/prometheus/alerts.yml`

```yaml
groups:
  - name: api_alerts
    interval: 30s
    rules:
      # ============================================
      # HIGH PRIORITY (Page immediately)
      # ============================================
      
      - alert: APIHighErrorRate
        expr: |
          (sum(rate(django_http_responses_total{status=~"5.."}[5m])) 
          / sum(rate(django_http_responses_total[5m]))) * 100 > 5
        for: 2m
        labels:
          severity: critical
          team: backend
        annotations:
          summary: "High API error rate"
          description: "Error rate is {{ $value }}% for the last 5 minutes"
          
      - alert: APIDown
        expr: up{job="backend"} == 0
        for: 1m
        labels:
          severity: critical
          team: backend
        annotations:
          summary: "API is down"
          description: "Backend service has been down for 1 minute"
          
      - alert: DatabaseDown
        expr: pg_up == 0
        for: 1m
        labels:
          severity: critical
          team: database
        annotations:
          summary: "PostgreSQL is down"
          description: "Database has been unreachable for 1 minute"

      # ============================================
      # MEDIUM PRIORITY (Slack notification only)
      # ============================================
      
      - alert: HighLatency
        expr: |
          histogram_quantile(0.95, 
          rate(django_http_requests_latency_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: warning
          team: backend
        annotations:
          summary: "High API latency"
          description: "P95 latency is {{ $value }}s"
          
      - alert: HighCPUUsage
        expr: |
          sum(rate(container_cpu_usage_seconds_total{container!=""}[5m])) by (container) > 0.8
        for: 10m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "High CPU usage on {{ $labels.container }}"
          description: "CPU usage is {{ $value }}% for the last 10 minutes"
          
      - alert: HighMemoryUsage
        expr: |
          (container_memory_working_set_bytes / container_spec_memory_limit_bytes) > 0.85
        for: 10m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "High memory usage on {{ $labels.container }}"
          description: "Memory usage is {{ $value | humanizePercentage }}"
          
      - alert: DatabaseHighConnections
        expr: sum(pg_stat_database_numbackends) > 80
        for: 5m
        labels:
          severity: warning
          team: database
        annotations:
          summary: "High database connections"
          description: "Current connections: {{ $value }}"
          
      - alert: LowDiskSpace
        expr: |
          (node_filesystem_free_bytes{mountpoint="/"} / 
           node_filesystem_size_bytes{mountpoint="/"}) * 100 < 10
        for: 5m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "Low disk space"
          description: "Only {{ $value }}% free on root partition"

      - alert: ContainerRestarting
        expr: changes(container_start_time_seconds{container!=""}[1h]) > 3
        for: 5m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "Container {{ $labels.container }} is restarting frequently"
          description: "Container has restarted {{ $value }} times in the last hour"

      - alert: DBLowCacheHit
        expr: |
          (pg_stat_database_blks_hit / 
          (pg_stat_database_blks_hit + pg_stat_database_blks_read)) * 100 < 95
        for: 10m
        labels:
          severity: warning
          team: database
        annotations:
          summary: "Low database cache hit ratio"
          description: "Cache hit ratio is {{ $value }}%"

      # ============================================
      # LOW PRIORITY (Business metrics)
      # ============================================
      
      - alert: LowUserSignups
        expr: increase(django_user_registrations_total[24h]) < 10
        for: 24h
        labels:
          severity: info
          team: product
        annotations:
          summary: "Low user signups"
          description: "Only {{ $value }} new users in the last 24 hours"
          
      - alert: NoContentCreation
        expr: increase(django_post_created_total[12h]) == 0
        for: 12h
        labels:
          severity: info
          team: product
        annotations:
          summary: "No content created"
          description: "No new posts in the last 12 hours"

  - name: service_health
    interval: 30s
    rules:
      - alert: ServiceDown
        expr: up{job=~"backend|postgres|nginx"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "{{ $labels.job }} service is down"

  - name: capacity
    interval: 1h
    rules:
      - alert: DiskWillFillSoon
        expr: |
          (predict_linear(node_filesystem_free_bytes{mountpoint="/"}[6h], 3600 * 24 * 30) < 0)
        for: 1h
        labels:
          severity: warning
        annotations:
          summary: "Disk will fill in 30 days"
          description: "Based on current usage, disk will be full in {{ $value | humanizeDuration }}"
```

## **15.2 Alertmanager Configuration**

**File:** `docker/dev/monitoring/alertmanager/alertmanager.yml`

```yaml
global:
  slack_api_url: 'YOUR SLACK WEBHOOK URL'
  resolve_timeout: 5m

route:
  group_by: ['alertname', 'cluster']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 12h
  receiver: 'slack-notifications'
  
  routes:
    # Critical alerts go to #critical channel and page on-call
    - match:
        severity: critical
      receiver: slack-critical
      continue: true
      
    # Warning alerts go to #warnings channel  
    - match:
        severity: warning
      receiver: slack-warnings
      continue: true
      
    # Info alerts go to #info channel
    - match:
        severity: info
      receiver: slack-info

receivers:
  - name: 'slack-notifications'
    slack_configs:
      - channel: '#alerts'
        title: '{{ .GroupLabels.alertname }}'
        text: |-
          *Status:* {{ .Status }}
          *Severity:* {{ .CommonLabels.severity }}
          *Description:* {{ .CommonAnnotations.description }}
          *Time:* {{ .StartsAt }}
          
  - name: 'slack-critical'
    slack_configs:
      - channel: '#critical-alerts'
        color: 'danger'
        title: '🚨 CRITICAL: {{ .GroupLabels.alertname }}'
        text: |-
          *Alert:* {{ .CommonLabels.alertname }}
          *Description:* {{ .CommonAnnotations.description }}
          *Value:* {{ .CommonAnnotations.value }}
          *Time:* {{ .StartsAt }}
          *On-call:* @here
          
  - name: 'slack-warnings'
    slack_configs:
      - channel: '#warnings'
        color: 'warning'
        title: '⚠️ WARNING: {{ .GroupLabels.alertname }}'
        text: |-
          *Alert:* {{ .CommonLabels.alertname }}
          *Description:* {{ .CommonAnnotations.description }}
          *Value:* {{ .CommonAnnotations.value }}
          
  - name: 'slack-info'
    slack_configs:
      - channel: '#info'
        color: 'good'
        title: 'ℹ️ INFO: {{ .GroupLabels.alertname }}'
        text: |-
          *Alert:* {{ .CommonLabels.alertname }}
          *Description:* {{ .CommonAnnotations.description }}

inhibit_rules:
  # If API is down, don't send latency/error alerts
  - source_match:
      alertname: 'APIDown'
    target_match_re:
      alertname: 'HighLatency|APIHighErrorRate'
    equal: ['instance']
    
  # If database is down, don't send connection alerts  
  - source_match:
      alertname: 'DatabaseDown'
    target_match_re:
      alertname: 'DatabaseHighConnections|DBLowCacheHit'
```

## **15.3 Slack Integration Setup**

### **Step 1: Create Slack App**
```bash
1. Go to https://api.slack.com/apps
2. Click "Create New App" → "From scratch"
3. Name: "Monitoring Alerts"
4. Select your workspace
5. Click "Create App"
```

### **Step 2: Configure Incoming Webhook**
```bash
1. Click "Incoming Webhooks" (left sidebar)
2. Toggle "Activate Incoming Webhooks" to ON
3. Click "Add New Webhook to Workspace"
4. Select channel (#alerts, #critical-alerts, #warnings)
5. Click "Allow"
6. Copy the webhook URL
```

### **Step 3: Add to Alertmanager**
```yaml
# In alertmanager.yml
global:
  slack_api_url: 'YOUR SLACK WEBHOOK URL'
```

### **Step 4: Restart Alertmanager**
```bash
docker compose -f compose/dev/compose.monitoring.dev.yml restart alertmanager
```

### **Step 5: Test alert**
```bash
curl -H "Content-Type: application/json" -d '{
  "status": "firing",
  "alerts": [{
    "labels": {
      "alertname": "TestAlert",
      "severity": "warning"
    },
    "annotations": {
      "summary": "This is a test alert",
      "description": "Testing Slack integration"
    }
  }]
}' http://localhost:9093/api/v1/alerts
```

## **15.4 Slack Alert Message Examples**

### **Critical Alert**
```
🚨 CRITICAL: APIHighErrorRate

*Alert:* APIHighErrorRate
*Description:* Error rate is 7.5% for the last 5 minutes
*Value:* 7.5
*Time:* 2025-01-15 14:32:15 UTC
*On-call:* @here
```

### **Warning Alert**
```
⚠️ WARNING: HighLatency

*Alert:* HighLatency
*Description:* P95 latency is 1.2s
*Value:* 1.2
*Time:* 2025-01-15 14:30:22 UTC
```

### **Info Alert**
```
ℹ️ INFO: LowUserSignups

*Alert:* LowUserSignups
*Description:* Only 8 new users in the last 24 hours
*Time:* 2025-01-15 14:00:00 UTC
```

## **15.5 Alert Severity Matrix**

| Severity | Color | Response Time | Notification | Example |
|----------|-------|---------------|--------------|---------|
| **Critical** | 🔴 Red | < 5 min | Slack + PagerDuty | API down, DB down |
| **Warning** | 🟡 Yellow | < 30 min | Slack only | High latency, High CPU |
| **Info** | 🔵 Blue | No action | Slack #info | Low signups, Low content |

---

# 📝 **16. QUERY REFERENCE LIBRARY**

## **16.1 Infrastructure Queries (Node Exporter)**

```yaml
# CPU Usage (%)
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory Usage (%)
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# Disk Usage (%)
(node_filesystem_size_bytes{fstype!="tmpfs"} - node_filesystem_free_bytes{fstype!="tmpfs"}) / node_filesystem_size_bytes{fstype!="tmpfs"} * 100

# Disk I/O (MB/s)
rate(node_disk_read_bytes_total[5m]) / 1024 / 1024

# Network Traffic (MB/s)
rate(node_network_receive_bytes_total{device!="lo"}[5m]) / 1024 / 1024

# Load Average (5 min)
node_load5

# System Uptime (days)
time() - node_boot_time_seconds / 86400

# File Descriptors
node_filefd_allocated
```

## **16.2 Container Metrics (cAdvisor)**

```yaml
# CPU per Container (cores)
sum(rate(container_cpu_usage_seconds_total{container!=""}[5m])) by (container)

# Memory per Container (bytes)
sum(container_memory_working_set_bytes{container!=""}) by (container)

# Network Received per Container (bytes/s)
sum(rate(container_network_receive_bytes_total{container!=""}[5m])) by (container)

# Network Transmitted per Container (bytes/s)
sum(rate(container_network_transmit_bytes_total{container!=""}[5m])) by (container)

# Disk Read per Container (bytes/s)
sum(rate(container_fs_reads_bytes_total{container!=""}[5m])) by (container)

# Disk Write per Container (bytes/s)
sum(rate(container_fs_writes_bytes_total{container!=""}[5m])) by (container)

# Container Uptime (seconds)
time() - container_start_time_seconds{container!=""}

# Container Restarts (last hour)
changes(container_start_time_seconds{container!=""}[1h])
```

## **16.3 Application Queries (Django)**

```yaml
# Total Request Rate (req/s)
sum(rate(django_http_requests_total[5m]))

# Request Rate by Method
sum(rate(django_http_requests_total[5m])) by (method)

# Request Rate by Endpoint (Top 10)
topk(10, sum(rate(django_http_requests_total[5m])) by (path))

# Response Time Percentiles
histogram_quantile(0.50, rate(django_http_requests_latency_seconds_bucket[5m]))  # P50
histogram_quantile(0.95, rate(django_http_requests_latency_seconds_bucket[5m]))  # P95
histogram_quantile(0.99, rate(django_http_requests_latency_seconds_bucket[5m]))  # P99

# Response Status Distribution
sum(rate(django_http_responses_total[5m])) by (status)

# Error Rate (%)
(sum(rate(django_http_responses_total{status=~"5.."}[5m])) / sum(rate(django_http_responses_total[5m]))) * 100

# Successful Request Rate (%)
(sum(rate(django_http_responses_total{status=~"2.."}[5m])) / sum(rate(django_http_responses_total[5m]))) * 100

# Request Size (bytes)
histogram_quantile(0.95, rate(django_http_request_size_bytes_bucket[5m]))

# Response Size (bytes)
histogram_quantile(0.95, rate(django_http_response_size_bytes_bucket[5m]))
```

## **16.4 Database Queries (PostgreSQL)**

```yaml
# Active Connections
sum(pg_stat_database_numbackends) by (datname)

# Connection Utilization (%)
(sum(pg_stat_database_numbackends) / pg_settings_max_connections) * 100

# Cache Hit Ratio (%)
(pg_stat_database_blks_hit / (pg_stat_database_blks_hit + pg_stat_database_blks_read)) * 100

# Transactions Per Second
rate(pg_stat_database_xact_commit[5m]) + rate(pg_stat_database_xact_rollback[5m])

# Transaction Rollback Rate
rate(pg_stat_database_xact_rollback[5m])

# Deadlocks Per Minute
rate(pg_stat_database_deadlocks[5m]) * 60

# Database Size (bytes)
pg_database_size_bytes

# Slow Queries (P95)
histogram_quantile(0.95, rate(pg_stat_statements_mean_time_bucket[5m]))
```

## **16.5 Nginx Queries**

```yaml
# Active Connections
nginx_connections_active

# Requests Per Second
rate(nginx_http_requests_total[5m])

# Status Code Distribution
sum(rate(nginx_http_requests_total[5m])) by (status)

# 5xx Error Rate
sum(rate(nginx_http_requests_total{status=~"5.."}[5m]))

# Request Processing Time (P95)
histogram_quantile(0.95, rate(nginx_http_request_duration_seconds_bucket[5m]))
```

## **16.6 Business Metrics Queries**

```yaml
# Daily Active Users (DAU)
increase(django_http_requests_total{user_authenticated="true"}[24h])

# Weekly Active Users (WAU)
increase(django_http_requests_total{user_authenticated="true"}[7d])

# Monthly Active Users (MAU)
increase(django_http_requests_total{user_authenticated="true"}[30d])

# New Users (Daily)
increase(django_user_registrations_total[24h])

# User Retention Rate
(django_returning_users_total / django_user_count) * 100

# Posts Created (Last 24h)
increase(django_post_created_total[24h])

# Comments Rate
rate(django_comment_created_total[5m])

# Likes Rate
rate(django_like_total[5m])

# Engagement Rate
(rate(django_like_total[5m]) + rate(django_comment_created_total[5m])) / rate(django_http_requests_total[5m]) * 100

# Conversion Rate (Signup/Visit)
(django_signup_completed_total / django_visit_total) * 100

# Login Success Rate
(sum(rate(django_auth_success_total[5m])) / sum(rate(django_auth_attempts_total[5m]))) * 100
```

## **16.7 Capacity Planning Queries**

```yaml
# Predict user count in 30 days
predict_linear(django_user_count[30d], 86400 * 30)

# When will disk fill up?
predict_linear(node_filesystem_free_bytes{mountpoint="/"}[30d], 86400 * 30)

# Future request volume
predict_linear(rate(django_http_requests_total[7d]), 86400)

# Memory trend forecast
predict_linear(container_memory_working_set_bytes{container="dev-backend-1"}[30d], 86400 * 30)

# CPU trend forecast
predict_linear(rate(container_cpu_usage_seconds_total{container="dev-backend-1"}[5m])[30d], 86400 * 30)
```

---

# 🔧 **17. ALERTMANAGER CONFIGURATION**

## **17.1 Docker Compose Service**

**File:** `compose/dev/compose.monitoring.dev.yml`

```yaml
alertmanager:
  image: prom/alertmanager:latest
  container_name: alertmanager
  restart: unless-stopped
  volumes:
    - ./docker/dev/monitoring/alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml
    - alertmanager_data:/alertmanager
  command:
    - '--config.file=/etc/alertmanager/alertmanager.yml'
    - '--storage.path=/alertmanager'
  ports:
    - "9093:9093"
  networks:
    - monitoring_dev_nw
    - bloggyspace_nw
```

## **17.2 Prometheus Configuration with Alertmanager**

**File:** `docker/dev/monitoring/prometheus/prometheus.yml`

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - 'alertmanager:9093'

rule_files:
  - "alerts.yml"

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']

  - job_name: 'backend'
    metrics_path: '/metrics'
    static_configs:
      - targets: ['backend:8000']

  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres-exporter:9187']

  - job_name: 'nginx'
    static_configs:
      - targets: ['nginx-exporter:9113']
```

---

# 📋 **18. MAINTENANCE & RUNBOOKS**

## **18.1 Health Check Commands**

```bash
# Check all services
docker ps

# Check Prometheus targets
curl http://prometheus.bloggyspace.local:8080/api/v1/targets

# Check Loki health
curl http://loki:3100/ready

# Check Alertmanager status
curl http://localhost:9093/api/v1/status

# Check Alloy logs
docker logs alloy --tail 50

# Test Slack webhook
curl -X POST -H "Content-Type: application/json" -d '{"text":"Test from monitoring"}' YOUR_SLACK_WEBHOOK_URL

# Check Prometheus rules
curl http://prometheus:9090/api/v1/rules
```

## **18.2 Restart Procedures**

```bash
# Restart entire monitoring stack
make monitoring-down
make monitoring-up

# Restart individual service
docker compose -f compose/dev/compose.monitoring.dev.yml restart prometheus
docker compose -f compose/dev/compose.monitoring.dev.yml restart grafana
docker compose -f compose/dev/compose.monitoring.dev.yml restart alertmanager
docker compose -f compose/dev/compose.monitoring.dev.yml restart loki
docker compose -f compose/dev/compose.monitoring.dev.yml restart alloy
```

## **18.3 Common Issues & Solutions**

| Issue | Solution |
|-------|----------|
| **Prometheus targets down** | Check container is running: `docker ps` |
| **No logs in Loki** | Check Alloy: `docker logs alloy` |
| **Grafana "No data"** | Check datasource URL is `http://prometheus:9090` |
| **Alerts not firing** | Check Alertmanager config: `docker logs alertmanager` |
| **Slack not receiving alerts** | Verify webhook URL in alertmanager.yml |
| **High CPU/Memory** | Run `docker stats` to identify culprit |
| **Grafana dashboards missing** | Check folder permissions and datasource |
| **Prometheus high memory** | Reduce retention period or increase memory limit |
| **Loki query timeout** | Reduce time range or add more specific filters |

## **18.4 Backup & Restore**

```bash
# Backup Grafana dashboards
docker exec grafana tar czf /tmp/grafana-backup.tar.gz /var/lib/grafana

# Copy backup to host
docker cp grafana:/tmp/grafana-backup.tar.gz ./backups/

# Backup Prometheus data
docker exec prometheus tar czf /tmp/prometheus-backup.tar.gz /prometheus

# Copy Prometheus backup
docker cp prometheus:/tmp/prometheus-backup.tar.gz ./backups/

# Restore Grafana from backup
docker cp ./backups/grafana-backup.tar.gz grafana:/tmp/
docker exec grafana tar xzf /tmp/grafana-backup.tar.gz -C /

# Restart services after restore
docker restart grafana prometheus
```

## **18.5 On-Call Runbook**

### **Critical Alert: API Down**
```bash
1. Check if backend container is running: docker ps | grep backend
2. Check logs: docker logs dev-backend-1 --tail 50
3. Check for database connectivity: docker exec dev-backend-1 python manage.py check
4. Restart if needed: docker restart dev-backend-1
5. If unresolved: docker compose -f compose/dev/compose.dev.yml up -d --build backend
6. If still down: Check host resources (CPU/Memory/Disk)
```

### **Critical Alert: Database Down**
```bash
1. Check postgres container: docker ps | grep postgres
2. Check logs: docker logs dev-postgres-1 --tail 50
3. Check data volume: docker volume ls | grep postgres
4. Restart: docker restart dev-postgres-1
5. If corrupted: Restore from backup
6. Check disk space: df -h
```

### **Warning Alert: High Latency**
```bash
1. Check current latency in Grafana (P50, P95, P99)
2. Identify slow endpoints from Django API dashboard
3. Check database query performance (slow queries panel)
4. Check if there are resource constraints (CPU/Memory)
5. Check logs for errors: {service="backend"} |= "slow"
6. Scale horizontally if needed: docker compose up -d --scale backend=3
7. Optimize slow queries with indexes
```

### **Warning Alert: High CPU/Memory**
```bash
1. Identify culprit container: docker stats
2. Check container logs for errors: docker logs CONTAINER_NAME
3. Check if there's a memory leak (gradual increase over time)
4. Restart problematic container if needed
5. Scale up resources in docker-compose.yml
6. Consider adding more replicas for horizontal scaling
```

### **Warning Alert: Low Disk Space**
```bash
1. Check disk usage: df -h
2. Find large files: du -sh /* | sort -h
3. Clean Docker: docker system prune -af
4. Check logs: find /var/log -type f -size +100M
5. Reduce Prometheus retention: Add --storage.tsdb.retention.time=15d
6. Reduce Loki retention in configuration
7. Add more disk space or move to larger volume
```

## **18.6 Quick Recovery Commands**

```bash
# Quick restart of all services
make dev-down && make dev-up

# Clear all containers and volumes (WARNING: deletes data)
docker compose -f compose/dev/compose.yml down -v

# View all logs in real-time
docker compose -f compose/dev/compose.yml logs -f

# Check resource usage
docker stats --no-stream

# Enter a container for debugging
docker exec -it dev-backend-1 /bin/bash

# Check network connectivity between containers
docker exec dev-backend-1 ping postgres

# Reload Prometheus configuration without restart
curl -X POST http://prometheus:9090/-/reload

# Reload Alertmanager configuration
curl -X POST http://alertmanager:9093/-/reload
```

---

# ✅ **19. IMPLEMENTATION CHECKLIST**

## **Phase 1: Infrastructure Setup**
- [ ] Create all 7 Grafana folders
- [ ] Import dashboard ID 1860 (Host Overview) → folder 01-Infrastructure
- [ ] Import dashboard ID 14282 (Container Resources) → folder 01-Infrastructure
- [ ] Import dashboard ID 11074 (Prometheus Stats) → folder 01-Infrastructure
- [ ] Create Production Overview dashboard (folder 00)
- [ ] Create Django API dashboard (folder 02)
- [ ] Create PostgreSQL dashboard (folder 02)
- [ ] Create Nginx dashboard (folder 02)

## **Phase 2: Business Dashboards**
- [ ] Create User Analytics dashboard (folder 03)
- [ ] Create Content Metrics dashboard (folder 03)
- [ ] Create Log Explorer dashboard (folder 04)

## **Phase 3: Alerting & Capacity**
- [ ] Create Alert Status dashboard (folder 05)
- [ ] Create Alert History dashboard (folder 05)
- [ ] Create Capacity Planning dashboard (folder 06)
- [ ] Create Resource Trends dashboard (folder 06)

## **Phase 4: Alerting Setup**
- [ ] Create alerts.yml file with all alert rules
- [ ] Create alertmanager.yml file
- [ ] Create Slack App and get webhook URL
- [ ] Configure webhook in alertmanager.yml
- [ ] Test Slack integration with test alert
- [ ] Configure on-call rotation (PagerDuty optional)

## **Phase 5: SLO/SLA Setup**
- [ ] Define SLO targets for API (99.9% availability)
- [ ] Create SLO dashboard panels
- [ ] Set up error budget alerts
- [ ] Configure monthly reporting

## **Phase 6: Final Validation**
- [ ] Verify all dashboards show data
- [ ] Test all alert rules by simulating failures
- [ ] Verify Slack notifications work
- [ ] Test capacity forecasting queries
- [ ] Validate Loki log queries work
- [ ] Set dashboard auto-refresh (30s)

## **Phase 7: Documentation & Training**
- [ ] Document all dashboard URLs
- [ ] Create on-call runbook
- [ ] Document recovery procedures
- [ ] Train team on dashboard usage
- [ ] Set up weekly SLO review meeting

---

# 🚀 **20. QUICK SETUP COMMANDS SUMMARY**

```bash
# 1. Import pre-made dashboards
Import ID 1860 → "Host Overview" → Folder: 01-Infrastructure
Import ID 14282 → "Container Resources" → Folder: 01-Infrastructure
Import ID 11074 → "Prometheus Stats" → Folder: 01-Infrastructure

# 2. Create remaining dashboards manually using panels above

# 3. Set up auto-refresh
Dashboards → Settings → Auto-refresh → 30s

# 4. Set time range defaults
Last 6 hours (default), Last 24 hours, Last 7 days, Last 30 days

# 5. Test alerting
curl -H "Content-Type: application/json" -d '{"status":"firing","alerts":[{"labels":{"alertname":"TestAlert","severity":"warning"},"annotations":{"summary":"Test","description":"Testing"}}]}' http://localhost:9093/api/v1/alerts
```

---

# 🎯 **21. FINAL SUMMARY**

## **What You Have Built**

| Component | Count |
|-----------|-------|
| **Grafana Folders** | 7 |
| **Dashboards** | 12+ |
| **Panels** | 75+ |
| **Alert Rules** | 15+ |
| **Alert Severities** | 3 (Critical, Warning, Info) |
| **SLOs Defined** | 5 |
| **Data Sources** | 2 (Prometheus, Loki) |

## **Monitoring Coverage**

| Layer | Coverage |
|-------|----------|
| **Infrastructure** | 100% (CPU, Memory, Disk, Network, Load) |
| **Containers** | 100% (Per-container CPU, memory, network, disk, restarts) |
| **Application** | 100% (API latency, errors, throughput, endpoints) |
| **Database** | 100% (Connections, TPS, cache, deadlocks, size) |
| **Web Server** | 100% (Nginx connections, status codes, request time) |
| **Business** | 100% (Users, engagement, content, retention) |
| **Logs** | 100% (All containers, searchable, filterable) |
| **Alerts** | 15+ rules covering all critical paths |
| **Capacity** | 100% (Forecasts, trends, predictions) |

## **Next Steps for Enterprise**

1. **Add PagerDuty integration** for on-call rotation
2. **Add Tempo** for distributed tracing
3. **Add Blackbox Exporter** for external endpoint monitoring
4. **Configure monthly SLO reports** automatically
5. **Set up automated canary deployments** with SLO validation
6. **Add business SLA dashboards** for customer reporting
7. **Implement anomaly detection** with machine learning
8. **Set up synthetic monitoring** for user journey testing

---

# ** COMPLETE PRODUCTION-GRADE MONITORING SYSTEM**

**Your stack now includes:**
- ✅ Metrics (Prometheus)
- ✅ Logs (Loki)
- ✅ Visualization (Grafana)
- ✅ Alerting (Alertmanager)
- ✅ Container Management (Portainer)
- ✅ SLIs/SLOs/SLAs defined
- ✅ Capacity planning with forecasts
- ✅ 12+ production dashboards
- ✅ 15+ alert rules
- ✅ Complete runbook

