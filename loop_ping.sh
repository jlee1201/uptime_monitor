#!/bin/bash

target=${1:-8.8.8.8}
interval=${2:-10}
LOG_FILE=${LOG_FILE:-uptime.log}
ERROR_FLAG=false

echo "Start monitor for network timeouts at $(date)" | tee -a "$LOG_FILE"
echo "Target host: $target"

echo .
while true
do
  RESULT=$(ping -A -c 1 -W 100 "$target" | xargs -L 1 -I '{}' date '+%Y-%m-%d %H:%M:%S: {}')
  ERROR=$(echo "$RESULT" | grep -i "100.0\|timeout\|unreachable\|no answer")
  if [[ "$ERROR" != "" ]]; then
    echo "."
    echo "Outage detected!: $ERROR"
    echo "."
    echo "$ERROR" >> "$LOG_FILE"
    ERROR_FLAG=true
  else
    OUTPUT=$(echo "$RESULT" | grep -i "time")
    echo "$OUTPUT"
    if [[ "$ERROR_FLAG" = "true" ]]; then
      ERROR_FLAG=false
      echo "$OUTPUT" >> "$LOG_FILE"
    fi
  fi
  sleep $interval
done
echo .
echo "End monitoring at $(date)."
