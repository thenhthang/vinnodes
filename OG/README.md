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
| **zgtendermint_16600-1** | v0.1.0 | No |  |
| **zgtendermint_16600-2** | v0.2.3 | Yes |  |

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
echo 'export MONIKER="'$MONIKER'"' >> ~/.bash_profile
echo 'export CHAIN_ID="zgtendermint_16600-2"' >> ~/.bash_profile
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
git clone -b v0.2.3 https://github.com/0glabs/0g-chain.git
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
rm ~/.0gchain/config/genesis.json
wget -P ~/.0gchain/config https://github.com/0glabs/0g-chain/releases/download/v0.2.3/genesis.json

SEEDS="81987895a11f6689ada254c6b57932ab7ed909b6@54.241.167.190:26656,010fb4de28667725a4fef26cdc7f9452cc34b16d@54.176.175.48:26656,e9b4bc203197b62cc7e6a80a64742e752f4210d5@54.193.250.204:26656,68b9145889e7576b652ca68d985826abd46ad660@18.166.164.232:26656" && \
sed -i.bak -e "s/^seeds *=.*/seeds = \"${SEEDS}\"/" $HOME/.0gchain/config/config.toml

PEERS="6dbb0450703d156d75db57dd3e51dc260a699221@152.53.47.155:13456,1bf93ac820773970cf4f46a479ab8b8206de5f60@62.171.185.81:12656,df4cc52fa0fcdd5db541a28e4b5a9c6ce1076ade@37.60.246.110:13456,66d59739b6b4ff0658e63832a5bbeb29e5259742@144.76.79.209:26656,76cc5b9beaff9f33dc2a235e80fe2d47448463a7@95.216.114.170:26656,adc616f440155f4e5c2bf748e9ac3c9e24bf78ac@51.161.13.62:26656,cd662c11f7b4879b3861a419a06041c782f1a32d@89.116.24.249:26656,40cf5c7c11931a4fdab2b721155cc236dfe7a809@84.46.255.133:12656,11945ced69c3448adeeba49355703984fcbc3a1a@37.27.130.146:26656,c02bf872d61f5dd04e877105ded1bd03243516fb@65.109.25.252:12656,d5e294d6d5439f5bd63d1422423d7798492e70fd@77.237.232.146:26656,386c82b09e0ec6a68e653a5d6c57f766ae73e0df@194.163.183.208:26656,4eac33906b2ba13ab37d0e2fe8fc5801e75f25a0@154.38.168.168:13456,c96b65a5b02081e3111b8b38cd7f5df76c7f9404@185.182.185.160:26656,48e3cab55ba7a1bc8ea940586e4718a857de84c4@178.63.4.186:26656"
sed -i "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.0gchain/config/config.toml

sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ua0gi\"/" $HOME/.0gchain/config/app.toml
```
## Create service
```
sudo tee /etc/systemd/system/0gchaind.service > /dev/null <<EOF
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
sudo systemctl enable 0gchaind && \
sudo systemctl restart 0gchaind && \
sudo journalctl -u 0gchaind -f -o cat
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
0gchaind q bank balances $(0gchaind keys show $WALLET_NAME -a) 
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
  --details="NodesRunner number 1!" \
  --gas=auto \
  --gas-adjustment=1.4 \
  -y
```
## Done

# Useful commands

### Check node status 
```bash
0gchaind status | jq .sync_info
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
sudo journalctl -u 0gchaind -f -o cat
```
### Check the node is running
```
sudo systemctl status 0gchaind.service
```
### Restart the node
```bash
sudo systemctl restart 0gchaind && sudo journalctl -u 0gchaind -f -o cat
```
### Stop the node
```bash
sudo systemctl stop 0gchaind
```
### Delete the node from the server
```bash
# !!! IF YOU HAVE CREATED A VALIDATOR, MAKE SURE TO BACKUP `priv_validator_key.json` file located in $HOME/.0gchain/config/ 
sudo systemctl stop 0gchaind
sudo systemctl disable 0gchaind
sudo rm /etc/systemd/system/0gchaind.service
rm -rf $HOME/.0gchain
sudo rm /usr/local/bin/0gchain
```

Question: <a href="https://t.me/nodesrunnerguruchat" target="_blank">NodesRunner Chat</a>
