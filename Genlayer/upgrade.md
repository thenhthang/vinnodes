## This guide helps you update your GenLayer node from version v0.3.0 or later to v0.3.7 while preserving all previously synchronized data.
Set vars (if necessary)
```
cd $HOME
ZKSYNC_URL="YOUR_URL"
ZKSYNC_WEBSOCKET_URL="YOUR_URL"
HEURISTKEY="YOUR_HEURIST_API_KEY"
echo "export ZKSYNC_URL=$ZKSYNC_URL" >> $HOME/.bash_profile
echo "export ZKSYNC_WEBSOCKET_URL=$ZKSYNC_WEBSOCKET_URL" >> $HOME/.bash_profile
echo "export HEURISTKEY=$HEURISTKEY" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
Download latest version
```
LATEST_VERSION=v0.3.7 # set your desired version here
wget https://storage.googleapis.com/gh-af/genlayer-node/bin/amd64/${LATEST_VERSION}/genlayer-node-linux-amd64-${LATEST_VERSION}.tar.gz -O $HOME/genlayer-node-linux-amd64-${LATEST_VERSION}.tar.gz
cd $HOME
```
Extract
```
mkdir $HOME/genlayer-node-linux-amd64-${LATEST_VERSION}
tar -xzvf $HOME/genlayer-node-linux-amd64-${LATEST_VERSION}.tar.gz -C genlayer-node-linux-amd64-${LATEST_VERSION}
```
Stop node
```
sudo systemctl stop genlayer-node
```
Move new node files
```
cd $HOME/genlayer-node-linux-amd64-${LATEST_VERSION}/genlayer-node-linux-amd64
cp -r bin configs third_party $HOME/genlayer-node-linux-amd64
```
Update node config
```
sed -i "s|^\( *zksyncurl: *\).*|\1\"$ZKSYNC_URL\"|" $HOME/genlayer-node-linux-amd64/configs/node/config.yaml
sed -i "s|^\( *zksyncwebsocketurl: *\).*|\1\"$ZKSYNC_WEBSOCKET_URL\"|" $HOME/genlayer-node-linux-amd64/configs/node/config.yaml
```
Update LLM config
- At this stage, select one LLM and set all other to disabled. Disable (enable: false) every provider but HEURIST.
```
sed -i '/comput3:/,/enabled:/s/enabled: true/enabled: false/' \
$HOME/genlayer-node-linux-amd64/third_party/genvm/config/genvm-module-llm.yaml
```
Start node
```
sudo systemctl start genlayer-node && journalctl -fu genlayer-node
```