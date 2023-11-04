<p style="font-size:14px" align="right">
<a href="https://t.me/vinnodes" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://discord.gg/dvNSrwyU" target="_blank">Join our discord <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
<a href="https://radió.com/" target="_blank">Visit our website <img src="https://github.com/thenhthang/vinnodes/blob/main/content/logo.jpg?raw=true" width="30"/></a>
</p>
<p align="center">
  <img height="100" height="auto" src="https://github.com/thenhthang/vinnodes/blob/main/content/avail.png?raw=true">
</p>

# Avail Light Client (Light Node)

Official documentation:
>- https://github.com/availproject/avail

Explorer:
>- https://telemetry.avail.tools
>- https://kate.avail.tools/

Fill form for Avail Light client: 
>- https://docs.google.com/forms/d/e/1FAIpQLSeL6aXqz6vBbYEgD1cZKaQ4vwbN2o3Rxys-wKTuKySVR-oS8g/viewform

## Recommended Hardware Requirements 
Minimum
>- 4GB RAM
>- 2core CPU (amd64/x86 architecture)
>- 20-40 GB Storage (SSD)

Recommended
>- 8GB RAM
>- 4core CPU (amd64/x86 architecture)
>- 200-300 GB Storage (SSD)

## Set up your Avail Light Node
### Option 1 (automatic)
You can setup your avail light node in few minutes by using automated script below. It will prompt you to input your validator node name!
```
wget -O avail-light.sh https://raw.githubusercontent.com/thenhthang/vinnodes/main/Avail/avail-light.sh && chmod +x avail-light.sh && ./avail-light.sh
```

### Option 2 (manual)
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
git clone https://github.com/availproject/avail-light.git
cd avail-light
wget -O config.yaml https://raw.githubusercontent.com/thenhthang/vinnodes/main/Avail/config.yaml
git checkout v1.7.2
cargo build --release
sudo cp $HOME/avail-light/target/release/avail-light /usr/local/bin
```
## Create service
```
sudo tee /etc/systemd/system/availightd.service > /dev/null <<EOF
[Unit]
Description=Avail Light Client
After=network-online.target

[Service]
User=$USER
ExecStart=$(which avail-light) --config $HOME/avail-light/config.yaml --network biryani
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
sudo systemctl enable availightd
sudo systemctl restart availightd
```
## Logs
>- View the logs from the running service: journalctl -f -u availightd.service'