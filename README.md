**System Health Check Script**
This project provides a portable Bash script called healthcheck.sh that performs a system health audit and logs the results to a timestamped file. It is designed to work across most Linux environments, including minimal setups where some commands may be missing.
Features
- Logs current system date and time
- Displays system uptime and CPU load (with fallback if uptime or top is missing)
- Shows memory usage using free -m (with fallback)
- Reports disk usage using df -h
- Lists top 5 memory-consuming processes using ps aux
- Checks status of nginx and ssh services (if systemctl is available)
- Saves output to a timestamped log file (e.g., healthlog_2025-10-29_17-42-54.txt)
**Requirements**
- Bash shell
- Basic Linux utilities: date, df, ps, awk, sort, head
- Optional utilities: uptime, top, free, systemctl (script handles missing commands gracefully)
**How to Use**
- Clone the repository:
**git clone https://github.com/rohith643/system-Health1**
- Make the script executable:
**chmod +x healthcheck.sh**
  - Run the script:
**./healthcheck.sh**
- View the log file:
**cat healthlog_*.txt** 


