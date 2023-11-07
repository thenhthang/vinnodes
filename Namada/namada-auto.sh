#!/bin/bash
exists()
{
	  command -v "$1" >/dev/null 2>&1
  }
if exists curl; then
	echo ''
else
	  sudo apt update && sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
	    . $HOME/.bash_profile
fi
sleep 1 && curl -s https://raw.githubusercontent.com/thenhthang/vinnodes/main/logo.sh | bash && sleep 1
if ss -tulpen | awk '{print $5}' | grep -q ":26656$" ; then
        echo -e "\e[31mInstallation is not possible, port 26656 already in use.\e[39m"
        exit
else
        echo ""
fi
#NAMADA_TAG="v0.15.4"
#TM_HASH="v0.1.4-abciplus"
NAMADA_CHAIN_ID="public-testnet-14.5d79b6958580"
rm -rf $HOME/.masp-params

if [ ! $VALIDATOR_ALIAS ]; then
	read -p "Enter validator name: " VALIDATOR_ALIAS
	echo 'export VALIDATOR_ALIAS='\"${VALIDATOR_ALIAS}\" >> $HOME/.bash_profile
fi
echo -e 'Setting up swapfile...\n'
curl -s https://api.nodes.guru/swap8.sh | bash
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
. $HOME/.bash_profile
sleep 1
cd $HOME
sudo apt update
sudo apt install make clang pkg-config git-core libssl-dev build-essential libclang-12-dev git jq ncdu bsdmainutils htop -y < "/dev/null"
wget -O libssl1.1_1.1.1f-1ubuntu2_amd64.deb http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb

echo -e '\n\e[42mInstall Rust\e[0m\n' && sleep 1
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

echo -e '\n\e[42mInstall Go\e[0m\n' && sleep 1
VERSION=1.20.5
wget -O go.tar.gz https://go.dev/dl/go$VERSION.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz
echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
echo 'export GOPATH=$HOME/go' >> $HOME/.bash_profile
echo 'export GO111MODULE=on' >> $HOME/.bash_profile
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile && . $HOME/.bash_profile
go version

echo -e '\n\e[42mInstall software\e[0m\n' && sleep 1
mkdir -p $HOME/cometbft_bin
cd $HOME/cometbft_bin
wget -O cometbft.tar.gz https://github.com/cometbft/cometbft/releases/download/v0.37.2/cometbft_0.37.2_linux_amd64.tar.gz
tar xvf cometbft.tar.gz
sudo chmod +x cometbft
sudo mv ./cometbft /usr/local/bin/

rm -rf $HOME/namada_bin
mkdir -p $HOME/namada_bin
cd $HOME/namada_bin
wget -O namada.tar.gz https://github.com/anoma/namada/releases/download/v0.25.0/namada-v0.25.0-Linux-x86_64.tar.gz
tar xvf namada.tar.gz
cd namada-*
sudo chmod +x namada namada[c,n,w]
sudo mv namada /usr/local/bin/
sudo mv namada[c,n,w] /usr/local/bin/
#git clone https://github.com/anoma/namada 
#cd namada 
#git checkout $NAMADA_TAG
#make build-release
#sudo mv target/release/namada /usr/local/bin/
#sudo mv target/release/namada[c,n,w] /usr/local/bin/

#cd $HOME && sudo rm -rf tendermint 
#git clone https://github.com/heliaxdev/tendermint 
#cd tendermint 
#git checkout $TM_HASH
#make build
#sudo mv build/tendermint /usr/local/bin/
cd $HOME
namada client utils join-network --chain-id $NAMADA_CHAIN_ID
sleep 3
echo "[Unit]
Description=Namada Node
After=network.target

[Service]
User=$USER
WorkingDirectory=$HOME/.local/share/namada
Type=simple
ExecStart=/usr/local/bin/namada --base-dir=$HOME/.local/share/namada node ledger run
Environment=NAMADA_CMT_STDOUT=true
RemainAfterExit=no
Restart=always
RestartSec=5s
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/namadad.service
sudo mv $HOME/namadad.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
echo -e '\n\e[42mRunning a service\e[0m\n' && sleep 1
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable namadad
sudo systemctl restart namadad

echo -e '\n\e[42mCheck node status\e[0m\n' && sleep 1
if [[ `service namadad status | grep active` =~ "running" ]]; then
        echo -e "Your namada node \e[32minstalled and works\e[39m!"
        echo -e "You can check node status by the command \e[7mservice namadad status\e[0m"
        echo -e "Press \e[7mQ\e[0m for exit from status menu"
      else
        echo -e "Your namada node \e[31mwas not installed correctly\e[39m, please reinstall."
fi
