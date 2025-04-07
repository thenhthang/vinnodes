#!/bin/bash

sudo bash -c "cat > /usr/local/bin/memory_monitor.sh" << 'SCRIPT'
#!/bin/bash
read -p "Enter memory usage threshold in % (e.g., 8.5GB~10GB RAM is appropriate): " THRESHOLD
MEM_USAGE=$(free | awk '/Mem:/ {print $3/$2 * 100}')
if (( $(echo "$MEM_USAGE > $THRESHOLD" | bc -l) )); then
    echo "Memory usage exceeded $THRESHOLD%: $MEM_USAGE%"
    sudo systemctl restart 0gchaind
    echo "0gchaind service has been restarted."
    echo "$(date): Memory usage: $MEM_USAGE%, 0gchaind restarted" >> /var/log/memory_monitor.log
else
    echo "Memory usage: $MEM_USAGE% (below $THRESHOLD%)"
fi
SCRIPT

sudo chmod +x /usr/local/bin/memory_monitor.sh

sudo bash -c "cat > /etc/systemd/system/memory-monitor.service" << 'SERVICE'
[Unit]
Description=Memory usage monitoring and 0gchaind restart

[Service]
ExecStart=/usr/local/bin/memory_monitor.sh
Type=oneshot
SERVICE

sudo bash -c "cat > /etc/systemd/system/memory-monitor.timer" << 'TIMER'
[Unit]
Description=Memory usage check timer

[Timer]
OnBootSec=1min
OnUnitActiveSec=30s
Unit=memory-monitor.service

[Install]
WantedBy=timers.target
TIMER

echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart 0gchaind" | sudo tee -a /etc/sudoers

sudo systemctl daemon-reload
sudo systemctl enable memory-monitor.timer
sudo systemctl start memory-monitor.timer

echo "Installation completed. Check status with: systemctl status memory-monitor.timer"
