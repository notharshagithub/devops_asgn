#!/bin/bash

# Store system information in variables
current_date=$(date)
host_name=$(hostname)
user_name=$(whoami)

# Take user input
read -p "Enter directory name: " dir_name

# Create directory
mkdir -p "$dir_name"

# Create file inside the directory
process_file="$dir_name/processes.txt"
touch "$process_file"

# Store running processes in the file
ps > "$process_file"

# Display system information
echo "Current Date: $current_date"
echo "Hostname: $host_name"
echo "Username: $user_name"

echo
echo "Disk Usage:"
df -h

echo
echo "Running Processes:"
ps

echo
echo "Process information saved to: $process_file"
