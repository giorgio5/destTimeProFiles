 set terminal png
 set output 'multi_graph_NGC_5139_(omega-Cen)   .png'
 set logscale y
 set style data linespoints
 set title 'Time of destabilization in the NGC 5139 (omega-Cen) vs distance from center'
 set xlabel 'r (pc)'
 set ylabel 'time (year)'
 plot "profile_NGC_5139_(omega-Cen)   _1.ris" using 1:2 title "M_{test}=0.1",           \
 "profile_NGC_5139_(omega-Cen)   _2.ris" using 1:2 title "M_{test}=0.2",           \
 "profile_NGC_5139_(omega-Cen)   _3.ris" using 1:2 title "M_{test}=0.3",           \
 "profile_NGC_5139_(omega-Cen)   _4.ris" using 1:2 title "M_{test}=0.4",           \
 "profile_NGC_5139_(omega-Cen)   _5.ris" using 1:2 title "M_{test}=0.5",           \
 "profile_NGC_5139_(omega-Cen)   _6.ris" using 1:2 title "M_{test}=0.6",           \
 "profile_NGC_5139_(omega-Cen)   _7.ris" using 1:2 title "M_{test}=0.7",           
