## Install docker & docker-composr
## Install grafana
Login ip:3000; admin/adim
## Install prometheus
Config
sudo nano /etc/prometheus/prometheus.yml
ui ip:9090; 

## Firewall
sudo ufw allow 9090
sudo ufw allow 9092
sudo ufw allow 3000
sudo ufw allow 9100
sudo ufw reload

## Log
sudo journalctl -u node-health.service -f
sudo journalctl -u prometheus -f
sudo journalctl -u grafana-server -f
