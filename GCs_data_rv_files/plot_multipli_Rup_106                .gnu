 set terminal png
 set output 'multi_graph_Rup_106                .png'
 set logscale y
 set style data linespoints
 set title 'Time of destabilization in the Rup_106                 vs distance from center'
 set xlabel 'r (pc)'
 set ylabel 'time (year)'
 plot "profile_Rup_106                _1.ris" using 1:2 title "M_{test}=0.1",           \
 "profile_Rup_106                _2.ris" using 1:2 title "M_{test}=0.2",           \
 "profile_Rup_106                _3.ris" using 1:2 title "M_{test}=0.3",           \
 "profile_Rup_106                _4.ris" using 1:2 title "M_{test}=0.4",           \
 "profile_Rup_106                _5.ris" using 1:2 title "M_{test}=0.5",           \
 "profile_Rup_106                _6.ris" using 1:2 title "M_{test}=0.6",           \
 "profile_Rup_106                _7.ris" using 1:2 title "M_{test}=0.7",           
