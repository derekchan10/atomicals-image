#!/bin/sh

mint() {
  wallet=$1
  image_path=$2
  shift
  shift

  if [ -f "$wallet" ];
  then
    docker run -it --rm -v "$wallet":/wallet.json -v "$image_path":/app/image atomicals yarn cli "$@";
  else
    echo "wallet file $wallet not exit";
  fi;
}

run () {
  wallet_json=$1
  images_dir=$2
  gas_fee=${3:-1}
  bitworkc=${4:-0000}

  # 遍历文件
  for image in $images_dir/*
  do
    filename=$(echo $image | awk -F'/' '{print $NF}')

    # 调用命令,用$image传递文件名
    mint "$wallet_json" "$images_dir" mint-nft "image/$filename" --satsbyte="$gas_fee" --funding="funding" --bitworkc="$bitworkc"

    # 其他处理逻辑
    echo "Processed image: $image"
  done
}

run $@
