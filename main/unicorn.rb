# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/opt/dailyReport"
 
# Unicorn PID file location
pid "/var/run/unicorn.pid"
 
# Path to logs
stderr_path "/var/log/dailyReport/unicorn.err.log"
stdout_path "/var/log/dailyReport/unicorn.log"
 
# Unicorn socket
#listen "/opt/dailyReport/tmp/sockets/unicorn.dailyReport.sock"
listen "/tmp/unicorn.dailyReport.sock"
 
# Number of processes
## Rule of thum: 2x per core
worker_processes 2
 
# Time-out
timeout 30