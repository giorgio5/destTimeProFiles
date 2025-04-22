 set terminal png
 set output 'multi_graph_Pyxis                  .png'
 set logscale y
 set style data linespoints
 set title 'Time of destabilization in the Pyxis                   vs distance from center'
 set xlabel 'r (pc)'
 set ylabel 'time (year)'
 plot "profile_Pyxis                  _1.ris" using 1:2 title "M_{test}=0.1",           \
 "profile_Pyxis                  _2.ris" using 1:2 title "M_{test}=0.2",           \
 "profile_Pyxis                  _3.ris" using 1:2 title "M_{test}=0.3",           \
 "profile_Pyxis                  _4.ris" using 1:2 title "M_{test}=0.4",           \
 "profile_Pyxis                  _5.ris" using 1:2 title "M_{test}=0.5",           \
 "profile_Pyxis                  _6.ris" using 1:2 title "M_{test}=0.6",           \
 "profile_Pyxis                  _7.ris" using 1:2 title "M_{test}=0.7",           
