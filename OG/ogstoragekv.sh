#!/bin/bash

echo -e "\033[0;35m"
echo " __      _______ _   _ _   _  ____  _____  ______  _____  ";
echo " \ \    / /_   _| \ | | \ | |/ __ \|  __ \|  ____|/ ____| ";
echo "  \ \  / /  | | |  \| |  \| | |  | | |  | | |__  | (___   ";
echo "   \ \/ /   | | |     |     | |  | | |  | |  __|  \___ \  ";
echo "    \  /   _| |_| |\  | |\  | |__| | |__| | |____ ____) | ";
echo "     \/   |_____|_| \_|_| \_|\____/|_____/|______|_____/    ";
echo -e "\e[0m"

sleep 2

# set vars
read -p "Enter your BLOCKCHAIN_RPC_ENDPOINT: " BLOCKCHAIN_RPC_ENDPOINT
echo 'export BLOCKCHAIN_RPC_ENDPOINT="'$BLOCKCHAIN_RPC_ENDPOINT'"' >> $HOME/.bash_profile
MYIP=$(wget -qO- eth0.me)
echo 'export MYIP="'$MYIP'"' >> $HOME/.bash_profile
source ~/.bash_profile

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages

sudo apt-get install clang cmake build-essential git

# install go

cd $HOME && \
ver="1.22.0" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
sleep 1

# install rust

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1

# download binary

git clone -b v1.1.0-testnet https://github.com/0glabs/0g-storage-kv.git

# build
cd 0g-storage-kv
git submodule update --init
# Build in release mode
cargo build --release

cp $HOME/0g-storage-kv/run/config_example.toml $HOME/0g-storage-kv/run/config.toml
# update config
sed -i '
s|^blockchain_rpc_endpoint = ""|blockchain_rpc_endpoint = "'$BLOCKCHAIN_RPC_ENDPOINT'"|
s|^log_contract_address = ""|log_contract_address = "0x8873cc79c5b3b5666535C825205C9a128B1D75F1"|
s|^log_sync_start_block_number = 0|log_sync_start_block_number = 802|
s|^zgs_node_urls = ".*"|zgs_node_urls = "http://'$MYIP':5678"|
' $HOME/0g-storage-kv/run/config.toml

# create service

sudo tee /etc/systemd/system/zgskv.service > /dev/null <<EOF
[Unit]
Description=ZGS Node KV
After=network.target

[Service]
User=root
WorkingDirectory=$HOME/0g-storage-kv/run
ExecStart=$HOME/0g-storage-kv/target/release/zgs_kv --config $HOME/0g-storage-kv/run/config.toml
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# run

sudo systemctl daemon-reload && \
sudo systemctl enable zgskv && \
sudo systemctl start zgskv

echo -e "\e[1m\e[32m2. Install complete \e[0m" && sleep 1
