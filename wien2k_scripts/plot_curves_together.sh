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

NUM='^[0-9]+$'
plotSTR='plot'
flist=/tmp/files.txt

read -p "How many lines/curves do you like to plot? " pNUM
if ! [[ $pNUM =~ $NUM ]] ; then
   echo "Error: Not a valid number!" >&2; exit 1
fi

echo ""
ls -p | grep -vE '\\|eps|png|jpg|jpeg|pdf|klist|kgen|injoint|inop' > $flist
cat -n $flist

####################################################
for ii in {1..99} ; do

echo ""
read -p "$ii. Enter the file name or the sirial number: " fNUM
if [[ $fNUM == '' ]]; then 
   echo "Error: Not a valid input!" >&2; exit 1
elif [[ $fNUM =~ $NUM ]] ; then
   fnam=`gawk -v jj=$fNUM 'NR==jj' $flist`
else
   fnam=$fNUM
fi

if [[ ! -s $fnam ]]; then
   echo "Error: $fnam does not exit or has no data in it!" >&2; exit 1
else
   echo "Selected file name: $fnam"
fi

echo "----------------------------------------------------------------------------------------"
head -10 $fnam
echo "----------------------------------------------------------------------------------------"
echo ""

read -p "Enter the column number: " cNUM
if ! [[ $cNUM =~ $NUM ]] ; then
   echo "Error: Not a valid number!" >&2; exit 1
fi

read -p "     Title of the graph: " userFEED
if [[ $userFEED == '' ]]; then
   gtitle=notitle
else
   gtitle="title '$userFEED'"
fi
echo ""

plotSTR="$plotSTR '$fnam' u 1:$cNUM w l $gtitle"

if [[ $ii == $pNUM ]]; then 
   break
else
   plotSTR="$plotSTR, "
fi
done
####################################################

clear
echo $plotSTR
echo ""
gnuplot -p -e "$plotSTR"
read -p "Do you like to save the graph? (y/n) " userFEED
if [[ $userFEED != 'y' ]]; then
   killall gnuplot_qt
   exit
fi

echo ""
read -p "Provide the file name: " userFEED
if [[ $userFEED == '' ]]; then
   savenam=graph
else
   savenam=`echo ${userFEED// /_}`
fi


echo ""
read -p "Set a title for the plot: " userFEED
if [[ $userFEED == '' ]]; then
   ptitle=''
else
   ptitle="set title '$userFEED'"
fi
read -p "Set the label for x-axis: " userFEED
if [[ $userFEED == '' ]]; then
   pxlabel=''
else
   pxlabel="set xlabel '$userFEED'"
fi
read -p "Set the label for y-axis: " userFEED
if [[ $userFEED == '' ]]; then
   pylabel=''
else
   pylabel="set ylabel '$userFEED'"
fi


echo ""
read -p "Do you like to set a x-range? (y/n)  " userFEED
if [[ $userFEED == 'y' ]]; then
   read -p "     Minimum x-value: " xmin
   read -p "     Maximum x-value: " xmax
   pxrange="set xrange [$xmin:$xmax] noextend"
#   pxrange="set xrange [$xmin<*:*<$xmax] noextend"
else
   pxrange='set xrange [:] noextend'
fi


echo ""
read -p "Do you like to set a y-range? (y/n)  " userFEED
if [[ $userFEED == 'y' ]]; then
   read -p "     Minimum y-value: " ymin
   read -p "     Maximum y-value: " ymax
   pyrange="set yrange [$ymin:$ymax] noextend"
#   pyrange="set yrange [$ymin<*:*<$ymax] noextend"
else
   pyrange='set yrange [:] noextend'
fi


killall gnuplot_qt


SETeps='set term postscript eps enhanced color font "Times-Roman, 20" '
SETpng='set term png enhanced size 1000,800 font "Times-Roman, 20"'

cat > $savenam.gnu << EOF

##########################################################
##                                                      ##
##  Gnuplot script by Dr. Rashid                        ##
##                                                      ##
##  WIEN2k Tutorials: https://tiny.cc/w2k               ##
##                                                      ##
##  Youtube: https://www.youtube.com/c/PhysicsSchool20  ##
##                                                      ##
##########################################################


set	linetype	1	linewidth	3	lc	rgb	"blue"		
set	linetype	2	linewidth	3	lc	rgb	"forest-green"	
set	linetype	3	linewidth	3	lc	rgb	"dark-violet"
set	linetype	4	linewidth	3	lc	rgb	"dark-orange"
set	linetype	5	linewidth	3	lc	rgb	"yellow"
set	linetype	6	linewidth	3	lc	rgb	"cyan"
set	linetype	7	linewidth	3	lc	rgb	"dark-red"		
set	linetype	8	linewidth	3	lc	rgb	"goldenrod"
set	linetype	cycle	9


$ptitle
$pxlabel
$pylabel
$pxrange
$pyrange

$SETeps
set output '$savenam.eps'
$plotSTR

$SETpng
set output '$savenam.png'
$plotSTR

!xdg-open $savenam.png

EOF

gnuplot < $savenam.gnu 

echo "" 
echo "Created files are: " 
ls $savenam.*
echo ""

exit

echo ""
read -p " " userFEED
if [[ $userFEED == '' ]]; then

else

fi


