#!/bin/bash

echo ""
echo "************************************"
echo "*                                  *"
echo "*   Script by Dr. Rashid @ 20201    *"
echo "*                                  *" 
echo "************************************"
echo ""
echo "The script is free; you can redistribute it and/or modify it under the terms of the GNU General Public License. The script is distributed in the hope that it will be helpful, but WITHOUT ANY WARRANTY OF FITNESS FOR A PARTICULAR PURPOSE."
echo ""

cd $HOME
bashpath=".bashrc"
xnam="xcrysden"
aa=`which $xnam`

if [[ $aa == '' ]]; then
	echo "XCrySDen is not installed!"
	read -p "Do you like to install XCrySDen? (y/n) " userFEED
	if [[ $userFEED == y ]]; then
		sudo apt install $xnam
	else
		echo "Your system does not have XCrySDen. Try again."
		exit
	fi
	bb=`which $xnam`
	if [[ $bb == '' ]]; then
		echo "Your system does not have XCrySDen. Try again."
		exit
	else
		xpath=${bb%xcrysden}
	fi
else
	xpath=${aa%xcrysden}
fi

cat << EOF

Script has located XCrySDen in $xpath
Adding the pathe to the ~/.bashrc file ..

EOF

cp $bashpath ${bashpath}_back_$(date +%y.%m.%d_%R:%S)

cat >> $bashpath << EOF

#-----------------------------------------------------------------------------
# To include XCrySDen path in .bashrc file for WIEN2k
# Added by Dr. Rashid using XCrySDen_path_WIEN2k.sh script, $(date)
#-----------------------------------------------------------------------------
XCRYSDEN_TOPDIR=$xpath
XCRYSDEN_SCRATCH=/tmp
export XCRYSDEN_TOPDIR XCRYSDEN_SCRATCH
#-----------------------------------------------------------------------------

EOF

wCHK=`ps -C  w2web | grep w2web | gawk 'NR==1{print $4}'`
if [[ $wCHK == w2web ]]; then 
	killall w2web
fi

cat << EOF
Done!
Run the following commands in sequesnce: 
	1. source ~/.bashrc
	2. w2web

EOF


#### PATH="$XCRYSDEN_TOPDIR:$PATH:$XCRYSDEN_TOPDIR/scripts:$XCRYSDEN_TOPDIR/util"


