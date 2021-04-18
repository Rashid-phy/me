#! /bin/bash

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

NUM='^[0-9]+$'
bashfile=$HOME/.bashrc
aa=`grep 'OMP_NUM_THREADS=' $bashfile | gawk '{print $2}'`
nMAX=`lscpu | grep -E '^CPU\(' | gawk '{print $2}'`

echo " $(lscpu | grep -E '^CPU\(')"
grep "model name" /proc/cpuinfo | tail -1 |  cut -c 13-
echo ""
echo "Current setting: $aa"
echo ""

if [[ $1 == c ]]; then exit; fi

read -p "How many threads do you like to use? (maximum $nMAX) " userFEED

if ! [[ $userFEED =~ $NUM ]]; then
   echo "Bad choice! Try again!!"
   echo ""
   exit
else
   if [[ $userFEED -gt $nMAX ]]; then
      echo "Only $nMAX threads are available! Try again!!"
      echo ""
      exit
   fi
   
   bb="OMP_NUM_THREADS=$userFEED"
   echo ""
   echo "Changed setting: $bb"
   sed -i "s/$aa/$bb/" $bashfile

   wCHK=`ps -C  w2web | grep w2web | gawk 'NR==1{print $4}'`
   if [[ $wCHK == w2web ]]; then 
   	killall w2web
   fi

cat << EOF

Run the following commands in sequesnce: 
	1. source ~/.bashrc
	2. w2web

EOF

fi

# For more sctipts visit https://tiny.cc/w2k​

