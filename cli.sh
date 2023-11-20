mint() {
  wallet=$1
  shift

  image_path=$1
  if [[ $image_path == *"image"* ]]; then
    shift
    volume="-v ${image_path}:/app/image"
    daemon=$1
    shift
  else
    volume=""
    daemon=$1
    shift
  fi

  echo $@

  if [ "$daemon" -eq "1" ]; then
    param="-d"
  else
    param=""
  fi

  if [ -f "$wallet" ];
  then
    docker run -it $param --rm -v "$wallet":/wallet.json ${volume} atomicals yarn cli "$@";
  else
    echo "wallet file $wallet not exit";
  fi;
}

file_time() {
  # 指定要检查的文件
  file=$1
  os=$(uname)
  if [ "$os" = "Darwin" ]; then
    # macOS
    modified=$(stat -f "%m" "$file")
  elif [ "$os" = "Linux" ]; then
    # Ubuntu/Debian
    modified=$(stat -c %Y "$file")
  fi

  now=$(date +%s)

  echo $((now - modified))
}

set_value() {
  file=$1
  val=$2
  echo "$val" > "$file"
}

get_value() {
  echo $(cat $1)
}

gas_fee() {
  result=$(curl -s 'https://mempool.space/api/v1/fees/recommended?_1699895357798')
  fee=$(echo $result | jq -r '.fastestFee')

  gas_file="./gas.txt"
  gas_offset_file="./gas_offset.txt"
  prev_fee=$(get_value "$gas_file")
  gas_offset=$(get_value "$gas_offset_file")

  if [ -z "$prev_fee" ]; then
    set_value "$gas_file" "$fee"
    set_value "$gas_offset_file" "0"
  else
    file_second=$(file_time "$gas_file")
    if [ $file_second -ge 30 ]; then
      if [ $fee -ge $prev_fee ]; then
        gas_offset=$((fee - prev_fee))
        set_value "$gas_file" "$fee"
        set_value "$gas_offset_file" "$gas_offset"
      else
        gas_offset=0
        set_value "$gas_file" "$fee"
        set_value "$gas_offset_file" "$gas_offset"
      fi
    fi
  fi

  echo $(echo "($fee + $gas_offset) / 1.8" | bc)
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

