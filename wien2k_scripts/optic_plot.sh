#! /bin/bash

# NOT suitable if XMCD (X-ray magnetic circular dichroism) calculation is included 
# can also be done by running "opticplot_lapw"
# *.joint  *.epsilon  *.sigmak   *.absorp   *.refraction   *.reflectivity   *.sigma_intra   *.eloss   *.sumrules

xyzPLOT=n   #### xx_yy_zz plot option (y/n)

NAME=`ls *.eloss 2> /dev/null | sed -e "s/.eloss//"`

COUNT=0
for ii in  absorp  eloss  epsilon  reflectivity  refraction  sigmak ; do
	if [[ ! -f "$NAME.$ii" ]]; then 
		echo "$NAME.$ii is not available to perform the action!!"
		COUNT=$(($COUNT + 1))
	fi
done
if [[ ! $COUNT == 0 ]]; then exit 1; fi 

gpltDEFINATION=$HOME/.gnuplot
if [[ ! -s "$gpltDEFINATION" ]]; then 
cat > $gpltDEFINATION << EOF
set	linetype	1	linewidth	3	lc	rgb	"blue"		
set	linetype	2	linewidth	3	lc	rgb	"forest-green"	
set	linetype	3	linewidth	3	lc	rgb	"dark-violet"
set	linetype	4	linewidth	3	lc	rgb	"cyan"
set	linetype	5	linewidth	3	lc	rgb	"dark-red"		
set	linetype	6	linewidth	3	lc	rgb	"dark-orange"
set	linetype	7	linewidth	3	lc	rgb	"goldenrod"
set	linetype	8	linewidth	3
set	linetype	cycle	8								
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

if [[ $xyzPLOT == n ]]; then  ### upto reference xx_zz

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


if [[ -f "$NAME.elossup" ]]; then     ### upto reference xx_zz_up_dn

# plot eloss UP
FILE='elossup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Electron energy loss (arb. units)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'eloss\_xx\_up', \
				''		 u 1:3 w l title 'eloss\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'eloss\_xx\_up', \
				''		 u 1:3 w l title 'eloss\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot eloss DOWN
FILE='elossdn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Electron energy loss (arb. units)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'eloss\_xx\_dn', \
				''		 u 1:3 w l title 'eloss\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'eloss\_xx\_dn', \
				''		 u 1:3 w l title 'eloss\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon REAL UP
FILE='epsilonup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_epsilon\_xx\_up', \
				''		 u 1:4 w l title 'Re\_epsilon\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_epsilon\_xx\_up', \
				''		 u 1:4 w l title 'Re\_epsilon\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon REAL DOWN
FILE='epsilondn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_epsilon\_xx\_dn', \
				''		 u 1:4 w l title 'Re\_epsilon\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_epsilon\_xx\_dn', \
				''		 u 1:4 w l title 'Re\_epsilon\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon IMAGINARY UP
FILE='epsilonup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_epsilon\_xx\_up', \
				''		 u 1:5 w l title 'Im\_epsilon\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_epsilon\_xx\_up', \
				''		 u 1:5 w l title 'Im\_epsilon\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon IMAGINARY DOWN
FILE='epsilondn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_epsilon\_xx\_dn', \
				''		 u 1:5 w l title 'Im\_epsilon\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_epsilon\_xx\_dn', \
				''		 u 1:5 w l title 'Im\_epsilon\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL UP
FILE='sigmakup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.REup.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_up', \
				''		 u 1:4 w l title 'Re\_sigma\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.REup.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_up', \
				''		 u 1:4 w l title 'Re\_sigma\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL DOWN
FILE='sigmakdn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.REdn.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_dn', \
				''		 u 1:4 w l title 'Re\_sigma\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.REdn.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_dn', \
				''		 u 1:4 w l title 'Re\_sigma\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity IMAGINARY UP
FILE='sigmakup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.IMup.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_xx\_up', \
				''		 u 1:5 w l title 'Im\_sigma\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.IMup.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_xx\_up', \
				''		 u 1:5 w l title 'Im\_sigma\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity IMAGINARY DOWN
FILE='sigmakdn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.IMdn.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_xx\_dn', \
				''		 u 1:5 w l title 'Im\_sigma\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.IMdn.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_xx\_dn', \
				''		 u 1:5 w l title 'Im\_sigma\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot refraction UP
FILE='refractionup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Refractive index'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_xx\_up', \
				''		 u 1:3 w l title 'ref\_ind\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_xx\_up', \
				''		 u 1:3 w l title 'ref\_ind\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot refraction DOWN
FILE='refractiondn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Refractive index'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_xx\_dn', \
				''		 u 1:3 w l title 'ref\_ind\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_xx\_dn', \
				''		 u 1:3 w l title 'ref\_ind\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot reflectivity UP
FILE='reflectivityup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Optical reflectivity'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_xx\_up', \
				''		 u 1:3 w l title 'reflect\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_xx\_up', \
				''		 u 1:3 w l title 'reflect\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot reflectivity DOWN
FILE='reflectivitydn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Optical reflectivity'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_xx\_dn', \
				''		 u 1:3 w l title 'reflect\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_xx\_dn', \
				''		 u 1:3 w l title 'reflect\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL-UP in [1 / (Ohm cm)] unit **from absorp**
FILE='absorpup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (1/(Ohm-cm))'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.REup.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_up', \
				''		 u 1:3 w l title 'Re\_sigma\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.REup.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_up', \
				''		 u 1:3 w l title 'Re\_sigma\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL-DOWN in [1 / (Ohm cm)] unit **from absorp**
FILE='absorpdn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (1/(Ohm-cm))'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.REdn.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_dn', \
				''		 u 1:3 w l title 'Re\_sigma\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.REdn.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_dn', \
				''		 u 1:3 w l title 'Re\_sigma\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot absorption coefficient UP
FILE='absorpup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Absorption coefficient (10^4/cm)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:4 w l title 'absorp\_xx\_up', \
				''		 u 1:5 w l title 'absorp\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:4 w l title 'absorp\_xx\_up', \
				''		 u 1:5 w l title 'absorp\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot absorption coefficient DOWN
FILE='absorpdn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Absorption coefficient (10^4/cm)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:4 w l title 'absorp\_xx\_dn', \
				''		 u 1:5 w l title 'absorp\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:4 w l title 'absorp\_xx\_dn', \
				''		 u 1:5 w l title 'absorp\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu

fi    ### reference xx_zz_up_dn

### reference xx_zz

elif [[ $xyzPLOT == y ]]; then  ### updo reference xx_yy_zz 
echo ""
read -p "Do you like to proced selecting xx_yy_zz option? (y/n) " xyzFEED
if [[ $xyzFEED != y ]]; then 
	echo "Select appropiate xx_yy_zz option then try again!!!"
	exit
fi

# plot eloss
FILE='eloss'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Electron energy loss (arb. units)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title '$FILE\_xx', \
                ''       u 1:3 w l title '$FILE\_yy', \
                ''       u 1:4 w l title '$FILE\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title '$FILE\_xx', \
                ''       u 1:3 w l title '$FILE\_yy', \
                ''       u 1:4 w l title '$FILE\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon REAL
FILE='epsilon'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_$FILE\_xx', \
                ''       u 1:4 w l title 'Re\_$FILE\_yy', \
                ''       u 1:6 w l title 'Re\_$FILE\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_$FILE\_xx', \
                ''       u 1:4 w l title 'Re\_$FILE\_yy', \
                ''       u 1:6 w l title 'Re\_$FILE\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon IMAGINARY
FILE='epsilon'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_$FILE\_xx', \
                ''       u 1:5 w l title 'Im\_$FILE\_yy', \
                ''       u 1:7 w l title 'Im\_$FILE\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_$FILE\_xx', \
                ''       u 1:5 w l title 'Im\_$FILE\_yy', \
                ''       u 1:7 w l title 'Im\_$FILE\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL
FILE='sigmak'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.RE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx', \
                ''       u 1:4 w l title 'Re\_sigma\_yy', \
                ''       u 1:6 w l title 'Re\_sigma\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.RE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx', \
                ''       u 1:4 w l title 'Re\_sigma\_yy', \
                ''       u 1:6 w l title 'Re\_sigma\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity IMAGINARY
FILE='sigmak'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.IM.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_xx', \
                ''       u 1:5 w l title 'Im\_sigma\_yy', \
                ''       u 1:7 w l title 'Im\_sigma\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.IM.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_xx', \
                ''       u 1:5 w l title 'Im\_sigma\_yy', \
                ''       u 1:7 w l title 'Im\_sigma\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot refraction 
FILE='refraction'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Refractive index'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_xx', \
                ''       u 1:3 w l title 'ref\_ind\_yy', \
                ''       u 1:4 w l title 'ref\_ind\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_xx', \
                ''       u 1:3 w l title 'ref\_ind\_yy', \
                ''       u 1:4 w l title 'ref\_ind\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot refraction *** extinct ***
FILE='refraction'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Refractive index'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.extinct-$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:5 w l title 'extinct\_xx', \
                ''       u 1:6 w l title 'extinct\_yy', \
                ''       u 1:7 w l title 'extinct\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.extinct-$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:5 w l title 'extinct\_xx', \
                ''       u 1:6 w l title 'extinct\_yy', \
                ''       u 1:7 w l title 'extinct\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot reflectivity 
FILE='reflectivity'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Optical reflectivity'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_xx', \
                ''       u 1:3 w l title 'reflect\_yy', \
                ''       u 1:4 w l title 'reflect\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_xx', \
                ''       u 1:3 w l title 'reflect\_yy', \
                ''       u 1:4 w l title 'reflect\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL in [1 / (Ohm cm)] unit **from absorp**
FILE='absorp'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (1/(Ohm-cm))'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx', \
                ''       u 1:3 w l title 'Re\_sigma\_yy', \
                ''       u 1:4 w l title 'Re\_sigma\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx', \
                ''       u 1:3 w l title 'Re\_sigma\_yy', \
                ''       u 1:4 w l title 'Re\_sigma\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


# plot absorption coefficient
FILE='absorp'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Absorption coefficient (10^4/cm)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:5 w l title '$FILE\_xx', \
                ''       u 1:6 w l title '$FILE\_yy', \
                ''       u 1:7 w l title '$FILE\_zz'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:5 w l title '$FILE\_xx', \
                ''       u 1:6 w l title '$FILE\_yy', \
                ''       u 1:7 w l title '$FILE\_zz'" >> gplot.gnu
gnuplot < gplot.gnu


if [[ -f "$NAME.elossup" ]]; then     ### upto reference xx_yy_zz_up_dn

# plot eloss UP
FILE='elossup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Electron energy loss (arb. units)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'eloss\_xx\_up', \
                ''       u 1:3 w l title 'eloss\_yy\_up', \
                ''       u 1:4 w l title 'eloss\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'eloss\_xx\_up', \
                ''       u 1:3 w l title 'eloss\_yy\_up', \
                ''       u 1:4 w l title 'eloss\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot eloss DOWN
FILE='elossdn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Electron energy loss (arb. units)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'eloss\_xx\_dn', \
                ''       u 1:3 w l title 'eloss\_yy\_dn', \
                ''       u 1:4 w l title 'eloss\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'eloss\_xx\_dn', \
                ''       u 1:3 w l title 'eloss\_yy\_dn', \
                ''       u 1:4 w l title 'eloss\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon REAL UP
FILE='epsilonup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_epsilon\_xx\_up', \
                ''       u 1:4 w l title 'Re\_epsilon\_yy\_up', \
                ''       u 1:6 w l title 'Re\_epsilon\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_epsilon\_xx\_up', \
                ''       u 1:4 w l title 'Re\_epsilon\_yy\_up', \
                ''       u 1:6 w l title 'Re\_epsilon\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon REAL DOWN
FILE='epsilondn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_epsilon\_xx\_dn', \
                ''       u 1:4 w l title 'Re\_epsilon\_yy\_dn', \
                ''       u 1:6 w l title 'Re\_epsilon\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_epsilon\_xx\_dn', \
                ''       u 1:4 w l title 'Re\_epsilon\_yy\_dn', \
                ''       u 1:6 w l title 'Re\_epsilon\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon IMAGINARY UP
FILE='epsilonup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_epsilon\_xx\_up', \
                ''       u 1:5 w l title 'Im\_epsilon\_yy\_up', \
                ''       u 1:7 w l title 'Im\_epsilon\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_epsilon\_xx\_up', \
                ''       u 1:5 w l title 'Im\_epsilon\_yy\_up', \
                ''       u 1:7 w l title 'Im\_epsilon\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon IMAGINARY DOWN
FILE='epsilondn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_epsilon\_xx\_dn', \
                ''       u 1:5 w l title 'Im\_epsilon\_yy\_dn', \
                ''       u 1:7 w l title 'Im\_epsilon\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_epsilon\_xx\_dn', \
                ''       u 1:5 w l title 'Im\_epsilon\_yy\_dn', \
                ''       u 1:7 w l title 'Im\_epsilon\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL UP
FILE='sigmakup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.REup.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_up', \
                ''       u 1:4 w l title 'Re\_sigma\_yy\_up', \
                ''       u 1:6 w l title 'Re\_sigma\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.REup.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_up', \
                ''       u 1:4 w l title 'Re\_sigma\_yy\_up', \
                ''       u 1:6 w l title 'Re\_sigma\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL DOWN
FILE='sigmakdn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.REdn.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_dn', \
                ''       u 1:4 w l title 'Re\_sigma\_yy\_dn', \
                ''       u 1:6 w l title 'Re\_sigma\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.REdn.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_dn', \
                ''       u 1:4 w l title 'Re\_sigma\_yy\_dn', \
                ''       u 1:6 w l title 'Re\_sigma\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity IMAGINARY UP
FILE='sigmakup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.IMup.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_xx\_up', \
                ''       u 1:5 w l title 'Im\_sigma\_yy\_up', \
                ''       u 1:7 w l title 'Im\_sigma\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.IMup.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_xx\_up', \
                ''       u 1:5 w l title 'Im\_sigma\_yy\_up', \
                ''       u 1:7 w l title 'Im\_sigma\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity IMAGINARY DOWN
FILE='sigmakdn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.IMdn.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_xx\_dn', \
                ''       u 1:5 w l title 'Im\_sigma\_yy\_dn', \
                ''       u 1:7 w l title 'Im\_sigma\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.IMdn.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_xx\_dn', \
                ''       u 1:5 w l title 'Im\_sigma\_yy\_dn', \
                ''       u 1:7 w l title 'Im\_sigma\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot refraction UP
FILE='refractionup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Refractive index'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_xx\_up', \
                ''       u 1:3 w l title 'ref\_ind\_yy\_up', \
                ''       u 1:4 w l title 'ref\_ind\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_xx\_up', \
                ''       u 1:3 w l title 'ref\_ind\_yy\_up', \
                ''       u 1:4 w l title 'ref\_ind\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot refraction DOWN
FILE='refractiondn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Refractive index'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_xx\_dn', \
                ''       u 1:3 w l title 'ref\_ind\_yy\_dn', \
                ''       u 1:4 w l title 'ref\_ind\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_xx\_dn', \
                ''       u 1:3 w l title 'ref\_ind\_yy\_dn', \
                ''       u 1:4 w l title 'ref\_ind\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot reflectivity UP
FILE='reflectivityup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Optical reflectivity'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_xx\_up', \
                ''       u 1:3 w l title 'reflect\_yy\_up', \
                ''       u 1:4 w l title 'reflect\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_xx\_up', \
                ''       u 1:3 w l title 'reflect\_yy\_up', \
                ''       u 1:4 w l title 'reflect\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot reflectivity DOWN
FILE='reflectivitydn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Optical reflectivity'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_xx\_dn', \
                ''       u 1:3 w l title 'reflect\_yy\_dn', \
                ''       u 1:4 w l title 'reflect\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_xx\_dn', \
                ''       u 1:3 w l title 'reflect\_yy\_dn', \
                ''       u 1:4 w l title 'reflect\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL-UP in [1 / (Ohm cm)] unit **from absorp**
FILE='absorpup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (1/(Ohm-cm))'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.REup.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_up', \
                ''       u 1:3 w l title 'Re\_sigma\_yy\_up', \
                ''       u 1:4 w l title 'Re\_sigma\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.REup.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_up', \
                ''       u 1:3 w l title 'Re\_sigma\_yy\_up', \
                ''       u 1:4 w l title 'Re\_sigma\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL-DOWN in [1 / (Ohm cm)] unit **from absorp**
FILE='absorpdn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (1/(Ohm-cm))'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.REdn.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_dn', \
                ''       u 1:3 w l title 'Re\_sigma\_yy\_dn', \
                ''       u 1:4 w l title 'Re\_sigma\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.REdn.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_xx\_dn', \
                ''       u 1:3 w l title 'Re\_sigma\_yy\_dn', \
                ''       u 1:4 w l title 'Re\_sigma\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu


# plot absorption coefficient UP
FILE='absorpup'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Absorption coefficient (10^4/cm)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:5 w l title 'absorp\_xx\_up', \
                ''       u 1:6 w l title 'absorp\_yy\_up', \
                ''       u 1:7 w l title 'absorp\_zz\_up'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:5 w l title 'absorp\_xx\_up', \
                ''       u 1:6 w l title 'absorp\_yy\_up', \
                ''       u 1:7 w l title 'absorp\_zz\_up'" >> gplot.gnu
gnuplot < gplot.gnu


# plot absorption coefficient DOWN
FILE='absorpdn'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Absorption coefficient (10^4/cm)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:5 w l title 'absorp\_xx\_dn', \
                ''       u 1:6 w l title 'absorp\_yy\_dn', \
                ''       u 1:7 w l title 'absorp\_zz\_dn'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:5 w l title 'absorp\_xx\_dn', \
                ''       u 1:6 w l title 'absorp\_yy\_dn', \
                ''       u 1:7 w l title 'absorp\_zz\_dn'" >> gplot.gnu
gnuplot < gplot.gnu

fi ### reference xx_yy_zz_up_dn

else		### reference xx_yy_zz
	echo "Wrong xyzPLOT value! Check $NAME.inop to chose proper value!!"
	exit 
fi

echo "Done! Images are saved both as *.eps and *.png files." > gplot.gnu
cd ..

echo " "
echo "		All done! Check *.eps and *.png files in $saveDIR!!" 

