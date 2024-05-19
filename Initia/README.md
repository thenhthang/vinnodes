<p style="font-size:14px" align="right">
<a href="https://t.me/nodesrunnerguru" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://discord.gg/dvNSrwyU" target="_blank">Join our discord <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
<a href="https://vinnodes.com" target="_blank">Visit our website <img src="https://github.com/thenhthang/vinnodes/blob/main/content/logo.jpg?raw=true" width="30"/></a>
</p>
<p align="center">
  <img height="100" height="auto" src="https://github.com/thenhthang/vinnodes/blob/main/content/initialogo.png?raw=true">
</p>

# Initia validator

Official documentation:
>- https://docs.initia.xyz/run-initia-node/running-initia-node

Faucet:
>- https://faucet.testnet.initia.xyz

Submit Google form:
>- https://docs.google.com/forms/d/e/1FAIpQLSc09Kl6mXyZHOL12n_6IUA8MCcL6OqzTqsoZn9N8gpptoeU_Q/viewform

Folow this link and complete all validator task:

>- https://initia-xyz.notion.site/The-Initiation-Validator-Tasks-6d88ab0034644473907435662f9285b3?p=a1520303c75a4997a65c89e9f2148a00&pm=s

## Hardware Requirements 
Minimum
>- 16GB RAM
>- 4Core CPU
>- Disk: 1 TB SSD Storage
>- Bandwidth: 100 Mbps

```diff
It is recommended to use Linux OS to run Initia nodes. Running Initia node has not been tested on other OS environments, and same environment settings and running conditions cannot be guaranteed. 
```
| Network | Version | Current | Last modified |
|---------------|-------------|-------------|-------------|
| **Initia testnet** | v0.2.15 | Yes |  |

## Step 1: Set up your Initia validator
### Option 1 (automatic)
You can setup your initia validator in few minutes by using automated script below. It will prompt you to input your validator node name!
```
wget -O initia-auto.sh https://raw.githubusercontent.com/thenhthang/vinnodes/main/Initia/initia-auto.sh && chmod +x initia-auto.sh && ./initia-auto.sh
```

### Option 2 (manual)
## Setting up vars
Here you have to put name of your node name (validator) that will be visible in explorer
```
MONIKER=<YOUR_NODE_NAME_GOES_HERE>
```
Save and import variables into system
```
echo "export MONIKER=$MONIKER" >> $HOME/.bash_profile
echo 'export CHAIN_ID="initiation-1"' >> ~/.bash_profile
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
git clone https://github.com/initia-labs/initia.git
cd initia
git checkout v0.2.15
make install
initiad version
```
## Init node
```
cd $HOME
initiad init $MONIKER --chain-id $CHAIN_ID
initiad config set client chain-id $CHAIN_ID
initiad config set client node tcp://localhost:$RPC_PORT
initiad config set client keyring-backend test
```
## Config node
```
wget https://initia.s3.ap-southeast-1.amazonaws.com/initiation-1/genesis.json -O $HOME/.initia/config/genesis.json
PEERS="dbc6c6f5e740378f3e4b0128d9e0561e28693181@173.212.233.137:14656,3371c3f698f81eb568e6613764d028c5855f5694@149.50.109.43:14656,afc82f6ab6d3dd1a07ca4988c58d82d1dfcac8df@84.46.250.62:14656,398fca7aab6856631becc4034284c2cdddeed7a6@127.0.0.1:26933,c8590bbaa90f6a78cd30b87bd0858c6902571e08@144.91.110.68:14656,4f759cf0eab30fc951639b4464e740d32154e1c6@38.242.255.128:14656,165a919c2003096914367c5439c4f58fdc32acf7@167.86.101.31:39656,e38e75368d186c6db5754ee6ff9072e3fb52233a@89.117.63.148:14656,a29ecdcfe85c537409638ce80a1ab8079154b1ab@149.50.113.114:14656,ee0391af866b10486cfe91b4c211c29ab683a1da@104.237.13.109:26656,67ae4c930efe1fca234985c0ef734aa340a9cb91@149.50.113.112:14656,7d18af48a2ae59e6eef166d06c80d627b3bc9ae8@149.50.111.9:14656,0efa5534ab76164eeb0e1ef75457224a96533e66@173.212.231.142:14656,456d3bc6e7fe1648d7b91ed1c66437f8a5558387@144.91.73.210:14656,29ca39c111ab15950398ea7537fb292725837906@89.117.48.166:14656,9452a5cb394de7f0826097e76f3cea57a9e97376@37.60.230.87:14656,ecbaf24f917517f992cf70cc1ac7a705f0e0b2ad@194.61.28.243:39656,a1e1d94bc413464d6d6b414b18b62ca054b0abe8@37.27.89.186:26656,55c1ef27565a4e7f96940e794e25352a41030406@31.220.74.139:14656,c89b7bb212011292fd02b861b3b8d8b9a8b6dd09@161.97.97.7:14656,1305cc1a3344208094584f51319bf9a5ae7bc86d@84.54.23.60:14656,8e8537bacf66e9bdf15872a4e070362c2ded00fe@89.117.60.190:14656,6bb30c44a34ff30c377c08a88f6b21feb65a165f@75.119.130.9:14656,4f0c17cb438655e867aaec8e66097dbd8c528d64@149.50.111.245:14656,e8e5ce53a6323d9b40b67a06260ec69c4131c249@95.111.244.126:14656,912f4b4d6fc74b3c7949fced37fc524c00f7eb11@5.189.133.252:14656,ab357b1da9bf92dd06293162a88006c31ecef67b@149.50.113.64:14656,d010b77ecd06b51b927f4ef3fbe667c5663fe078@88.99.144.140:26656,ab014c2c73879262047eb013112c849604a6abff@149.50.112.206:14656,d871096b11164134099df23f9736d60a394a6900@5.182.33.223:39656,808feaceaa7cf76bd016a5160c55f3036eb8ba33@51.158.124.170:26656,5e9fb9fa15fad5356828ed4832ed58bf80177719@161.97.118.3:14656,c383adc0bdc15d6cf374436a4a960ba51517fd3e@109.123.250.81:14656,1ae804e6a624d37d4affe9c2e29f83faf4fefc90@161.97.87.25:14656,e28ea35b16700e093100f1e50c8586a7ee5b2f9e@149.50.114.198:14656,d97595e65f8b9d4589b8e472034f8dd2b856d8a0@38.242.234.159:14656,d2db1174d2fc5896db9a41002ee13d39d8ce8ae6@185.187.170.164:39656,7d91fedde0045743424aa053cb7e21c9b61f7e5d@173.212.245.129:14656,cfc84b99280b42544b209aa9ec9ef004b95d43b5@149.50.111.19:14656,2f13795b17aca8760f7201b3808759b8ae2cddd3@185.252.232.138:14656,3effeb341c41d7f97faa2eb0bf7742bd1267e276@84.247.164.238:14656,9b5a5155575fb946ac813258076f96a90672e339@193.233.75.128:26656,4327ae81c914589505c00513e775a89529e404b3@62.171.140.24:14656,e9c5c14880533618f3c3678ae8c5461a06ff8fc2@207.180.226.186:14656,8bfd5650a8391ac2b1eceb5e4b9b7e1301bb25c8@75.119.158.32:14656,a69e1d850f5f59256a0ca8724b5ab8797d7761c1@144.91.120.68:14656" && \
SEEDS="2eaa272622d1ba6796100ab39f58c75d458b9dbc@34.142.181.82:26656,c28827cb96c14c905b127b92065a3fb4cd77d7f6@testnet-seeds.whispernode.com:25756" && \
sed -i \
    -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" \
    -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" \
    "$HOME/.initia/config/config.toml"
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.15uinit,0.01uusdc\"/" $HOME/.initia/config/app.toml
```

## Create service
```
sudo tee /etc/systemd/system/initiad.service > /dev/null <<EOF
[Unit]
Description=Initia Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which initiad) start --home $HOME/.initia
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
## Register and start service
```
sudo systemctl daemon-reload && \
sudo systemctl enable initiad && \
sudo systemctl restart initiad && \
sudo journalctl -u initiad -f -o cat
```
# DONE

## Logs
>- View the logs from the running service: journalctl -f -u initiad.service
>- Check the node is running: sudo systemctl status initiad.service
>- Stop your avail node: sudo systemctl stop initiad.service
>- Start your avail node: sudo systemctl start initiad.service

