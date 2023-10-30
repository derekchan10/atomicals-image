#!/bin/bash

while true; do
  sleep 14400
  docker ps -q --filter 'status=running' | xargs -L 1 docker rm -f
done

