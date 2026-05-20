# BLOGGYSPACE — COMPLETE GRAFANA DASHBOARD GUIDE
## Every dashboard, every panel, every query, every visualization setting

> All queries verified against your actual `/metrics` endpoint.
> Follow this document top to bottom — each section is self-contained.

---

## YOUR REAL METRIC NAMES (READ THIS FIRST)

| Purpose | Real metric name |
|---------|-----------------|
| Request count by method | `django_http_requests_total_by_method_total` |
| Request count by view+method | `django_http_requests_total_by_view_transport_method_total` |
| Response count by status | `django_http_responses_total_by_status_total` |
| Response count by status+view | `django_http_responses_total_by_status_view_method_total` |
| Global latency histogram | `django_http_requests_latency_including_middlewares_seconds_bucket` |
| Per-view latency histogram | `django_http_requests_latency_seconds_by_view_method_bucket` |
| DB queries total | `django_db_execute_total` |
| DB query duration | `django_db_query_duration_seconds_bucket` |
| DB connections | `django_db_new_connections_total` |
| Container uptime | use `name=` label, not `container=` |

**Metrics marked `[CUSTOM]` don't exist yet — need code in Django views.**

---

## 📁 FOLDER STRUCTURE

```
Grafana Dashboards
│
├── 📁 00-Production Overview
│   └── 📊 Single Pane of Glass
│
├── 📁 01-Infrastructure
│   ├── 📊 Host Overview         (import ID: 1860)
│   ├── 📊 Container Resources   (import ID: 14282)
│   └── 📊 Prometheus Stats      (import ID: 11074)
│
├── 📁 02-Services
│   ├── 📊 Django API
│   └── 📊 PostgreSQL Database
│
├── 📁 03-Business               (Phase 2 — needs custom Django code)
│   ├── 📊 User Analytics
│   └── 📊 Content Metrics
│
├── 📁 04-Logs
│   └── 📊 Log Explorer
│
├── 📁 05-Alerts
│   └── 📊 Alert Status
│
└── 📁 06-Capacity
    └── 📊 Capacity Planning
```

**Create folders:** Dashboards → New → New folder → create each one above in order.

---

---

# 📁 00-PRODUCTION OVERVIEW

## 📊 Dashboard: Single Pane of Glass

**Settings:** Auto-refresh: 30s | Default range: Last 6 hours

---

### ROW 1 — HEALTH STATUS

---

#### Panel: Overall Availability

```yaml
Query (Prometheus):
  avg(up{job="backend"}) * 100

Legend: leave Auto
```

```yml
Visualization:   Stat
Unit:            Percent (0-100)
Decimals:        2
Color scheme:    Thresholds only
Color mode:      Background
Calculation:     Last
Fields:          Numeric Fields
Graph mode:      None
Text mode:       Auto
Orientation:     Auto

Thresholds:
  Base (0):     Red    #c4162a
  Add → 99:     Yellow #e5a132
  Add → 99.9:   Green  #299c46
Thresholds mode: Absolute
```

---

#### Panel: Active Incidents

```bash
Query (Prometheus):
  count(ALERTS{alertstate="firing"})

Note: returns 0 when no alerts are firing.
If query returns no data at all, use:
  count(ALERTS{alertstate="firing"}) or vector(0)
```

```yml
Visualization:   Stat
Unit:            None (short)
Decimals:        0
Color scheme:    Thresholds only
Color mode:      Background
Calculation:     Last
Graph mode:      None

Thresholds:
  Base (0):     Green  #299c46
  Add → 1:      Red    #c4162a
Thresholds mode: Absolute
```

---

#### Panel: Service Uptime (Backend)

```
Query (Prometheus):
  time() - max(container_start_time_seconds{name="dev-backend-1"}) by (name)

Why max()? — cAdvisor keeps old container records after restarts.
max() takes the most recent start time, so uptime shows current container only.
```

```
Visualization:   Stat
Unit:            Duration (d h m s)    ← NOT "seconds (s)", pick the duration format
Decimals:        0
Color scheme:    Classic palette
Color mode:      Value
Calculation:     Last
Graph mode:      None
Text mode:       Auto
Orientation:     Auto

Thresholds:      None needed
```

---

#### Panel: Current Error Rate

```
Query (Prometheus):
  (sum(rate(django_http_responses_total_by_status_total{status=~"5.."}[5m]))
  / sum(rate(django_http_responses_total_by_status_total[5m]))) * 100
```

```
Visualization:   Stat
Unit:            Percent (0-100)
Decimals:        2
Color scheme:    Thresholds only
Color mode:      Background
Calculation:     Last
Graph mode:      None

Thresholds:
  Base (0):     Green  #299c46
  Add → 1:      Yellow #e5a132
  Add → 5:      Red    #c4162a
Thresholds mode: Absolute
```

---

### ROW 2 — BUSINESS METRICS

> ⚠️ All 4 panels below are Phase 2 — metrics don't exist yet.
> Skip this row for now. Come back after adding custom Django counters.

```
[PLACEHOLDER] Total Registered Users    → django_user_count [CUSTOM]
[PLACEHOLDER] New Users (Last 24h)      → increase(django_user_registrations_total[24h]) [CUSTOM]
[PLACEHOLDER] Posts Created (Last 24h)  → increase(django_post_created_total[24h]) [CUSTOM]
[PLACEHOLDER] Engagement Rate           → requires django_like_total, django_comment_created_total [CUSTOM]
```

---

### ROW 3 — PERFORMANCE SLIs

---

#### Panel: API Latency (P50, P95, P99)

```
Query A (Prometheus):
  histogram_quantile(0.50, sum by (le) (rate(django_http_requests_latency_including_middlewares_seconds_bucket{job="backend"}[5m])))
  Legend: P50

Query B (Prometheus):
  histogram_quantile(0.95, sum by (le) (rate(django_http_requests_latency_including_middlewares_seconds_bucket{job="backend"}[5m])))
  Legend: P95

Query C (Prometheus):
  histogram_quantile(0.99, sum by (le) (rate(django_http_requests_latency_including_middlewares_seconds_bucket{job="backend"}[5m])))
  Legend: P99

Why sum by (le)? — correct SRE-standard way to aggregate histograms.
```

```
Visualization:    Time series
Unit:             Seconds (s)
Decimals:         3
Tooltip mode:     Multi cursor
Legend mode:      Table
Legend placement: Bottom
Legend values:    Last, Min, Max

Graph styles:
  Style:          Lines
  Line width:     2
  Fill opacity:   10
  Gradient mode:  Opacity
  Show points:    Never
  Stack series:   Off

Axis:
  Left Y label:   "Latency (s)"
  Min:            0
  Soft max:       leave empty

Field overrides:
  Override 1 — Fields with name "P50":
    Color: Fixed color → Green  #31a354
    Line width: 1
  Override 2 — Fields with name "P95":
    Color: Fixed color → Orange #feb24c
    Line width: 2
  Override 3 — Fields with name "P99":
    Color: Fixed color → Red    #de2d26
    Line width: 3

Thresholds (optional visual guide line):
  Add → 0.5: Red dashed line (SLO target)
  Show thresholds: As lines
```

**What P50/P95/P99 means:**

| Percentile | Meaning | Production target |
|-----------|---------|-------------------|
| P50 | Half your requests are faster than this | < 100ms |
| P95 | 95% of requests are faster than this | < 200ms |
| P99 | 99% of requests are faster than this | < 500ms |

P99 is what your worst users experience. Averages hide spikes — percentiles don't.

---

#### Panel: Error Rate by Status

```
Query (Prometheus):
  sum(rate(django_http_responses_total_by_status_total[5m])) by (status)
  Legend: {{status}}
```

```
Visualization:    Time series
Unit:             Requests/sec (reqps)
Decimals:         2
Tooltip mode:     Multi cursor
Legend mode:      Table
Legend placement: Bottom
Legend values:    Last, Max

Graph styles:
  Style:          Lines
  Line width:     1
  Fill opacity:   20
  Gradient mode:  Opacity
  Stack series:   Normal
  Show points:    Never

Field overrides:
  Override — Fields with name matching /2../: Color: Green  #31a354
  Override — Fields with name matching /4../: Color: Orange #feb24c
  Override — Fields with name matching /5../: Color: Red    #de2d26
```

---

#### Panel: Throughput (Requests/sec)

```
Query (Prometheus):
  sum(rate(django_http_requests_total_by_method_total[5m]))
  Legend: Requests/sec
```

```
Visualization:    Time series
Unit:             Requests/sec (reqps)
Decimals:         0
Tooltip mode:     Single
Legend mode:      Hidden

Graph styles:
  Style:          Lines
  Line width:     2
  Fill opacity:   30
  Gradient mode:  Scheme
  Color scheme:   Blues
  Show points:    Never
  Stack series:   Off

Axis:
  Left Y label:   "req/s"
  Min:            0
```

---

### ROW 4 — RESOURCE USAGE

---

#### Panel: CPU Usage by Container

```
Query (Prometheus):
  sum(rate(container_cpu_usage_seconds_total{container!="", container!="cadvisor", container!="prometheus"}[5m])) by (container)
  Legend: {{container}}
```

```
Visualization:    Time series
Unit:             Cores
Decimals:         2
Tooltip mode:     Multi cursor
Legend mode:      Table
Legend placement: Right
Legend values:    Last, Max

Graph styles:
  Style:          Lines
  Line width:     1
  Fill opacity:   20
  Gradient mode:  Scheme
  Stack series:   Normal
  Show points:    Never

Axis:
  Left Y label:   "CPU cores"
  Min:            0
```

---

#### Panel: Memory Usage by Container

```
Query (Prometheus):
  sum(container_memory_working_set_bytes{container!="", container!="cadvisor"}) by (container)
  Legend: {{container}}
```

```
Visualization:    Time series
Unit:             Bytes (auto — Grafana shows KB/MB/GB automatically)
Decimals:         1
Tooltip mode:     Multi cursor
Legend mode:      Table
Legend placement: Right
Legend values:    Last, Max

Graph styles:
  Style:          Lines
  Line width:     1
  Fill opacity:   20
  Gradient mode:  Scheme
  Stack series:   Normal
  Show points:    Never

Axis:
  Left Y label:   "Memory"
  Min:            0
```

---

#### Panel: Recent Error Logs

```
Query (Loki):
  {service="backend"} |= "ERROR"

Datasource: Loki
```

```
Visualization:    Logs
Max lines:        50
Order:            Descending (newest first)
Wrap lines:       On
Show time:        On
Show labels:      On
Show common labels: On
Deduplication:    None
```

---

---

# 📁 01-INFRASTRUCTURE

## 📊 Dashboard: Host Overview

**Import:** Dashboards → New → Import → ID: `1860` → Select Prometheus datasource → Import
**Move to folder:** 01-Infrastructure

---

## 📊 Dashboard: Container Resources

**Import:** Dashboards → New → Import → ID: `14282` → Select Prometheus datasource → Import
**Move to folder:** 01-Infrastructure

---

## 📊 Dashboard: Prometheus Stats

**Import:** Dashboards → New → Import → ID: `11074` → Select Prometheus datasource → Import
**Move to folder:** 01-Infrastructure

---

---

# 📁 02-SERVICES

## 📊 Dashboard: Django API

**Settings:** Auto-refresh: 30s | Default range: Last 1 hour

---

### ROW 1 — REQUEST VOLUME

---

#### Panel: Total Request Rate

```
Query (Prometheus):
  sum(rate(django_http_requests_total_by_method_total[5m]))
  Legend: Total
```

```
Visualization:   Stat
Unit:            Requests/sec (reqps)
Decimals:        1
Color scheme:    Classic palette
Color mode:      Value
Calculation:     Last
Graph mode:      Area (sparkline)
Text mode:       Auto
Orientation:     Auto
```

---

#### Panel: Requests by Method

```
Query (Prometheus):
  sum(rate(django_http_requests_total_by_method_total[5m])) by (method)
  Legend: {{method}}
```

```
Visualization:    Pie chart
Unit:             Requests/sec (reqps)
Decimals:         2
Legend mode:      Table
Legend placement: Right
Legend values:    Value, Percent

Labels:           Name, Percent
Tooltip mode:     Multi
```

---

#### Panel: Requests by View — Top 10

```
Query (Prometheus):
  topk(10, sum(rate(django_http_requests_total_by_view_transport_method_total[5m])) by (view))
  Legend: {{view}}
```

```
Visualization:    Bar gauge
Unit:             Requests/sec (reqps)
Decimals:         2
Orientation:      Horizontal
Display mode:     Gradient
Show:             Calculate = Last
Legend:           Show values = On

Min:              0
Color scheme:     Blues
```

---

### ROW 2 — PERFORMANCE

---

#### Panel: Response Time Percentiles

```
Query A (Prometheus):
  histogram_quantile(0.50, sum by (le) (rate(django_http_requests_latency_including_middlewares_seconds_bucket{job="backend"}[5m])))
  Legend: P50

Query B (Prometheus):
  histogram_quantile(0.95, sum by (le) (rate(django_http_requests_latency_including_middlewares_seconds_bucket{job="backend"}[5m])))
  Legend: P95

Query C (Prometheus):
  histogram_quantile(0.99, sum by (le) (rate(django_http_requests_latency_including_middlewares_seconds_bucket{job="backend"}[5m])))
  Legend: P99
```

```
Visualization:    Time series
Unit:             Seconds (s)
Decimals:         3
Tooltip mode:     Multi cursor
Legend mode:      Table
Legend placement: Bottom
Legend values:    Last, Min, Max, Mean

Graph styles:
  Style:          Lines
  Fill opacity:   10
  Gradient mode:  Opacity
  Show points:    Never
  Stack series:   Off

Field overrides:
  "P50": Color: Green #31a354, Line width: 1
  "P95": Color: Orange #feb24c, Line width: 2
  "P99": Color: Red #de2d26, Line width: 3

Thresholds:
  0.5: Red dashed  (P99 SLO target)
  0.2: Yellow dashed (P95 SLO target)
  Show thresholds: As lines
```

---

#### Panel: Latency by View — P95 per Endpoint

```
Query (Prometheus):
  histogram_quantile(0.95, sum by (view, le) (rate(django_http_requests_latency_seconds_by_view_method_bucket{job="backend"}[5m])))
  Legend: {{view}}
```

```
Visualization:    Time series
Unit:             Seconds (s)
Decimals:         3
Tooltip mode:     Multi cursor
Legend mode:      Table
Legend placement: Bottom
Legend values:    Last, Max

Graph styles:
  Style:          Lines
  Line width:     1
  Fill opacity:   0
  Show points:    Never
  Stack series:   Off
```

---

#### Panel: Slow Views — P95 > 100ms

```
Query (Prometheus):
  histogram_quantile(0.95, sum by (view, le) (rate(django_http_requests_latency_seconds_by_view_method_bucket{job="backend"}[5m]))) > 0.1
  Legend: {{view}}

Note: Only shows series that breach 100ms. If nothing shows, all views are fast — that's good.
```

```
Visualization:    Table
Unit:             Seconds (s)
Decimals:         3

Columns:         view, Value
Sort by:         Value descending

Standard options:
  Color scheme:  Thresholds only

Thresholds:
  Base:          Green
  0.1:           Yellow
  0.5:           Red
```

---

#### Panel: Response Time Heatmap

```
Query (Prometheus):
  sum(rate(django_http_requests_latency_including_middlewares_seconds_bucket{job="backend"}[5m])) by (le)
  Legend: {{le}}
```

```
Visualization:    Heatmap
Unit:             Seconds (s)

Y Axis:
  Unit:           Seconds (s)
  Decimals:       3

Color scheme:     Oranges
  Low:            #fee5d9
  High:           #de2d26

Show tooltip:     On
Tooltip mode:     Single
```

---

### ROW 3 — ERRORS

---

#### Panel: Overall Error Percentage

```
Query (Prometheus):
  (sum(rate(django_http_responses_total_by_status_total{status=~"5.."}[5m]))
  / sum(rate(django_http_responses_total_by_status_total[5m]))) * 100
```

```
Visualization:    Time series
Unit:             Percent (0-100)
Decimals:         2
Tooltip mode:     Single
Legend mode:      Hidden

Graph styles:
  Style:          Lines
  Line width:     2
  Fill opacity:   50
  Gradient mode:  Opacity
  Color:          Fixed → Red #de2d26
  Show points:    Never
  Stack series:   Off

Thresholds:
  1:              Yellow (warning)
  5:              Red    (critical)
  Show thresholds: As filled regions

Axis:
  Min:            0
  Max:            100 (or leave auto)
```

---

#### Panel: Status Code Distribution

```
Query (Prometheus):
  sum(rate(django_http_responses_total_by_status_total[5m])) by (status)
  Legend: {{status}}
```

```
Visualization:    Pie chart
Unit:             Requests/sec
Decimals:         2
Legend mode:      Table
Legend placement: Right
Legend values:    Value, Percent
Labels:           Name, Percent
Tooltip mode:     Multi

Field overrides:
  Fields matching /2../: Color: Green  #31a354
  Fields matching /4../: Color: Orange #feb24c
  Fields matching /5../: Color: Red    #de2d26
```

---

#### Panel: Error Rate by View — Top 5

```
Query (Prometheus):
  topk(5, sum(rate(django_http_responses_total_by_status_view_method_total{status=~"5.."}[5m])) by (view))
  Legend: {{view}}
```

```
Visualization:    Bar gauge
Unit:             Requests/sec
Decimals:         3
Orientation:      Horizontal
Display mode:     Gradient
Show:             Calculate = Last
Color scheme:     Reds
Min:              0

Note: Shows nothing if no 5xx errors — that's a good sign.
```

---

### ROW 4 — DATABASE (from Django — no extra exporter needed)

---

#### Panel: DB Queries per Second

```
Query (Prometheus):
  rate(django_db_execute_total{job="backend"}[5m])
  Legend: DB queries/sec
```

```
Visualization:   Stat
Unit:            Ops/sec (ops)
Decimals:        1
Color scheme:    Classic palette
Color mode:      Value
Calculation:     Last
Graph mode:      Area
```

---

#### Panel: DB Query Latency P50 / P95 / P99

```
Query A (Prometheus):
  histogram_quantile(0.50, sum by (le) (rate(django_db_query_duration_seconds_bucket{job="backend"}[5m])))
  Legend: P50

Query B (Prometheus):
  histogram_quantile(0.95, sum by (le) (rate(django_db_query_duration_seconds_bucket{job="backend"}[5m])))
  Legend: P95

Query C (Prometheus):
  histogram_quantile(0.99, sum by (le) (rate(django_db_query_duration_seconds_bucket{job="backend"}[5m])))
  Legend: P99
```

```
Visualization:    Time series
Unit:             Seconds (s)
Decimals:         3
Tooltip mode:     Multi cursor
Legend mode:      Table
Legend placement: Bottom
Legend values:    Last, Max

Graph styles:
  Style:          Lines
  Fill opacity:   10
  Show points:    Never

Field overrides:
  "P50": Color: Green  #31a354, Line width: 1
  "P95": Color: Orange #feb24c, Line width: 2
  "P99": Color: Red    #de2d26, Line width: 3

Thresholds:
  0.1: Yellow
  0.5: Red
  Show thresholds: As lines
```

---

#### Panel: DB New Connection Rate

```
Query (Prometheus):
  rate(django_db_new_connections_total{job="backend"}[5m])
  Legend: Connections/sec
```

```
Visualization:    Time series
Unit:             Connections/sec
Decimals:         2
Tooltip mode:     Single
Legend mode:      Hidden

Graph styles:
  Style:          Lines
  Line width:     2
  Fill opacity:   30
  Color:          Fixed → Blue #1f78d4
  Show points:    Never

Axis:
  Min: 0
```

---

### SLO Targets (add as Text panel at top of dashboard)

```
Visualization: Text
Mode: Markdown
Content:
  ## API SLO Targets
  | Metric | Target |
  |--------|--------|
  | Availability | > 99.9% |
  | P99 Latency | < 500ms |
  | P95 Latency | < 200ms |
  | Error Rate | < 0.1% |
  | DB P95 Query | < 100ms |
```

---

## 📊 Dashboard: PostgreSQL Database

**Settings:** Auto-refresh: 30s | Default range: Last 1 hour

---

### Phase 1 — Django DB Metrics (available now, no extra setup)

---

#### Panel: DB Query Rate

```
Query (Prometheus):
  rate(django_db_execute_total{job="backend"}[5m])
```

```
Visualization:    Time series
Unit:             Ops/sec
Decimals:         1
Graph styles:     Lines, Fill opacity: 30, Color: Blue #1f78d4
Axis Min:         0
Legend:           Hidden
```

---

#### Panel: DB Query Latency

```
(same as DB Query Latency panel in Django API dashboard — copy it here)
```

---

#### Panel: DB Connection Rate

```
Query (Prometheus):
  rate(django_db_new_connections_total{job="backend"}[5m])
```

```
Visualization:    Stat
Unit:             Connections/sec
Decimals:         2
Calculation:      Last
Graph mode:       Area
Color scheme:     Classic palette
```

---

### Phase 2 — postgres_exporter (add later)

**Setup:**

Add to `compose/dev/compose.monitoring.dev.yml`:
```yaml
postgres-exporter:
  image: prometheuscommunity/postgres-exporter:latest
  container_name: postgres_exporter
  restart: unless-stopped
  environment:
    DATA_SOURCE_NAME: "postgresql://YOUR_USER:YOUR_PASS@postgres:5432/YOUR_DB?sslmode=disable"
  expose:
    - 9187
  networks:
    - bloggyspace_nw
  depends_on:
    - postgres
```

Add to `prometheus.yml`:
```yaml
- job_name: 'postgres'
  static_configs:
    - targets: ['postgres-exporter:9187']
```

**Panels (once running):**

Active Connections:
```promql
sum(pg_stat_database_numbackends) by (datname)
```
```
Visualization: Stat | Unit: None | Thresholds: >100 Yellow, >150 Red
```

Cache Hit Ratio:
```promql
(pg_stat_database_blks_hit / (pg_stat_database_blks_hit + pg_stat_database_blks_read)) * 100
```
```
Visualization: Gauge | Unit: Percent | Min: 0, Max: 100
Thresholds: <95 Red, 95-99 Yellow, 99-100 Green
```

Transactions per Second:
```promql
rate(pg_stat_database_xact_commit[5m]) + rate(pg_stat_database_xact_rollback[5m])
```
```
Visualization: Time series | Unit: tps | Graph: Lines
```

Database Size:
```promql
pg_database_size_bytes
```
```
Visualization: Stat | Unit: Bytes (auto) | Graph mode: Area
```

---

---

# 📁 03-BUSINESS (Phase 2)

> ⚠️ These dashboards require custom metrics added to Django views.
> Create the folder now, leave dashboards empty until Phase 2.

## How to add custom metrics (when ready)

Create `backend/api/metrics.py`:
```python
from prometheus_client import Counter, Gauge

user_registrations_total = Counter(
    'django_user_registrations_total',
    'Total user registrations'
)

user_count = Gauge(
    'django_user_count',
    'Total registered users'
)

post_created_total = Counter(
    'django_post_created_total',
    'Total posts created'
)

like_total = Counter(
    'django_like_total',
    'Total likes',
    ['post_id']
)

comment_created_total = Counter(
    'django_comment_created_total',
    'Total comments created',
    ['post_id']
)
```

Then in your views call `.inc()` or `.set()` at the right point.

---

## 📊 Dashboard: User Analytics

**(Phase 2 — build after custom metrics are added)**

Panels and queries:

```promql
# Total users (Stat panel)
django_user_count

# New users daily (Stat + sparkline)
increase(django_user_registrations_total[24h])

# New users weekly (Stat)
increase(django_user_registrations_total[7d])
```

```
All panels:
  Visualization: Stat
  Unit: None (short)
  Decimals: 0
  Graph mode: Area (sparkline where useful)
  Color scheme: Classic palette
```

---

## 📊 Dashboard: Content Metrics

**(Phase 2 — build after custom metrics are added)**

```promql
# Posts created (last 24h)  [Stat]
increase(django_post_created_total[24h])

# Comments per minute  [Time series]
rate(django_comment_created_total[1m])

# Likes per minute  [Time series]
rate(django_like_total[1m])

# Top posts by likes  [Bar gauge]
topk(5, increase(django_like_total[24h]) by (post_id))
```

---

---

# 📁 04-LOGS

## 📊 Dashboard: Log Explorer

**Settings:** Auto-refresh: 10s | Default range: Last 15 minutes

---

#### Panel: Log Volume by Service

```
Query (Loki):
  sum(count_over_time({service=~".+"}[5m])) by (service)
  Legend: {{service}}

Datasource: Loki
```

```
Visualization:    Bar gauge
Unit:             Logs/5min
Orientation:      Horizontal
Display mode:     Gradient
Show:             Calculate = Last
Color scheme:     Greens
Min:              0
Legend:           Show values = On
```

---

#### Panel: Error Log Rate

```
Query (Loki):
  count_over_time({service="backend"} |= "ERROR" [5m])

Datasource: Loki
```

```
Visualization:    Time series
Unit:             Logs/5min
Decimals:         0
Graph styles:
  Style:          Bars
  Fill opacity:   80
  Color:          Fixed → Red #de2d26
  Line width:     0

Thresholds:
  100: Red
  Show thresholds: As filled regions
Axis Min: 0
Legend: Hidden
```

---

#### Panel: Log Level Distribution

```
Query (Loki):
  sum(count_over_time({container="dev-backend-1"} | json | level != "" [5m])) by (level)
  Legend: {{level}}

Datasource: Loki
```

```
Visualization:    Pie chart
Legend mode:      Table
Legend placement: Right
Legend values:    Value, Percent
Labels:           Name, Percent
Tooltip mode:     Multi

Field overrides:
  "error":   Color: Red    #de2d26
  "warning": Color: Orange #feb24c
  "info":    Color: Green  #31a354
  "debug":   Color: Blue   #1f78d4
```

---

#### Panel: Recent Error Logs

```
Query (Loki):
  {service="backend"} |= "ERROR"

Datasource: Loki
```

```
Visualization:    Logs
Max lines:        100
Order:            Descending
Wrap lines:       On
Show time:        On
Show labels:      On
Show common labels: On
Deduplication:    None
```

---

#### Panel: Warning Log Rate

```
Query (Loki):
  count_over_time({service="backend"} |= "WARNING" [5m])

Datasource: Loki
```

```
Visualization:    Time series
Unit:             Logs/5min
Decimals:         0
Graph styles:
  Style:          Lines
  Line width:     2
  Fill opacity:   40
  Color:          Fixed → Orange #feb24c
Axis Min: 0
Legend: Hidden
```

---

### Common Loki Queries (for Explore tab)

```logql
# All backend logs
{container="dev-backend-1"}

# Error logs only
{container="dev-backend-1"} |= "ERROR"

# Errors or warnings
{container="dev-backend-1"} |~ "(ERROR|WARNING)"

# Nginx access logs
{container="dev-nginx-1"}

# Postgres logs
{container="dev-postgres-1"}

# Specific text
{service="backend"} |= "Database timeout"

# Regex pattern
{container="dev-backend-1"} |~ "User.*logged in"

# Exclude noise
{container="dev-backend-1"} != "health check"

# JSON parse and filter by level
{container="dev-backend-1"} | json | level = "error"

# All services error count
sum(count_over_time({service=~".+"} |= "ERROR" [5m])) by (service)
```

---

---

# 📁 05-ALERTS

## 📊 Dashboard: Alert Status

**Settings:** Auto-refresh: 1m | Default range: Last 24 hours

---

#### Panel: Active Alerts

```
Query (Prometheus):
  ALERTS{alertstate="firing"}
```

```
Visualization:    Table
Show:             All rows

Columns to show:
  alertname, severity, instance, team

Column widths:
  alertname: 200px
  severity:  100px
  instance:  150px
  team:      100px

Cell display:     Color background on severity column
  Thresholds:
    "critical": Red    #c4162a
    "warning":  Yellow #e5a132
    "info":     Blue   #1f78d4

Sort by:          severity (descending — critical on top)
```

---

#### Panel: Alert Severity Distribution

```
Query (Prometheus):
  count(ALERTS{alertstate="firing"}) by (severity)
  Legend: {{severity}}
```

```
Visualization:    Pie chart
Legend mode:      Table
Legend placement: Right
Legend values:    Value, Percent
Tooltip mode:     Multi

Field overrides:
  "critical": Color: Red    #c4162a
  "warning":  Color: Orange #feb24c
  "info":     Color: Blue   #1f78d4
```

---

#### Panel: Alerts Over Time

```
Query (Prometheus):
  count(ALERTS{alertstate="firing"}) by (alertname)
  Legend: {{alertname}}
```

```
Visualization:    Time series
Unit:             None (short)
Decimals:         0
Tooltip mode:     Multi cursor
Legend mode:      Table
Legend placement: Bottom

Graph styles:
  Style:          Bars
  Fill opacity:   80
  Stack series:   Normal
  Line width:     0

Axis Min: 0
```

---

---

# 📁 06-CAPACITY

## 📊 Dashboard: Capacity Planning

**Settings:** Auto-refresh: 1h | Default range: Last 7 days

---

#### Panel: CPU Trend (7 days)

```
Query A (Prometheus):
  avg(rate(container_cpu_usage_seconds_total{container="dev-backend-1"}[1h]))
  Legend: Actual CPU

Query B (Prometheus):
  predict_linear(avg(rate(container_cpu_usage_seconds_total{container="dev-backend-1"}[5m]))[7d:5m], 86400 * 14)
  Legend: Forecast (14d)
```

```
Visualization:    Time series
Unit:             Cores
Decimals:         3
Tooltip mode:     Multi cursor
Legend mode:      Table
Legend placement: Bottom
Legend values:    Last

Graph styles:
  Style:          Lines
  Fill opacity:   20
  Show points:    Never
  Stack series:   Off

Field overrides:
  "Actual CPU":     Color: Blue #1f78d4, Line width: 2, Fill opacity: 20
  "Forecast (14d)": Color: Orange #ff9830, Line width: 2, Line style: Dashed, Fill opacity: 0
```

---

#### Panel: Memory Trend (7 days)

```
Query A (Prometheus):
  avg(container_memory_working_set_bytes{container="dev-backend-1"})
  Legend: Actual Memory

Query B (Prometheus):
  predict_linear(avg(container_memory_working_set_bytes{container="dev-backend-1"})[7d:5m], 86400 * 14)
  Legend: Forecast (14d)
```

```
Visualization:    Time series
Unit:             Bytes (auto)
Decimals:         1
Legend mode:      Table
Legend values:    Last

Field overrides:
  "Actual Memory":  Color: Purple #756bb1, Line width: 2, Fill opacity: 20
  "Forecast (14d)": Color: Orange #ff9830, Line width: 2, Line style: Dashed, Fill opacity: 0
```

---

#### Panel: Disk Usage Trend

```
Query (Prometheus):
  (node_filesystem_size_bytes{mountpoint="/"} - node_filesystem_free_bytes{mountpoint="/"}) / node_filesystem_size_bytes{mountpoint="/"} * 100
  Legend: Disk Used %
```

```
Visualization:    Time series
Unit:             Percent (0-100)
Decimals:         1
Graph styles:     Lines, Fill opacity: 30, Color: Red #de2d26
Legend:           Hidden

Thresholds:
  80: Yellow
  90: Red
  Show thresholds: As lines

Axis Min: 0, Max: 100
```

---

#### Panel: Request Volume Forecast

```
Query A (Prometheus):
  sum(rate(django_http_requests_total_by_method_total[1h]))
  Legend: Actual

Query B (Prometheus):
  predict_linear(sum(rate(django_http_requests_total_by_method_total[5m]))[7d:5m], 86400 * 14)
  Legend: Forecast (14d)
```

```
Visualization:    Time series
Unit:             Requests/sec
Decimals:         2
Legend mode:      Table
Legend values:    Last

Field overrides:
  "Actual":        Color: Blue,   Line width: 2, Fill opacity: 20
  "Forecast (14d)":Color: Orange, Line width: 2, Line style: Dashed, Fill opacity: 0
```

---

#### Panel: When Will Disk Be Full?

```
Query (Prometheus):
  predict_linear(node_filesystem_free_bytes{mountpoint="/"}[6h], 86400 * 30)

Note: Returns negative value = disk full within 30 days.
      Returns positive value = disk has this many bytes free in 30 days.
      Show "Days until full" by converting:
  predict_linear(node_filesystem_free_bytes{mountpoint="/"}[6h], 86400) / 1073741824

Or a simple directional check — does it go negative within 30 days?
```

```
Visualization:    Stat
Unit:             Bytes (auto)
Decimals:         1
Color scheme:     Thresholds only
Color mode:       Background
Calculation:      Last

Thresholds:
  Negative value:  Red    (disk will fill)
  0 to 10GB:       Yellow (low space)
  10GB+:           Green

Display name:     "Disk free in 30 days (predicted)"
```

---

---

# 🚨 ALERTING SETUP

## Files to create

### File 1: `docker/dev/monitoring/prometheus/rules/alerts.yml`

```yaml
groups:
  - name: api_alerts
    interval: 30s
    rules:

      - alert: APIHighErrorRate
        expr: |
          (sum(rate(django_http_responses_total_by_status_total{status=~"5.."}[5m]))
          / sum(rate(django_http_responses_total_by_status_total[5m]))) * 100 > 5
        for: 2m
        labels:
          severity: critical
          team: backend
        annotations:
          summary: "High API error rate"
          description: "Error rate is {{ $value | printf \"%.2f\" }}% for the last 5 minutes"

      - alert: APIDown
        expr: up{job="backend"} == 0
        for: 1m
        labels:
          severity: critical
          team: backend
        annotations:
          summary: "API is down"
          description: "Backend service has been down for 1 minute"

      - alert: HighLatency
        expr: |
          histogram_quantile(0.95,
          sum by (le) (rate(django_http_requests_latency_including_middlewares_seconds_bucket{job="backend"}[5m]))) > 0.5
        for: 5m
        labels:
          severity: warning
          team: backend
        annotations:
          summary: "High API latency"
          description: "P95 latency is {{ $value | printf \"%.2f\" }}s"

      - alert: ElevatedErrorRate
        expr: |
          (sum(rate(django_http_responses_total_by_status_total{status=~"5.."}[5m]))
          / sum(rate(django_http_responses_total_by_status_total[5m]))) * 100 > 1
        for: 2m
        labels:
          severity: warning
          team: backend
        annotations:
          summary: "Elevated API error rate"
          description: "Error rate is {{ $value | printf \"%.2f\" }}%"

      - alert: SlowDBQueries
        expr: |
          histogram_quantile(0.95,
          sum by (le) (rate(django_db_query_duration_seconds_bucket{job="backend"}[5m]))) > 0.1
        for: 5m
        labels:
          severity: warning
          team: backend
        annotations:
          summary: "Slow database queries"
          description: "DB P95 query time is {{ $value | printf \"%.3f\" }}s"

  - name: infrastructure_alerts
    interval: 30s
    rules:

      - alert: HighCPUUsage
        expr: |
          100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 10m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "High CPU usage"
          description: "Host CPU is {{ $value | printf \"%.1f\" }}%"

      - alert: HighMemoryUsage
        expr: |
          (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 85
        for: 10m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "High memory usage"
          description: "Memory usage is {{ $value | printf \"%.1f\" }}%"

      - alert: LowDiskSpace
        expr: |
          (node_filesystem_free_bytes{mountpoint="/"}
          / node_filesystem_size_bytes{mountpoint="/"}) * 100 < 10
        for: 5m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "Low disk space"
          description: "Only {{ $value | printf \"%.1f\" }}% free on root partition"

      - alert: ContainerRestarting
        expr: changes(container_start_time_seconds{name!=""}[1h]) > 3
        for: 5m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "Container {{ $labels.name }} restarting frequently"
          description: "Container has restarted {{ $value }} times in the last hour"

  - name: capacity_alerts
    interval: 1h
    rules:

      - alert: DiskWillFillIn30Days
        expr: |
          predict_linear(node_filesystem_free_bytes{mountpoint="/"}[6h], 3600 * 24 * 30) < 0
        for: 1h
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "Disk will fill in 30 days"
          description: "Based on current growth, disk will be full within 30 days"
```

---

### File 2: `docker/dev/monitoring/alertmanager/alertmanager.yml`

```yaml
global:
  slack_api_url: '${SLACK_WEBHOOK_URL}'
  resolve_timeout: 5m

route:
  group_by: ['alertname', 'team']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 12h
  receiver: 'slack-notifications'

  routes:
    - match:
        severity: critical
      receiver: slack-critical
      continue: true

    - match:
        severity: warning
      receiver: slack-warnings
      continue: true

receivers:
  - name: 'slack-notifications'
    slack_configs:
      - channel: '#alerts'
        send_resolved: true
        title: '{{ if eq .Status "firing" }}🔥{{ else }}✅{{ end }} {{ .CommonLabels.alertname }}'
        text: |
          {{ range .Alerts }}*{{ .Status | toUpper }}* — {{ .Annotations.description }}{{ end }}

  - name: 'slack-critical'
    slack_configs:
      - channel: '#critical-alerts'
        send_resolved: true
        color: 'danger'
        title: '🚨 CRITICAL: {{ .GroupLabels.alertname }}'
        text: |
          *Description:* {{ .CommonAnnotations.description }}
          *Time:* {{ .StartsAt.Format "2006-01-02 15:04:05 UTC" }}
          @here

  - name: 'slack-warnings'
    slack_configs:
      - channel: '#warnings'
        send_resolved: true
        color: 'warning'
        title: '⚠️ WARNING: {{ .GroupLabels.alertname }}'
        text: |
          *Description:* {{ .CommonAnnotations.description }}

inhibit_rules:
  - source_match:
      alertname: 'APIDown'
    target_match_re:
      alertname: 'HighLatency|APIHighErrorRate|ElevatedErrorRate'
    equal: ['instance']
```

---

### File 3: Update `docker/dev/monitoring/prometheus/prometheus.yml`

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

alerting:
  alertmanagers:
    - static_configs:
        - targets: ['alertmanager:9093']

rule_files:
  - /etc/prometheus/rules/*.yml

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['prometheus:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']

  - job_name: 'backend'
    metrics_path: /metrics
    static_configs:
      - targets: ['backend:8000']

  - job_name: 'alloy'
    static_configs:
      - targets: ['alloy:12345']

  - job_name: 'loki'
    static_configs:
      - targets: ['loki:3100']

  # Phase 2 — uncomment when ready:
  # - job_name: 'postgres'
  #   static_configs:
  #     - targets: ['postgres-exporter:9187']
  # - job_name: 'nginx'
  #   static_configs:
  #     - targets: ['nginx-exporter:9113']
```

### Prometheus volumes (in compose.monitoring.dev.yml):

```yaml
prometheus:
  volumes:
    - ../../docker/dev/monitoring/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    - ../../docker/dev/monitoring/prometheus/rules:/etc/prometheus/rules
    - prometheus_bloggyspace_dev_data:/prometheus
```

---

### File 4: Add to `compose/dev/compose.monitoring.dev.yml`

```yaml
alertmanager:
  image: prom/alertmanager:v0.28.1
  container_name: alertmanager
  restart: unless-stopped
  volumes:
    - ../../docker/dev/monitoring/alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml
    - alertmanager_data:/alertmanager
  command:
    - '--config.file=/etc/alertmanager/alertmanager.yml'
    - '--storage.path=/alertmanager'
  env_file:
    - ../../backend/.envs/.env.dev
  expose:
    - 9093
  networks:
    - monitoring_dev_nw
    - bloggyspace_nw
```

Add to volumes section:
```yaml
volumes:
  alertmanager_data:
```

---

### File 5: Add to `docker/dev/monitoring/nginx/nginx.conf`

```nginx
server {
    listen 80;
    server_name alertmanager.bloggyspace.local;

    location / {
        proxy_pass http://alertmanager:9093;
        proxy_redirect off;
        proxy_buffering off;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Add to `/etc/hosts`:
```
127.0.0.1 alertmanager.bloggyspace.local
```

---

### Deploy alerting:

```bash
# Create rules directory
mkdir -p docker/dev/monitoring/prometheus/rules

# Create alertmanager config directory
mkdir -p docker/dev/monitoring/alertmanager

# Apply everything
docker compose -f compose/dev/compose.monitoring.dev.yml up -d --build

# Verify rules loaded
curl -s http://prometheus.bloggyspace.local:8080/api/v1/rules | python3 -m json.tool

# Verify alertmanager running
docker logs alertmanager --tail 20

# Test Slack integration
curl -H "Content-Type: application/json" -d '{
  "status": "firing",
  "alerts": [{
    "labels": {"alertname": "TestAlert", "severity": "warning"},
    "annotations": {"description": "Testing Slack from BloggySpace monitoring"}
  }]
}' http://localhost:9093/api/v1/alerts
```

---

---

# 📋 IMPLEMENTATION CHECKLIST

## Phase 1 — Dashboards (do now)
- [ ] Create all 7 Grafana folders
- [ ] Import ID 1860 → 01-Infrastructure
- [ ] Import ID 14282 → 01-Infrastructure
- [ ] Import ID 11074 → 01-Infrastructure
- [ ] Build: 00-Production Overview / Single Pane of Glass
  - [ ] Row 1: Health Status (4 stat panels)
  - [ ] Row 3: Performance SLIs (3 time series)
  - [ ] Row 4: Resource Usage (2 time series + logs)
- [ ] Build: 02-Services / Django API
  - [ ] Row 1: Request Volume (stat + pie + bar gauge)
  - [ ] Row 2: Performance (latency percentiles + per-view + heatmap)
  - [ ] Row 3: Errors (error % + status distribution + top errors)
  - [ ] Row 4: DB metrics (query rate + latency + connections)
- [ ] Build: 02-Services / PostgreSQL (Phase 1 panels only)
- [ ] Build: 04-Logs / Log Explorer
- [ ] Build: 05-Alerts / Alert Status
- [ ] Build: 06-Capacity / Capacity Planning

## Phase 2 — Alerting (do next)
- [ ] Create `docker/dev/monitoring/prometheus/rules/alerts.yml`
- [ ] Update prometheus.yml (rules path + alertmanager target)
- [ ] Add alertmanager to compose
- [ ] Create alertmanager.yml (with SLACK_WEBHOOK_URL)
- [ ] Add nginx block for alertmanager
- [ ] Add alertmanager.bloggyspace.local to /etc/hosts
- [ ] Rebuild + redeploy
- [ ] Test: check rules in Prometheus UI
- [ ] Test: send test alert, verify Slack message

## Phase 3 — Extended
- [ ] Add postgres_exporter to compose
- [ ] Complete PostgreSQL dashboard (Phase 2 panels)
- [ ] Add custom business metrics to Django
- [ ] Build User Analytics dashboard
- [ ] Build Content Metrics dashboard
- [ ] Add nginx-exporter (optional)

---

# 🔧 QUICK REFERENCE — UNIT TYPES IN GRAFANA

| Metric | Grafana Unit | Location in UI |
|--------|-------------|----------------|
| CPU % | Percent (0-100) | Misc → Percent (0-100) |
| Memory | Bytes (auto) | Data → bytes (auto) |
| Latency | Seconds (s) | Time → seconds (s) |
| Request rate | Requests/sec | Throughput → requests/sec (rps) |
| Duration/Uptime | Duration (d h m s) | Time → duration (d h m s) |
| DB queries | Ops/sec | Throughput → ops/sec (ops) |
| Log count | None (short) | Misc → short |
| Availability % | Percent (0-100) | Misc → Percent (0-100) |

# 🔧 QUICK REFERENCE — COMMON ISSUES

| Issue | Fix |
|-------|-----|
| Panel shows two uptime values | Use `time() - max(container_start_time_seconds{name="dev-backend-1"}) by (name)` |
| Latency query returns no data | Use `sum by (le)` inside the rate, not after histogram_quantile |
| Error rate panel shows no data | Check metric name: `django_http_responses_total_by_status_total` not `django_http_responses_total` |
| Container label not found | Use `name=` label from cAdvisor, not `container=` for uptime queries |
| Business metrics empty | Those need custom Django code — Phase 2 |
| Grafana origin not allowed | Check nginx has `Upgrade` + `Connection "upgrade"` headers |
| Rules not loading in Prometheus | Verify volume mounts rules directory and prometheus.yml has `/etc/prometheus/rules/*.yml` |
