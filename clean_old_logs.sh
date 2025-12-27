#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 /path/to/logs N_days"
  exit 1
fi

LOG_DIR="$1"
DAYS="$2"

FILES=$(find "$LOG_DIR" -type f -name "*.log" -mtime +"$DAYS")

if [ -z "$FILES" ]; then
  echo "No old log files found."
  exit 0
fi

echo "Files found:"
echo "$FILES"

read -p "Удалить эти файлы? (y/n): " CONFIRM

if [ "$CONFIRM" = "y" ]; then

  find "$LOG_DIR" -type f -name "*.log" -mtime +"$DAYS" -print0 | xargs -0 rm -f
  echo "Files deleted."
else
  echo "Operation cancelled."
fi







