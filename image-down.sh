#!/bin/sh

# 获取参数
url_file=$1
images_dir=$2

mkdir -p $images_dir

# 检查参数
if [ -z "$images_dir" ] || [ -z "$url_file" ]; then
  echo "Usage: $0 <images_dir> <url_file>"
  exit 1
fi

# 创建图片目录
mkdir -p $images_dir

# 循环读取URL下载图片
while read line; do
  filename=$(echo $line | awk -F'/' '{print $NF}')
  save_path=$images_dir/$filename
  curl -o "$save_path" "$line"

  echo "Saved image: $line"

done < $url_file