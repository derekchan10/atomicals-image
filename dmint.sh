#!/bin/sh

mint() {
  wallet=$1
  image_path=$2
  shift
  shift

  echo $@

  if [ -f "$wallet" ];
  then
    docker run -it --rm -v "$wallet":/wallet.json -v "$image_path":/app/image atomicals yarn cli "$@";
  else
    echo "wallet file $wallet not exit";
  fi;
}

gas_fee() {
  result=$(curl -s 'https://mempool.space/api/v1/fees/recommended?_1699895357798')
  fee=$(echo $result | jq -r '.fastestFee')
  echo $(echo "($fee + 1) / 2" | bc)
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
  container=$3
  bitworkc=${4:-1000}
  satsoutput=${5:-546}

  echo "wallet:${wallet_json},image dir:${images_dir},container:${container},bitworkc:{$bitworkc},satsoutput:{$satsoutput}"


  gas_fee=$(gas_fee)
  echo "gas_fee:${gas_fee}"

  # 随机获取图片的编号
  filename=$(random_line `pwd`"/image.txt")
  echo $filename

  # 调用命令,用$image传递文件名
  mint "$wallet_json" "$images_dir" mint-dmitem $container "$bitworkc"  "image/$filename" --satsbyte="$gas_fee" --funding="funding" --satsoutput="$satsoutput"

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

if [ $core_count -lt 8 ]; then
  count=$(($core_count/2))
else
  count=$(($core_count-4))
fi

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

