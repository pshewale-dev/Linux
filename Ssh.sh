
#!/bin/bash

output_file="output.csv"

echo "server, status, kernel_info, uptime" > $output_file

while read server; do
    if ping -c 1 $server > /dev/null 2>&1; then
        a=$(ssh -o StrictHostKeyChecking=no -o ConnectTimeout=2 -o BatchMode=yes -p 77 -i sysadm Si "rpm -qa-last kernel | head -1")
        b=$(ssh -o StrictHostKeyChecking=no -o ConnectTimeout=2 -o BatchMode=yes -p 77 -i sysadm Si uptime)
        echo "$server, OK, $a, $b" >> $output_file
    else
        echo "$server, Unreachable" >> $output_file
    fi
done < server_list.txt
