#!/bin/sh

prefix=$1
start=$2
end=$3
suffix=$4
output=$5

rm -rf $output

for i in $(seq $start $end)
do
  # 生成文件名
  filename=$(printf "%04d.$suffix" $i)

  # 输出完整URL
  echo "$prefix$filename" >> $output

  # 也可以直接输出文件名
  # echo $filename

done