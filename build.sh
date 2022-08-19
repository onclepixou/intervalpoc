#! /bin/bash

rm *.o
rm *.cf

echo "Analysing interval_pkg"
ghdl -a --std=08 interval_pkg.vhd

echo "Analysing iadder"
ghdl -a --std=08 iadder.vhd

echo "Analysing isqr"
ghdl -a --std=08 isqr.vhd

echo "Analysing isqrt"
ghdl -a --std=08 isqrt.vhd

echo "Analysing fwdadd"
ghdl -a --std=08 fwdadd.vhd

echo "Analysing bwdadd"
ghdl -a --std=08 bwdadd.vhd

echo "Analysing fwdsqr"
ghdl -a --std=08 fwdsqr.vhd

echo "Analysing bwdsqr"
ghdl -a --std=08 bwdsqr.vhd

echo "Analysing union2"
ghdl -a --std=08 intersect2.vhd

echo "Analysing intersect2"
ghdl -a --std=08 intersect2.vhd

echo "Analysing intersectn"
ghdl -a --std=08 intersectn.vhd

echo "Analysing controller"
ghdl -a --std=08 controller.vhd

#echo "Analysing varupdater"
#ghdl -a --std=08 varupdater.vhd