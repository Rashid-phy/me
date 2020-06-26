#!/bin/bash


echo ""
echo "************************************"
echo "*                                  *"
echo "*   Script by Dr. Rashid @ 2020    *"
echo "*                                  *" 
echo "************************************"
echo ""

## the ploting can also be done with the following command 
## eplot_lapw -t vol -a " "

#sudo apt-get install zip

NAME=${PWD##*/}
plotNAME=$NAME\_vol_opt
sendDIR=$NAME\_vol_opt_send
saveDIR=$NAME\_vol_opt_saved
tmpPNG=~/.w2web/$(hostname -f)/tmp/*.png

read -p "Which structure has lowest total energy? (number only) " volENElow

#if [[ $volENElow -eq 0 ]]; then
#	STRUCTURE=`ls $NAME\_vol____0.00_default.struct`
#elif [[ $volENElow -gt 0 && $volENElow -lt 10 ]]; then
#	STRUCTURE=`ls $NAME\_vol____$volENElow*default.struct`
#elif [[ $volENElow -gt -10 && $volENElow -lt 0 ]]; then
#	STRUCTURE=`ls $NAME\_vol___$volENElow*default.struct`
#else
#	STRUCTURE=`ls $NAME\_vol*$volENElow*default.struct`
#fi
#if [[ $volENElow -ge 0 && $volENElow -lt 10 ]]; then
#	structFILE=$NAME\_vol____$volENElow*default.struct
#elif [[ $volENElow -gt -10 && $volENElow -lt 0 ]]; then
#	structFILE=$NAME\_vol___$volENElow*default.struct
#else
#	structFILE=$NAME\_vol*$volENElow*default.struct
#fi

if (( $(echo "$volENElow >= 0" | bc -l ) && $(echo "$volENElow < 10" | bc -l ) )); then
	structFILE=$NAME\_vol____$volENElow*default.struct
elif [[ $(echo "$volENElow < 0 " | bc -l ) && $(echo "$volENElow > -10" | bc -l ) ]]; then
	structFILE=$NAME\_vol___$volENElow*default.struct
else
	structFILE=$NAME\_vol*$volENElow*default.struct
fi

#STRUCTURE=`ls $structFILE`

if [[ ! -f "$(ls $structFILE 2> /dev/null)" ]]; then
	echo " "
	echo "   No such structure is available!"
	echo "   CHECK your result and try again!!"
	echo ""
	exit 1
else
	STRUCTURE=`ls $structFILE`
#	echo "$STRUCTURE"
fi


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

SETpng='set term png enhanced size 1000,800 font "Times-Roman, 20"'
SETeps='set term postscript eps enhanced color font "Times-Roman, 20" '

cat > vplot.gnu << EOF
set linetype    1   linewidth	4   pt 2   lc rgb 'red' 
set	linetype	2	linewidth	2	lc	rgb	"forest-green"	
$SETpng
set output "$plotNAME.png"
set format y "%.4f"
set title "$NAME: Murnaghan"
set xlabel "Volume [a.u.^3]"
set ylabel "Energy [Ry]"
plot "$NAME.vol" w p notitle , "$NAME.eosfit"  w l notitle
$SETeps
set output "$plotNAME.eps"
plot "$NAME.vol" w p notitle, "$NAME.eosfit"  w l notitle
EOF

gnuplot < vplot.gnu

if [[ -d "$sendDIR" ]]; then
	echo "A folder named '$sendDIR' already exits!"
	echo "If you proced all the contents of the folder will be deleted!!"
	read -p "Do you like to continue?  (y/n) " contentDEL
	if [[ $contentDEL == y ]]; then
echo " 88 uncomment the following line "
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

for ii in kgen klist scf scf2 vsp ; do
	sendFILE=$NAME\_vol_*default.$ii
	cp $sendFILE $sendDIR/
done
cp ':eplot' $sendDIR/$NAME\_vol.eplot
cp STDOUT $NAME*struct optimize.job $NAME.eosfit* $NAME.outputeos $NAME.vol $plotNAME.* vplot.gnu $sendDIR/

if [[ -f "$(ls $tmpPNG 2> /dev/null)" ]]; then
	cp $tmpPNG $sendDIR/
fi


#for ii in {1..5}; do
#	saveDIR=0$ii\_$NAME\_vol_opt_saved
#	if [[ ! -d "$saveDIR" ]]; then
#		mkdir $saveDIR
#		break
#	fi
#done

if [[ -d "$saveDIR" ]]; then
	echo "" 
	echo "A folder named '$saveDIR' already exits!"
	echo "If you proced all the contents of the folder will be deleted!!"
	read -p "Do you like to continue?  (y/n) " contentDEL
	if [[ $contentDEL == y ]]; then
echo " 88 uncomment the following line "
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


mv $NAME\_vol_*_default.* optimize.job $plotNAME.* $NAME.eosfit* $NAME.outputeos $NAME.vol $saveDIR/
mv STDOUT $NAME*struct $saveDIR

rm -f *.vector*  *.energy* *.broyd*
extraDIR=extra_$(date +%R:%S)
mkdir $extraDIR
mv *.* $extraDIR/
rm -f * 

cp $saveDIR/$plotNAME.* .
cp $saveDIR/$STRUCTURE .
cp $STRUCTURE $NAME.struct
echo " "
echo "  $(date)"
echo " "
echo "  Plots are saves as '$plotNAME.png' and '$plotNAME.eps' for future use."
echo " "
echo "  '$STRUCTURE' is saved as '$NAME.struct' for SCF calculation."
echo " "

zip -rq $sendDIR.zip $sendDIR
echo "  A tape achieve named '$sendDIR.zip' is created."
echo " "
echo "Necessery file are saved in '$saveDIR' folder."
echo "All the other files are saved in '$extraDIR' which can be deleted after checking files in '$saveDIR' folder."
echo " "

du -sh .
du -sh $extraDIR
du -sh $saveDIR
du -sh $sendDIR*
echo " "


