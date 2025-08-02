## Install docker & docker-composr
## Install grafana
UI: http://IP:3000
Login: admin/adim
Add plugin Infinity

Connection/Add new connection/Infinity

Add new Data source
Conneciton/Data source/Add new Data source/Infinity
Add Allowed hosts

## Install prometheus
Config
```
sudo nano /etc/prometheus/prometheus.yml
```
UI: http://:9090


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
