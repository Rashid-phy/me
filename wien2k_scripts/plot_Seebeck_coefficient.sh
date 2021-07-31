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
traceFILE=$NAME.trace2
seebeckFILE=$NAME.condtens

if [[ ! -s $traceFILE ]]; then
   echo ""
   echo "  *** $traceFILE file is not available! *** "
   echo ""
   exit
elif [[ ! -s $seebeckFILE ]]; then
   echo ""
   echo "  *** $seebeckFILE file is not available! *** "
   echo ""
   exit
fi

dataFILE=Seebeck.dat
sed '/^$/d' $traceFILE > tmp1
gawk 'NR>1 {print $1, "\t\t", $2, "\t\t", $5, "\t\t" }' tmp1 > tmp2
gawk 'NR>1 {print $13, "\t\t", $17, "\t\t", $21}' $seebeckFILE > tmp3

LineOne='# (E-Ef)[eV]         T[K]            S[V/K]                S\_xx[V/K]        S\_yy[V/K]         S\_zz[V/K]'
echo "$LineOne" > $dataFILE 
paste tmp2  tmp3 >> $dataFILE


gpltDEFINE=$HOME/.gnuplot
if [[ ! -s "$gpltDEFINE" ]]; then 
cat > $gpltDEFINE << EOF
set	linetype	1	linewidth	3	lc	rgb	"blue"		
set	linetype	2	linewidth	3	lc	rgb	"forest-green"	
set	linetype	3	linewidth	3	lc	rgb	"dark-violet"
set	linetype	4	linewidth	3	lc	rgb	"dark-orange"
set	linetype	5	linewidth	3	lc	rgb	"yellow"
set	linetype	6	linewidth	3	lc	rgb	"cyan"
set	linetype	7	linewidth	3	lc	rgb	"dark-red"		
set	linetype	8	linewidth	3	lc	rgb	"goldenrod"
set	linetype	cycle	9
EOF
fi
#SETeps='set term postscript eps enhanced color font "Times-Roman, 20" '
#SETpng='set term png enhanced size 1000,800 font "Times-Roman, 20"'

cat > tmp4 <<EOF
set terminal postscript eps enhanced color font 'Helvetica,14'
set output "Seebeck.ps"
set xrange [:]
set yrange [:]
set xlabel "The chemical potential ({/Symbol m }- {/Symbol e }_F) [eV]"
set ylabel " Seebeck coefficient S [VK^{-1}]"
set xzeroaxis
set yzeroaxis

EOF

cat > tmp4x <<EOF
set terminal postscript eps enhanced color font 'Helvetica,14'
set output "Seebeck_xx.ps"
set xrange [:]
set yrange [:]
set xlabel "The chemical potential ({/Symbol m }- {/Symbol e }_F) [eV]"
set ylabel " S^{(xx)} [VK^{-1}]"
set xzeroaxis
set yzeroaxis

EOF

cat > tmp4y <<EOF
set terminal postscript eps enhanced color font 'Helvetica,14'
set output "Seebeck_yy.ps"
set xrange [:]
set yrange [:]
set xlabel "The chemical potential ({/Symbol m }- {/Symbol e }_F) [eV]"
set ylabel " S^{(yy)} [VK^{-1}]"
set xzeroaxis
set yzeroaxis

EOF

cat > tmp4z <<EOF
set terminal postscript eps enhanced color font 'Helvetica,14'
set output "Seebeck_zz.ps"
set xrange [:]
set yrange [:]
set xlabel "The chemical potential ({/Symbol m }- {/Symbol e }_F) [eV]"
set ylabel " S^{(zz)} [VK^{-1}]"
set xzeroaxis
set yzeroaxis

EOF

echo "" > tmp5
echo "" > tmp5x
echo "" > tmp5y
echo "" > tmp5z


T1=`gawk  'NR==1 {print $2}' tmp2 | cut -c1-4 | bc `
T2=`gawk  'NR==2 {print $2}' tmp2 | cut -c1-4 | bc `
Tmax=`gawk  '{print $2}' tmp2 | cut -c1-4 | bc | tail -n 1`
Tstep=`echo "$T2 - $T1" | bc `


temp=$T1
for j in {1..50}; do
   echo "$LineOne" > TT_$temp
   gawk '$2+0=='$temp'' $dataFILE | gawk '/# Phase/{print ""; print ""} {print}' >> TT_$temp
#   echo $temp
#   cat TT_$temp | wc -l

   echo "plot 'TT_$temp' u 1:3 w l  title 'T = $temp K' "  >> tmp5
   echo "plot 'TT_$temp' u 1:4 w l  title 'T = $temp K' "  >> tmp5x
   echo "plot 'TT_$temp' u 1:5 w l  title 'T = $temp K' "  >> tmp5y
   echo "plot 'TT_$temp' u 1:6 w l  title 'T = $temp K' "  >> tmp5z

   if [[ $temp == $Tmax ]]; then break; fi
   
   if [[ $j == 1 ]]; then
      echo "plot 'TT_$temp' u 1:3 w l  title 'T = $temp K' , \\"  >> tmp4
      echo "plot 'TT_$temp' u 1:4 w l  title 'T = $temp K' , \\"  >> tmp4x
      echo "plot 'TT_$temp' u 1:5 w l  title 'T = $temp K' , \\"  >> tmp4y
      echo "plot 'TT_$temp' u 1:6 w l  title 'T = $temp K' , \\"  >> tmp4z
   else
      echo "     'TT_$temp' u 1:3 w l  title 'T = $temp K' , \\"  >> tmp4
      echo "     'TT_$temp' u 1:4 w l  title 'T = $temp K' , \\"  >> tmp4x
      echo "     'TT_$temp' u 1:5 w l  title 'T = $temp K' , \\"  >> tmp4y
      echo "     'TT_$temp' u 1:6 w l  title 'T = $temp K' , \\"  >> tmp4z
   fi   

   temp=`echo "$temp + $Tstep" | bc `

done
      echo "     'TT_$temp' u 1:3 w l  title 'T = $temp K' "  >> tmp4
      echo "     'TT_$temp' u 1:4 w l  title 'T = $temp K' "  >> tmp4x
      echo "     'TT_$temp' u 1:5 w l  title 'T = $temp K' "  >> tmp4y
      echo "     'TT_$temp' u 1:6 w l  title 'T = $temp K' "  >> tmp4z

cat tmp4  tmp5  > tmp6
cat tmp4x tmp5x > tmp6x
cat tmp4y tmp5y > tmp6y
cat tmp4z tmp5z > tmp6z

gnuplot tmp6
gnuplot tmp6x
gnuplot tmp6y
gnuplot tmp6z


CHK=`ls ENF_* 2> /dev/null | wc -l`
if [[ $CHK != 0 ]]; then
echo "***************************************************"
echo "   list of files: chemical potential is constant "
echo "***************************************************"
echo
ls -1 ENF_* 
echo
fi


CHK=`ls T_* 2> /dev/null | wc -l`
if [[ $CHK != 0 ]]; then
echo "***************************************************"
echo "   list of files: Temperature is constant "
echo "***************************************************"
echo
ls -1 T_* 
echo
fi
 
CHK=`ls *.ps | grep -v Seebeck 2> /dev/null | wc -l`
if [[ $CHK != 0 ]]; then
echo "***************************************************"
echo "   list of .ps files "
echo "***************************************************"
echo
ls -1 *.ps | grep -v Seebeck
echo
fi

echo "*******************************************"
echo "   list of files: Seebeck coefficient "
echo "*******************************************"
echo
ls -1 Seebeck*
echo
ls -1 TT_*

rm tmp1 tmp2 tmp3 tmp4* tmp5* tmp6* 

saveDIR=Result.BoltzTraP
if [[ -d $saveDIR ]]; then
	rm -f $saveDIR/*
else
   mkdir $saveDIR
fi

cp  $dataFILE $saveDIR
for i in bt2 btj   condtens   dope.condtens   dope.halltens   dope.trace     halltens     trace   trace2 ; do
   if [[ ! -z $NAME.$i && -e $NAME.$i ]]; then 
      cp $NAME.$i  $saveDIR
   fi
done

for ii in *.ps T_* TT_* ENF_* ; do
   if [[ ! -z $ii && -e $ii ]]; then 
      mv $ii  $saveDIR
   fi
done

echo
echo "*******************************************************"
echo "  All the above files are saved in $saveDIR "
echo "*******************************************************"
echo

# For more sctipts visit https://tiny.cc/w2k​

