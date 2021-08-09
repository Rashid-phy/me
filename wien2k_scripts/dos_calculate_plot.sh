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
SCF=$NAME.scf
structure=$NAME.struct
sysINT=$NAME.int
fname=$NAME.dos1ev
saveDIR=Result.DOS

NUM='^[0-9]+$'

function WCTAfunction () {
   echo ""
   echo "  $1"
   echo ""
   exit
}

if [[ ! -s $SCF ]]; then
   WCTAfunction "$SCF is NOT available! Do the scf calculation first!!"
elif [[ ! -s $structure ]]; then
   WCTAfunction "$structure is NOT available!"
elif [[ ! -s $sysINT ]]; then
   WCTAfunction "$sysINT is NOT available!"
fi

if [[ -f "$NAME.scf2up" && -f "$NAME.scf2dn" ]]; then 
	spCAL=y
	WCTAfunction 'The script is NOT suitable for spin-polarization calculation!'
else
	spCAL=n
fi

cat << EOF
Atoms in the structure file:

$(grep 'RMT=' $structure  | cat -n)

     0 => to calculate total contribution of all the atoms (up to 6) 

EOF
read -p "For which atom you like to calculate PDOS (number only): " atomNUM
totalATOM=`grep 'RMT=' $structure | wc -l`
if ! [[ $atomNUM =~ $NUM ]]; then
   WCTAfunction 'Wrong choice! Try again!!'
elif [[ $atomNUM > $totalATOM ]]; then
   WCTAfunction 'Wrong choice! Try again!!'
fi

dosXrange="set xrange [:] noextend"
SETeps='set term postscript eps enhanced color font "Times-Roman, 20" '
SETpng='set term png enhanced size 1000,800 font "Times-Roman, 20"'
gpltDEFINATION=$HOME/.gnuplot
if [[ ! -s "$gpltDEFINATION" ]]; then 
cat > $gpltDEFINATION << EOF
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


############################################################### 
#####   Only total contribution of each (up to 6) atoms   #####
###############################################################
if [[ $atomNUM == 0 ]]; then 
cat << EOF

###############################################################
## Total contribution of individual atom will be calculates. ##
###############################################################
EOF
if [[ $totalATOM > 6 ]]; then
   totalATOM=6
cat << EOF
##  For first 6 atoms the claculation and plot will be done. ##
###############################################################

EOF
fi

init_lapwSTR=''
plotSTR="u 1:2 w l title 'total'"

for ((i = 1; i <= $totalATOM; i++)); do
	ATOM=`grep 'RMT=' $structure | gawk -v j=$i 'NR==j{print $1}'`
	init_lapwSTR="$init_lapwSTR $i tot"
	plotSTR="$plotSTR, '' u 1:$(($i+2)) w l title '$ATOM'"
done

gawk 'NR<3' $sysINT > dos.tmp
configure_int_lapw -b total $init_lapwSTR end
gawk 'NR>2' $sysINT >> dos.tmp
mv dos.tmp $sysINT

echo "*************************************************" 
x tetra 

cat > gplot.gnu << EOF

############################################################
##
## Gnuplot script by Dr. Rashid
##
## WIEN2k Tutorials: https://tiny.cc/w2k
##
## Youtube: https://www.youtube.com/c/PhysicsSchool20
##
############################################################

set xlabel 'Energy (eV)'
set ylabel 'DOS (states/eV)'
set yzeroaxis
$dosXrange

$SETeps
set output '$NAME.DOS.eps'
plot '$fname' $plotSTR

set output '$NAME.TDOS.eps'
plot '$fname' u 1:2 w l notitle 

$SETpng
set output '$NAME.DOS.png'
plot '$fname' $plotSTR

set output '$NAME.TDOS.png'
plot '$fname' u 1:2 w l notitle 

EOF

gnuplot < gplot.gnu

mkdir -p $saveDIR
mv $NAME.DOS.*  $NAME.TDOS.* $saveDIR/
cp $NAME.dos* $NAME.klist gplot.gnu $sysINT $saveDIR/
echo ""
du -sh $saveDIR
echo ""
echo "** Plots and nessery files are saved in $saveDIR **"
echo ""

xdg-open $saveDIR/$NAME.DOS.png


exit
fi

################################################################
# Contribution of orbitals of selected atom will be calculated #
################################################################

atomNAME=`grep 'RMT=' $structure | gawk -v i=$atomNUM 'NR==i{print $1}' | cut -c1-2`
nameSTR=PDOS_atom_${atomNUM}_${atomNAME}
DATAname=$nameSTR.data
EPSname=$nameSTR.eps
GNUname=$nameSTR.gnu
PNGname=$nameSTR.png


cat << EOF

**********************************************************
***** Orbitals for which the PDOS will be calculated *****
**      Up to 5 orbitals only. Do NOT include tot.      **
**  A possible input could look like: p,d,d-eg,d-t2g,f  **
**     Make sure there are no blanks in the string.     **
**       Separate the orbitals by comma (,) only.       **
**********************************************************

EOF
read -p "Enter your choice: " userFEED
if [[ $userFEED == '' ]]; then
   STR='p,d,d-eg,d-t2g,f' 
else
   STR=$userFEED
fi

STRspace=`echo "$STR" | tr , " "`
STRcount=`echo "$STRspace" | wc -w`
if [[ $STRcount > 5 ]]; then
   WCTAfunction 'Wrong choice! Try again!!'
fi

init_lapwSTR="configure_int_lapw -b total $atomNUM tot,$STR end"
cat << EOF

Command to calculate PDOS: $init_lapwSTR

EOF
read -p "Do you like to continue? (y/n) " userFEED
if [[ $userFEED != y ]]; then exit; fi

echo ""
gawk 'NR<3' $sysINT > pdos.tmp
$init_lapwSTR 
gawk 'NR>2' $sysINT >> pdos.tmp
mv pdos.tmp $sysINT

x tetra | tee -a 
cp $fname $DATAname

cat > $GNUname << EOF

############################################################
##
## Gnuplot script by Dr. Rashid
##
## WIEN2k Tutorials: https://tiny.cc/w2k
##
## Youtube: https://www.youtube.com/c/PhysicsSchool20
##
############################################################

set xlabel "Energy (eV)"
set ylabel "DOS(States/eV)"
set title "Atom \# $atomNUM: $atomNAME"
set yzeroaxis
$dosXrange

$SETpng
set output "TDOS_$PNGname"
plot "$DATAname" using 1:2 title "TDOS"  w l, '' using 1:3 title "$atomNAME" w l 

unset title

$SETeps
set output "TDOS_$EPSname"
replot

set ylabel "PDOS(States/eV)"
set title "Atom \# $atomNUM: $atomNAME"
$SETpng
set output "$PNGname"
set multiplot

  plot  "$DATAname" using 1:3 title "$atomNAME" w l 
EOF

column=4
for ii in $STRspace ; do
   echo "replot  '$DATAname' using 1:$column title '$ii' w l" >> $GNUname
   column=$(($column+1))
done

cat >> $GNUname << EOF

unset multiplot
unset title

$SETeps
set output "$EPSname"
replot

EOF

gnuplot < $GNUname
cp $sysINT ${nameSTR}.int
mkdir -p $saveDIR
mv *${nameSTR}.* $saveDIR/
echo ""
du -sh $saveDIR
echo ""
echo "** Plots and nessery files are saved in $saveDIR **"
echo ""
xdg-open $saveDIR/$PNGname


