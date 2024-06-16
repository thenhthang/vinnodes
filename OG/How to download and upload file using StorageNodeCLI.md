# How to download and upload file using StorageNodeCLI.md
## Step 1: Install Storage Node CLI
#### Install golang
```
VERSION=1.22.4
wget -O go.tar.gz https://go.dev/dl/go$VERSION.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz
echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
echo 'export GOPATH=$HOME/go' >> $HOME/.bash_profile
echo 'export GO111MODULE=on' >> $HOME/.bash_profile
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile && . $HOME/.bash_profile
go version
```
#### Download the source code
```
git clone https://github.com/0glabs/0g-storage-client.git
```
#### Build the source code
```
cd 0g-storage-client
go build
```
## Step 2: Upload
#### Make a sample.txt file
```
sudo tee ./sample1.txt > /dev/null <<EOF
OG To the moon. NodesRunner number 1.
EOF
```
#### Upload
```
./0g-storage-client upload \
--url YOUR_BLOKCHAIN_RPC_ENPOINT \
--contract 0xb8F03061969da6Ad38f0a4a9f8a86bE71dA3c8E7 \
--key YOUR_STORAGE_NODE_PRIVATE_KEY \
--node YOUR_STORAGENODE_RPC_ENTPOINT \
--file sample.txt
```
_Example (If you use default port)_
```
./0g-storage-client upload \
--url http://IP:8545 \
--contract 0xb8F03061969da6Ad38f0a4a9f8a86bE71dA3c8E7 \
--key 6ab820c603exxxxxxxxxxxxxxxxxxxxxxxxxxxxx00b02157ea40bf \
--node http://IP:5678 \
--file sample.txt
```
**Result**
![image](https://github.com/thenhthang/vinnodes/assets/16117878/0611b913-b6eb-4ebd-a212-dc2b0dfb5812)

#### Download
```
./0g-storage-client download --node YOUR_STORAGENODE_RPC_ENDPOINT --root YOUR_FILE_ROOT_HASH --file output.txt
```
# Check transaction

https://chainscan-newton.0g.ai
