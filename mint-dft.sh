#!/bin/bash

source ./cli.sh

run () {
  wallet_json=$1
  ticket=$2
  daemon=${3:-1}
  gas_offset=${4:-0}
  gas_limit=${5:-0}
  funding=${6:-"funding"}

  gas_fee=$(gas_fee)

  if [ $gas_limit -gt 0 ]; then
    if [ $gas_fee -ge $gas_limit ]; then
      echo "gas too higher"
      sleep 3
      return 0
    fi
  fi

  gas_fee=$((gas_fee + gas_offset))
  echo "gas_fee:$gas_fee"

  # 调用命令,用$image传递文件名
  mint "$wallet_json" "$daemon" mint-dft $ticket --satsbyte="$gas_fee" --funding="$funding" --disablechalk

  return 1
}

source ./start.sh

