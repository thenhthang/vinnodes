## Step 1: Run a Full node
Read guide: https://github.com/thenhthang/vinnodes/blob/main/Avail/README.md
## Step 2: Create account & Set Identity
- Create account
Go to https://goldberg.avail.tools/#/accounts
<img width="1440" alt="image" src="https://github.com/thenhthang/vinnodes/assets/16117878/ebf6ebd9-f81b-414a-8b1e-bffae9629f11">
- Set identity
You need 10 AVAIL tokens for identification, faucet on discord
<img width="1437" alt="image" src="https://github.com/thenhthang/vinnodes/assets/16117878/b7ad0b47-08fc-48d7-af73-e09426e7190c">
Fill in all information and confirm
<img width="900" alt="image" src="https://github.com/thenhthang/vinnodes/assets/16117878/1c3a5b40-d052-49be-b9b4-972d240f1157">
## Step 3: Controll your full node
Official documentation: https://docs.availproject.org/operate/validator/staking

- Create Stash
<img width="1440" alt="image" src="https://github.com/thenhthang/vinnodes/assets/16117878/20a11727-8b4f-43e9-89e1-785206188e03">
<img width="1085" alt="image" src="https://github.com/thenhthang/vinnodes/assets/16117878/793db9cb-1c13-4c39-9582-6e43cb4aca7a">
- Submit seesion keys
  
**After your node is fully synced, you'll need to rotate and submit your session keys.**

get hex-encoded, run command on your machine

```
curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "author_rotateKeys", "params":[]}' http://localhost:9944
```
Navigate back to the Staking tab.

Click on **Set Session Key** and enter the hex-encoded result.

Click **Set Session Key** and enter your password when prompted.

![image](https://github.com/thenhthang/vinnodes/assets/16117878/85cb24a6-d9da-4ef2-a70d-03782fd43c58)




