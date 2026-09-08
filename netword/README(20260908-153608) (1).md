# Shell Scripting Homework

## Task: System Information Script

The script prints system information, uses variables and user input, creates a directory and file, and saves running process information using `>`.

### Script

```bash
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
```

### Run the Script

<!--
$ chmod +x system_info.sh
$ ./system_info.sh
Enter directory name: system_info
Current Date: Tue Sep  8 15:35:55 UTC 2026
Hostname: localhost
Username: oai
-->

### Commands Used

<!--
$ date
$ hostname
$ whoami
$ read -p "Enter directory name: " dir_name
$ mkdir -p "$dir_name"
$ touch "$process_file"
$ ps > "$process_file"
$ df -h
$ ps
-->

### Output File

The running process information is stored in `processes.txt` inside the directory entered by the user.

<!--
$ ls system_info
processes.txt

$ head system_info/processes.txt
PID TTY          TIME CMD
...
-->

## Submission

Push `system_info.sh` and `README.md` to the public GitHub repository.
