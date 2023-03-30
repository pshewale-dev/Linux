#!/bin/bash

# Input variables
server_file="server_list.txt"
output_file="patch_dates.csv"

# Loop through each server in the file
while read -r server; do

  # Check if server is reachable over ssh
  if ssh -q -i /path/to/private/key -p 77 adm@"$server" exit &>/dev/null; then
    # Get last patch date
    last_patch=$(ssh -i /path/to/private/key -p 77 adm@"$server" "rpm -qa --last | head -1 | awk '{print \$NF}'")
    # Get uptime
    uptime=$(ssh -i /path/to/private/key -p 77 adm@"$server" "uptime | awk '{print \$3}'")
    # Store server, patch date, and uptime in output file
    echo "$server,$last_patch,$uptime" >> "$output_file"
  else
    # Server not reachable, output error
    echo "$server,ssh ko" >> "$output_file"
  fi

done < "$server_file"
