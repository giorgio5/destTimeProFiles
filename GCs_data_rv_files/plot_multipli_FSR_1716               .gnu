 set terminal png
 set output 'multi_graph_FSR_1716               .png'
 set logscale y
 set style data linespoints
 set title 'Time of destabilization in the FSR 1716 vs distance from center'
 set xlabel 'r (pc)'
 set ylabel 'time (year)'
 plot "profile_FSR_1716               _1.ris" using 1:2 title "M_{test}=0.1",           \
 "profile_FSR_1716               _2.ris" using 1:2 title "M_{test}=0.2",           \
 "profile_FSR_1716               _3.ris" using 1:2 title "M_{test}=0.3",           \
 "profile_FSR_1716               _4.ris" using 1:2 title "M_{test}=0.4",           \
 "profile_FSR_1716               _5.ris" using 1:2 title "M_{test}=0.5",           \
 "profile_FSR_1716               _6.ris" using 1:2 title "M_{test}=0.6",           \
 "profile_FSR_1716               _7.ris" using 1:2 title "M_{test}=0.7",           
