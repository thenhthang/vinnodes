#!/bin/bash

# ===== CONFIG =====
# Nếu TOPICNAME chưa được set → hỏi người dùng
TOPIC_FILE="/etc/genlayer/topic"

# Nếu chưa có TOPICNAME → đọc từ file
if [ -z "$TOPICNAME" ] && [ -f "$TOPIC_FILE" ]; then
  TOPICNAME=$(cat "$TOPIC_FILE")
fi

# Nếu vẫn rỗng → hỏi người dùng
if [ -z "$TOPICNAME" ]; then
  read -rp "Enter NTFY topic name: " TOPICNAME
fi

# Validate
if [ -z "$TOPICNAME" ]; then
  echo "ERROR: TOPICNAME is required"
  exit 1
fi

if ! [[ "$TOPICNAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "ERROR: Invalid TOPICNAME"
  exit 1
fi

# Lưu lại để lần sau khỏi hỏi
mkdir -p /etc/genlayer
echo "$TOPICNAME" > "$TOPIC_FILE"

NTFY_URL="https://notify.vinnodes.com/$TOPICNAME"
HEALTH_URL="http://localhost:9153/health"
# NTFY_URL="https://notify.vinnodes.com/$IP"
# NTFY_URL="https://notify.vinnodes.com/genlayer"
STATE_FILE="/var/tmp/genlayer_health.state"
HOSTNAME=$(hostname)
NOW=$(date -u)

# ===== LOAD PREVIOUS STATE =====
PREV_STATE="unknown"
[ -f "$STATE_FILE" ] && PREV_STATE=$(cat "$STATE_FILE")

CURRENT_STATE="ok"
ERROR_REASON=""

# ===== HEALTH CHECK =====
RESPONSE=$(curl -s -w "\n%{http_code}" "$HEALTH_URL")
BODY=$(echo "$RESPONSE" | sed '$d')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)

# ===== HTTP FAIL =====
if [ "$HTTP_CODE" -ne 200 ]; then
  CURRENT_STATE="fail"
  ERROR_REASON="HTTP status $HTTP_CODE"
else
  OVERALL_STATUS=$(echo "$BODY" | jq -r '.status')
  FAILED_CHECKS=$(echo "$BODY" | jq -r '
    .checks
    | to_entries[]
    | select(.value.status != "up")
    | "• \(.key): \(.value.status)"'
  )

  if [ "$OVERALL_STATUS" != "up" ] || [ -n "$FAILED_CHECKS" ]; then
    CURRENT_STATE="fail"
    ERROR_REASON="Service degraded"
  fi
fi

# ===== STATE TRANSITION =====
# OK -> FAIL (ALERT)
if [ "$PREV_STATE" = "ok" ] && [ "$CURRENT_STATE" = "fail" ]; then
  curl -X POST "$NTFY_URL" \
    -H "Title: 🚨 GenLayer Node DOWN" \
    -H "Priority: 5" \
    -H "Tags: fire,genlayer,node" \
    -d "Host: $HOSTNAME

Reason: $ERROR_REASON

Failed services:
$FAILED_CHECKS

Time: $NOW"
fi

# FAIL -> OK (RECOVERY)
if [ "$PREV_STATE" = "fail" ] && [ "$CURRENT_STATE" = "ok" ]; then
  curl -X POST "$NTFY_URL" \
    -H "Title: ✅ GenLayer Node RECOVERED" \
    -H "Priority: 2" \
    -H "Tags: white_check_mark,genlayer,recovery" \
    -d "Host: $HOSTNAME

All services are UP again ✅

Time: $NOW"
fi

# ===== SAVE CURRENT STATE =====
echo "$CURRENT_STATE" > "$STATE_FILE"
