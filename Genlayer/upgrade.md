## This guide helps you update your GenLayer node from version v0.3.0 or later to v0.3.7 while preserving all previously synchronized data.
Check latest version
```
curl -s "https://storage.googleapis.com/storage/v1/b/gh-af/o?prefix=genlayer-node/bin/amd64" \
| grep -o '"name": *"[^"]*"' \
| sed -n 's/.*\/\(v[^/]*\)\/.*/\1/p' \
| sort -ru
```
Download latest version
```
LATEST_VERSION=v0.3.8 # set your desired version here
wget https://storage.googleapis.com/gh-af/genlayer-node/bin/amd64/${LATEST_VERSION}/genlayer-node-linux-amd64-${LATEST_VERSION}.tar.gz -O $HOME/genlayer-node-linux-amd64-${LATEST_VERSION}.tar.gz
cd $HOME
```
Extract
```
mkdir $HOME/genlayer-node-linux-amd64-${LATEST_VERSION}
tar -xzvf $HOME/genlayer-node-linux-amd64-${LATEST_VERSION}.tar.gz -C genlayer-node-linux-amd64-${LATEST_VERSION}
```
Upgrade 
```
sudo systemctl stop genlayer-node
cd $HOME/genlayer-node-linux-amd64-${LATEST_VERSION}/genlayer-node-linux-amd64
cp -r bin $HOME/genlayer-node-linux-amd64
sudo systemctl start genlayer-node && journalctl -fu genlayer-node
```
