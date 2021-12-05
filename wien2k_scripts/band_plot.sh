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

## To plot custom band using the default agr file


NAME=${PWD##*/}
saveDIR=Result.band


function WCTAfunction () {
   file=$1
   if [[ ! -s $file.agr ]]; then
      echo ""
      echo "$file.agr" is not available! Try again!!
      echo ""
      exit
   fi

   Nfile=${file}_N
   gawk 'NR<3' $file.agr > $Nfile.agr

   LcS=2.125

cat >> $Nfile.agr << EOF

 @ default linewidth 6.0

 @ xaxis  tick linewidth 3
 @ xaxis  label char size $LcS
 @ xaxis  ticklabel char size 2.0

 @ yaxis  tick linewidth 4
 @ yaxis  label char size $LcS
 @ yaxis  ticklabel char size 2.0

 @    frame linewidth 3.0
 @ title size 1.750000

EOF

   aa=`grep -n 'line linestyle 3' $file.agr | cut -c1-2`
   gawk -v jj=$aa 'NR==8,NR==jj' $file.agr >> $Nfile.agr
   printf "\n @ line linewidth 3.0\n\n" >> $Nfile.agr
   gawk -v jj=$aa 'NR>jj' $file.agr >> $Nfile.agr
   sed -i "s/@ title /#@ subtitle /g" $Nfile.agr
   sed -i "s/string char size 1.5/string char size $LcS/g" $Nfile.agr

   grace $Nfile.agr -hdevice PNG -hardcopy -printfile $Nfile.png 
   grace $Nfile.agr -hdevice EPS -hardcopy -printfile $Nfile.eps

   rm $Nfile.agr
   echo ""

   ls --color=auto -lh $file.agr
   ls --color=auto -lh $Nfile.*
   echo ""
   xdg-open $Nfile.png
}



if [[ -s $NAME.bands.agr ]]; then
   WCTAfunction "$NAME.bands"


elif [[ -s $NAME.bandsdn.agr && -s $NAME.bandsup.agr ]]; then
   WCTAfunction "$NAME.bandsdn"
   sleep 3
   WCTAfunction "$NAME.bandsup"


elif [[ -s $NAME.bandsdn.agr ]]; then
   WCTAfunction "$NAME.bandsdn"


elif [[ -s $NAME.bandsup.agr ]]; then
   WCTAfunction "$NAME.bandsup"


else
   echo "No agr file is available! Calculate the band structure first!!"
   echo ''
   exit
fi


if [[ -d $saveDIR ]]; then
	rm $saveDIR/*
else
   mkdir $saveDIR
fi


save_lapw -s -band -d $saveDIR
cp $NAME.bands*.agr $NAME.bands*.png $NAME.bands*.eps $saveDIR/  2> /dev/null


echo " "
echo "Done! Results are saved in $saveDIR folder."
echo " "


