
timestamp=$(date +"%Y%m%d_%H%M%S")
logfile="healthlog_${timestamp}.txt"

check_service() {
    service=$1
    if command -v systemctl &> /dev/null; then
        systemctl is-active --quiet $service && echo "$service is running" || echo "$service is NOT running"
    else
        pgrep -x $service &> /dev/null && echo "$service is running" || echo "$service is NOT running"
    fi
}

exec > >(tee -a "$logfile") 2>&1

echo "System Health Check Report"
echo "========================="
echo "Date and Time: $(date)"
echo

echo "System Uptime:"
echo "-------------"
uptime
echo

echo "CPU Load:"
echo "---------"
uptime | grep -o "load average:.*"
echo

echo "Memory Usage:"
echo "-------------"
free -m
echo

echo "Disk Usage:"
echo "-----------"
df -h
echo

echo "Top 5 Memory-Consuming Processes:"
echo "--------------------------------"
ps aux --sort=-%mem | head -n 6
echo

echo "Service Status:"
echo "--------------"
check_service nginx
check_service ssh
echo

echo "Report generated at: $(date)"
echo "Report saved to: $logfile"
