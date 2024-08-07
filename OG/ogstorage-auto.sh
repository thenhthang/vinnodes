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
read -p "Enter your evm private key: " PRIVATE_KEY
echo 'export PRIVATE_KEY="'$PRIVATE_KEY'"' >> $HOME/.bash_profile
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
. "$HOME/.cargo/env" 
# download binary

git clone -b v0.3.3 https://github.com/0glabs/0g-storage-node.git

# build
cd $HOME/0g-storage-node
git submodule update --init
sudo apt install cargo
cargo build --release

# update config
sed -i '
s|# network_enr_address = ""|network_enr_address = "'$MYIP'"|
s|# rpc_listen_address = ".*"|rpc_listen_address = "0.0.0.0:5678"|
s|# rpc_listen_address_admin = ".*"|rpc_listen_address_admin = "0.0.0.0:5679"|
s|# network_boot_nodes = \[\]|network_boot_nodes = \[\"/ip4/54.219.26.22/udp/1234/p2p/16Uiu2HAmTVDGNhkHD98zDnJxQWu3i1FL1aFYeh9wiQTNu4pDCgps\",\"/ip4/52.52.127.117/udp/1234/p2p/16Uiu2HAkzRjxK2gorngB1Xq84qDrT4hSVznYDHj6BkbaE4SGx9oS\",\"/ip4/18.167.69.68/udp/1234/p2p/16Uiu2HAm2k6ua2mGgvZ8rTMV8GhpW71aVzkQWy7D37TTDuLCpgmX\"\]|
s|# log_contract_address = ""|log_contract_address = "0x8873cc79c5b3b5666535C825205C9a128B1D75F1"|
s|# mine_contract_address = ""|mine_contract_address = "0x85F6722319538A805ED5733c5F4882d96F1C7384"|
s|# blockchain_rpc_endpoint = ".*"|blockchain_rpc_endpoint = "'$BLOCKCHAIN_RPC_ENDPOINT'"|
s|# log_sync_start_block_number = 0|log_sync_start_block_number = 802|
s|# db_dir = "db"|db_dir = "db"|
s|# rpc_enabled = true|rpc_enabled = true|
s|# network_dir = "network"|network_dir = "network"|
s|# miner_key = ""|miner_key = "'$PRIVATE_KEY'"|
' $HOME/0g-storage-node/run/config.toml

sed -i '
s|debug,hyper=info,h2=info|info,hyper=warn,h2=warn|
' $HOME/0g-storage-node/run/log_config
# create service

sudo tee /etc/systemd/system/zgs.service > /dev/null <<EOF
[Unit]
Description=ZGS Node
After=network.target

[Service]
User=root
WorkingDirectory=$HOME/0g-storage-node/run
ExecStart=$HOME/0g-storage-node/target/release/zgs_node --config $HOME/0g-storage-node/run/config.toml --miner-key $PRIVATE_KEY --blockchain-rpc-endpoint $BLOCKCHAIN_RPC_ENDPOINT
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# run

sudo systemctl daemon-reload && \
sudo systemctl enable zgs && \
sudo systemctl start zgs

echo -e "\e[1m\e[32m2. Install complete \e[0m" && sleep 1
