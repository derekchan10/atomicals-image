#!/bin/bash

source ./cli.sh

run () {
  wallet_json=$1
  ticket=$2
  daemon=${3:-1}
  gas_offset=${4:-0}

  gas_fee=$(gas_fee)
  gas_fee=$((gas_fee + gas_offset))
  echo "gas_fee:$gas_fee"

  # 调用命令,用$image传递文件名
  mint "$wallet_json" "$daemon" mint-dft $ticket --satsbyte="$gas_fee" --funding="funding" --disablechalk

  # 其他处理逻辑
  echo "Processed image: $image"
}

source ./start.sh

