#### Create new validator
```
ojod tx staking create-validator \
--amount 1000000uojo \
--pubkey $(ojod tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id ojo-devnet \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0uojo \
-y
```
#### Edit validator
```
ojod tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id ojo-devnet \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0uojo \
-y
```
```
nolusd tx staking edit-validator \
  --new-moniker="VinnodesNolus" \
  --details="We are from vinnodes.Operation worldwide" \
  --chain-id=nolus-rila \
  --fees=600unls \
  --from=noluswallet
 ```
#### Crom job auto withdraw all rewards and redelegate to your validator
```
0 1 * * * bash ojodelegate.sh
30 0 * * * ojod tx distribution withdraw-rewards $(ojod keys show wallet --bech val -a) --commission --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```
#### Jailing info
```
entangled q slashing signing-info $(entangled tendermint show-validator)
```
#### Unjail validator
```
entangled tx slashing unjail --broadcast-mode block --from $WALLET --chain-id entangle_33133-1 --gas=700000 --gas-prices="20aNGL" -y
```
#### Chuyển validator sang server khác

B1. Tại server mới: Chạy fullnode mới , chờ đồng bộ hoàn toàn (không cần tạo validator)
B2. Dừng node ở server cũ, dừng node ở server mới
Copy các file sau từ server cũ sang server mới:
/config/node_key.json
/config/priv_validator_key.json
/data/priv_validator_state.json
B3. Restart node ở server mới (Done)
