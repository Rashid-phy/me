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
## eplot_lapw -t coa -a " "

cat << EOF
The script is only useful to save results from WIEN2k optimizer
in varying c/a ratio with constant volume (tetr., hex. lattice).

  ENTER to continue 
  q to quit
EOF

read -p "                " userFEED
if [[ $userFEED == q ]]; then exit; fi

NAME=${PWD##*/}
coaDATA=$NAME.coadata
coaFIT=$NAME.varfit
plotCOAchange=${NAME}_coa_change
tmpPNG=~/.w2web/$(hostname -f)/tmp/*.png

na=`ls ${NAME}_coa*default.scf | wc -l`

if [[ $na -le 4 ]]; then
   echo "Number of available SCF files are $na"
   echo "There is no sufficient files to plot the Energy vs c/a graph!"
   echo ""
   exit
fi

ls ${NAME}_coa*default.scf > aa

printf "# cell_volume \t\t c/a_change \t\t  total_energy (Ry) \n" > $coaDATA

for i in {1..50}; do
	scfFILE=`gawk -v j=$i 'NR==j' aa`
	coaCHANGE=`gawk -v j=$i 'NR==j' aa | sed -s "s/${NAME}_coa//g" | sed -s 's/default.scf//g' | sed -s 's/_/ /g'`
	if [[ $coaCHANGE == '' ]]; then 
		break
	else
		ENERGY=`grep '********** TOTAL ENERGY IN Ry =' $scfFILE | tail -n 1 | gawk '{print $9}'`
		VOLUME=`grep 'UNIT CELL VOLUME =' $scfFILE | tail -n 1 | gawk '{print $7}'`
		printf "$VOLUME \t\t $coaCHANGE \t\t\t $ENERGY \n" >> $coaDATA
	fi
done

sort -g -k2,2 $coaDATA > .var
mv .var $coaDATA
Emin=`sort -g -k3,3 $coaDATA | gawk 'NR==2 {print $3}'`
EminCOA=`sort -g -k3,3 $coaDATA | gawk 'NR==2 {print $2}'`

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

SETpng='set term png enhanced size 1000,800 font "Times-Roman, 20"'
SETeps='set term postscript eps enhanced color font "Times-Roman, 20" '

cat > fitparameter << EOF
a1=1
a2=1
a3=1
a4=1
a5=1
EOF

gawk 'NR>1 {print "\t" $2 "\t" $3}' $coaDATA > tmp2

cat > coaplot.gnu << EOF
set linetype    1   linewidth	4   pt 2   lc rgb 'red' 
set	linetype	2	linewidth	2	lc	rgb	"forest-green"	

set xlabel "Change in c/a [%]"
set ylabel "Energy [Ry]"
set format y "%.4f"
f(x)=a1+a2*x+a3*x**2+a4*x**3+a5*x**4
fit f(x) 'tmp2' via 'fitparameter' 
$SETpng
set output "$plotCOAchange.png"
plot "$coaDATA" u 2:3 w p notitle, f(x) title "polyfit: 4^{th}order"
$SETeps
set output "$plotCOAchange.eps"
plot "$coaDATA" u 2:3 w p notitle, f(x) title "polyfit: 4^{th}order"
save var "$coaFIT"
EOF

gnuplot < coaplot.gnu 
xdg-open $plotCOAchange.png &

if [[ -s "$coaFIT" ]]; then
	cp ${NAME}_initial.struct init.struct
	echo "coa" > tmp3
	grep "a[1-5]" $coaFIT > .var
	head -5 < .var|awk '{print $3}' > varfit.dat
	echo "" | tee -a $coaFIT
	findMINcboa | tee -a $coaFIT
fi

cat >> $coaDATA << EOF

Minimum energy = $Emin Ry
Change in c/a  = $EminCOA %

EOF


echo "" 
cat $coaDATA

echo "   1 => Save and continue with setected c/a change"
echo "   2 => Enter your own choice of c/a change"
echo "   3 => EXIT without doing anything"
read -p "What is your choice? " userFEED

if [[ $userFEED == 1 ]]; then
	coaENElow=$EminCOA
elif [[ $userFEED == 2 ]]; then
	read -p "Enter your choice of c/a change? (number only) " coaENElow
	if [[ $coaENElow == '' ]]; then
		echo "A poper input need to be provided! Aborted"
		echo ""
		exit
	fi
else
	exit
fi

if (( $(echo "$coaENElow >= 0" | bc -l ) && $(echo "$coaENElow < 10" | bc -l ) )); then
	structFILE=${NAME}_coa____$coaENElow*default.struct
else
	structFILE=${NAME}_coa*$coaENElow*default.struct
fi


if [[ ! -f "$(ls $structFILE 2> /dev/null)" ]]; then
	echo ""
	echo " No such structure is available! CHECK your result and try again!!"
	echo ""
	exit 1
else
	STRUCTURE=`ls $structFILE`
fi
 

sendDIR=${NAME}_coa_opt_${coaENElow}_send
saveDIR=02.coa_opt_${coaENElow}


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

for ii in outputnn outputsgroup struct_st outputs outputst kgen klist outputd ; do 
	sendFILE=$NAME.$ii
	cp $sendFILE $sendDIR/
done


for ii in scf scf2 vsp ; do
	sendFILE=${NAME}_coa_*default.$ii
	cp $sendFILE $sendDIR/
done
cp ':log' $sendDIR/$NAME.tlogf
cp STDOUT optimize.job coaplot.gnu fitparameter $coaDATA $coaFIT $sendDIR/
cp $NAME*struct $NAME.in* $NAME.coa* $plotCOAchange* $sendDIR/

if [[ -f "$(ls $tmpPNG 2> /dev/null)" ]]; then
	cp $tmpPNG $sendDIR/
fi


if [[ -d "$saveDIR" ]]; then
	echo "" 
	echo "A folder named '$saveDIR' already exits!"
	echo "If you proced all the contents of the folder will be deleted!!"
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

mv ${NAME}_coa_*_default.* optimize.job $NAME.in* $NAME*png $NAME*eps $coaDATA $coaFIT $saveDIR/
mv STDOUT $NAME*struct eplot.ps $saveDIR/

for ii in outputnn outputsgroup struct_st outputs outputst kgen klist outputd ; do #outputeos
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
cp $saveDIR/*ps .
cp $saveDIR/$coaDATA .
cp $saveDIR/$coaFIT .
cp $saveDIR/$STRUCTURE .
cp $STRUCTURE $NAME.struct

echo " "
echo "  $(date)"
echo "  Plots are saves as '$plotCOAchange.png' and '$plotCOAchange.eps' for future use."
echo "  '$STRUCTURE' is saved as '$NAME.struct' for SCF calculation."
echo " "
echo "Necessery file are saved in '$saveDIR' folder."
echo "All the other files are saved in '$extraDIR' which can be deleted after checking files in '$saveDIR' folder."
echo " "

zip -rq $sendDIR.zip $sendDIR
rm -r $sendDIR

du -sh .
du -sh $extraDIR
du -sh $saveDIR
du -sh $sendDIR*
echo " "

