
```
sudo apt-get install git build-essential curl file nginx certbot python3-certbot-nginx jq -y
```
```
sudo certbot --nginx --domain linera.vinnodes.com
```
```
git clone https://github.com/linera-io/linera-protocol.git
cd linera-protocol
git checkout -t origin/testnet_boole
```
```
cargo install --locked --path linera-service
```
```
cd target/release
```
sudo tee ./configuration.toml > /dev/null <<EOF
server_config_path = "server.json"
host = "<your-host>" # e.g. my-subdomain.my-domain.net
port = 19100
metrics_host = "proxy"
metrics_port = 21100
internal_host = "proxy"
internal_port = 20100
[external_protocol]
Grpc = "ClearText" # Depending on your load balancer you may need "Tls" here.
[internal_protocol]
Grpc = "ClearText"

[[shards]]
host = "shard"
port = 19100
metrics_host = "shard"
metrics_port = 21100
EOF
```
wget "https://storage.googleapis.com/linera-io-dev-public/testnet-boole/genesis.json"
```
```
linera-server generate --validators ./configuration.toml
```
```
cd $HOME/linera-protocal
docker build -f docker/Dockerfile . -t linera

```