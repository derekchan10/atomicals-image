#!/bin/sh

mint() {
  wallet=$1
  image_path=$2
  daemon=$3
  shift
  shift
  shift

  echo $@

  if [ "$daemon" -eq "1" ]; then
    param="-d"
  else
    param=""
  fi

  if [ -f "$wallet" ];
  then
    docker run -it $param --rm -v "$wallet":/wallet.json -v "$image_path":/app/image atomicals yarn cli "$@";
  else
    echo "wallet file $wallet not exit";
  fi;
}

gas_fee() {
  result=$(curl -s 'https://mempool.space/api/v1/fees/recommended?_1699895357798')
  fee=$(echo $result | jq -r '.fastestFee')
  echo $(echo "($fee + 16) / 2" | bc)
}

random_file () {
  # 获取所有文件名
  files=$(ls $1)

  # 计算文件总数
  count=$(echo "$files" | wc -l)

  # 生成一个随机数作为索引
  index=$(($RANDOM % $count + 1))

  # 使用awk获取随机行即文件名
  echo $(echo "$files" | awk -v idx=$index 'NR == idx {print $1}')
}

run () {
  wallet_json=$1
  images_dir=$2
  container=$3
  bitworkc=${4:-1000}
  satsoutput=${5:-546}
  daemon=${6:-1}

  echo "wallet:${wallet_json},image dir:${images_dir},container:${container},bitworkc:${bitworkc},satsoutput:${satsoutput},daemon=${daemon}"

  gas_fee=$(gas_fee)
  echo "gas_fee:${gas_fee}"

  # 随机获取图片的编号
  filename=$(random_file $images_dir)
  echo "file:"$filename

  # 调用命令,用$image传递文件名
  mint "$wallet_json" "$images_dir" "$daemon" mint-dmitem $container "$bitworkc"  "image/$filename" --satsbyte="$gas_fee" --funding="funding" --satsoutput="$satsoutput"

  # 其他处理逻辑
  echo "Processed image: $image"
}

core_count () {
  cores=0

  os=$(uname)

  if [ "$os" = "Darwin" ]; then
    # macOS
    cores=$(sysctl -n hw.ncpu)

  elif [ "$os" = "Linux" ]; then
    # Ubuntu/Debian
    cores=$(nproc --all)
  fi

  echo $cores
}

docker_count () {
  echo $(docker ps | grep atomicals -c)
}


start () {
  core_count=$1
  re='^[0-9]+$'
  if [[ $core_count =~ $re ]]; then
    shift
  else
    core_count=$(core_count)
  fi

  echo "core_count:"$core_count

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
}

start $@

