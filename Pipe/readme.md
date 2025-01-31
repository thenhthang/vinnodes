# Download binary
```
mkdir pipe
cd pipe
wget https://raw.githubusercontent.com/thenhthang/vinnodes/refs/heads/main/Pipe/binary/pop
chmod +x pop
mkdir download_cache
```
# Signup
```
./pop --signup-by-referral-route 3bc39301286371bc
```
# Setting, 
```
./pop
```
# Create systemd service file
## please change YOUR_SOLANA_ADDRESS
```
sudo tee /etc/systemd/system/popd.service > /dev/null <<EOF
[Unit]
Description=Pipe POP Node Service
After=network.target
Wants=network-online.target

[Service]
User=root
Type=simple
ExecStart=$HOME/pipe/pop --cache-dir $HOME/pipe/download_cache --pubKey YOUR_SOLANA_ADDRESS

Restart=always
RestartSec=5
Restart=on-failure
LimitNOFILE=65536
LimitNPROC=4096
StandardOutput=journal
StandardError=journal
WorkingDirectory=$HOME/pipe

[Install]
WantedBy=multi-user.target
EOF
```
# start
``
sudo systemctl daemon-reload
sudo systemctl enable popd.service
sudo systemctl start popd.service
``
# DONE

# Restart
```
sudo systemctl restart popd.service
```
# check services status
```
sudo systemctl status popd.service
```
# MONITOR
## View metrics
./pop --status

## Check points
./pop --points-route

## Generate referral
./pop --gen-referral-route

## Use referral
./pop --signup-by-referral-route <CODE>

