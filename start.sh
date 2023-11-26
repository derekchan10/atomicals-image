#!/bin/sh

# 开始运行
start () {
  count=$1
  re='^[0-9]+$'
  if [[ $count =~ $re ]]; then
    shift
  else
    core_count=$(core_count)
    if [ $core_count -lt 8 ]; then
      count=$(($core_count/2))
    else
      count=$(($core_count-4))
    fi
  fi

  echo "core_count:"$count

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