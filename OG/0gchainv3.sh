#!/bin/bash

# Prompt user for MONIKER value
read -p "Enter your MONIKER value: " MONIKER

# Get the server's public IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

# Change to home directory
cd $HOME

# Remove existing galileo and .0gchaind directories if they exist
sudo systemctl stop 0gd && sudo systemctl disable 0gd
sudo systemctl stop 0ggeth && sudo systemctl disable 0ggeth
sudo systemctl stop 0gchaind && sudo systemctl disable 0gchaind
rm -rf galileo
rm -r galileo-v1.0.1.tar.gz
rm -r galileo-v1.1.0.tar.gz
rm -r galileo-v1.1.1.tar.gz
rm -rf .0gchaind
rm -r $HOME/go/bin/*
rm -r $HOME/.bash_profile
sudo rm /usr/local/bin/0gchaind

# Download and extract Galileo node package
wget https://github.com/0glabs/0gchain-ng/releases/download/v1.1.1/galileo-v1.1.1.tar.gz
tar -xzvf galileo-v1.1.1.tar.gz -C $HOME
cd galileo

# Copy files to galileo/0g-home directory
cp -r 0g-home/* $HOME/galileo/0g-home/

# Set permissions for geth and 0gchaind binaries
sudo chmod 777 ./bin/geth
sudo chmod 777 ./bin/0gchaind

# Initialize Geth with genesis file
./bin/geth init --datadir $HOME/galileo/0g-home/geth-home ./genesis.json

# Initialize 0gchaind with user-provided MONIKER value
./bin/0gchaind init "$MONIKER" --home $HOME/galileo/tmp

# Copy node files to 0gchaind home directory
cp $HOME/galileo/tmp/data/priv_validator_state.json $HOME/galileo/0g-home/0gchaind-home/data/
cp $HOME/galileo/tmp/config/node_key.json $HOME/galileo/0g-home/0gchaind-home/config/
cp $HOME/galileo/tmp/config/priv_validator_key.json $HOME/galileo/0g-home/0gchaind-home/config/

echo 'export PATH=$PATH:$HOME/galileo/bin' >> $HOME/.bash_profile
source $HOME/.bash_profile

# Create systemd service file for 0gchaind
sudo tee /etc/systemd/system/0gchaind.service > /dev/null <<EOF
[Unit]
Description=0gchaind Node Service
After=network-online.target

[Service]
User=$USER
ExecStart=/bin/bash -c 'cd ~/galileo && CHAIN_SPEC=devnet ./bin/0gchaind start \
    --rpc.laddr tcp://0.0.0.0:26657 \
    --beacon-kit.kzg.trusted-setup-path=kzg-trusted-setup.json \
    --beacon-kit.engine.jwt-secret-path=jwt-secret.hex \
    --beacon-kit.kzg.implementation=crate-crypto/go-kzg-4844 \
    --beacon-kit.block-store-service.enabled \
    --beacon-kit.node-api.enabled \
    --beacon-kit.node-api.logging \
    --beacon-kit.node-api.address 0.0.0.0:3500 \
    --pruning=nothing \
    --home $HOME/galileo/0g-home/0gchaind-home \
    --p2p.external_address $SERVER_IP:26656 \
    --p2p.seeds 85a9b9a1b7fa0969704db2bc37f7c100855a75d9@8.218.88.60:26656'
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# Create systemd service file for 0ggeth
sudo tee /etc/systemd/system/0ggeth.service > /dev/null <<EOF
[Unit]
Description=0g Geth Node Service
After=network-online.target

[Service]
User=$USER
ExecStart=/bin/bash -c 'cd ~/galileo && ./bin/geth --config geth-config.toml \
    --nat extip:$SERVER_IP \
    --bootnodes enode://de7b86d8ac452b1413983049c20eafa2ea0851a3219c2cc12649b971c1677bd83fe24c5331e078471e52a94d95e8cde84cb9d866574fec957124e57ac6056699@8.218.88.60:30303 \
    --datadir $HOME/galileo/0g-home/geth-home \
    --networkid 16601'
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable, and start services
sudo systemctl daemon-reload
sudo systemctl enable 0ggeth.service
sudo systemctl start 0ggeth.service
sudo systemctl enable 0gchaind.service
sudo systemctl start 0gchaind.service
journalctl -u 0gchaind -u 0ggeth -f
