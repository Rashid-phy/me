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
volDATA=$NAME.voldata
plotVOLcell=$NAME\_cell_vol
plotVOLchange=$NAME\_vol_change
tmpPNG=~/.w2web/$(hostname -f)/tmp/*.png


ls $NAME\_vol*default.scf > aa

printf "# cell_volume \t vol_change \t  total_energy \n\n" > $volDATA
printf "\ncell_volume \t vol_change \t  total_energy \n\n" 

for i in {1..10}; do
	scfFILE=`gawk -v j=$i 'NR==j' aa`
	volCHANGE=`gawk -v j=$i 'NR==j' aa | sed -s "s/$NAME\_vol//g" | sed -s 's/default.scf//g' | sed -s 's/_//g'`
	if [[ $volCHANGE == '' ]]; then 
		break
	else
		ENERGY=`grep '********** TOTAL ENERGY IN Ry =' $scfFILE | tail -n 1 | gawk '{print $9}'`
		VOLUME=`grep 'UNIT CELL VOLUME =' $scfFILE | tail -n 1 | gawk '{print $7}'`
		printf "$VOLUME \t\t $volCHANGE \t\t\t $ENERGY \n" >> $volDATA
		printf "$VOLUME \t $volCHANGE \t\t $ENERGY \n" 
	fi
done

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
set output "$plotVOLcell.png"
set format y "%.4f"
set title "$NAME: Murnaghan"
set xlabel "Volume [a.u.^3]"
set ylabel "Energy [Ry]"
plot "$volDATA" u 1:3 w p notitle , "$NAME.eosfit"  w l notitle
$SETeps
set output "$plotVOLcell.eps"
plot "$volDATA" u 1:3 w p notitle, "$NAME.eosfit"  w l notitle

$SETpng
set output "$plotVOLchange.png"
set format y "%.4f"
set title "$NAME: Murnaghan"
set xlabel "Change in volume [%]"
set ylabel "Energy [Ry]"
plot "$volDATA" u 2:3 w p notitle
$SETeps
set output "$plotVOLchange.eps"
plot "$volDATA" u 2:3 w p notitle
EOF

gnuplot < vplot.gnu

if [[ $plotONLY == y ]]; then exit; fi

echo ""
read -p "Which structure has lowest total energy? (number only) " volENElow


if (( $(echo "$volENElow >= 0" | bc -l ) && $(echo "$volENElow < 10" | bc -l ) )); then
	structFILE=$NAME\_vol____$volENElow*default.struct
elif [[ $(echo "$volENElow < 0 " | bc -l ) && $(echo "$volENElow > -10" | bc -l ) ]]; then
	structFILE=$NAME\_vol___$volENElow*default.struct
else
	structFILE=$NAME\_vol*$volENElow*default.struct
fi


if [[ ! -f "$(ls $structFILE 2> /dev/null)" ]]; then
	echo " "
	echo "   No such structure is available!"
	echo "   CHECK your result and try again!!"
	echo ""
	exit 1
else
	STRUCTURE=`ls $structFILE`
fi

sendDIR=$NAME\_vol_opt_$volENElow\_send
saveDIR=$NAME\_vol_opt_$volENElow\_saved

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

for ii in outputnn outputsgroup struct_st outputs inst outputst in* kgen klist outputd ; do
	sendFILE=$NAME.$ii
	cp $sendFILE $sendDIR/
done


for ii in scf scf2 vsp ; do
	sendFILE=$NAME\_vol_*default.$ii
	cp $sendFILE $sendDIR/
done
cp ':eplot' $sendDIR/$NAME\_vol.eplot
cp STDOUT $NAME*struct optimize.job $NAME.eosfit* $NAME.outputeos $NAME.vol* $NAME*png $NAME*eps vplot.gnu $sendDIR/

if [[ -f "$(ls $tmpPNG 2> /dev/null)" ]]; then
	cp $tmpPNG $sendDIR/
fi

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


mv $NAME\_vol_*_default.* optimize.job $NAME.eosfit* $NAME.outputeos $NAME.vol $NAME*png $NAME*eps $saveDIR/
mv STDOUT $NAME*struct $saveDIR

for ii in outputnn outputsgroup struct_st outputs inst outputst in* kgen klist outputd ; do
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

cp $saveDIR/$plotVOLcell.* .
cp $saveDIR/$STRUCTURE .
cp $STRUCTURE $NAME.struct

echo " "
echo " $(date)"
echo " Plots are saves as '$plotVOLcell.png' and '$plotVOLcell.eps' for future use."
echo " Optimized structure'$STRUCTURE' is saved as '$NAME.struct' for SCF calculation after initialization with proper parameters."
echo " "

zip -rq $sendDIR.zip $sendDIR
echo " Necessery file are saved in '$saveDIR' folder."
echo " All the other files are saved in '$extraDIR' which can be deleted after checking files in '$saveDIR' folder."
echo " "

du -sh .
du -sh $extraDIR
du -sh $saveDIR
du -sh $sendDIR*
echo " "


