#!/bin/bash

#set -x

target=${1:-8.8.8.8}
interval=${2:-10}

echo "Start monitor for network timeouts at $(date)"
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
    echo "$ERROR" >> uptime.log
  else
    echo "$RESULT" | grep -i "time"
  fi
  sleep $interval
done
echo .
echo "End monitoring at $(date)."

# 
