c234567
      program spezza_rv_file
      
      implicit none
      integer k0,k1,i_u
      character*24 namecluster
      character*36 namefile
      real*8 r,v 
      
      i_u = 0
      namecluster = "                        "
      open(unit=0, file='BaumgardtGlobular_rv_mod_copia.dat', 
     & action='read', status='old',iostat= k0)
      open(unit = 167, file='lista_nomi_per_gnuplot_files.txt', 
     & action='write', status='replace',iostat= k1)
      
  55  continue    
      read(0,*) !salta la prima riga o quella dopo gli zeri
      read(0,*) namecluster
      write(167,*) namecluster
      i_u = i_u + 1
      namefile = 'data_rv_'//namecluster//'.dat'
      open(unit=i_u, file=namefile,status='replace',action='write')
      write(i_u,*) namecluster
  66  read(0,*) r,v
      if((r .ne. 0) .and. (v .ne. 0)) then 
       write(i_u,*) r,v 
       go to 66
       else
       write(i_u,*) r,v 
       close(i_u)
       go to 55
      endif
      if(k0==0) go to 55
      close(0)
      close(167)
       
      end program spezza_rv_file
    
