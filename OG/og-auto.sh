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
if [ ! $MONIKER ]; then
	read -p "Enter node name: " MONIKER
	echo 'export MONIKER='$MONIKER >> $HOME/.bash_profile
fi
source $HOME/.bash_profile
echo 'export CHAIN_ID="zgtendermint_16600-1"' >> ~/.bash_profile
echo 'export WALLET_NAME="wallet"' >> ~/.bash_profile
echo 'export RPC_PORT="26657"' >> ~/.bash_profile
source $HOME/.bash_profile
echo '================================================='
echo -e "Your node name: \e[1m\e[32m$MONIKER\e[0m"
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl tar wget clang pkg-config protobuf-compiler libssl-dev jq build-essential protobuf-compiler bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y snapd
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

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1

# download binary

git clone -b v0.2.3 https://github.com/0glabs/0g-chain.git
cd 0g-chain
make install
0gchaind version

# init node

cd $HOME
0gchaind init $MONIKER --chain-id $CHAIN_ID
0gchaind config chain-id $CHAIN_ID
0gchaind config node tcp://localhost:$RPC_PORT
0gchaind config keyring-backend os # You can set it to "test" so you will not be asked for a password

# download genesis

wget https://github.com/0glabs/0g-chain/releases/download/v0.1.0/genesis.json -O $HOME/.0gchain/config/genesis.json

# add seed and peer

rm ~/.0gchain/config/genesis.json
wget -P ~/.0gchain/config https://github.com/0glabs/0g-chain/releases/download/v0.2.3/genesis.json
SEEDS="81987895a11f6689ada254c6b57932ab7ed909b6@54.241.167.190:26656,010fb4de28667725a4fef26cdc7f9452cc34b16d@54.176.175.48:26656,e9b4bc203197b62cc7e6a80a64742e752f4210d5@54.193.250.204:26656,68b9145889e7576b652ca68d985826abd46ad660@18.166.164.232:26656" && \
sed -i.bak -e "s/^seeds *=.*/seeds = \"${SEEDS}\"/" $HOME/.0gchain/config/config.toml
	
# set min gas price

sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ua0gi\"/" $HOME/.0gchain/config/app.toml

# create service

sudo tee /etc/systemd/system/0gd.service > /dev/null <<EOF
[Unit]
Description=0G Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which 0gchaind) start --home $HOME/.0gchain
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service

sudo systemctl daemon-reload && \
sudo systemctl enable 0gd && \
sudo systemctl restart 0gd && \
sudo journalctl -u 0gd -f -o cat

echo '=============== SETUP FINISHED ==================='
echo -e 'View the logs from the running service:: sudo journalctl -u 0gd -f -o cat'
echo -e "Check the node is running: sudo systemctl status 0gd.service"
echo -e "Stop your avail node: sudo systemctl stop 0gd.service"
echo -e "Start your avail node: sudo systemctl start 0gd.service"
