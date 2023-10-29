<p style="font-size:14px" align="right">
<a href="https://t.me/vinnodes" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://discord.gg/dvNSrwyU" target="_blank">Join our discord <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
<a href="https://radió.com/" target="_blank">Visit our website <img src="https://github.com/thenhthang/vinnodes/blob/main/content/logo.jpg?raw=true" width="30"/></a>
</p>
<p align="center">
  <img height="100" height="auto" src="https://github.com/thenhthang/vinnodes/blob/main/content/avail.png?raw=true">
</p>

# Avial Tesnet (Validator)

Official documentation:
>- https://github.com/availproject/avail

Explorer:
>- https://telemetry.avail.tools
>- https://kate.avail.tools/

## Recommended Hardware Requirements 
Minimum
>- 4GB RAM
>- 2core CPU (amd64/x86 architecture)
>- 20-40 GB Storage (SSD)

Recommended
>- 8GB RAM
>- 4core CPU (amd64/x86 architecture)
>- 200-300 GB Storage (SSD)

## Set up your Avail Validator
### Option 1 (automatic)
You can setup your avail validator in few minutes by using automated script below. It will prompt you to input your validator node name!
```
wget -O avail-auto.sh https://github.com/thenhthang/vinnodes/blob/main/Avail/avail-auto.sh && chmod +x avail-auto.sh && ./avail-auto.sh
```

### Option 2 (manual)
## Setting up vars
Here you have to put name of your node name (validator) that will be visible in explorer
```
NODENAME=<YOUR_NODE_NAME_GOES_HERE>
```
Save and import variables into system
```
AVAIL_PORT=30333
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
echo "export AVAIL_PORT=${AVAIL_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
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
git checkout v1.7.2
cargo build --release -p data-avail
```
## Create service
```
sudo tee /etc/systemd/system/availd.service > /dev/null <<EOF
[Unit]
Description=Avail Validator
After=network-online.target

[Service]
User=$USER
ExecStart=$(which data-avail) --validator --port 30333 --base-path `pwd`/data --chain kate --name $NODENAME
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