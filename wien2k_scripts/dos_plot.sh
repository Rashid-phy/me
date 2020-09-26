##################################################
#                                                #
#   Sample gnuplot script by Dr. Rashid @ 2020   #
#                                                # 
##################################################

set	linetype	1	linewidth	3	lc	rgb	"blue"		
set	linetype	2	linewidth	3	lc	rgb	"forest-green"	
set	linetype	3	linewidth	3	lc	rgb	"dark-violet"
set	linetype	4	linewidth	3	lc	rgb	"cyan"
set	linetype	5	linewidth	3	lc	rgb	"dark-red"		
set	linetype	6	linewidth	3	lc	rgb	"dark-orange"
set	linetype	7	linewidth	3	lc	rgb	"goldenrod"
set	linetype	8	linewidth	3
set	linetype	cycle	8


set term png enhanced size 1000,800 font "Times-Roman, 20"
set output "dos_plot.png"

#set multiplot

#set xzeroaxis
#set yzeroaxis

#set xrange [:] noextend
#set xrange [-6:7]
#set yrange [0:16]
#set yrange [-17:17]

set xlabel "Energy (eV)"
set ylabel "DOS(States/eV)"

plot    "test.dos1ev" using 1:2 title "total DOS"  w l 
#replot  "test.dos1ev" using 1:3 title "Ti tot"     w l 
#replot  "test.dos1ev" using 1:6 title "Ti d"       w l 
#replot  "test.dos1ev" using 1:7 title "O tot"      w l 
#replot  "test.dos2ev" using 1:2 title "O p"        w l 


#plot "test.dos1ev" using 1:2     title "up spin"   w l, \
#     "test.dos1ev" using 1:(-$2) title "down spin" w l 

#plot   "test.dos1ev" using 1:2     title "up spin"   w l
#replot "test.dos1ev" using 1:(-$2) title "down spin" w l 

#replot  "test.dos1ev" using 1:(0) 	notitle w d

unset multiplot

set term postscript eps enhanced color font "Times-Roman, 20"
set output "dos_plot.eps"
replot




