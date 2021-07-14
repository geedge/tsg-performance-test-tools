#!/bin/bash

if [ ! -n "$1" ] ;then
	echo "Please input pid !"
	exit 0
fi

rm -rf perf.data out.perf-folded result.svg

perf record -F 99 -p $1 -g -- sleep 10
perf script | FlameGraph-master/stackcollapse-perf.pl > out.perf-folded
FlameGraph-master/flamegraph.pl out.perf-folded > result.svg
