<p style="font-size:14px" align="right">
<a href="https://t.me/vinnodes" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://discord.gg/dvNSrwyU" target="_blank">Join our discord <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
<a href="https://vinnodes.com" target="_blank">Visit our website <img src="https://github.com/thenhthang/vinnodes/blob/main/content/logo.jpg?raw=true" width="30"/></a>
</p>
<p align="center">
  <img height="100" height="auto" src="https://github.com/thenhthang/vinnodes/blob/main/content/genlayer.png?raw=true">
</p>

# Genlayer validator

Official documentation:
>- https://docs.genlayer.com/validators/setup-guide
>- https://github.com/genlayerlabs

Explorer:
>- https://genlayer-testnet.explorer.caldera.xyz

## Hardware Requirements 
Recommended
>- 16GB RAM
>- 8 cores/16 threads
>- 128+ GB Storage (SSD)
>- Operating System - 64-bit Linux (Ubuntu, Debian, CentOS, etc.)
>- GPU is Not Required

```diff
- These requirements are a starting point. As GenLayer evolves and usage patterns change (e.g., more complex AI-driven Intelligent Contracts), the recommended hardware may change.
```

| Network | Version | Current |
|---------------|-------------|-------------|
| **Asimov** | v0.3.6 | Yes |

## Step 1: Set up your Genlayer Node
Check for the latest version
```
curl -s "https://storage.googleapis.com/storage/v1/b/gh-af/o?prefix=genlayer-node/bin/amd64" \
| grep -o '"name": *"[^"]*"' \
| sed -n 's/.*\/\(v[^/]*\)\/.*/\1/p' \
| sort -ru
```
Download the latest version
```
LATEST_VERSION=v0.3.6 # set your desired version here
export version=$LATEST_VERSION 
wget https://storage.googleapis.com/gh-af/genlayer-node/bin/amd64/${version}/genlayer-node-linux-amd64-${version}.tar.gz -O $HOME/genlayer-node-linux-amd64-${LATEST_VERSION}.tar.gz
cd $HOME
tar -xzvf genlayer-node-linux-amd64-${version}.tar.gz

```
Precompilation (optional but recommended)
```
$HOME/genlayer-node-linux-amd64/third_party/genvm/bin/genvm precompile
```
Configuration node
## Setting up vars

```
cd $HOME
ZKSYNC_URL="https://genlayer-testnet.rpc.caldera.xyz/http"
ZKSYNC_WEBSOCKET_URL="wss://genlayer-testnet.rpc.caldera.xyz/ws"
HEURISTKEY="YOUR_HEURIST_API_KEY"
echo "export ZKSYNC_URL=$ZKSYNC_URL" >> $HOME/.bash_profile
echo "export ZKSYNC_WEBSOCKET_URL=$ZKSYNC_WEBSOCKET_URL" >> $HOME/.bash_profile
echo "export HEURISTKEY=$HEURISTKEY" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
Config node
```
sed -i "s|^\( *zksyncurl: *\).*|\1\"$ZKSYNC_URL\"|" $HOME/genlayer-node-linux-amd64/configs/node/config.yaml
sed -i "s|^\( *zksyncwebsocketurl: *\).*|\1\"$ZKSYNC_WEBSOCKET_URL\"|" $HOME/genlayer-node-linux-amd64/configs/node/config.yaml
```
Config LLM provider :
```diff
At this stage, select one LLM and set all other to disabled.
Disable (enable: false) every provider but HEURIST.
```
```
nano $HOME/genlayer-node-linux-amd64/third_party/genvm/config/genvm-module-llm.yaml 
```
Set up validator key
#### Remember your password! You will need it to unlock your account when running the node
```
$HOME/genlayer-node-linux-amd64/bin/genlayernode account new -c $HOME/genlayer-node-linux-amd64/configs/node/config.yaml --setup --password "YOUR_VALIDATOR_PASSWORD"
```
## Install docker & docker-compose
```
wget -q -O docker.sh https://raw.githubusercontent.com/thenhthang/vinnodes/main/docker.sh && chmod +x docker.sh && sudo /bin/bash docker.sh
```
Run the WebDriver Container
```
cd $HOME/genlayer-node-linux-amd64
docker compose up -d # Starts the WebDriver needed by the GenVM web module
```
## Create service
```
cat <<EOL > /lib/systemd/system/genlayerd.service
[Unit]
Description=GenLayer Node
After=network.target

[Service]
LimitNOFILE=4294967296
User=root
Group=root
Environment=RUST_BACKTRACE=1
Environment=RUST_LOG=info
WorkingDirectory=$HOME
ExecStart=$HOME/genlayer-node-linux-amd64/bin/genlayernode run -c $(pwd)/configs/node/config.yaml --password "YOUR_VALIDATOR_PASSWORD"
Restart=always

[Install]
WantedBy=multi-user.target
EOL
```
## Register and start service
```
sudo systemctl enable genlayerd
sudo systemctl daemon-reload
sudo systemctl restart genlayerd && journalctl -fu genlayerd
```
## Logs
>- View the logs from the running service: journalctl -f -u genlayerd
>- Check the node is running: sudo systemctl status genlayerd.service
>- Stop your node: sudo systemctl stop genlayerd.service
>- Start your node: sudo systemctl start genlayerd.service

Question: <a href="https://t.me/nodesrunnerguruchat" target="_blank">NodesRunner Chat</a>
