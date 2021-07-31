#! /bin/bash

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

# NOT suitable if XMCD (X-ray magnetic circular dichroism) calculation is included 
# can also be done by running "opticplot_lapw"

NAME=${PWD##*/}
INOP=$NAME.inop

bandGAP=`grep ':GAP (global)   :' $NAME.scf | tail -n 1  | gawk '{print $7}'`
if [[ $bandGAP == 0.0 ]]; then
	echo "Formula to calculate plasma frequency in the case of spin polarization for metal:"  
	echo "w_pl = sqrt( w_pl(up-spin)**2 + w_pl(dn-spin)**2 )"
	echo ""
	echo "Make sure you have calculated the plasma frequency correctly."
	echo ""
fi

noCOLUMN=`grep 'number of choices' $INOP | gawk '{print $1}'`
noLINE=`grep -n 'number of choices' $INOP | gawk '{print $1}'`
noLINE=${noLINE%:2}

if [[ $noCOLUMN != 2 ]]; then
	echo "The script only works with number of column = 2 in $INOP file."
	echo "Your choice is inconsistant with the script. Aborted!"
	echo ""
	exit
fi

Rexx=`gawk -v j=$(($noLINE + 1)) 'NR==j {print $1}' $INOP`
Rezz=`gawk -v j=$(($noLINE + 2)) 'NR==j {print $1}' $INOP`

if [[ $Rexx != 1 || $Rezz != 3 ]]; then
	echo "Inconsistant choices in $INOP. The script only works with following choices:"
	echo ""
	echo "2             number of choices (columns in ...."
	echo "1             Re xx"
	echo "3             Re zz"
#	echo "OFF           ON/OFF   writes MME to unit 4"
	echo ""
	exit
fi

COUNT=0
for ii in  absorp  eloss  epsilon  reflectivity  refraction  sigmak ; do
	if [[ ! -f "$NAME.$ii" ]]; then 
		echo " $NAME.$ii is not available!"
		COUNT=$(($COUNT + 1))
	fi
done
if [[ ! $COUNT == 0 ]]; then
	echo ""
	echo "First run OPTIC in WIEN2k and make sure you are in the right directory." 
	echo ""
	exit 1; 
fi 

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
SETeps='set term postscript eps enhanced color font "Times-Roman, 20" '
SETpng='set term png enhanced size 1000,800 font "Times-Roman, 20"'

saveDIR=Result.optic
if [[ -d $saveDIR ]]; then
	rm -f $saveDIR/*
fi
save_lapw -s -optic -d $saveDIR
cp $NAME.reflectivity* $saveDIR
cd $saveDIR


# plot eloss
FILE='eloss'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Electron energy loss (arb. units)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title '$FILE\_xx', \
		''	 u 1:3 w l title '$FILE\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title '$FILE\_xx', \
		''	 u 1:3 w l title '$FILE\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon REAL
FILE='epsilon'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_$FILE\_xx', \
		''	 u 1:4 w l title 'Re\_$FILE\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_$FILE\_xx', \
		''	 u 1:4 w l title 'Re\_$FILE\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon IMAGINARY
FILE='epsilon'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_$FILE\_xx', \
		''	 u 1:5 w l title 'Im\_$FILE\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_$FILE\_xx', \
		''	 u 1:5 w l title 'Im\_$FILE\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL
FILE='sigmak'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.RE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx', \
		''	 u 1:4 w l title 'Re\_sigma\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.RE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx', \
		''	 u 1:4 w l title 'Re\_sigma\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity IMAGINARY
FILE='sigmak'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.IM.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_xx', \
		''	 u 1:5 w l title 'Im\_sigma\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.IM.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_xx', \
		''	 u 1:5 w l title 'Im\_sigma\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot refraction 
FILE='refraction'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Refractive index'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_xx', \
		''	 u 1:3 w l title 'ref\_ind\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_xx', \
		''	 u 1:3 w l title 'ref\_ind\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot reflectivity 
FILE='reflectivity'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Optical reflectivity'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_xx', \
		''	 u 1:3 w l title 'reflect\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_xx', \
		''	 u 1:3 w l title 'reflect\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL in [1 / (Ohm cm)] unit **from absorp**
FILE='absorp'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (1/(Ohm-cm))'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx', \
		''	 u 1:3 w l title 'Re\_sigma\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx', \
		''	 u 1:3 w l title 'Re\_sigma\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot absorption coefficient
FILE='absorp'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Absorption coefficient (10^4/cm)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:4 w l title '$FILE\_xx', \
		''	 u 1:5 w l title '$FILE\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:4 w l title '$FILE\_xx', \
		''	 u 1:5 w l title '$FILE\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


echo "Done! Images are saved both as *.eps and *.png files." > gplot.gnu
cd ..
du -sh $saveDIR
echo ""
echo "  All done! Check *.eps and *.png files in $saveDIR!!" 
echo " "


