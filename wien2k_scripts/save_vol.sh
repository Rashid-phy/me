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

## the ploting can also be done with the following command 
## eplot_lapw -t vol -a " "

cat << EOF
*** The script is only useful to save results from volume 
optimization using WIEN2k with constant a:b:c ratio. ****

  ENTER to continue 
  q to quit
EOF

read -p "                " userFEED
if [[ $userFEED == q ]]; then exit; fi

NAME=${PWD##*/}
volDATA=$NAME.voldata
fitDATA=$NAME.fitdata
plotVOLcell=${NAME}_cell_vol
plotVOLchange=${NAME}_vol_change
tmpPNG=~/.w2web/$(hostname -f)/tmp/*.png

na=`ls ${NAME}_vol*default.scf | wc -l`

if [[ $na -le 2 ]]; then
   echo "Number of available SCF files are $na"
   echo "There is no sufficient files to plot the Energy vs Volume graph!"
   echo ""
   exit
fi

dback=dayfile.back
if [[ -s "$NAME.dayfile" ]]; then
   cp $NAME.dayfile $dback
fi

ls ${NAME}_vol*default.scf > aa

printf "# cell_volume \t\t vol_change \t\t  total_energy (Ry) \n" > $volDATA

for i in {1..50}; do
	scfFILE=`gawk -v j=$i 'NR==j' aa`
	volCHANGE=`gawk -v j=$i 'NR==j' aa | sed -s "s/${NAME}_vol//g" | sed -s 's/default.scf//g' | sed -s 's/_/ /g'`
	if [[ $volCHANGE == '' ]]; then 
		break
	else
		ENERGY=`grep '********** TOTAL ENERGY IN Ry =' $scfFILE | tail -n 1 | gawk '{print $9}'`
		VOLUME=`grep 'UNIT CELL VOLUME =' $scfFILE | tail -n 1 | gawk '{print $7}'`
		printf "$VOLUME \t\t $volCHANGE \t\t $ENERGY \n" >> $volDATA
	fi
done

sort -g -k3,3 $volDATA > .var
Emin=`gawk 'NR==2 {print $3}' .var`
EminVOL=`gawk 'NR==2 {print $2}' .var`
Volume=`gawk 'NR==2 {print $1}' .var`
sort -g -k2,2 .var > $volDATA
cat > .var << EOF

Volume           = $Volume bohr^3
Minimum energy   = $Emin Ry
Change in volume = $EminVOL %

EOF
cat $volDATA .var


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

printf "y \n \n \n " > eosfit.data
	
gawk 'NR>1 {print $2 "\t\t" $3}' $volDATA > $NAME.vol
x eosfit < eosfit.data > /dev/null 2>&1
mv $NAME.eosfit  $NAME.eosfit_change
gawk 'NR>1 {print $1 "\t\t" $3}' $volDATA > $NAME.vol
x eosfit < eosfit.data > /dev/null 2>&1

cat >> $NAME.outputeos <<EOF

Murnaghan-data are in $NAME.eosfit
Birch-Murnaghan-data are in $NAME.eosfitb
Vinet-Rose-data are in $NAME.eosfitv
Poirier-Tarantola-data are in $NAME.eosfitp

EOF


printf "# Using  Murnaghan fit \n" > $fitDATA
printf "# cell_volume \t vol_change \t  total_energy \t Pressure(GPa) \n\n" >> $fitDATA
paste $NAME.eosfit $NAME.eosfit_change > eosfit.data 
gawk '{print $1 "\t\t" $4 "\t\t" $2 "\t\t" $3}' eosfit.data >> $fitDATA


SETpng='set term png enhanced size 1000,800 font "Times-Roman, 20"'
SETeps='set term postscript eps enhanced color font "Times-Roman, 20" '

cat > vplot.gnu << EOF
set  linetype  1  linewidth  4  pt  2  lc  rgb 'red' 
set  linetype  2  linewidth  2         lc  rgb "forest-green"	

set format y "%.4f"
set title "$NAME: Murnaghan"
set xlabel "Volume [bohr^3]"
set ylabel "Energy [Ry]"
$SETpng
set output "$plotVOLcell.png"
plot "$volDATA" u 1:3 w p notitle , "$NAME.eosfit"  w l notitle
$SETeps
set output "$plotVOLcell.eps"
plot "$volDATA" u 1:3 w p notitle, "$NAME.eosfit"  w l notitle

set format y "%.4f"
set title "$NAME: Murnaghan"
set xlabel "Change in volume [%]"
set ylabel "Energy [Ry]"
$SETpng
set output "$plotVOLchange.png"
plot "$volDATA" u 2:3 w p notitle, "$fitDATA" u 2:3 w l notitle
$SETeps
set output "$plotVOLchange.eps"
plot "$volDATA" u 2:3 w p notitle, "$fitDATA" u 2:3 w l notitle
EOF


gnuplot < vplot.gnu

cat .var >> $volDATA

echo "Results are saved in $volDATA and $NAME.outputeos files."
echo ""

if [[ $1 != s ]]; then
	xdg-open $plotVOLchange.png &
fi


echo "   1 => Save and continue with setected vol change"
echo "   2 => Enter your own choice of vol change"
echo "   3 => EXIT without doing anything"
read -p "What is your choice? " userFEED

if [[ $userFEED == 1 ]]; then
	volENElow=$EminVOL
elif [[ $userFEED == 2 ]]; then
	read -p "Which structure has lowest total energy? (number only) " volENElow
	if [[ $volENElow == '' ]]; then
		echo "A poper input need to be provided! Aborted"
		echo ""
		exit
	fi
else
	exit
fi


if (( $(echo "$volENElow >= 0" | bc -l ) && $(echo "$volENElow < 10" | bc -l ) )); then
	structFILE=${NAME}_vol____$volENElow*default.struct
else
	structFILE=${NAME}_vol*$volENElow*default.struct
fi


if [[ ! -f "$(ls $structFILE 2> /dev/null)" ]]; then
	echo " "
	echo " No such structure is available! CHECK your result and try again!!"
	echo ""
	exit 1
else
	STRUCTURE=`ls $structFILE`
fi


sendDIR=${NAME}_vol_opt_${volENElow}_send
saveDIR=01.vol_opt_${volENElow}


if [[ -d "$sendDIR" ]]; then
	echo "A folder named '$sendDIR' already exits!"
	echo "If you proced all the contents of the folder will be deleted!!"
	read -p "Do you like to continue?  (y/n) " contentDEL
	if [[ $contentDEL == y ]]; then
		rm -rf $sendDIR/*
	else
		echo " "
		echo "Script aborted!!!"
		echo "Save '$sendDIR' with a different name and try again!!!"
		exit
	fi
else
	mkdir $sendDIR
fi

for ii in outputnn outputsgroup struct_st outputs outputst kgen klist outputd outputeos ; do
	sendFILE=$NAME.$ii
	cp $sendFILE $sendDIR/
done


for ii in scf scf2 vsp ; do
	sendFILE=${NAME}_vol_*default.$ii
	cp $sendFILE $sendDIR/
done
cp ':eplot' $sendDIR/${NAME}_vol.eplot
cp ':log' $sendDIR/$NAME.tlogf
cp STDOUT optimize.job vplot.gnu $dback $sendDIR/
cp $NAME*struct $NAME.eosfit* $NAME.in* $NAME.vol* $NAME*png $NAME*eps $fitDATA $sendDIR/

if [[ -f "$(ls $tmpPNG 2> /dev/null)" ]]; then
	cp $tmpPNG $sendDIR/
fi

if [[ -d "$saveDIR" ]]; then
	echo "" 
	echo "A folder named '$saveDIR' already exits!"
	echo "If you proceed all the contents of the folder will be deleted!!"
	read -p "Do you like to continue?  (y/n) " contentDEL
	if [[ $contentDEL == y ]]; then
		rm -rf $saveDIR/*
	else
		echo " "
		echo "Script aborted!!!"
		echo "Save '$saveDIR' with a different name and try again!!!"
		exit
	fi
else
	mkdir $saveDIR
fi


mv ${NAME}_vol_*_default.* optimize.job $NAME.eosfit* $NAME.in* $NAME.vol* $NAME*png $NAME*eps $fitDATA $saveDIR/
mv STDOUT $NAME*struct $saveDIR

for ii in outputnn outputsgroup struct_st outputs outputst kgen klist outputd outputeos ; do
	sendFILE=$NAME.$ii
	mv $sendFILE $saveDIR/
done


extraDIR=extra_$(date +%R:%S)
mkdir $extraDIR

for x in *; do
   if ! [ -d "$x" ]; then
     mv -- "$x" $extraDIR/
   fi
done

cp $saveDIR/*.png .
cp $saveDIR/*.eps .
cp $saveDIR/$volDATA .
cp $saveDIR/$NAME.outputeos .
cp $saveDIR/$STRUCTURE .
cp $STRUCTURE $NAME.struct

echo " "
echo "  $(date)"
echo "  Plots are saves as '$plotVOLcell.png' and '$plotVOLcell.eps' for future use."
echo "  '$STRUCTURE' is saved as '$NAME.struct' for SCF calculation."
echo " "
echo "Necessery file are saved in '$saveDIR' folder."
echo "All the other files are saved in '$extraDIR' which can be deleted after checking files in '$saveDIR' folder."
echo " "

mkdir $NAME
cp $NAME.* ${NAME}_* $NAME 2>/dev/null
cp -r $NAME $saveDIR 
mv $NAME $sendDIR

zip -rq $sendDIR.zip $sendDIR

du -sh .
du -sh $extraDIR
du -sh $saveDIR
du -sh $sendDIR*

echo " "

