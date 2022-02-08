#!/bin/sh
apt install make git python3 gtkwave gcc g++ bison flex gperf autoconf
git clone -b v11_0 --depth=1 https://gitee.com/xiaowuzxc/iverilog/
cd iverilog
sh autoconf.sh
./configure
make
sudo make install
cd ..
rm -rf iverilog/
