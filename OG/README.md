<p style="font-size:14px" align="right">
<a href="https://t.me/nodesrunnerguru" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://discord.gg/dvNSrwyU" target="_blank">Join our discord <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
<a href="https://vinnodes.com" target="_blank">Visit our website <img src="https://github.com/thenhthang/vinnodes/blob/main/content/logo.jpg?raw=true" width="30"/></a>
</p>
<p align="center">
  <img height="100" height="auto" src="https://github.com/thenhthang/vinnodes/blob/main/content/oglogo.png?raw=true">
</p>

# OG validator

Official documentation:
>- https://docs.0g.ai/0g-doc/run-a-node/validator-node

Faucet:
>- https://faucet.0g.ai

Submit Google form:
>- https://docs.google.com/forms/d/e/1FAIpQLScsa1lpn43F7XAydVlKK_ItLGOkuz2fBmQaZjecDn76kysQsw/viewform?ts=6617a343

## Hardware Requirements 
Minimum
>- 64GB RAM
>- 8Core CPU
>- Disk: 1 TB NVME SSD
>- Bandwidth: 100 MBps for Download / Upload

| Network | Version | Current | Last modified |
|---------------|-------------|-------------|-------------|
| **zgtendermint_16600-1** | v0.1.0 | Yes |  |

# Step I: Set up your OG FullNode
### Option 1 (automatic)
You can setup your OG validator in few minutes by using automated script below. It will prompt you to input your validator node name!
```
wget -O og-auto.sh https://raw.githubusercontent.com/thenhthang/vinnodes/main/OG/og-auto.sh && chmod +x og-auto.sh && ./og-auto.sh
```

### Option 2 (manual)
## Setting up vars
Here you have to put name of your node name (validator) that will be visible in explorer
```
MONIKER=<YOUR_NODE_NAME_GOES_HERE>
```
Save and import variables into system
```
echo 'export MONIKER=$MONIKER' >> ~/.bash_profile
echo 'export CHAIN_ID="zgtendermint_16600-1"' >> ~/.bash_profile
echo 'export WALLET_NAME="wallet"' >> ~/.bash_profile
echo 'export RPC_PORT="26657"' >> ~/.bash_profile
source $HOME/.bash_profile
```
## Update packages
```
sudo apt update && sudo apt upgrade -y
```
## Install dependencies
```
sudo apt install curl tar wget clang pkg-config protobuf-compiler libssl-dev jq build-essential protobuf-compiler bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y snapd
```
## Install Go
```
cd $HOME && \
ver="1.22.0" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```
## Download and build binaries
```
git clone -b v0.1.0 https://github.com/0glabs/0g-chain.git
cd 0g-chain
make install
0gchaind version
```
## Init node
```
cd $HOME
0gchaind init $MONIKER --chain-id $CHAIN_ID
0gchaind config chain-id $CHAIN_ID
0gchaind config node tcp://localhost:$RPC_PORT
0gchaind config keyring-backend os # You can set it to "test" so you will not be asked for a password
```
## Config node
```
wget https://github.com/0glabs/0g-chain/releases/download/v0.1.0/genesis.json -O $HOME/.0gchain/config/genesis.json
SEEDS="c4d619f6088cb0b24b4ab43a0510bf9251ab5d7f@54.241.167.190:26656,44d11d4ba92a01b520923f51632d2450984d5886@54.176.175.48:26656,f2693dd86766b5bf8fd6ab87e2e970d564d20aff@54.193.250.204:26656,f878d40c538c8c23653a5b70f615f8dccec6fb9f@54.215.187.94:26656" && \
sed -i.bak -e "s/^seeds *=.*/seeds = \"${SEEDS}\"/" $HOME/.0gchain/config/config.toml
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ua0gi\"/" $HOME/.0gchain/config/app.toml

```

## Create service
```
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
```
## Register and start service
```
sudo systemctl daemon-reload && \
sudo systemctl enable 0gd && \
sudo systemctl restart 0gd && \
sudo journalctl -u 0gd -f -o cat
```
# Step 2: Create validator
## Create wallet
```
0gchaind keys add $WALLET_NAME
```
#### DO NOT FORGET TO SAVE THE SEED PHRASE
#### You can add --recover flag to restore existing key instead of creating
## Extract the HEX address to request some tokens from the faucet
```
echo "0x$(0gchaind debug addr $(0gchaind keys show $WALLET_NAME -a) | grep hex | awk '{print $3}')"
```
## Faucet: https://faucet.0g.ai

## Check your wallet balance
#### Make sure your node is fully synced unless it won't work.
```
0gchaind status | jq .SyncInfo.catching_up
```
```
initiad q bank balances $(initiad keys show $WALLET_NAME -a) 
```
## Create validator
### Make sure your node is fully synced unless it won't work.
```
0gchaind tx staking create-validator \
  --amount=1000000ua0gi \
  --pubkey=$(0gchaind tendermint show-validator) \
  --moniker=$MONIKER \
  --chain-id=$CHAIN_ID \
  --commission-rate=0.05 \
  --commission-max-rate=0.10 \
  --commission-max-change-rate=0.01 \
  --min-self-delegation=1 \
  --from=$WALLET_NAME \
  --identity="" \
  --website="" \
  --details="0G to the moon!" \
  --gas=auto \
  --gas-adjustment=1.4 \
  -y
```
## Done

# Useful commands

### Check node status 
```bash
0gchaind status | jq .SyncInfo
```
### Query your validator
```bash
0gchaind q staking validator $(0gchaind keys show $WALLET_NAME --bech val -a) 
```
### Query missed blocks counter & jail details of your validator
```bash
0gchaind q slashing signing-info $(0gchaind tendermint show-validator)
```
### Unjail your validator 
```bash
0gchaind tx slashing unjail --from $WALLET_NAME --gas=500000 --gas-prices=99999ua0gi -y
```
### Delegate tokens to your validator 
```bash 
0gchaind tx staking delegate $(0gchaind keys show $WALLET_NAME --bech val -a)  <AMOUNT>ua0gi --from $WALLET_NAME --gas=500000 --gas-prices=99999ua0gi -y
```
### Get your p2p peer address
```bash
0gchaind status | jq -r '"\(.NodeInfo.id)@\(.NodeInfo.listen_addr)"'
```
### Edit your validator
```bash 
0gchaind tx staking edit-validator --website="<WEBSITE>" --details="<DESCRIPTION>" --new-moniker="<NEW_MONIKER>" --identity="<KEY BASE PREFIX>" --from=$WALLET_NAME --gas=500000 --gas-prices=99999ua0gi -y
```
### Send tokens between wallets 
```bash
0gchaind tx bank send $WALLET_NAME <TO_WALLET> <AMOUNT>ua0gi --gas=500000 --gas-prices=99999ua0gi -y
```
### Query your wallet balance 
```bash
0gchaind q bank balances $(0gchaind keys show $WALLET_NAME -a)
```
### Monitor server load
```bash 
sudo apt update
sudo apt install htop -y
htop
```
### Check logs of the node
```bash
sudo journalctl -u 0gd -f -o cat
```
### Check the node is running
```
sudo systemctl status 0gd.service
```
### Restart the node
```bash
sudo systemctl restart 0gd
```
### Stop the node
```bash
sudo systemctl stop 0gd
```
### Delete the node from the server
```bash
# !!! IF YOU HAVE CREATED A VALIDATOR, MAKE SURE TO BACKUP `priv_validator_key.json` file located in $HOME/.0gchain/config/ 
sudo systemctl stop 0gd
sudo systemctl disable 0gd
sudo rm /etc/systemd/system/0gd.service
rm -rf $HOME/.0gchain
sudo rm /usr/local/bin/0gchain
```
