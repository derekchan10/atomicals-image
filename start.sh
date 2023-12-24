#!/bin/sh

# 开始运行
start () {
  container_count=$1
  re='^[0-9]+$'
  if [[ $container_count =~ $re ]]; then
    shift
  else
    core_count=$(core_count)
    container_count=$(($core_count/2))
  fi

  echo "container_count:"$container_count

  mint_count=$1
  if [[ $mint_count =~ $re ]]; then
    shift
  else
    mint_count=9999
  fi

  i=0
  while true; do
    echo "current mint count: $i"
    if [ $i -ge $mint_count ]; then
      echo "mint count complete"
      exit
    fi

    docker_count=$(docker_count)
    if [ $docker_count -lt $container_count ]; then
      run $@
      res="$?"
      if [ $res -eq "1" ]; then
        i=$((i + 1))
      fi

      echo "mint start."
    else
      echo "current docker count :"$docker_count"-"$(date +%Y-%m-%d" "%H:%M:%S)
      sleep 3
    fi
  done
}

start $@