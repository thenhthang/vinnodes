# Start
## Download binary
```
curl -L -o pop "https://dl.pipecdn.app/v0.2.5/pop"
chmod +x pop
mkdir download_cache
```
## Signup
```
./pop --signup-by-referral-route 84a8bbbe91f5acdf
```
please change $YOUR_SOLANA_ADDRESS
```
SOLANA_ADDRESS="YOUR_SOLANA_ADDRESS"
```
## Create systemd service file
### please change YOUR_SOLANA_ADDRESS
```
sudo tee /etc/systemd/system/popd.service > /dev/null <<EOF
[Unit]
Description=Pipe POP Node Service
After=network.target
Wants=network-online.target

[Service]
User=root
Type=simple
ExecStart=$HOME/pop --cache-dir $HOME/download_cache --pubKey $SOLANA_ADDRESS

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
## Start service

```
sudo systemctl daemon-reload && sudo systemctl enable popd.service && sudo systemctl start popd.service
```
# END

## Restart
```
sudo systemctl restart popd.service
```
## Stop
```
sudo systemctl stop popd.service
```
# Upgrade
```
sudo systemctl stop popd.service
cd $HOME
wget https://
sudo systemctl restart popd.service
```
# MONITOR
## check service status
```
sudo systemctl status popd.service
```
if you see the same, it's ok.
<img width="1044" alt="image" src="https://github.com/user-attachments/assets/d9e5f48b-8d64-4ccd-8f3c-0036142324f4" />

## View metrics
```
./pop --status
```

## Check points
```
./pop --points-route
```

## Generate referral
```
./pop --gen-referral-route
```

## Use referral
```
./pop --signup-by-referral-route <CODE>
```

