#!/bin/bash

source ./cli.sh

run () {
  wallet_json=$1
  ticket=$2
  daemon=${3:-1}
  gas_offset=${4:-0}
  gas_limit=${5:-0}
  gas_type=${6:-1}

  gas_fee=$(gas_fee)
  echo "gas_fee:$gas_fee"

  if [ $gas_limit -gt 0 ]; then
    if [ "$gas_type" == "2" ]; then
      if [ $gas_fee -ge $gas_limit ]; then
        gas_fee=$gas_limit
      fi
    else
      if [ $gas_fee -ge $gas_limit ]; then
        echo "gas too higher"
        sleep 3
        return 0
      fi

    fi

  fi

  gas_fee=$((gas_fee + gas_offset))

  # 调用命令,用$image传递文件名
  mint "$wallet_json" "$daemon" mint-dft $ticket --satsbyte="$gas_fee" --funding="funding" --disablechalk

  return 1
}

source ./start.sh

