<img width="500" height="1000" alt="image" src="https://github.com/user-attachments/assets/12c3cded-819b-43cb-a62e-00d3939e42e2" />

## Create bash file
> Download the monitoring script that checks your node status and sends notifications via NTFY:
```
wget https://raw.githubusercontent.com/thenhthang/vinnodes/refs/heads/main/Genlayer/genlayer-alert.sh
```
> Make the script executable:
```
chmod +x genlayer-alert.sh
```
> Run the script:
```
./genlayer-alert.sh
```
On the first run, the script will ask you to enter a topic name for notifications:

<img width="520" height="52" alt="image" src="https://github.com/user-attachments/assets/4b58630e-9d41-43b5-9782-9d4503d1300f" />

Note:
- The topic name is your personal notification channel.
- Remember this topic name, as you will use it again when installing the app.
- The script saves the topic name as an environment variable, so you won’t be asked again on future runs.


## Install App to Receive Notifications

https://notify.vinnodes.com/docs/

<img width="765" height="293" alt="image" src="https://github.com/user-attachments/assets/4aa4b568-3827-4209-a7d8-2e0d453e4955" />

Steps:
- Install the ntfy app (Android / iOS / Web)
- Open the app
- Subscribe to a topic
- Enter the same topic name you used when running the script

<img width="7000" height="1000" alt="image" src="https://github.com/user-attachments/assets/6a4dea80-c5ad-4566-afea-d1ffede6096e" />

# Done
From now on:
- The script continuously monitors your node status. 
- You will receive an instant notification if your node goes down. 
- You can run the script via cron to enable 24/7 monitoring.

# Cron job: run every 2 minutes
> Open crontab editor
```
sudo crontab -e
```
> Add the cron job
```
*/2 * * * * $HOME/genlayer-alert.sh >> /var/log/genlayer-health.log 2>&1
```
# Test notify
```
TOPIC_FILE="/etc/genlayer/topic"
if [ -z "$TOPICNAME" ] && [ -f "$TOPIC_FILE" ]; then
  TOPICNAME=$(cat "$TOPIC_FILE")
fi
curl -d "Backup successful 😀" https://ntfy.sh/$TOPICNAME
```
<img width="1070" height="130" alt="image" src="https://github.com/user-attachments/assets/abf3f733-85d4-43cd-bb86-0e92e28ba4bb" />



