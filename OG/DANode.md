<p style="font-size:14px" align="right">
<a href="https://t.me/nodesrunnerguru" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://discord.gg/dvNSrwyU" target="_blank">Join our discord <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
<a href="https://vinnodes.com" target="_blank">Visit our website <img src="https://github.com/thenhthang/vinnodes/blob/main/content/logo.jpg?raw=true" width="30"/></a>
</p>
<p align="center">
  <img height="100" height="auto" src="https://github.com/thenhthang/vinnodes/blob/main/content/oglogo.png?raw=true">
</p>

# OG Da Node
This guide will help you in the 0G DA node installation process.

-----------------------------------------------------------------

## Required Hardware Specifications
| Required | Specification |
|-|-
| CPU | 8 Cores |
| Memory | 16 GB |
| Storage | 1 TB NVMe SSD |
| Bandwidth | 100mbps |
| OS | Linux |

-----------------------------------------------------------------

## DA Node Installation
## YOUR ETH WALLET NEED STAKE MIN 10 OG TO ANY VALIDATOR TO RUN DA NODE
## Create wallet
```
0gchaind keys add DANODE --eth
```
### Export private key
```
0gchaind keys export DANODE --unsafe --unarmored-hex
```
### Get ETH Address
```
echo "0x$(0gchaind debug addr $(0gchaind keys show DANODE -a) | grep hex | awk '{print $3}')"
```
### Faucet 11 og: https://faucet.0g.ai/
### Delegate 10 og to a validator
```
0gchaind tx staking delegate 0gvaloper1d5rq8htu5c87djw2g5zkpwa4gpm2e62gek0ptf 10000000ua0gi --from DANODE --gas=auto --gas-adjustment=1.4 -y
```
### 1. Install Dependencies
```bash
sudo apt-get update
sudo apt-get install git cargo clang cmake build-essential pkg-config openssl libssl-dev protobuf-compiler llvm llvm-dev
wget https://github.com/protocolbuffers/protobuf/releases/download/v21.0/protoc-21.0-linux-x86_64.zip
unzip protoc-21.0-linux-x86_64.zip -d protoc21
sudo cp protoc21/bin/protoc /usr/local/bin/
```

### 2. Install Rustup
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

You will be asked for Rust installation options, just use the default one. Press `1` then `enter` to continue the installation process.
![CleanShot 2024-04-13 at 15 07 52@2x](https://github.com/BlockchainsHub/Testnet/assets/77204008/bcb81284-8235-4cf2-a4f1-50821044cc21)

After the installation process is complete, run the following command, to restart the shell.
```bash
. "$HOME/.cargo/env"
```
![CleanShot 2024-04-13 at 15 13 17@2x](https://github.com/BlockchainsHub/Testnet/assets/77204008/f8f94656-0f1f-4d27-b347-3842b2b77a6f)

### 3. Build Binary
```bash
git clone https://github.com/0glabs/0g-da-node.git
cd $HOME/0g-da-node
cargo build --release
cd $HOME/0g-da-node/dev_support
./download_params.sh
sudo cp -R /root/0g-da-node/dev_support/params /root/0g-da-node/target/release
```

### 4. Create DB Directory
```bash
mkdir -p "$HOME/0g-da-node/db"
```

### 5. Create Config File
```bash
cp $HOME/0g-da-node/config_example.toml $HOME/0g-da-node/config.toml
```

### 6. Generate a BLS Private Key
Run the command below to generate a BLS private key. **Please keep the generated BLS private key carefully**.
```bash
cargo run --bin key-gen
```
Example output:
![CleanShot 2024-07-10 at 18 05 17@2x](https://github.com/BlockchainsHub/Testnet/assets/77204008/aaa9ab86-3bb0-4445-9d4a-b75deb2d686d)
> [!CAUTION]
> **DO NOT FORGET TO SAVE YOUR BLS PRIVATE KEY!**

### 7. Set Up Environment Variables
Run the command below and input your validator node IP and port in this format `http://x.x.x.x:8545`. 
```bash
read -p "Enter your validator node IP and port for eth_rpc_endpoint configuration: " BLOCKCHAIN_RPC_ENDPOINT
```

Run the command below and input your DA node IP and port in this format `http://x.x.x.x:34000`. 
```bash
read -p "Enter your DA node IP and port for socket_address configuration: " SOCKET_ADDRESS
```

Run the command below and input your BLS private key. 
```bash
read -p "Enter your BLS private key for signer_bls_private_key configuration: " SIGNER_BLS_PRIVATE_KEY
```

Run the command below and input your wallet's private key. 
```bash
read -p "Enter your private key for signer_eth_private_key configuration: " SIGNER_ETH_PRIVATE_KEY
```

```bash
echo 'export ZGDA_CONFIG_FILE="$HOME/0g-da-node/config.toml"' >> ~/.bash_profile

echo 'export DB_DIR="$HOME/0g-da-node/db"' >> ~/.bash_profile

echo 'export ZGDA_ENCODER_PARAMS_DIR="$HOME/0g-da-node/params"' >> ~/.bash_profile

echo 'export BLOCKCHAIN_RPC_ENDPOINT="'$BLOCKCHAIN_RPC_ENDPOINT'"' >> ~/.bash_profile

echo 'export SOCKET_ADDRESS="'$SOCKET_ADDRESS'"' >> ~/.bash_profile

echo 'export SIGNER_BLS_PRIVATE_KEY="'$SIGNER_BLS_PRIVATE_KEY'"' >> ~/.bash_profile

echo 'export SIGNER_ETH_PRIVATE_KEY="'$SIGNER_ETH_PRIVATE_KEY'"' >> ~/.bash_profile

source ~/.bash_profile
```

### 8. Update Config File
```bash
sed -i "s|^\s*#\?\s*data_path\s*=.*|data_path = \"$DB_DIR\"|" "$ZGDA_CONFIG_FILE"

sed -i "s|^\s*#\?\s*encoder_params_dir\s*=.*|encoder_params_dir = \"$ZGDA_ENCODER_PARAMS_DIR\"|" "$ZGDA_CONFIG_FILE"

sed -i "s|^\s*#\?\s*eth_rpc_endpoint\s*=.*|eth_rpc_endpoint = \"$BLOCKCHAIN_RPC_ENDPOINT\"|" "$ZGDA_CONFIG_FILE"

sed -i "s|^\s*#\?\s*socket_address\s*=.*|socket_address = \"$SOCKET_ADDRESS\"|" "$ZGDA_CONFIG_FILE"

sed -i 's|^\s*#\?\s*da_entrance_address\s*=.*|da_entrance_address = "0xDFC8B84e3C98e8b550c7FEF00BCB2d8742d80a69"|' "$ZGDA_CONFIG_FILE"

sed -i "s|^\s*#\?\s*signer_bls_private_key\s*=.*|signer_bls_private_key = \"$SIGNER_BLS_PRIVATE_KEY\"|" "$ZGDA_CONFIG_FILE"

sed -i "s|^\s*#\?\s*signer_eth_private_key\s*=.*|signer_eth_private_key = \"$SIGNER_ETH_PRIVATE_KEY\"|" "$ZGDA_CONFIG_FILE"
```

### 9. Create Service File
Create a service file to run the DA node in the background.
```bash
sudo tee /etc/systemd/system/zgda.service > /dev/null <<EOF
[Unit]
Description=0G DA Node
After=network.target

[Service]
User=root
WorkingDirectory=/root/0g-da-node/target/release
ExecStart=/root/0g-da-node/target/release/server --config /root/0g-da-node/config.toml
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

### 10. Start DA Node
```bash
sudo systemctl daemon-reload && \
sudo systemctl enable zgda && \
sudo systemctl start zgda && \
sudo systemctl status zgda
```

-----------------------------------------------------------------

## Useful Commands
### Check Log
```bash
sudo journalctl -u zgda -f -o cat
```

### Restart the Node
```bash
sudo systemctl restart zgda
```

### Stop the Node
```bash
sudo systemctl stop zgda
```

### Delete the Node
```bash
sudo systemctl stop zgda
sudo systemctl disable zgda
sudo rm /etc/systemd/system/zgda.service
sudo rm /usr/local/bin/server
rm -rf $HOME/0g-da-node
```
