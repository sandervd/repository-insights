set xdata time
set xtics rotate by 60 right
set timefmt "%Y-%m-%d"
set format x "%m-%Y"
#set key left top
set terminal svg size 500,200 dynamic rounded
set xrange [*:today]
plot commits using 1:2 with lines smooth sbezier t "Commits" lw 2 lt -1
