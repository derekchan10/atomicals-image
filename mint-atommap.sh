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

random_line () {
  file=$1
  lines=$(wc -l < $file)
  random=$(( $RANDOM % $lines + 1))
  echo $(sed -n "${random}p" $file)
}

run () {
  wallet_json=$1
  images_dir=$2
  gas_fee=${3:-1}
  bitworkc=${4:-0000}
  satsoutput=${5:-546}


  # 跳到atommap text文件夹，拉取git记录
  cd /root/blockchaintools
  git pull

  # 随机获取atommap text的编号
  line=$(random_line "/root/blockchaintools/tools/atommap.txt")

  # mint

  # 遍历文件
  filename=$(echo $line".atommap.svg")
  echo $filename

  # 调用命令,用$image传递文件名
  mint "$wallet_json" "$images_dir" mint-nft "image/$filename" --satsbyte="$gas_fee" --funding="funding" --bitworkc="$bitworkc" --satsoutput="$satsoutput"

  # 其他处理逻辑
  echo "Processed image: $image"
}


run $@
