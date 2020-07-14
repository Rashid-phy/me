#!/bin/bash

echo ""
echo "************************************"
echo "*                                  *"
echo "*   Copyright © 2020 Dr Rashid     *"
echo "*  WIEN2k tutorials: tiny.cc/w2k   *" 
echo "*                                  *" 
echo "************************************"
echo ""

## Change the following values if you need so!
## If you are not sure, leave them as they are!!
VALUE_EC="0.00001"
VALUE_CC="0.0001"

## This is the maximum SCF cycle value. 
## Usually SCF calculation finishes way before this.
ITERATION="500"


echo "Default converging values: ec = $VALUE_EC and cc = $VALUE_CC "
read -p "Do you want to continue with these values? (y/n) " conCal
if [[ $conCal != y ]]; then
	echo ""
	echo "Change default values in the script then run agian." 
	echo ""
	exit 
fi

rm -f *.broy* STDOUT
echo ""
read -p "Perform spin-polarized calculation? (y/n) " userFEED

if [[ $userFEED == y ]]; then
	echo " "
	init_mbj_lapw
	echo " "
	runsp_lapw -i 1 -NI
	echo " "
	init_mbj_lapw
	echo " "
	runsp_lapw -i $ITERATION -ec $VALUE_EC -cc $VALUE_CC -NI |& tee -a STDOUT
	echo " "
elif [[ $userFEED == n ]]; then
	echo " "
	init_mbj_lapw
	echo " "
	run_lapw -i 1 -NI
	echo " "
	init_mbj_lapw
	echo " "
	run_lapw -i $ITERATION -ec $VALUE_EC -cc $VALUE_CC -NI |& tee -a STDOUT
	echo " "
else
	echo "Wrong input!!!! Try again!!!!!"
fi

