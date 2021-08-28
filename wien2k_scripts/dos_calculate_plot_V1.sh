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

set border lw 3
EOF
fi


############################################################### 
############################################################### 
#####   Only total contribution of each (up to 6) atoms   #####
###############################################################
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
	atomNAME=`grep 'RMT=' $structure | gawk -v j=$i 'NR==j{print $1}'`
	init_lapwSTR="$init_lapwSTR $i tot"
	plotSTR="$plotSTR, '' u 1:$(($i+2)) w l title '$atomNAME'"
done

gawk 'NR<3' $sysINT > pdos.tmp
configure_int_lapw -b total $init_lapwSTR end
gawk 'NR>2' $sysINT >> pdos.tmp
mv pdos.tmp $sysINT

################################################################ spCAL=n
################################################################ spCAL=n
if [[ $spCAL == n ]]; then

echo ""
x tetra 
fname=$NAME.dos1ev

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



## CHECK 123456789



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


fi
################################################################ spCAL=n
################################################################ spCAL=n

################################################################ spCAL=y
################################################################ spCAL=y
if [[ $spCAL == y ]]; then

echo ""
x tetra -up
echo "" 
x tetra -dn
fnamedn=$NAME.dos1evdn
fnameup=$NAME.dos1evup

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
set output '$NAME.DOS_up.eps'
plot '$fnameup' $plotSTR

set output '$NAME.DOS_dn.eps'
plot '$fnamedn' $plotSTR

set output '$NAME.TDOS_up-dn.eps'
plot '$fnameup' u 1:2 w l title 'up spin','$fnamedn' u 1:(-\$2) w l title 'down spin', '' u 1:(0) w d notitle


$SETpng
set title 'TOTAL'
set output '$NAME.TDOS_up-dn.png'
plot '$fnameup' u 1:2 w l title 'up spin','$fnamedn' u 1:(-\$2) w l title 'down spin', '' u 1:(0) w d notitle

set title 'UP spin'
set output '$NAME.DOS_up.png'
plot '$fnameup' $plotSTR

set title 'DOWN spin'
set output '$NAME.DOS_dn.png'
plot '$fnamedn' $plotSTR

EOF


for ((i = 1; i <= $totalATOM; i++)); do
	atomNAME=`grep 'RMT=' $structure | gawk -v j=$i 'NR==j{print $1}'`
   nameSTR=PDOS_atom_${i}_${atomNAME}
	pdosATOM=$(($i+2))

cat >> gplot.gnu << EOF

unset title

$SETeps
set output '${nameSTR}_up-down.eps'
plot '$NAME.dos1evup' u 1:$pdosATOM w l title 'up spin', \
	   '$NAME.dos1evdn' u 1:(-\$$pdosATOM) w l title 'down spin', '' u 1:(0) w d notitle

$SETpng
set title "Atom \# $i: $atomNAME"
set output '${nameSTR}_up-down.png'
plot '$NAME.dos1evup' u 1:$pdosATOM w l title 'up spin', \
	   '$NAME.dos1evdn' u 1:(-\$$pdosATOM) w l title 'down spin', '' u 1:(0) w d notitle


EOF
done


gnuplot < gplot.gnu

mkdir -p $saveDIR
cp $NAME.dos* $NAME.klist $sysINT $saveDIR/
mv $NAME.DOS* $NAME.TDOS* PDOS_atom_* gplot.gnu $saveDIR/
echo ""
du -sh $saveDIR
echo ""
echo "** Plots and nessery files are saved in $saveDIR **"
echo ""

xdg-open $saveDIR/$NAME.DOS_dn.png

fi

################################################################ spCAL=y
################################################################ spCAL=y

exit
fi




################################################################ 
################################################################
# Contribution of orbitals of selected atom will be calculated #
################################################################
################################################################

atomNAME=`grep 'RMT=' $structure | gawk -v i=$atomNUM 'NR==i{print $1}' | cut -c1-2`
nameSTR=PDOS_atom_${atomNUM}_${atomNAME}
GNUname=$nameSTR.gnu

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

gawk 'NR<3' $sysINT > pdos.tmp
echo ""
$init_lapwSTR 
gawk 'NR>2' $sysINT >> pdos.tmp
mv pdos.tmp $sysINT


################################################################ spCAL=n
################################################################ spCAL=n
if [[ $spCAL == n ]]; then

DATAname=$nameSTR.data
EPSname=$nameSTR.eps
PNGname=$nameSTR.png

echo ""
x tetra
cp $NAME.dos1ev $DATAname

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
plot "$DATAname" using 1:2 title "total"  w l, '' using 1:3 title "$atomNAME" w l 

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

exit
fi
################################################################ spCAL=n
################################################################ spCAL=n

################################################################ spCAL=y
################################################################ spCAL=y
if [[ $spCAL == y ]]; then

echo ""
x tetra -up
echo ""
x tetra -dn

DATAnameup=${nameSTR}_up.data
EPSnameup=${nameSTR}_up.eps
PNGnameup=${nameSTR}_up.png

DATAnamedn=${nameSTR}_dn.data
EPSnamedn=${nameSTR}_dn.eps
PNGnamedn=${nameSTR}_dn.png

cp $NAME.dos1evup $DATAnameup
cp $NAME.dos1evdn $DATAnamedn


cat > $GNUname << EOF

##
## Gnuplot script by Dr. Rashid
##
## WIEN2k Tutorials: https://tiny.cc/w2k
##
## Youtube: https://www.youtube.com/c/PhysicsSchool20
##

set xlabel "Energy (eV)"
set ylabel "DOS(States/eV)"
set title "Atom \# $atomNUM: $atomNAME (up spin)
set yzeroaxis
$dosXrange

$SETpng
set output "TDOS_$PNGnameup"
plot "$DATAnameup" using 1:2 title "total"  w l, '' using 1:3 title "$atomNAME" w l 

unset title

$SETeps
set output "TDOS_$EPSnameup"
replot

set ylabel "DOS(States/eV)"
set title "Atom \# $atomNUM: $atomNAME (up spin)"
$SETpng
set output "$PNGnameup"
set multiplot

  plot  "$DATAnameup" using 1:3 title "$atomNAME" w l 
EOF

column=4
for ii in $STRspace ; do
   echo "replot  '$DATAnameup' using 1:$column title '$ii' w l" >> $GNUname
   column=$(($column+1))
done

cat >> $GNUname << EOF

unset multiplot
unset title

$SETeps
set output "$EPSnameup"
replot

EOF

gnuplot < $GNUname


################################################################ UP
################################################################ DOWN


cat > $GNUname << EOF

##
## Gnuplot script by Dr. Rashid
##
## WIEN2k Tutorials: https://tiny.cc/w2k
##
## Youtube: https://www.youtube.com/c/PhysicsSchool20
##

set xlabel "Energy (eV)"
set ylabel "DOS(States/eV)"
set title "Atom \# $atomNUM: $atomNAME (down spin)"
set yzeroaxis
$dosXrange

$SETpng
set output "TDOS_$PNGnamedn"
plot "$DATAnamedn" using 1:2 title "total"  w l, '' using 1:3 title "$atomNAME" w l 

unset title

$SETeps
set output "TDOS_$EPSnamedn"
replot

set ylabel "DOS(States/eV)"
set title "Atom \# $atomNUM: $atomNAME (down spin)"
$SETpng
set output "$PNGnamedn"
set multiplot

  plot  "$DATAnamedn" using 1:3 title "$atomNAME" w l 
EOF

column=4
for ii in $STRspace ; do
   echo "replot  '$DATAnamedn' using 1:$column title '$ii' w l" >> $GNUname
   column=$(($column+1))
done

cat >> $GNUname << EOF

unset multiplot
unset title

$SETeps
set output "$EPSnamedn"
replot

EOF

gnuplot < $GNUname


cp $sysINT ${nameSTR}.int
mkdir -p $saveDIR
echo ""
mv *${nameSTR}_up.*  *${nameSTR}_dn.* $GNUname ${nameSTR}.int $saveDIR/
du -sh $saveDIR
echo ""
echo "** Plots and nessery files are saved in $saveDIR **"
echo ""
xdg-open $saveDIR/$PNGnamedn

exit
fi
################################################################ spCAL=y
################################################################ spCAL=y


