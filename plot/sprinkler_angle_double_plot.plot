set terminal postscript eps enhanced color "Times-Roman" 22
set output "sprinkler_angle.eps"
set key font ",14" samplen 1

set datafile separator ','

#set xlabel "path [m]"
#set x2label "time [h:min]" offset 0,-0.1
#set ylabel "sprinkler orientation [deg]"

#set xtics nomirror
#set x2tics time format "%tH:%tM" rotate by 20 offset 0,0
set autoscale xfix
#set autoscale x2fix

#plot 'sprinkler_angle.csv' using 2:3 with lines lw 1.5 lt rgb "#0000FF" notitle, \
#     'sprinkler_angle.csv' using ($1):3 axes x2y1 with points pt 7 ps 0.1 notitle

set multiplot layout 2,1 #title "Noise Test"

set lmargin 10   # in order to align with figure on the bottom
set rmargin 3    # in order to align with figure on the bottom
unset xlabel
unset xtics
set ylabel "orientation [deg]"
set yrange [-95:95]
plot "sprinkler_angle.csv" using 1:3 with lines lw 1.5 lt rgb "#0000FF" notitle

set lmargin 10   # in order to align with figure on the bottom
set rmargin 3    # in order to align with figure on the bottom
set xtics time format "%tH:%tM" #rotate by 20 
set xlabel "time [h:m]"
set ylabel "path [m]"
set yrange [0:85]
plot "sprinkler_angle.csv" using 1:2 with lines lw 1.5 lt rgb "#0000FF" notitle

unset multiplot;
