#!/bin/bash

source ./cli.sh

run () {
  wallet_json=$1
  dir=$2
  daemon=${3:-1}
  bitworkc=${4:-0000}

  gas_fee=$(gas_fee)
  echo "gas_fee:${gas_fee}"

  # 随机获取图片的编号
  filename=$(random_file $dir)
  echo "file:$filename"

  param=""
  if [ -n "$bitworkc" ]; then
    param="--bitworkc=$bitworkc"
  fi

  mint "$wallet_json" "$dir" "$daemon" mint-nft "image/$filename" --satsbyte="$gas_fee" $param --funding="funding" --satsoutput="546" --disablechalk

  # 其他处理逻辑
  echo "Processed image: $image"
}

source ./start.sh

