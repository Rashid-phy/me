#!/bin/bash

echo ""
echo "************************************"
echo "*                                  *"
echo "*   Script by Dr. Rashid @ 2020    *"
echo "*                                  *" 
echo "************************************"
echo ""

VALUE_EC="0.00001"
VALUE_CC="0.0001"
ITERATION="500"


if [[ $1 == c ]]; then
	echo " "
	init_mbj_lapw
	echo " "
	exit
fi

echo "Converging values: ec = $VALUE_EC and cc = $VALUE_CC "
read -p "Do you want to continue? (y/n) " conCal
if [[ $conCal != y ]]; then exit; fi

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

