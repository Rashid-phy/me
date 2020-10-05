#!/bin/bash

echo ""
echo "************************************"
echo "*                                  *"
echo "*   Script by Dr. Rashid @ 2020    *"
echo "*                                  *" 
echo "************************************"
echo ""
echo "The script is free; you can redistribute it and/or modify it under the terms of the GNU General Public License. The script is distributed in the hope that it will be helpful, but WITHOUT ANY WARRANTY OF FITNESS FOR A PARTICULAR PURPOSE."
echo ""

NAME=${PWD##*/}

if [[ $# -gt 0 && $1 != s ]]; then
	DIR=$1
	SCF=$1
	SCF=${SCF%.scf}
	SCF=${SCF%.s}
	SCF=${SCF%.}
	SCF=${SCF}.scf
	if [[ -d "$DIR" ]]; then
		cd $DIR
		SCF=''
	elif [[ -f "$SCF" ]]; then
		NAME=${SCF%.scf}
	else
		echo "Neither directory '$DIR' nor file '$SCF' is available!"
		echo ""
		exit
	fi
fi

aa=`ls *.scf 2>/dev/null | wc -l`

if [[ $SCF == '' && $aa -eq 1 ]]; then
   SCF=`ls *.scf`

elif [[ $SCF == '' && $aa -gt 1 ]]; then
	echo "There are several SCF files."
	echo ""
	ls -lhtr *.scf
	echo ""
	read -p "Choose one (name with extention): " SCF
	SCF=${SCF%.scf}
	SCF=${SCF%.s}
	SCF=${SCF%.}
	SCF=${SCF}.scf

fi   


NAME=${SCF%.scf}

if [[ $SCF == '' ]]; then
	echo "----> SCF file is not found."
	echo ""
	exit
elif [[ -s "$SCF" ]]; then
	echo "$(pwd)/$SCF is selected."
	echo ""
elif [[ ! -s "$SCF" ]]; then
	echo "----> $SCF is NOT available or has NO date in it."
	echo ""
	exit
fi


grep ':ENE' $SCF | gawk '{print $9}' > aa
echo "stop" >> aa
echo "#Itaration        Energy" > bb

for i in {1..1000}; do
   ENE=`gawk -v j=$i "NR==j" aa`
   if [[ $ENE == stop ]]; then
      break
   else
      printf "$i \t\t $ENE \n" >> bb
   fi
done


cat > gplot.gnu << EOF
set linetype    2   linewidth	4   pt 2   lc rgb 'red' 

set term png enhanced size 1000,800 font "Times-Roman, 20
set output "${NAME}_E_con.png"
set xlabel "Number of iteration"
set ylabel "Total Energy (Ry)"

set multiplot
plot   "bb" using 1:2 notitle w l
replot "bb" using 1:2 notitle  

unset multiplot

set term postscript eps enhanced color font "Times-Roman, 20"
set output "${NAME}_E_con.eps"
replot

EOF

gnuplot < gplot.gnu

cat bb
rm aa bb gplot.gnu

if [[ $1 != s && $2 != s ]]; then 
   xdg-open ${NAME}_E_con.png
fi

echo ""
echo "${NAME}_E_con.png and ${NAME}_E_con.eps are created"
echo ""
   

