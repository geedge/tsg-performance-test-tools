#!/bin/bash

if [ ! -f "perf.data" ]; then
	echo "Please Collect data !"
	exit 0
fi

if [ ! -d FlameGraph ]; then
	echo "git clone https://github.com/brendangregg/FlameGraph.git"
	git clone https://github.com/brendangregg/FlameGraph.git
fi

rm -rf perf.unfold
rm -rf perf.folded
rm -rf perf.svg

# 用 perf script 工具对 perf.data 进行解析
perf script -i perf.data &> perf.unfold

# 将 perf.unfold 中的符号进行折叠
./FlameGraph/stackcollapse-perf.pl perf.unfold &> perf.folded

# 生成 svg 图
./FlameGraph/flamegraph.pl perf.folded > perf.svg

# 使用浏览器查看 perf.svg, 在浏览器中使用 Ctrl + F 进行关键字搜索
