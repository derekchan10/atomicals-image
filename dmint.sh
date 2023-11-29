#!/bin/bash

source ./cli.sh

# 运行
run () {
  wallet_json=$1
  dir=$2
  container=$3
  daemon=${4:-1}
  satsoutput=${5:-546}

  echo "wallet:${wallet_json},dir:${dir},container:${container},satsoutput:${satsoutput},daemon=${daemon}"

  gas_fee=$(gas_fee)
  echo "gas_fee:$gas_fee"

  # 随机获取图片的编号
  filename=$(random_file $dir)
  echo "file:$filename"

  item=$(basename "$filename" | sed 's/\.[^.]*$//')
  echo "item:$item"

  # 调用命令,用$image传递文件名
  mint "$wallet_json"  "$dir" "$daemon" mint-item "$container" "$item" "image/$filename" --satsbyte="$gas_fee" --funding="funding" --satsoutput="$satsoutput"

  # 其他处理逻辑
  echo "Processed image: $image"
}

source ./start.sh