#!/bin/bash

source ./cli.sh

# 运行
run () {
  wallet_json=$1
  dir=$2
  container=$3
  daemon=${4:-1}
  gas_offset=${5:-0}
  gas_limit=${6:-0}
  gas_type=${7:-1}
  satsoutput=${8:-546}

  echo "wallet:${wallet_json},dir:${dir},container:${container},satsoutput:${satsoutput},daemon=${daemon}"

  fee=$(gas_fee)
  gas_fee=$((fee + gas_offset))
  echo "current fee:$fee,offset_fee:$gas_fee"

  if [ $gas_limit -gt 0 ]; then
    if [ "$gas_type" == "2" ]; then
      if [ $gas_fee -ge $gas_limit ]; then
        gas_fee=$gas_limit
      fi
    elif [ "$gas_type" == "3" ]; then
      gas_fee=$gas_limit
    else
      if [ $gas_fee -ge $gas_limit ]; then
        echo "gas too higher"
        sleep 3
        return 0
      fi

    fi

  fi

  echo "gas_fee:$gas_fee"

  # 随机获取图片的编号
  filename=$(random_file $dir)
  echo "file:$filename"

  item=$(basename "$filename" | sed 's/\.[^.]*$//' |  sed 's/item-//')
  echo "item:$item"

  # 检查是否有重复
  len=$(mint "$wallet_json" "$dir" "0" get-container-item "$container" "$item" | wc -c)
  echo "len:$len"

  if [ $len -gt 500 ]; then
    echo "$item minted"
    rm -rf $dir"/"$filename
    return 0
  else
    # 调用命令,用$image传递文件名
    mint "$wallet_json"  "$dir" "$daemon" mint-item "$container" "$item" "image/$filename" --satsbyte="$gas_fee" --funding="funding" --satsoutput="$satsoutput"
    return 1
  fi
}

source ./start.sh