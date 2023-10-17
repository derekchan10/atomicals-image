#!/bin/sh

# 文件所在目录
wallet_json=$1
images_dir=$2
gas_fee=${3:-1}
bitworkc=${4:-0000}

alias atom-mint='f() { if [ -f "$1" ]; then docker run -it --rm -v "$1":/wallet.json -v $2:/app/image  atomicals yarn cli "${@:3}"; else echo "wallet file $1 not exit"; fi; unset -f f; }; f'

# 遍历文件
for image in $images_dir/*
do
  filename=$(echo $image | awk -F'/' '{print $NF}')

  # 调用命令,用$image传递文件名
  atom-mint "$wallet_json" "$images_dir" mint-nft "image/$filename" --satsbyte=$gas_fee --funding=funding --bitworkc="$bitworkc"

  # 其他处理逻辑
  echo "Processed image: $image"
done