#! /bin/bash

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

# NOT suitable if XMCD (X-ray magnetic circular dichroism) calculation is included 
# can also be done by running "opticplot_lapw"

NAME=${PWD##*/}
INOP=$NAME.inop

if [[ ! -f "$NAME.scf" ]]; then 
   echo "$NAME.scf in not available"
   echo ""
   exit
elif [[ ! -f "$INOP" ]]; then 
   echo "$INOP in not available"
   echo ""
   exit
fi

bandGAP=`grep ':GAP (global)   :' $NAME.scf | tail -n 1  | gawk '{print $7}'`
if [[ $bandGAP == 0.0 ]]; then
	echo "Formula to calculate plasma frequency in the case of spin polarization for metal:"  
	echo "w_pl = sqrt( w_pl(up-spin)**2 + w_pl(dn-spin)**2 )"
	echo ""
	echo "Make sure you have calculated the plasma frequency correctly."
	echo ""
fi


noCOLUMN=`grep 'number of choices' $INOP | gawk '{print $1}'`
noLINE=`grep -n 'number of choices' $INOP | cut -c1`


if [[ $noCOLUMN == '' ]]; then
   echo "I can't detect the number of choices (columns) in $INOP."
   echo "Please make sure you keep the text 'number of choices' "
   echo "beside the colume number in the $INOP file."
   echo ""
   exit
fi


if [[ $noCOLUMN == 1 ]]; then
   ReVALUE=`gawk -v j=$(($noLINE + 1)) 'NR==j {print $1}' $INOP`
   if [[ $ReVALUE == 1 ]]; then
      ReXYZ=xx
   elif [[ $ReVALUE == 2 ]]; then
      ReXYZ=yy
   elif [[ $ReVALUE == 3 ]]; then
      ReXYZ=zz
   elif [[ $ReVALUE == 4 ]]; then
      ReXYZ=xy
   elif [[ $ReVALUE == 5 ]]; then
      ReXYZ=xz
   elif [[ $ReVALUE == 6 ]]; then
      ReXYZ=yz
   else
      echo "The script only works with Re xx/yy/zz/xy/xz/yz in $INOP."
      echo "  Your choice is inconsistant with the script. Aborted!"
      echo ""
      exit  
   fi

elif [[ $noCOLUMN == 2 ]]; then
   ReVone=`gawk -v j=$(($noLINE + 1)) 'NR==j {print $1}' $INOP`
   ReVtwo=`gawk -v j=$(($noLINE + 2)) 'NR==j {print $1}' $INOP`
   
   if [[ $ReVone == 1 ]]; then
      ReXYZ1=xx
   elif [[ $ReVone == 2 ]]; then
      ReXYZ1=yy
   elif [[ $ReVone == 3 ]]; then
      ReXYZ1=zz
   elif [[ $ReVone == 4 ]]; then
      ReXYZ1=xy
   elif [[ $ReVone == 5 ]]; then
      ReXYZ1=xz
   elif [[ $ReVone == 6 ]]; then
      ReXYZ1=yz
   else
      echo "The script only works with Re xx/yy/zz/xy/xz/yz in $INOP."
      echo "  Your choice is inconsistant with the script. Aborted!"
      echo ""
      exit  
   fi

   if [[ $ReVtwo == 1 ]]; then
      ReXYZ2=xx
   elif [[ $ReVtwo == 2 ]]; then
      ReXYZ2=yy
   elif [[ $ReVtwo == 3 ]]; then
      ReXYZ2=zz
   elif [[ $ReVtwo == 4 ]]; then
      ReXYZ2=xy
   elif [[ $ReVtwo == 5 ]]; then
      ReXYZ2=xz
   elif [[ $ReVtwo == 6 ]]; then
      ReXYZ2=yz
   else
      echo "The script only works with Re xx/yy/zz/xy/xz/yz in $INOP."
      echo "  Your choice is inconsistant with the script. Aborted!"
      echo ""
      exit  
   fi

elif [[ $noCOLUMN == 3 ]]; then
   ReVone=`gawk -v j=$(($noLINE + 1)) 'NR==j {print $1}' $INOP`
   ReVtwo=`gawk -v j=$(($noLINE + 2)) 'NR==j {print $1}' $INOP`
   ReVthree=`gawk -v j=$(($noLINE + 3)) 'NR==j {print $1}' $INOP`
   
   if [[ $ReVone == 1 ]]; then
      ReXYZ1=xx
   elif [[ $ReVone == 2 ]]; then
      ReXYZ1=yy
   elif [[ $ReVone == 3 ]]; then
      ReXYZ1=zz
   elif [[ $ReVone == 4 ]]; then
      ReXYZ1=xy
   elif [[ $ReVone == 5 ]]; then
      ReXYZ1=xz
   elif [[ $ReVone == 6 ]]; then
      ReXYZ1=yz
   else
      echo "The script only works with Re xx/yy/zz/xy/xz/yz in $INOP."
      echo "  Your choice is inconsistant with the script. Aborted!"
      echo ""
      exit  
   fi

   if [[ $ReVtwo == 1 ]]; then
      ReXYZ2=xx
   elif [[ $ReVtwo == 2 ]]; then
      ReXYZ2=yy
   elif [[ $ReVtwo == 3 ]]; then
      ReXYZ2=zz
   elif [[ $ReVtwo == 4 ]]; then
      ReXYZ2=xy
   elif [[ $ReVtwo == 5 ]]; then
      ReXYZ2=xz
   elif [[ $ReVtwo == 6 ]]; then
      ReXYZ2=yz
   else
      echo "The script only works with Re xx/yy/zz/xy/xz/yz in $INOP."
      echo "  Your choice is inconsistant with the script. Aborted!"
      echo ""
      exit  
   fi

   if [[ $ReVthree == 1 ]]; then
      ReXYZ3=xx
   elif [[ $ReVthree == 2 ]]; then
      ReXYZ3=yy
   elif [[ $ReVthree == 3 ]]; then
      ReXYZ3=zz
   elif [[ $ReVthree == 4 ]]; then
      ReXYZ3=xy
   elif [[ $ReVthree == 5 ]]; then
      ReXYZ3=xz
   elif [[ $ReVthree == 6 ]]; then
      ReXYZ3=yz
   else
      echo "The script only works with Re xx/yy/zz/xy/xz/yz in $INOP."
      echo "  Your choice is inconsistant with the script. Aborted!"
      echo ""
      exit  
   fi

else
	echo "The script only works with number of column = 1/2/3 in $INOP."
	echo "Your choice is inconsistant with the script. Aborted!"
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

set border lw 3
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



######################### 11111111

if [[ $noCOLUMN == 1 ]]; then  


# plot eloss
FILE='eloss'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Electron energy loss (arb. units)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title '$FILE\_$ReXYZ'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title '$FILE\_$ReXYZ'" >> gplot.gnu
gnuplot < gplot.gnu

# plot epsilon REAL
FILE='epsilon'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_$FILE\_$ReXYZ'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_$FILE\_$ReXYZ'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon IMAGINARY
FILE='epsilon'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_$FILE\_$ReXYZ'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_$FILE\_$ReXYZ'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL
FILE='sigmak'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.RE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_$ReXYZ'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.RE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_$ReXYZ'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity IMAGINARY
FILE='sigmak'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.IM.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_$ReXYZ'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.IM.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_$ReXYZ'" >> gplot.gnu
gnuplot < gplot.gnu


# plot refraction 
FILE='refraction'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Refractive index'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_$ReXYZ'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_$ReXYZ'" >> gplot.gnu
gnuplot < gplot.gnu


#################################################################################

# plot extinction coefficient | refraction 
FILE='refraction'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Extinction coefficient'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.extinct.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'ref\_ind\_$ReXYZ1'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.extinct.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'ref\_ind\_$ReXYZ1'" >> gplot.gnu
gnuplot < gplot.gnu


#################################################################################

# plot reflectivity 
FILE='reflectivity'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Optical reflectivity'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_$ReXYZ'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_$ReXYZ'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL in [1 / (Ohm cm)] unit **from absorp**
FILE='absorp'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (1/(Ohm-cm))'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_$ReXYZ'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_$ReXYZ'" >> gplot.gnu
gnuplot < gplot.gnu


# plot absorption coefficient
FILE='absorp'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Absorption coefficient (10^4/cm)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title '$FILE\_$ReXYZ'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title '$FILE\_$ReXYZ'" >> gplot.gnu
gnuplot < gplot.gnu


######################### 11111111

elif [[ $noCOLUMN == 2 ]]; then 

######################### 22222222


# plot eloss
FILE='eloss'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Electron energy loss (arb. units)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title '$FILE\_$ReXYZ1', \
		''	 u 1:3 w l title '$FILE\_$ReXYZ2'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title '$FILE\_$ReXYZ1', \
		''	 u 1:3 w l title '$FILE\_$ReXYZ2'" >> gplot.gnu
gnuplot < gplot.gnu

# plot epsilon REAL
FILE='epsilon'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_$FILE\_$ReXYZ1', \
		''	 u 1:4 w l title 'Re\_$FILE\_$ReXYZ2'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_$FILE\_$ReXYZ1', \
		''	 u 1:4 w l title 'Re\_$FILE\_$ReXYZ2'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon IMAGINARY
FILE='epsilon'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_$FILE\_$ReXYZ1', \
		''	 u 1:5 w l title 'Im\_$FILE\_$ReXYZ2'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_$FILE\_$ReXYZ1', \
		''	 u 1:5 w l title 'Im\_$FILE\_$ReXYZ2'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL
FILE='sigmak'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.RE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_$ReXYZ1', \
		''	 u 1:4 w l title 'Re\_sigma\_$ReXYZ2'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.RE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_$ReXYZ1', \
		''	 u 1:4 w l title 'Re\_sigma\_$ReXYZ2'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity IMAGINARY
FILE='sigmak'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.IM.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_$ReXYZ1', \
		''	 u 1:5 w l title 'Im\_sigma\_$ReXYZ2'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.IM.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_$ReXYZ1', \
		''	 u 1:5 w l title 'Im\_sigma\_$ReXYZ2'" >> gplot.gnu
gnuplot < gplot.gnu


# plot refraction 
FILE='refraction'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Refractive index'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_$ReXYZ1', \
		''	 u 1:3 w l title 'ref\_ind\_$ReXYZ2'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_$ReXYZ1', \
		''	 u 1:3 w l title 'ref\_ind\_$ReXYZ2'" >> gplot.gnu
gnuplot < gplot.gnu

#################################################################################

# plot extinction coefficient | refraction 
FILE='refraction'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Extinction coefficient'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.extinct.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:4 w l title 'ref\_ind\_$ReXYZ1', \
		''	 u 1:5 w l title 'ref\_ind\_$ReXYZ2'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.extinct.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:4 w l title 'ref\_ind\_$ReXYZ1', \
		''	 u 1:5 w l title 'ref\_ind\_$ReXYZ2'" >> gplot.gnu
gnuplot < gplot.gnu


#################################################################################


# plot reflectivity 
FILE='reflectivity'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Optical reflectivity'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_$ReXYZ1', \
		''	 u 1:3 w l title 'reflect\_$ReXYZ2'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_$ReXYZ1', \
		''	 u 1:3 w l title 'reflect\_$ReXYZ2'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL in [1 / (Ohm cm)] unit **from absorp**
FILE='absorp'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (1/(Ohm-cm))'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_$ReXYZ1', \
		''	 u 1:3 w l title 'Re\_sigma\_$ReXYZ2'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_$ReXYZ1', \
		''	 u 1:3 w l title 'Re\_sigma\_$ReXYZ2'" >> gplot.gnu
gnuplot < gplot.gnu


# plot absorption coefficient
FILE='absorp'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Absorption coefficient (10^4/cm)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:4 w l title '$FILE\_$ReXYZ1', \
		''	 u 1:5 w l title '$FILE\_$ReXYZ2'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:4 w l title '$FILE\_$ReXYZ1', \
		''	 u 1:5 w l title '$FILE\_$ReXYZ2'" >> gplot.gnu
gnuplot < gplot.gnu

######################### 22222222 

elif [[ $noCOLUMN == 3 ]]; then 

######################### 33333333


# plot eloss
FILE='eloss'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Electron energy loss (arb. units)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title '$FILE\_$ReXYZ1', \
		''	 u 1:3 w l title '$FILE\_$ReXYZ2', \
		''	 u 1:4 w l title '$FILE\_$ReXYZ3'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title '$FILE\_$ReXYZ1', \
		''	 u 1:3 w l title '$FILE\_$ReXYZ2', \
		''	 u 1:4 w l title '$FILE\_$ReXYZ3'" >> gplot.gnu
gnuplot < gplot.gnu

# plot epsilon REAL
FILE='epsilon'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_$FILE\_$ReXYZ1', \
		''	 u 1:4 w l title 'Re\_$FILE\_$ReXYZ2', \
		''	 u 1:6 w l title 'Re\_$FILE\_$ReXYZ3'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.RE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_$FILE\_$ReXYZ1', \
		''	 u 1:4 w l title 'Re\_$FILE\_$ReXYZ2', \
		''	 u 1:6 w l title 'Re\_$FILE\_$ReXYZ3'" >> gplot.gnu
gnuplot < gplot.gnu


# plot epsilon IMAGINARY
FILE='epsilon'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary dielectric tensor'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_$FILE\_$ReXYZ1', \
		''	 u 1:5 w l title 'Im\_$FILE\_$ReXYZ2', \
		''	 u 1:7 w l title 'Im\_$FILE\_$ReXYZ3'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.IM.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_$FILE\_$ReXYZ1', \
		''	 u 1:5 w l title 'Im\_$FILE\_$ReXYZ2', \
		''	 u 1:7 w l title 'Im\_$FILE\_$ReXYZ3'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL
FILE='sigmak'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.RE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_$ReXYZ1', \
		''	 u 1:4 w l title 'Re\_sigma\_$ReXYZ2', \
		''	 u 1:6 w l title 'Re\_sigma\_$ReXYZ3'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.RE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_$ReXYZ1', \
		''	 u 1:4 w l title 'Re\_sigma\_$ReXYZ2', \
		''	 u 1:6 w l title 'Re\_sigma\_$ReXYZ3'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity IMAGINARY
FILE='sigmak'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Imaginary optical conductivity (10^{15}/sec)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity.IM.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_$ReXYZ1', \
		''	 u 1:5 w l title 'Im\_sigma\_$ReXYZ2', \
		''	 u 1:7 w l title 'Im\_sigma\_$ReXYZ3'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity.IM.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:3 w l title 'Im\_sigma\_$ReXYZ1', \
		''	 u 1:5 w l title 'Im\_sigma\_$ReXYZ2', \
		''	 u 1:7 w l title 'Im\_sigma\_$ReXYZ3'" >> gplot.gnu
gnuplot < gplot.gnu


# plot refraction 
FILE='refraction'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Refractive index'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_$ReXYZ1', \
		''	 u 1:3 w l title 'ref\_ind\_$ReXYZ2', \
		''	 u 1:4 w l title 'ref\_ind\_$ReXYZ3'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'ref\_ind\_$ReXYZ1', \
		''	 u 1:3 w l title 'ref\_ind\_$ReXYZ2', \
		''	 u 1:4 w l title 'ref\_ind\_$ReXYZ3'" >> gplot.gnu
gnuplot < gplot.gnu



#################################################################################

# plot extinction coefficient | refraction 
FILE='refraction'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Extinction coefficient'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.extinct.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:5 w l title 'ref\_ind\_$ReXYZ1', \
		''	 u 1:6 w l title 'ref\_ind\_$ReXYZ2', \
		''	 u 1:7 w l title 'ref\_ind\_$ReXYZ3'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.extinct.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:5 w l title 'ref\_ind\_$ReXYZ1', \
		''	 u 1:6 w l title 'ref\_ind\_$ReXYZ2', \
		''	 u 1:7 w l title 'ref\_ind\_$ReXYZ3'" >> gplot.gnu
gnuplot < gplot.gnu


#################################################################################


# plot reflectivity 
FILE='reflectivity'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Optical reflectivity'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_$ReXYZ1', \
		''	 u 1:3 w l title 'reflect\_$ReXYZ2', \
		''	 u 1:4 w l title 'reflect\_$ReXYZ3'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'reflect\_$ReXYZ1', \
		''	 u 1:3 w l title 'reflect\_$ReXYZ2', \
		''	 u 1:4 w l title 'reflect\_$ReXYZ3'" >> gplot.gnu
gnuplot < gplot.gnu


# plot conductivity REAL in [1 / (Ohm cm)] unit **from absorp**
FILE='absorp'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Real optical conductivity (1/(Ohm-cm))'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_$ReXYZ1', \
		''	 u 1:3 w l title 'Re\_sigma\_$ReXYZ2', \
		''	 u 1:4 w l title 'Re\_sigma\_$ReXYZ3'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.conductivity_absorp.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:2 w l title 'Re\_sigma\_$ReXYZ1', \
		''	 u 1:3 w l title 'Re\_sigma\_$ReXYZ2', \
		''	 u 1:4 w l title 'Re\_sigma\_$ReXYZ3'" >> gplot.gnu
gnuplot < gplot.gnu


# plot absorption coefficient
FILE='absorp'
echo "set xlabel 'Energy (eV)'" > gplot.gnu
echo "set ylabel 'Absorption coefficient (10^4/cm)'" >> gplot.gnu

echo "$SETeps" >> gplot.gnu
echo "set output '$NAME.$FILE.eps'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:5 w l title '$FILE\_$ReXYZ1', \
		''	 u 1:6 w l title '$FILE\_$ReXYZ2', \
		''	 u 1:7 w l title '$FILE\_$ReXYZ3'" >> gplot.gnu

echo "$SETpng" >> gplot.gnu
echo "set output '$NAME.$FILE.png'" >> gplot.gnu
echo "plot '$NAME.$FILE' u 1:5 w l title '$FILE\_$ReXYZ1', \
		''	 u 1:6 w l title '$FILE\_$ReXYZ2', \
		''	 u 1:7 w l title '$FILE\_$ReXYZ3'" >> gplot.gnu
gnuplot < gplot.gnu

######################### 33333333 
fi

echo "Done! Images are saved both as *.eps and *.png files." > gplot.gnu
if [[ -s $NAME.$FILE.png ]]; then
   xdg-open $NAME.$FILE.png 
fi
cd ..
du -sh $saveDIR
echo ""
echo "  All done! Check *.eps and *.png files in $saveDIR!!" 
echo " "

# For more sctipts visit https://tiny.cc/w2k​

