#!/bin/bash

echo ""
echo "************************************"
echo "*                                  *"
echo "*   Script by Dr. Rashid @ 2020    *"
echo "*                                  *" 
echo "************************************"
echo ""

#NAME=${PWD##*/}  
#SCF=$NAME.scf

if [[ $# -gt 0 ]]; then
	DIR=$1
	SCF=$1
	SCF=${SCF%.scf}
	SCF=${SCF%.s}
	SCF=${SCF%.}
	SCF=${SCF}.scf
	if [[ -d "$DIR" ]]; then
		cd $DIR
		SCF=''
#		pwd

#	elif [[ -f "$DIR" ]]; then
#		SCF=$DIR
#		SCF=${SCF%.scf}
#		SCF=${SCF%.}
#		NAME=$SCF
#		SCF=$NAME.scf

	elif [[ -f "$SCF" ]]; then
		NAME=${SCF%.scf}
	else
		echo "Neither directory '$DIR' nor file '$SCF' is available!"
		echo "Use 'h' to get the details about options."
		echo ""
		exit
	fi
fi



aa=`ls *.scf 2>/dev/null | wc -l`

if [[ $SCF == '' && $aa -gt 1 ]]; then
	echo "There are several SCF files."
	echo ""
	ls -lhtr *.scf
	echo ""
	read -p "Choose one (name with extention): " SCF
	SCF=${SCF%.scf}
	SCF=${SCF%.s}
	SCF=${SCF%.}
	SCF=${SCF}.scf
elif [[ $SCF == '' && $aa -eq 1 ]]; then
	SCF=`ls *.scf 2>/dev/null`
fi

#	echo "----> $SCF "

NAME=${SCF%.scf}

if [[ $SCF == '' ]]; then
	echo "----> SCF file is not found."
	echo ""
	exit
elif [[ -s "$SCF" ]]; then
	echo "----> $(pwd)/$SCF is selected."
elif [[ ! -s "$SCF" ]]; then
	echo "----> $SCF is NOT available or has NO date in it."
#	echo " ***** Make sure you are in right directory. *****"
	echo ""
	exit
fi

echo " "

if [[ -f "$NAME.klist" ]]; then
	currentKmesh=`gawk 'NR==1 {print $9, $10, $11, $12 $13, $14, $15}' $NAME.klist`
	echo "k-mesh details are : $currentKmesh"
else
	echo "$NAME.klist is not available"
fi

echo " "
grep ':GAP (this spin):' $SCF | tail -n 2
grep ':GAP (global)   :' $SCF | tail -n 1
echo " "
grep :ENE $SCF | tail -n 1
echo " "
grep 'F E R M I' $SCF | tail -n 1
echo " "
grep ':LABEL4:' $SCF | tail -n 1
echo " "
#echo "---> ec == energy convergence"
#echo "---> cc == charge convergence "
#echo " "

numATOM=`grep ':MMI' $SCF | tail -n 1 | gawk '{print $6}'`

if [[ $numATOM != '' ]]; then
	grep ':MMT' $SCF | tail -n 1
	echo " "
	grep ':MMI' $SCF | tail -n $(($numATOM +1 ))
	echo " "
#	grep ':HFF' $SCF | tail -n 3
#	echo " "
fi


ab=`grep :ENE $SCF | tail -n 1 | gawk '{print $3}'`
if [[ $ab == '*WARNING**' ]]; then
	grep :WAR $SCF | tail -n 5
	echo ""
#	echo "Use 'grwa' to view all the warnings."
#	echo ""
fi


