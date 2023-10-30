#!/bin/bash


docker ps -q --filter 'status=running' | xargs -L 1 docker rm -f