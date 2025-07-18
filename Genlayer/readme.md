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
| sort -ru \
| head -n1
```
Download the latest version
```
export version=v0.3.6 # set your desired version here
wget https://storage.googleapis.com/gh-af/genlayer-node/bin/amd64/${version}/genlayer-node-linux-amd64-${version}.tar.gz -O $HOME/genlayer-node-${LATEST_VERSION}.tar.gz
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
HEURISTKEY="YOUR_KEY"
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
Config LLM provider : Disable (enable: false) every provider but HEURIST.
```
nano $HOME/genlayer-node-linux-amd64/third_party/genvm/config/genvm-module-llm.yaml 
```

## Update packages
```
sudo apt update && sudo apt upgrade -y
```
## Install dependencies
```
sudo apt install curl tar wget clang pkg-config protobuf-compiler libssl-dev jq build-essential protobuf-compiler bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
## Install Rust
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
rustup default stable
rustup update
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
```
## Download and build binaries
```
git clone https://github.com/availproject/avail.git
cd avail
mkdir -p data
git checkout v1.11.0.0
cargo build --release -p data-avail
sudo cp $HOME/avail/target/release/data-avail /usr/local/bin
```
## Create service
```
sudo tee /etc/systemd/system/availd.service > /dev/null <<EOF
[Unit]
Description=Avail Validator
After=network-online.target

[Service]
User=$USER
ExecStart=$(which data-avail) -d `pwd`/data --chain goldberg --validator --name $NODENAME
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
## Register and start service
```
sudo systemctl daemon-reload
sudo systemctl enable availd
sudo systemctl restart availd && sudo journalctl -u availd -f -o cat
```
## Logs
>- View the logs from the running service: journalctl -f -u availd.service
>- Check the node is running: sudo systemctl status availd.service
>- Stop your avail node: sudo systemctl stop availd.service
>- Start your avail node: sudo systemctl start availd.service
## Update from old version to v1.10.0.0
Step 1
```
sudo systemctl stop availd
cd avail/data/chains/avail_goldberg_testnet
rm -rf db
rm -rf network
mkdir db
mkdir network
cd db
mkdir full
cd full
curl -o - -L https://snapshots.avail.nexus/goldberg/avail_goldberg_testnet_snapshot_jan_31.tar.gz | tar -xz -C .
cd
```
Step 2
```
wget -O avail-update.sh https://raw.githubusercontent.com/thenhthang/vinnodes/main/Avail/avail-update.sh && chmod +x avail-update.sh && ./avail-update.sh
```
Step 3: After full sync (Please check you node is full sync before execute this step
Find your node on https://telemetry.avail.tools
```
sudo systemctl stop availd
```
```
sudo tee /etc/systemd/system/availd.service > /dev/null <<EOF
[Unit]
Description=Avail Validator
After=network-online.target

[Service]
User=$USER
ExecStart=$(which data-avail) -d `pwd`/data --chain goldberg --validator --name $NODENAME
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl start availd
```
## Update from old version to v1.11.0.0
```
wget -O avail-update.sh https://raw.githubusercontent.com/thenhthang/vinnodes/main/Avail/avail-update.sh && chmod +x avail-update.sh && ./avail-update.sh
```
### Before you can become an active validator, you need to bond your funds to your node. 
>- Stake your validator: https://docs.availproject.org/operate/validator/staking
## Step 2: Create wallet and Set Identity
## Step 3: Control your full node account
>- Step 2 and step 3 read guide here: https://github.com/thenhthang/vinnodes/blob/main/Avail/How%20to%20participate%20Avail%20incentivized%20testnet.md

Question: <a href="https://t.me/nodesrunnerguruchat" target="_blank">NodesRunner Chat</a>
