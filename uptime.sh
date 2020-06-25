#!/bin/bash

#set -x

echo "running loop_ping with caffeinate..."
caffeinate -is ./loop_ping.sh "$@"
echo "process ended..."
