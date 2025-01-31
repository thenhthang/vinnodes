# Download binary
mkdir pipe
cd pipe
wget https://
chmod +x pop
mkdir download_cache

# Create systemd service file
sudo tee /etc/systemd/system/popd.service > /dev/null <<EOF
[Unit]
Description=Pipe POP Node Service
After=network.target
Wants=network-online.target

[Service]
User=root
Type=simple
ExecStart=./pop --signup-by-referral-route 3bc39301286371bc

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