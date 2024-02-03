<p style="font-size:14px" align="right">
<a href="https://t.me/vinnodes" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://discord.gg/dvNSrwyU" target="_blank">Join our discord <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
<a href="https://vinnodes.com" target="_blank">Visit our website <img src="https://github.com/thenhthang/vinnodes/blob/main/content/logo.jpg?raw=true" width="30"/></a>
</p>
<p align="center">
  <img height="100" height="auto" src="https://github.com/thenhthang/vinnodes/blob/main/content/avail.png?raw=true">
</p>

# Avial Full node

Official documentation:
>- https://docs.availproject.org/
>- https://github.com/availproject/avail

Explorer:
>- https://telemetry.avail.tools
>- https://goldberg.avail.tools
>- LeaderBoard:
>- https://leaderboard.availproject.org
>- Fill form for validator test:
>- https://docs.google.com/forms/d/e/1FAIpQLScvgXjSUmwPpUxf1s-MR2C2o5V79TSoud1dLPKVgeLiLFuyGQ/viewform

## Hardware Requirements 
Minimum
>- 4GB RAM
>- 2core CPU (amd64/x86 architecture)
>- 20-40 GB Storage (SSD)

Recommended
>- 8GB RAM
>- 4core CPU (amd64/x86 architecture)
>- 200-300 GB Storage (SSD)
```diff
- While Avail is currently in its testnet phase, running validator nodes requires significant system administration expertise.
```
| Network | Version | Current | Last modified |
|---------------|-------------|-------------|-------------|
| **Kate Testnet** | v1.7.2 | No |  |
| **Goldberg Testnet** | v1.10.0.0 | Yes | 2024/02/03 |
```
Ports used: 30333
```
## Step 1: Set up your Avail Node
### Option 1 (automatic)
You can setup your avail validator in few minutes by using automated script below. It will prompt you to input your validator node name!
```
wget -O avail-auto.sh https://raw.githubusercontent.com/thenhthang/vinnodes/main/Avail/avail-auto.sh && chmod +x avail-auto.sh && ./avail-auto.sh
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
git checkout v1.8.0.3
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
## Update to latest version
```
wget -O avail-update.sh https://raw.githubusercontent.com/thenhthang/vinnodes/main/Avail/avail-update.sh && chmod +x avail-update.sh && ./avail-update.sh
```
### Before you can become an active validator, you need to bond your funds to your node. 
>- Stake your validator: https://docs.availproject.org/operate/validator/staking
## Step 2: Create wallet and Set Identity
## Step 3: Control your full node account
>- Step 2 and step 3 read guide here: https://github.com/thenhthang/vinnodes/blob/main/Avail/How%20to%20participate%20Avail%20incentivized%20testnet.md

Question: <a href="https://t.me/vinnodeschat" target="_blank">VinNodes Chat</a>
