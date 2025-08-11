
![Uploading image.png…]()
## Firewall
```
sudo ufw enable
sudo ufw allow 9153
sudo ufw allow 9090
sudo ufw allow 9092
sudo ufw allow 3000
sudo ufw allow 9100
sudo ufw reload
```
## Install docker & docker-composr
```
wget -q -O docker.sh https://raw.githubusercontent.com/thenhthang/vinnodes/main/docker.sh && chmod +x docker.sh && sudo /bin/bash docker.sh
```
## Install grafana
```
docker run -d -p 3000:3000 --name=grafana grafana/grafana-enterprise
```
Grafane UI: http://YOUR_IP:3000
Login: admin/adim

Install Infinity plugin :
Connection/Add new connection/Infinity

Add new Data source:

Conneciton/Data source/Add new Data source/Infinity
Setting:
Add Allowed hosts: Setting/Security/Allowed hosts/Enter your node IP
Example: http://NODE_IP:9153/health

## Install node exporter
```
docker run -d \
  --net="host" \
  --pid="host" \
  -v "/:/host:ro,rslave" \
  quay.io/prometheus/node-exporter:latest \
  --path.rootfs=/host
```

## Install prometheus
```
sudo apt-get install prometheus
```
Config
```
sudo nano /etc/prometheus/prometheus.yml
```
Config example
```
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s
    scrape_timeout: 5s

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ['localhost:9090']

  - job_name: node
    # If prometheus-node-exporter is installed, grab stats about the local
    # machine by default.
    static_configs:
      - targets: ['YOUR_NODE_IP:9100']
  - job_name: genlayer
    static_configs:
      - targets: ['YOUR_NODE_IP:9153']
```
Prometheus UI: http://:9090

## Create new dashboard

Download dashboard.json file: https://raw.githubusercontent.com/thenhthang/vinnodes/55c2094a743e9797c69923b183581541e826851a/Genlayer/dashboard.json

Login to Grafana and follow step: 

Dashboard/New/NewDahboard/Importboard/Upload dashboard JSON file/Choose file dashboard.json/Import

## Log
```
sudo journalctl -u node-health.service -f
sudo journalctl -u prometheus -f
sudo journalctl -u grafana-server -f
sudo systemctl restart prometheus
```
