# PowerShell Health Check Script

# Get current timestamp for the log file
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logfile = "healthlog_$timestamp.txt"

# Function to check if a service is running
function Check-Service {
    param($serviceName)
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($service) {
        return "$serviceName is $($service.Status)"
    } else {
        return "$serviceName service not found"
    }
}

# Start logging
Start-Transcript -Path $logfile -Append

Write-Output "System Health Check Report"
Write-Output "========================="
Write-Output "Date and Time: $(Get-Date)"
Write-Output ""

Write-Output "System Uptime:"
Write-Output "-------------"
$uptime = (Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
Write-Output "Up time: $($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes"
Write-Output ""

Write-Output "CPU Load:"
Write-Output "---------"
$cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
Write-Output "CPU Load: $([math]::Round($cpu, 2))%"
Write-Output ""

Write-Output "Memory Usage:"
Write-Output "-------------"
$os = Get-CimInstance -ClassName Win32_OperatingSystem
$totalMemory = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$freeMemory = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$usedMemory = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1MB, 2)
Write-Output "Total Memory: $totalMemory GB"
Write-Output "Used Memory: $usedMemory GB"
Write-Output "Free Memory: $freeMemory GB"
Write-Output ""

Write-Output "Disk Usage:"
Write-Output "-----------"
Get-Volume | Where-Object {$_.DriveLetter} | Format-Table DriveLetter, FileSystemLabel, FileSystem, @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, @{Name="FreeSpace(GB)";Expression={[math]::Round($_.SizeRemaining/1GB,2)}}
Write-Output ""

Write-Output "Top 5 Memory-Consuming Processes:"
Write-Output "--------------------------------"
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5 | Format-Table Name, @{Name="Memory(MB)";Expression={[math]::Round($_.WorkingSet/1MB,2)}}, CPU
Write-Output ""

Write-Output "Service Status:"
Write-Output "--------------"
Check-Service "W32Time"  # Windows Time service
Check-Service "Spooler"  # Print Spooler service
Write-Output ""

Write-Output "Report generated at: $(Get-Date)"
Write-Output "Report saved to: $logfile"

Stop-Transcript