#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )"

mkdir -p build-tb
cd build-tb

for N in 16 24 32 48 64 96 128; do

	echo "Compiling xormix${N}_tb ..."
	ghdl -a --work=unisim ../rtl/unisim_stubs.vhd
	ghdl -a ../rtl/xormix${N}_x7s.vhd ../tb/xormix${N}_tb.vhd
	ghdl -e xormix${N}_tb

	echo "Running xormix${N}_tb ..."
	./xormix${N}_tb

done
