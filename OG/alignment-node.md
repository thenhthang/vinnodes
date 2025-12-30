./0g-alignment-node registerOperator --mainnet \
  --key <KEY> \
  --chain-id 16661 \
  --rpc https://evmrpc.0g.ai \
  --contract 0x7BDc2aECC3CDaF0ce5a975adeA1C8d84Fd9Be3D9 \
  --commission 1 \
  --token-id 54976

  nohup ./0g-alignment-node start --mainnet > node.log 2>&1 &

 ./0g-alignment-node approve --mainnet \
  --key <KEY> \
  --chain-id 16661 \
  --rpc https://evmrpc.0g.ai \
  --contract 0x7BDc2aECC3CDaF0ce5a975adeA1C8d84Fd9Be3D9 \
  --destNode 0x1A80B1f0939a7DA7CEB25eC581e3a6A78A6D6771 \
  --tokenIds 54976,54977,54978,54979,55053,55054,55055,55056,55057


./0g-alignment-node approve --mainnet \
  --key <KEY> \
  --chain-id 16661 \
  --rpc https://evmrpc.0g.ai \
  --contract 0x7BDc2aECC3CDaF0ce5a975adeA1C8d84Fd9Be3D9 \
  --destNode 0x6df57E227614028F58B3DF90510C94d1Eb12CC48 \
  --tokenIds 54957,54958,54959,54960,54961
