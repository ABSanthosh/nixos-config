#!/bin/sh

while true; do
  # Date and time
  date_and_week=$(date "+%Y/%m/%d (w%-V)")
  current_time=$(date "+%H:%M")

  sep=" | "

  echo "${date_and_week}${sep}${current_time}"
  sleep 1
done
