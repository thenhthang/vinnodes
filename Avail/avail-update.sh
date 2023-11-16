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
sudo systemctl stop availd.service
cd avail
git pull
git checkout v1.8.0.2
cargo build --release -p data-avail
. $HOME/.bash_profile
sudo cp $HOME/avail/target/release/data-avail /usr/local/bin
# create service
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

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# start service
sudo systemctl daemon-reload
sudo systemctl restart availd

echo '=============== Update success ==================='
echo -e 'View the logs from the running service: journalctl -f -u availd.service'
echo -e "Check the node is running: sudo systemctl status availd.service"
echo -e "Stop your avail node: sudo systemctl stop availd.service"
echo -e "Start your avail node: sudo systemctl start availd.service"
