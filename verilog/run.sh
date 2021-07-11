#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )"

mkdir -p build-tb
cd build-tb

for N in 16 24 32 48 64 96 128; do

	echo "Compiling xormix${N}_tb ..."
	iverilog -o xormix${N}_tb ../rtl/xormix${N}.v ../tb/xormix${N}_tb.v

	echo "Running xormix${N}_tb ..."
	vvp xormix${N}_tb

done
