<p style="font-size:14px" align="right">
<a href="https://t.me/nodesrunnerguru" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://discord.gg/dvNSrwyU" target="_blank">Join our discord <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
<a href="https://vinnodes.com" target="_blank">Visit our website <img src="https://github.com/thenhthang/vinnodes/blob/main/content/logo.jpg?raw=true" width="30"/></a>
</p>
<p align="center">
  <img height="100" height="auto" src="https://github.com/thenhthang/vinnodes/blob/main/content/oglogo.png?raw=true">
</p>

# OG Storage Node

Official documentation:
>- https://docs.0g.ai/0g-doc/run-a-node/storage-node-and-da-services

Faucet:
>- https://faucet.0g.ai

Submit Google form:
>- https://docs.google.com/forms/d/e/1FAIpQLScsa1lpn43F7XAydVlKK_ItLGOkuz2fBmQaZjecDn76kysQsw/viewform?ts=6617a343

## Hardware Requirements 
Minimum
>- 16GB RAM
>- 4Core CPU
>- Disk: 500G NVME SSD
>- Bandwidth: 600 MBps for Download / Upload

| Network | Version | Current | Last modified |
|---------------|-------------|-------------|-------------|
| **zgtendermint_16600-1** | v0.3.0 | No |  |
| **zgtendermint_16600-2** | v0.3.2 | No |  |
| **zgtendermint_16600-2** | v0.3.3 | Yes | 07/14/2024 |

# Install
### You can setup your OG Storage Node in few minutes by using automated script below.
### It will prompt you to input your EVM_PRIVATE_KEY and your BLOCKCHAIN_RPC_ENDPOIT!
#### Get evm private key
From metamask: Open metamask wallet > Account details > Show private key

OR 

From 0GChain wallet: ```0gchaind keys unsafe-export-eth-key $WALLET_NAME```
#### List rpc endpoint
You can use your own rpc-end-point or use any rpc below:
- https://rpc-testnet.0g.ai
- https://0g-new-rpc.dongqn.com
- https://0g-testnet-rpc.tech-coha05.xyz
- https://evm-rpc-0g.mflow.tech
- https://og-testnet-jsonrpc.blockhub.id
- https://0gevmrpc.nodebrand.xyz

#### Faucet token before install: https://faucet.0g.ai
#### Please check rpc still working before install 
```
curl -X POST <YOUR_RPC_END_POINT> -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```
If you see the same, it's working
![alt text](image.png)
### Ok, let's go, setup storage node automatic with one command
```
wget -O ogstorage-auto.sh https://raw.githubusercontent.com/thenhthang/vinnodes/main/OG/ogstorage-auto.sh && chmod +x ogstorage-auto.sh && ./ogstorage-auto.sh
```
# Useful commands
#### restart node
```
sudo systemctl restart zgs
```
#### stop node
```
sudo systemctl stop zgs
```
#### check your log list
```
ls ~/0g-storage-node/run/log/
```
#### check your last log
```
tail -f ~/0g-storage-node/run/log/zgs.log.$(date +%Y-%m-%d)
```
If you see the same, the installation was successful
#### check version
```
$HOME/0g-storage-node/target/release/zgs_node --version
```
### deleta all data
```
rm -rf $HOME/0g-storage-node/run/db
```
### backup config
```
cp $HOME/0g-storage-node/run/config.toml $HOME/config.toml.bak
```
### Upgrade to v0.8.4
```
sudo systemctl stop zgs
cp $HOME/0g-storage-node/run/config.toml $HOME/config.toml.bak
```
```
cd $HOME/0g-storage-node
git stash
git fetch --all --tags
git checkout tags/v0.8.4
git submodule update --init
cargo build --release
```
```
cp $HOME/config.toml.bak $HOME/0g-storage-node/run/config.toml
sudo systemctl restart zgs && sudo systemctl status zgs
```
### check sync status
```
source <(curl -s https://raw.githubusercontent.com/thenhthang/vinnodes/refs/heads/main/OG/storagenodetest.sh)
```
![alt text](image-1.png)

Question: <a href="https://t.me/nodesrunnerguruchat" target="_blank">NodesRunner Chat</a>
