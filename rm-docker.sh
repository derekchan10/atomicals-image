#!/bin/bash

while true; do
  sleep 600
  docker ps -q --filter 'status=running' | xargs -L 1 docker rm -f
done

