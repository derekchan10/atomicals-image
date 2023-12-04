#!/bin/sh

set -e

cd /app

# check if /wallet.json exists and has content
if [ -s "/wallet.json" ]; then
  mkdir /app/wallets
  cp /wallet.json /app/wallets/wallet.json
else
  yarn cli wallet-init
  cp /app/wallets/wallet.json /wallet.json
fi

exec "$@"
