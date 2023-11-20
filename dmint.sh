#!/bin/bash

source ./cli.sh

# 运行
run () {
  wallet_json=$1
  images_dir=$2
  container=$3
  bitworkc=${4:-1000}
  satsoutput=${5:-546}
  daemon=${6:-1}

  echo "wallet:${wallet_json},image dir:${images_dir},container:${container},bitworkc:${bitworkc},satsoutput:${satsoutput},daemon=${daemon}"

  gas_fee=$(gas_fee)
  echo "gas_fee:"$gas_fee

  # 随机获取图片的编号
  filename=$(random_file $images_dir)
  echo "file:"$filename

  # 调用命令,用$image传递文件名
  mint "$wallet_json" "$images_dir" "$daemon" mint-dmitem $container "$bitworkc"  "image/$filename" --satsbyte="$gas_fee" --funding="funding" --satsoutput="$satsoutput"

  # 其他处理逻辑
  echo "Processed image: $image"
}

source ./start.sh