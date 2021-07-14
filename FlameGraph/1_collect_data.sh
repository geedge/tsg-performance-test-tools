#!/bin/bash

if [ ! -n "$1" ]; then
	echo "Please input CPU ID !"
	exit 0
fi

# 执行后在当前目录下会生成采样数据 perf.data
rm -rf perf.data
perf record -e cpu-clock --call-graph dwarf -C $1 -- sleep 10
