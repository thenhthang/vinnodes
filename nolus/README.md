# NOLUS SNAPSHOT

## We take a node snapshot every day. We then delete all the previous snapshots to free up the space on the file server.

<sub>
Snapshots allows a new node to join the network by recovering application state from a backup file. Snapshot contains compressed copy of chain data directory. To keep backup files as small as plausible, snapshot server is periodically beeing state-synced.
</sub>

## Snapshots are taken automatically every day at 00:00

| Latest | Date | Block Height | Size | Download
| ------ | ------ | ------ | ------ | ------ |
| yes | 2023-03-02_17:42:37 | 1206255 | 40GB | http://185.193.67.93/nolus/nolus-rila_snapshot_latest.tar.lz4

## SDK Version: v0.1.43

> Snapshots logs: http://185.193.67.93/nolus_log.txt

**GUIDE**

> Stop the service
```sh
sudo systemctl stop nolusd
```
> Backup priv_validator_state
```sh
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
```
> Delete old data
```sh
rm -rf $HOME/.nolus/data
```
> Download latest snapshot && Decompression
```sh
curl -L http://185.193.67.93/nolus/nolus-rila_snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nolus
```
> Restore priv_validator_state
```sh
mv $HOME/.nolus/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json
```
> Restart the service and check the log
```sh
sudo systemctl start nolusd && sudo journalctl -u nolusd -f --no-hostname -o cat
```
