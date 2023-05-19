import subprocess
import socket
import pandas as pd

def ping(host):
    # Ping the host using the system's ping command
    command = ['ping', '-c', '4', host]  # Change '-c' value to adjust the number of pings
    result = subprocess.run(command, stdout=subprocess.PIPE)
    output = result.stdout.decode('utf-8')

    # Check the output for successful ping
    if ' 0% packet loss' in output:
        return True
    else:
        return False

def telnet(host, port):
    # Create a TCP socket and attempt to connect to the host and port
    try:
        socket.create_connection((host, port), timeout=5)
        return True
    except (ConnectionRefusedError, socket.timeout):
        return False

# Read hosts from text file
with open('hosts.txt', 'r') as file:
    hosts = file.read().splitlines()

# Perform tests and store results
results = []
for host in hosts:
    ping_result = ping(host)
    telnet_result1 = telnet(host, 80)
    telnet_result2 = telnet(host, 443)
    results.append((host, ping_result, telnet_result1, telnet_result2))

# Create a DataFrame from the results
df = pd.DataFrame(results, columns=['Host', 'Ping', 'Telnet Port 80', 'Telnet Port 443'])

# Save the DataFrame to an Excel file
df.to_excel('network_test_results.xlsx', index=False)
