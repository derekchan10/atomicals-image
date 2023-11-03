#!/bin/sh

mint() {
  wallet=$1
  image_path=$2
  shift
  shift

  if [ -f "$wallet" ];
  then
    docker run -itd --rm -v "$wallet":/wallet.json -v "$image_path":/app/image atomicals yarn cli "$@";
  else
    echo "wallet file $wallet not exit";
  fi;
}

random_line () {
  file=$1
  lines=$(wc -l < $file)
  number=$(od -An -N2 -i /dev/random)
  random=$(($number % $lines + 1))
  echo $(sed -n "${random}p" $file)
}

run () {
  wallet_json=$1
  images_dir=$2
  satsoutput=${3:-546}

  # 跳到atommap text文件夹，拉取git记录
  cd /root/blockchaintools
  git pull

  # 随机获取atommap text的编号
  line=$(random_line "/root/blockchaintools/tools/atommap.txt")

  gas_fee=$(cat "/root/blockchaintools/tools/atom_cli_gas.txt")

  # mint

  # 遍历文件
  filename=$(echo $line".atommap.svg")
  bitworkc=$(echo "ab"$line)
  echo $filename

  # 调用命令,用$image传递文件名
  mint "$wallet_json" "$images_dir" mint-nft "image/$filename" --satsbyte="$gas_fee" --funding="funding" --bitworkc="$bitworkc" --satsoutput="$satsoutput"

  # 其他处理逻辑
  echo "Processed image: $image"
}

core_count () {
  echo $(nproc --all)
}

docker_count () {
  echo $(docker ps | grep atomicals -c)
}

core_count=$(core_count)
count=$(($core_count-6))

while true; do
  docker_count=$(docker_count)
  if [ $docker_count -lt $count ]; then
    run $@
    echo "mint start."
  else
    echo "current docker count :"$docker_count"-"$(date +%Y-%m-%d" "%H:%M:%S)
    sleep 3
  fi
done

