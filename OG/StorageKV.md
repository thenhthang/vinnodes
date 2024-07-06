<p style="font-size:14px" align="right">
<a href="https://t.me/nodesrunnerguru" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://discord.gg/dvNSrwyU" target="_blank">Join our discord <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
<a href="https://vinnodes.com" target="_blank">Visit our website <img src="https://github.com/thenhthang/vinnodes/blob/main/content/logo.jpg?raw=true" width="30"/></a>
</p>
<p align="center">
  <img height="100" height="auto" src="https://github.com/thenhthang/vinnodes/blob/main/content/oglogo.png?raw=true">
</p>

# OG Storage NKV

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
>- Bandwidth: 500 MBps for Download / Upload

# Install
### This guide is used for installation storage node and storage kv on the same server.
### You can setup your OG Storage KV in few minutes by using automated script below.
### It will prompt you to input your BLOCKCHAIN_RPC_ENDPOINT!

### Ok, let's go, setup storage kv automatic with one command
```
wget -O ogstoragekv.sh https://raw.githubusercontent.com/thenhthang/vinnodes/main/OG/ogstoragekv.sh && chmod +x ogstoragekv.sh && ./ogstoragekv.sh
```
# Useful commands
#### restart node
```
sudo systemctl restart zgskv
```
#### stop node
```
sudo systemctl stop zgskv
```
#### check your log
```
sudo journalctl -u zgskv -f -o cat
```

Question: <a href="https://t.me/nodesrunnerguruchat" target="_blank">NodesRunner Chat</a>
