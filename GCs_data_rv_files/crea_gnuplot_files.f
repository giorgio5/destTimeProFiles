c234567
      program crea_gnuplot_files
      
      implicit none
      integer k0,k157,k_iu,i_u,iclu_tot,i_m ! i_m deve andare in un ciclo
                                      
      character*23 namecluster
      character*41 namefile_gnu ! quelli del namecluster + 18
      character*37 namefile_ris ! quelli del namecluster + 14
      character*1  string1
      character*82 stringa_riga ! quelli del namefile_ris + 45
      
      iclu_tot = 155 ! numero totale dei cluster che hanno un profilo rv
      i_u = 0 !il nome dell'unità va da 1 a 155
      
c                    12345678901234567890123
      namecluster = "                       "
      open(unit = 0, file='lista_nomi_per_gnuplot_files.txt', 
     & action='read', status='old',iostat= k0)
      open(unit = 157, file='lista_comandi_gnuplot.gnu', 
     & action='write', status='replace',iostat= k157)
      
  55  continue
      i_u = i_u + 1  
      print*, i_u
      if (i_u .gt. iclu_tot) go to 77
      read(0,*) namecluster
      
      namefile_gnu = 'plot_multipli_'//namecluster//'.gnu'
      
      open(unit=i_u,file=namefile_gnu,action='write',status='replace'
     & ,iostat= k_iu)
     
      if (k_iu .ne. 0) then 
       write(*,*) "solve the problem with the cluster name",namecluster
       write(*,*) "the file", namefile_gnu, "cannot be opened"
       stop
      endif
      
  
      write(i_u,*)"set terminal png"
      write(i_u,*)"set output 'multi_graph_"//namecluster//".png'"
      write(i_u,*)"set logscale y"
      write(i_u,*)"set style data linespoints"
      write(i_u,*)"set title 'Time of destabilization in the ",
     & namecluster ," vs distance from center'"
      write(i_u,*)"set xlabel 'r (pc)'"
      write(i_u,*)"set ylabel 'time (year)'"
      
      string1 ="1"
      namefile_ris = 'profile_'//namecluster//'_'//string1//'.ris'
       
c     8901   2         345           12        3456789012345678901234567
       stringa_riga = '"'//namefile_ris//'"'//' using 1:2 title "M_{test
     +}=0.'//string1//'", '
     
      write(i_u,*)"plot ",stringa_riga,"\"
      
       do 66 i_m = 2, 6
       string1 = char(48 + i_m)
       namefile_ris = 'profile_'//namecluster//'_'//string1//'.ris'

c     8901   2         345           12        3456789012345678901234567
       stringa_riga = '"'//namefile_ris//'"'//' using 1:2 title "M_{test
     +}=0.'//string1//'", '
     
       write(i_u,*)stringa_riga,"\"
       
  66  continue     
  
      string1 ="7"
      namefile_ris = 'profile_'//namecluster//'_'//string1//'.ris'
       
c     8901   2         345           12        3456789012345678901234567
       stringa_riga = '"'//namefile_ris//'"'//' using 1:2 title "M_{test
     +}=0.'//string1//'", '
      write(i_u,*)stringa_riga
      
      close(i_u)
      write(157,*)"load '",namefile_gnu,"'"
      if(k0==0) go to 55
      
  77  print*, "ho finito tutti i 155 clusters!"  
      write(*,*) "i_u = ", i_u
      close(0)
      close(157)
      
       
      end program crea_gnuplot_files
    
