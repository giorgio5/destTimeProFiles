 set terminal png
 set output 'multi_graph_NGC_6809_(M-55)        .png'
 set logscale y
 set style data linespoints
 set title 'Time of destabilization in the NGC 6809 (M-55) vs distance from center'
 set xlabel 'r (pc)'
 set ylabel 'time (year)'
 plot "profile_NGC_6809_(M-55)        _1.ris" using 1:2 title "M_{test}=0.1",           \
 "profile_NGC_6809_(M-55)        _2.ris" using 1:2 title "M_{test}=0.2",           \
 "profile_NGC_6809_(M-55)        _3.ris" using 1:2 title "M_{test}=0.3",           \
 "profile_NGC_6809_(M-55)        _4.ris" using 1:2 title "M_{test}=0.4",           \
 "profile_NGC_6809_(M-55)        _5.ris" using 1:2 title "M_{test}=0.5",           \
 "profile_NGC_6809_(M-55)        _6.ris" using 1:2 title "M_{test}=0.6",           \
 "profile_NGC_6809_(M-55)        _7.ris" using 1:2 title "M_{test}=0.7",           
