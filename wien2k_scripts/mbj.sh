#!/bin/bash

echo ""
echo "************************************"
echo "*                                  *"
echo "*   Copyright © 2021 Dr Rashid     *"
echo "*  WIEN2k tutorials: tiny.cc/w2k   *" 
echo "*                                  *" 
echo "************************************"
echo ""
echo "The script is free; you can redistribute it and/or modify it under the terms of the GNU General Public License. The script is distributed in the hope that it will be helpful, but WITHOUT ANY WARRANTY OF FITNESS FOR A PARTICULAR PURPOSE."
echo ""

NAME=${PWD##*/}
NUM='^[0-9]+([.][0-9]+)?$'
VALUE_EC="0.00001"
VALUE_CC="0.0001"
ITERATION="500"


if [[ -f $NAME.scf ]]; then 
   echo "  *** You have results from previous calculation. ***"
   echo "If you continue that will be lost and can't be undone."
   read -p "Did you save the results (y/n): " userFEED

   if [[ $userFEED != y ]]; then

cat << EOF

To save the results in a folder run 
  save_lapw -s -d FOLDER_NAME

or you may use the save_default.sh 
sctipt available at https://tiny.cc/w2k​

EOF
   exit
   else
      echo ""
   fi
fi 


echo "   Converging values are: "
echo "     ec = $VALUE_EC"
echo "     cc = $VALUE_CC"

read -p "Do you like to continue? (y/n) " conCal
if [[ $conCal != y ]]; then 

	read -p "Enter the value of ec: " VALUE_EC
	if ! [[ $VALUE_EC =~ $NUM ]]; then
		echo " Number only! Try again!!"
		exit
	fi

	read -p "Enter the value of cc: " VALUE_CC
	if ! [[ $VALUE_CC =~ $NUM ]]; then
		echo " Number only! Try again!!"
		exit
	fi

fi

stringCONV="-ec $VALUE_EC -cc $VALUE_CC"

echo "" 
if [[ -s "$NAME.clmup" && -s "$NAME.clmdn" ]]; then
	echo "** Spin-polarization calculation is selected. **"
	spinCAL=y
elif [[ -f "$NAME.clmsum" ]]; then
	echo "** Spin-polarization calculation is NOT selected. **"
	spinCAL=n
else
	echo "  $NAME.clm* files are not found."
	echo "You may need to initialize properly."
	echo "" 
	exit
fi

read -p "Press ENTER to continue " userFEED
if [[ $userFEED != '' ]]; then
	echo "Wrong input!! Try again!!!"
	echo ""
	exit
fi

if [[ $spinCAL == y ]]; then
	srtingLAPW=runsp_lapw
elif [[ $spinCAL == n ]]; then
	srtingLAPW=run_lapw
fi

rm -fv $NAME.broy* STDOUT $NAME.scf* $NAME.vector* $NAME.insp
TTT=`date`

echo " "
init_mbj_lapw |& tee -a STDOUT

echo " "
$srtingLAPW -i 1 -NI |& tee -a STDOUT

echo " "
init_mbj_lapw |& tee -a STDOUT

echo " "
$srtingLAPW -i $ITERATION $stringCONV -NI |& tee -a STDOUT

cat << EOF

Calculation started on  $TTT
Calculation finished on $(date)

To save the results in a folder run 
 save_lapw -nodel -s -d FOLDER_NAME

or you may use the save_default.sh 
sctipt available at https://tiny.cc/w2k​

EOF



