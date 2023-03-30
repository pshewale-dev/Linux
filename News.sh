#!/bin/bash

# Define input file containing server names
input_file="servers.txt"

# Define output file name
output_file="server_stats.csv"

# Write header row to output file
echo "Server Name,Kernel Version,Last Boot Time,Uptime" > $output_file

# Loop through servers in input file
while read -r server_name; do
  # Try to connect to server with SSH and retrieve kernel version and last boot time
  if ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=no -o User=sysadm -p 66 "$server_name" "rpm -qa --last kernel | head -n 1" >/dev/null 2>&1; then
    kernel_version=$(ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=no -o User=sysadm -p 66 "$server_name" "rpm -qa --last kernel | head -n 1")
    last_boot_time=$(echo "$kernel_version" | awk '{print $5, $6, $7, $8}')
    uptime=$(ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=no -o User=sysadm -p 66 "$server_name" "uptime")
    uptime_days=$(echo "$uptime" | awk '{print $3}')
    uptime_hours=$(echo "$uptime" | awk '{print $5}' | awk -F: '{print $1}')
    uptime_minutes=$(echo "$uptime" | awk '{print $5}' | awk -F: '{print $2}')
    echo "$server_name,$kernel_version,$last_boot_time,$uptime_days days, $uptime_hours hours, $uptime_minutes minutes" >> "$output_file"
  else
    echo "$server_name,Not Reachable,Not Reachable,Not Reachable" >> "$output_file"
  fi
done < "$input_file"
