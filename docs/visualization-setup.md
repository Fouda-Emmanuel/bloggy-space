Here is the **COMPLETE VISUALIZATION GUIDE** with every panel type, unit, color scheme, threshold, and setting you need for each dashboard.

---

# 🎨 **COMPLETE VISUALIZATION REFERENCE GUIDE**

## **Quick Reference: Panel Types by Use Case**

| What you want to show | Best Panel Type | When to use |
|----------------------|----------------|-------------|
| **A single number** | Stat | Current value, uptime, active users |
| **Change over time** | Time series | Latency trends, CPU over time |
| **Compare categories** | Bar gauge | Top endpoints, error by service |
| **Show proportions** | Pie chart | Status code distribution |
| **List of data** | Table | Active alerts, slow queries |
| **Heat of distribution** | Heatmap | Response time distribution |
| **Raw log messages** | Logs | Debugging, error messages |
| **Text/information** | Text | Instructions, notes |

---

# 📊 **DASHBOARD 1: PRODUCTION OVERVIEW**

## **Row 1: Health Status (Stat Panels)**

### **Panel 1: Overall Availability**
```yaml
Visualization: Stat
Unit: Percent (0-100)
Decimal: 2
Color scheme: Thresholds only
Thresholds:
  - 99.9 to 100: Green (#299c46)
  - 99 to 99.9: Yellow (#e5a132)
  - 0 to 99: Red (#c4162a)
Color mode: Background
Text size: Title 14px, Value 60px
Show: Calculate = Average
Orientation: Horizontal
Wide layout: Auto
```

### **Panel 2: Active Incidents**
```yaml
Visualization: Stat
Unit: None (short)
Color scheme: Thresholds only
Thresholds:
  - 0: Green (#299c46)
  - 1 to 100: Red (#c4162a)
Color mode: Background
Show: Calculate = Count
```

### **Panel 3: Service Uptime (Backend)**
```yaml
Visualization: Stat
Unit: Seconds (d h m s) - use "Duration (d h m s)"
Decimal: 0
Color scheme: Classic palette
Show: Calculate = Average
```

### **Panel 4: Current Error Rate**
```yaml
Visualization: Stat
Unit: Percent (0-100)
Decimal: 2
Thresholds:
  - 0 to 1: Green (#299c46)
  - 1 to 5: Yellow (#e5a132)
  - 5 to 100: Red (#c4162a)
Color mode: Background
```

## **Row 2: Business Metrics (Stat Panels)**

### **Panel 1: Active Users (Last 5 min)**
```yaml
Visualization: Stat
Unit: None (short)
Decimal: 0
Color scheme: Classic palette
Show: Calculate = Average
```

### **Panel 2: New Users (Last 24h)**
```yaml
Visualization: Stat
Unit: None (short)
Decimal: 0
Color scheme: Blue (#1f78d4)
```

### **Panel 3: Posts Created (Last 24h)**
```yaml
Visualization: Stat
Unit: None (short)
Decimal: 0
Color scheme: Green (#33a02c)
```

### **Panel 4: Engagement Rate**
```yaml
Visualization: Stat
Unit: Percent (0-100)
Decimal: 1
Color scheme: Thresholds
Thresholds:
  - 0 to 10: Red
  - 10 to 25: Yellow
  - 25 to 100: Green
```

## **Row 3: Performance SLIs (Time Series Graphs)**

### **Panel 1: API Latency (P50, P95, P99)**
```yaml
Visualization: Time series
Unit: Seconds (s)
Decimal: 3
Legend: Bottom
Legend values: Last, Min, Max

Series overrides:
  - P50: Color #31a354, Line width 1
  - P95: Color #feb24c, Line width 2
  - P99: Color #de2d26, Line width 3

Axis:
  - Placement: Left
  - Label: "Latency (seconds)"
  - Min: 0
  - Soft max: auto

Graph styles:
  - Style: Lines
  - Line width: 1-3 (as above)
  - Fill opacity: 10
  - Gradient mode: Opacity
  - Stack series: Disabled
  - Points: Disabled

Tooltip mode: Multi
Legend mode: Table
Thresholds:
  - P99 > 0.5: Red area warning
```

### **Panel 2: Error Rate by Status**
```yaml
Visualization: Time series
Unit: Requests per second (reqps)
Decimal: 2
Legend: Bottom

Series overrides:
  - 2xx: Color #31a354
  - 4xx: Color #feb24c
  - 5xx: Color #de2d26

Axis:
  - Placement: Left
  - Label: "Requests/sec"

Graph styles:
  - Style: Lines
  - Line width: 1
  - Fill opacity: 20
  - Stack series: Normal (stacked)
  - Gradient mode: Opacity

Tooltip mode: Multi
Legend mode: Table
Legend values: Last, Max
```

### **Panel 3: Throughput (Requests/sec)**
```yaml
Visualization: Time series
Unit: cps (counts per second)
Decimal: 0
Legend: Top

Axis:
  - Placement: Left
  - Label: "Requests per second"
  - Min: 0

Graph styles:
  - Style: Lines
  - Line width: 2
  - Fill opacity: 30
  - Gradient mode: Scheme (Blues)
  - Points: Disabled

Thresholds:
  - Baseline value: Add horizontal line at expected throughput
```

## **Row 4: Resource Usage (Time Series)**

### **Panel 1: CPU Usage by Container**
```yaml
Visualization: Time series
Unit: Cores
Decimal: 2
Legend: Right

Axis:
  - Placement: Left
  - Label: "CPU Cores"
  - Min: 0

Graph styles:
  - Style: Lines
  - Line width: 2
  - Fill opacity: 30
  - Stack series: Normal
  - Gradient mode: Scheme

Thresholds:
  - Add horizontal line at core limit
```

### **Panel 2: Memory Usage by Container**
```yaml
Visualization: Time series
Unit: Bytes (auto format: KB, MB, GB)
Decimal: 1
Legend: Right

Axis:
  - Placement: Left
  - Label: "Memory Usage"

Graph styles:
  - Style: Lines
  - Line width: 2
  - Fill opacity: 30
  - Stack series: Normal
  - Gradient mode: Scheme

Unit format: Auto (will show MB/GB automatically)
```

### **Log Errors Panel**
```yaml
Visualization: Logs
Query type: Loki
Deduplication: On
Time range: Show only last 1 hour
Max lines: 100
Wrap lines: On
Order: Descending
Show time: On
Show labels: On
Show common labels: On
```

---

# 🖥️ **DASHBOARD 2: HOST OVERVIEW**

## **Row 1: System Overview (Stat Panels)**

| Panel | Unit | Thresholds | Color Mode |
|-------|------|------------|------------|
| **CPU Usage** | Percent (0-100) | 0-80: Green, 80-95: Yellow, 95-100: Red | Background |
| **Memory Usage** | Percent (0-100) | 0-85: Green, 85-95: Yellow, 95-100: Red | Background |
| **Disk Usage** | Percent (0-100) | 0-80: Green, 80-90: Yellow, 90-100: Red | Background |
| **Load Average** | None (short) | 0-4: Green, 4-8: Yellow, 8+: Red | Value |

## **Row 2: Detailed Resources (Time Series)**

| Panel | Unit | Graph Style | Special Settings |
|-------|------|-------------|------------------|
| **CPU per Core** | Percent (0-100) | Lines, Stacked | Legend: Bottom, Show all CPUs |
| **Memory Breakdown** | Bytes (auto) | Lines, Stacked | Legend: Right, Show: Used, Cache, Buffer |
| **Disk I/O** | Bps (bytes/sec) | Lines | Dual axis: Read (green), Write (red) |
| **Network Traffic** | Bps (auto to MBps) | Lines | Dual axis: Received (blue), Sent (orange) |

### **CPU per Core Settings:**
```yaml
Visualization: Time series
Unit: Percent (0-100)
Decimal: 1
Legend: Bottom, Mode: Table, Placement: Bottom
Series: Show per CPU core (cpu0, cpu1, etc.)
Axis: Min: 0, Max: 100
Graph styles: Lines, Line width: 1, Fill opacity: 20
Stack series: Normal
```

---

# 🐳 **DASHBOARD 3: CONTAINER RESOURCES**

### **Container Restarts**
```yaml
Visualization: Stat
Unit: None (short)
Decimal: 0
Color scheme: Thresholds
Thresholds:
  - 0: Green
  - 1-3: Yellow
  - 3+: Red
Show: Calculate = Max
```

### **Container Uptime**
```yaml
Visualization: Table
Unit: Duration (d h m s)
Columns: Container, Uptime, Restarts
Sort by: Uptime (ascending)
```

### **CPU per Container**
```yaml
Visualization: Bar gauge
Unit: Cores
Decimal: 2
Orientation: Horizontal
Display mode: Gradient
Show: Calculate = Average
Legend: Show values
```

### **Memory per Container**
```yaml
Visualization: Bar gauge
Unit: Bytes (auto)
Decimal: 1
Orientation: Horizontal
Display mode: Gradient
Show: Calculate = Average
```

---

# 🔧 **DASHBOARD 4: DJANGO API METRICS**

## **Row 1: Request Volume**

| Panel | Visualization | Unit | Special |
|-------|---------------|------|---------|
| **Total Requests** | Stat | req/s | Decimal: 0 |
| **Requests by Method** | Pie chart | None | Show percentage |
| **Requests by Endpoint** | Bar gauge | req/s | Top 10 only |

### **Requests by Method (Pie Chart):**
```yaml
Visualization: Pie chart
Legend: Right, Show values: Percent
Tooltip mode: Multi
Labels: Name, Percent
```

### **Requests by Endpoint (Bar Gauge):**
```yaml
Visualization: Bar gauge
Unit: req/s
Orientation: Horizontal
Display mode: Retro LCD
Show: Limit 10
Sort: Descending
Legend: Show values
```

## **Row 2: Performance**

### **Response Time Percentiles:**
```yaml
Visualization: Time series
Unit: Seconds (s)
Decimal: 3
Legend: Bottom, Mode: Table, Values: Last, Min, Max, Mean

Series overrides:
  - P50: Color (#31a354), Line width 1, Fill opacity 10
  - P95: Color (#feb24c), Line width 2, Fill opacity 10
  - P99: Color (#de2d26), Line width 3, Fill opacity 10

Thresholds:
  - P95 > 0.3: Yellow warning
  - P99 > 0.5: Red critical

Annotations:
  - Add region markers for deployments
```

### **Response Time Heatmap:**
```yaml
Visualization: Heatmap
Unit: Seconds (s)
Sort by: le (buckets)
Color scheme: Oranges
Legend: Show scale

Y Axis:
  - Unit: Seconds (log scale recommended)
  - Min: 0.001
  - Max: 10

Colors: 
  - Low: #fee5d9
  - Medium: #fc9272
  - High: #de2d26
```

### **Slow Endpoints:**
```yaml
Visualization: Table
Unit: Seconds (s)
Decimal: 3
Columns: Endpoint, P95 Latency, Request Rate
Sort by: P95 Latency (descending)
```

## **Row 3: Errors**

| Panel | Visualization | Unit | Alert |
|-------|---------------|------|-------|
| **Error Rate by Endpoint** | Bar gauge | req/s | Top 5 |
| **Error Percentage** | Time series | Percent | Threshold >1% |
| **Status Code Distribution** | Pie chart | None | Show 2xx,4xx,5xx |

### **Error Percentage Settings:**
```yaml
Visualization: Time series
Unit: Percent (0-100)
Decimal: 2
Thresholds:
  - 0 to 0.1: Green
  - 0.1 to 1: Yellow
  - 1 to 100: Red
Fill opacity: 50
```

---

# 🗄️ **DASHBOARD 5: POSTGRESQL**

| Panel | Visualization | Unit | Thresholds |
|-------|---------------|------|------------|
| **Active Connections** | Stat | None | >100: Yellow, >150: Red |
| **Connection Utilization** | Gauge | Percent | 0-80: Green, 80-95: Yellow, 95-100: Red |
| **Transactions Per Second** | Time series | tps | Monitor trend |
| **Cache Hit Ratio** | Gauge | Percent | 0-95: Red, 95-99: Yellow, 99-100: Green |
| **Transaction Rollback Rate** | Time series | tps | >0: Investigate |
| **Slow Queries (P95)** | Time series | Seconds | >0.1: Yellow, >0.5: Red |
| **Deadlocks** | Stat | None | >0: Red background |
| **Database Size** | Stat | Bytes (auto) | Trend only |

### **Gauge Settings (Connection Utilization):**
```yaml
Visualization: Gauge
Unit: Percent (0-100)
Min: 0
Max: 100
Thresholds:
  - 0-80: Green
  - 80-95: Yellow
  - 95-100: Red
Show: Value + percentage
Orientation: Horizontal
```

---

# 🌐 **DASHBOARD 6: NGINX**

| Panel | Visualization | Unit | Alert Threshold |
|-------|---------------|------|-----------------|
| **Active Connections** | Stat | None | >1000: Yellow |
| **Requests per Second** | Time series | req/s | Monitor only |
| **Request Processing Time** | Time series | Seconds | P95 > 1s: Warning |
| **Status Code Distribution** | Pie chart | None | Show 2xx,3xx,4xx,5xx |
| **5xx Errors** | Time series | req/s | >10/min: Red |
| **4xx Errors** | Time series | req/s | Monitor only |

---

# 👥 **DASHBOARD 7: USER ANALYTICS**

## **Row 1: User Growth (Stat Panels)**

| Panel | Unit | Format | Special |
|-------|------|--------|---------|
| **Total Users** | None (short) | Decimal: 0 | Big number display |
| **New Users (Daily)** | None (short) | Decimal: 0 | Sparkline below |
| **User Growth Rate** | Percent (0-100) | Decimal: 1 | Color: Positive=Green, Negative=Red |

### **Stat Panel with Sparkline:**
```yaml
Visualization: Stat
Show: Calculate = Average
Show sparkline: On
Sparkline color: Theme color
Fill area: On
Line width: 1
```

## **Row 2: User Activity**

| Panel | Visualization | Unit | Legend |
|-------|---------------|------|--------|
| **DAU** | Time series | Users | Fill area |
| **WAU** | Time series | Users | Fill area |
| **MAU** | Time series | Users | Fill area |
| **Stickiness** | Time series | Percent | Line only |

### **Stickiness Settings:**
```yaml
Visualization: Time series
Unit: Percent (0-100)
Decimal: 1
Graph styles: Lines, Line width: 2, Fill opacity: 0
Thresholds:
  - 20%: Yellow target line
  - 30%: Green target line
Add horizontal line at target
```

## **Row 3: Engagement**

| Panel | Visualization | Unit | Type |
|-------|---------------|------|------|
| **Actions per User** | Time series | Actions | Lines |
| **Retention** | Gauge | Percent | Gauge |
| **Login Success Rate** | Gauge | Percent | Gauge |
| **Conversion Rate** | Gauge | Percent | Gauge |

---

# 📝 **DASHBOARD 8: CONTENT METRICS**

| Panel | Visualization | Unit | Special |
|-------|---------------|------|---------|
| **Posts Created (24h)** | Stat | Posts | Show sparkline |
| **Posts per Hour** | Heatmap | Posts/hour | X: Hour, Y: Day |
| **Comments per Minute** | Time series | Comments/min | Fill area |
| **Likes per Minute** | Time series | Likes/min | Fill area |
| **Comments per Post** | Stat | Count | Decimal: 1 |
| **Likes per Post** | Stat | Count | Decimal: 1 |
| **Engagement Rate** | Time series | Percent | Line + target |
| **Most Liked Posts** | Table | Likes | Top 5 |
| **Most Commented Posts** | Table | Comments | Top 5 |

### **Table Settings:**
```yaml
Visualization: Table
Sort by: Value (descending)
Limit: 5
Columns:
  - post_id: Width: 100px
  - title: Width: 300px
  - value: Width: 80px, Align: Right
Custom cell display: Color background for top 1
```

---

# 📜 **DASHBOARD 9: LOG EXPLORER**

| Panel | Visualization | Special |
|-------|---------------|---------|
| **Log Volume by Service** | Bar gauge | Horizontal, Show values |
| **Error Log Rate** | Time series | Fill opacity: 80, Color: Red |
| **Log Level Distribution** | Pie chart | Show count + percent |
| **Recent Error Logs** | Logs | Wrap lines, Show labels |
| **Warning Logs Rate** | Time series | Fill opacity: 50, Color: Yellow |

### **Logs Panel Settings:**
```yaml
Visualization: Logs
Max lines: 100
Wrap lines: On
Sort order: Descending
Show time: On
Show common labels: On
Unique fields: Only show level, message, service
Deduplication: On (timeout: 5s)
Highlight words: ERROR, WARNING, timeout, exception
```

---

# 🚨 **DASHBOARD 10: ALERT STATUS**

### **Active Alerts Table:**
```yaml
Visualization: Table
Query: ALERTS{alertstate="firing"}
Columns:
  - alertname: Width 200px
  - severity: Width 100px (color background)
  - instance: Width 150px
  - description: Width auto

Custom cell display:
  - severity = "critical": Red background
  - severity = "warning": Yellow background
  - severity = "info": Blue background

Thresholds for cell background:
  - critical: #c4162a
  - warning: #e5a132
  - info: #1f78d4
```

### **Alert Severity Distribution:**
```yaml
Visualization: Pie chart
Values: Count by severity
Labels: Name + Percent
Legend: Right
Tooltip: Percentage + Value
Colors:
  - critical: #c4162a
  - warning: #e5a132
  - info: #1f78d4
  - resolved: #299c46
```

### **Alerts Over Time:**
```yaml
Visualization: Time series
Unit: Count
Legend: Bottom, Mode: Table
Graph styles: Bars
Bar alignment: Center
Line width: 0
Fill opacity: 80
Group by: alertname
Stack series: Normal
```

---

# 📈 **DASHBOARD 11: CAPACITY PLANNING**

### **Growth Forecasts (Time series with predictions):**
```yaml
Visualization: Time series
Add two queries:
  A: Actual data (historical)
  B: Predict linear (forecast)

Series overrides:
  - Actual: Line width 2, Color blue, Fill opacity 30
  - Forecast: Line width 2, Color orange, Line style: Dashed

Axis:
  - Left: Actual values
  - Right: Forecast values (if different unit)

Annotations:
  - Add marker for "Expected exhaustion date"
```

### **Resource Trends (Heatmap):**
```yaml
Visualization: Heatmap
Data: Daily averages
X-axis: Date
Y-axis: Hour
Color scheme: Blues (higher usage = darker)
Show tooltip: Value at hour/day
```

### **When will disk be full? (Stat):**
```yaml
Visualization: Stat
Unit: Days (d)
Decimal: 0
Color scheme: Thresholds
Thresholds:
  - 30+ days: Green
  - 7-30 days: Yellow
  - 0-7 days: Red
Show: Days until full
```

---

# 🎨 **COMMON SETTINGS REFERENCE**

## **Color Schemes by Purpose**

| Purpose | Color Scheme | Colors |
|---------|--------------|--------|
| **System health** | Reds/Green/Yellows | Green: #299c46, Yellow: #e5a132, Red: #c4162a |
| **API latency** | Oranges | Light: #fee5d9, Medium: #fc9272, Dark: #de2d26 |
| **Traffic/Requests** | Blues | Light: #eff3ff, Medium: #bdd7e7, Dark: #3182bd |
| **Success/Errors** | Green/Red | Success: #31a354, Error: #de2d26 |
| **Container resources** | Purples | Light: #f2f0f7, Medium: #cbc9e2, Dark: #756bb1 |

## **Best Unit Types by Metric**

| Metric | Best Unit | Format | Example |
|--------|-----------|--------|---------|
| **CPU Usage** | Percent (0-100) | 2 decimals | 45.67% |
| **Memory** | Bytes (auto) | 1 decimal | 2.3 GB |
| **Latency** | Seconds (s) | 3 decimals | 0.245s |
| **Requests** | reqps (cps) | 0 decimals | 125 req/s |
| **Throughput** | Bps (auto) | 1 decimal | 1.2 MB/s |
| **Time duration** | Duration (d h m s) | 0 decimals | 2d 4h 30m |
| **Counts** | None (short) | 0 decimals | 1,234 |
| **Percentage** | Percent (0-100) | 1-2 decimals | 99.95% |
| **Temperature** | Celsius | 1 decimal | 45.2°C |

## **Threshold Best Practices**

| Severity | Color | Response |
|----------|-------|----------|
| **Critical** | 🔴 Red (#c4162a) | Page on-call immediately |
| **Warning** | 🟡 Yellow (#e5a132) | Send to Slack, investigate |
| **Info** | 🔵 Blue (#1f78d4) | Log only, no action |
| **Normal** | 🟢 Green (#299c46) | Everything is fine |
| **Resolved** | ⚪ Gray (#8e8e8e) | Issue is fixed |

## **Time Range Best Practices**

| Dashboard | Default Range | Auto-refresh |
|-----------|---------------|--------------|
| **Production Overview** | Last 6 hours | 30s |
| **Infrastructure** | Last 12 hours | 1m |
| **Services** | Last 1 hour | 30s |
| **Business** | Last 7 days | 5m |
| **Logs** | Last 15 minutes | 10s |
| **Alerts** | Last 24 hours | 1m |
| **Capacity** | Last 30 days | 1h |

---

# ✅ **QUICK FIX FOR YOUR CURRENT PANEL**

Based on your screenshot, here are the correct settings for **Overall Availability**:

```yaml
# Your current query is correct, but check these settings:

Queries tab:
  - Format: "Time series" (not Table)
  - Legend: "Overall Availability" (or leave auto)

Panel Options tab:
  - Title: "Overall Availability"
  - Description: "Percentage of time API is responding"

Standard options:
  - Unit: "Percent (0-100)"
  - Min: leave empty (auto)
  - Max: leave empty (auto)
  - Decimals: 2
  - Color scheme: "Thresholds only"

Thresholds:
  - Add threshold at 99.9: Green
  - Add threshold at 99: Yellow
  - Add threshold at 0: Red
  - Thresholds mode: "Percentage" (relative to min/max)
  - Show thresholds: "Off" (since you want background coloring)

Value mappings: None needed

Data links: None needed

Field overrides: Add override for:
  - Unit → Percent (0-100)
  - Thresholds → As above
  - Color scheme → Thresholds only

Display:
  - Color mode: Background (so whole panel changes color)
  - Text mode: Value and name
  - Wide layout: Auto
```

### **If the number is wrong (showing 500 instead of 100):**
```yaml
Check your query: avg(up{job="backend"}) * 100
If still wrong, try: avg(up{job="backend"}) * 100 (no space)
Or: avg(up{job="backend"}) * 100

Make sure:
  - Job name is correct (is it "backend" or something else?)
  - Data is actually coming in (check Query inspector)
  - Format is "Time series" not "Table"
```

---

# 📋 **PANEL TYPE QUICK GUIDE**

| Use this | For this |
|----------|----------|
| **Stat** | A single number (uptime, users, error rate) |
| **Time series** | Changes over time (latency, CPU, requests) |
| **Bar gauge** | Ranking/top 10 (slow endpoints, top containers) |
| **Pie chart** | Distribution (status codes, log levels) |
| **Table** | Multiple values with details (alerts, slow queries) |
| **Heatmap** | Distribution over time (response time histogram) |
| **Logs** | Raw log messages (debugging) |
| **Text** | Instructions, SLO targets, notes |
| **Gauge** | Percentage of limit (connection utilization, disk) |
| **Dashboard list** | Links to other dashboards |

---
