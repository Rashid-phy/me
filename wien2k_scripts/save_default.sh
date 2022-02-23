#!/bin/bash

echo ""
echo "************************************"
echo "*                                  *"
echo "*   Copyright © 2020 Dr Rashid     *"
echo "*  WIEN2k tutorials: tiny.cc/w2k   *" 
echo "*                                  *" 
echo "************************************"
echo ""
echo "The script is free; you can redistribute it and/or modify it under the terms of the GNU General Public License. The script is distributed in the hope that it will be helpful, but WITHOUT ANY WARRANTY OF FITNESS FOR A PARTICULAR PURPOSE."
echo ""

#sudo apt-get install zip
NAME=${PWD##*/}
SCF=$NAME.scf

if [[ ! -f "$SCF" ]]; then
	echo "scf file is missing!! Run SCF first!!!"
	echo ''
	exit 1
fi

if [[ $# -eq 0 ]]; then
	read -p "Give the folder name to save files: " saveDIR
	echo " "
else
	saveDIR=$1
fi

if [[ -d "$saveDIR" ]]; then
	echo "A folder named '$saveDIR' already exits!"
	echo "Try again with a different name or delete the folder first!!"
	exit
fi


save_lapw -nodel -s -d $saveDIR
if [[ ! -s $SCF ]]; then
   cp $saveDIR/$SCF .
fi


if [[ -s STDOUT ]]; then
	cp  STDOUT $saveDIR
fi

if [[ -s $NAME.dayfile ]]; then
	cp  $NAME.dayfile  $saveDIR
fi

if [[ -s $NAME.klist_band ]]; then
	cp  $NAME.klist_band  $saveDIR
fi

if [[ -s $NAME.outputd ]]; then
	cp  $NAME.outputd  $saveDIR
fi

cp ':log' $saveDIR/$NAME.tlogf

rm -f *.vector*  *.energy* *.broyd*

du -sh $saveDIR
echo " "
echo "$(date +%R:%S) Files are saved in '$saveDIR' folder."

echo " "
read -p "Do you like to compress '$saveDIR'? (y/n) " compressDIR

if [[ $compressDIR == y ]]; then
#	tarNAME=$NAME.$saveDIR.tar.gz
#	tarNAME=$NAME.$saveDIR.zip
	tarNAME=${NAME}_${saveDIR}.zip
	if [[ -f $tarNAME ]]; then
		rm $tarNAME
	fi
#	tar -cf $tarNAME $saveDIR
	zip -rq $tarNAME $saveDIR
	echo " "
	du -sh $saveDIR
	du -sh $tarNAME
	echo " "
	echo "$(date +%R:%S) A tape achieve named $tarNAME is created."
fi

