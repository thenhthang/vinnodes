#!/bin/bash

echo -e "\033[0;35m"
echo "/$$    /$$       /$$$$$$       /$$   /$$       /$$   /$$        /$$$$$$        /$$$$$$$        /$$$$$$$$        /$$$$$$ ";
echo "| $$   | $$      |_  $$_/      | $$$ | $$      | $$$ | $$       /$$__  $$      | $$__  $$      | $$_____/       /$$__  $$";
echo "| $$   | $$        | $$        | $$$$| $$      | $$$$| $$      | $$  \ $$      | $$  \ $$      | $$            | $$  \__/";
echo "|  $$ / $$/        | $$        | $$ $$ $$      | $$ $$ $$      | $$  | $$      | $$  | $$      | $$$$$         |  $$$$$$ ";
echo " \  $$ $$/         | $$        | $$  $$$$      | $$  $$$$      | $$  | $$      | $$  | $$      | $$__/          \____  $$";
echo "  \  $$$/          | $$        | $$\  $$$      | $$\  $$$      | $$  | $$      | $$  | $$      | $$             /$$  \ $$";
echo "   \  $/          /$$$$$$      | $$ \  $$      | $$ \  $$      |  $$$$$$/      | $$$$$$$/      | $$$$$$$$      |  $$$$$$/";
echo "    \_/          |______/      |__/  \__/      |__/  \__/       \______/       |_______/       |________/       \______/";
echo -e "\e[0m"

sleep 2

# set vars
AVAIL_PORT=30333
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
source $HOME/.bash_profile
echo "export AVAIL_PORT=${AVAIL_PORT}" >> $HOME/.bash_profile
echo '================================================='
echo -e "Your node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Your port: \e[1m\e[32m$AVAIL_PORT\e[0m"
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl tar wget clang pkg-config protobuf-compiler libssl-dev jq build-essential protobuf-compiler bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
rustup default stable
rustup update
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
sleep 1

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download binary
git clone https://github.com/availproject/avail.git
cd avail
mkdir -p data
git checkout v1.7.2
cargo build --release -p data-avail
. $HOME/.bash_profile

# create service
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

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# start service
sudo systemctl daemon-reload
sudo systemctl enable availd
sudo systemctl restart availd

echo '=============== SETUP FINISHED ==================='
echo -e 'View the logs from the running service:: journalctl -f -u availd.service'
echo -e "Check the node is running: sudo systemctl status availd.service"
echo -e "Stop your avail node: sudo systemctl stop availd.service"
echo -e "Start your avail node: sudo systemctl start availd.service"