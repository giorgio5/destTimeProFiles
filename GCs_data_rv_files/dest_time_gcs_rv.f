      program dest_time_gcs_rv
      implicit none
      
      real*8  km,sm,ggg,au,yr,pi,pc,dist_sun
      real*8  m_tot,m_test,m_test_sm,m_tot_sm,m_mean_sm,m_mean,m_bh_sm
      real*8  r_half_m,orb_r,r_half_m_pc,orb_r_au,dest
      real*8  time,time_yr,r,v,time_r,time_yr_r,r_cm 
      
      
      character*23 namecluster
      character*37 namefile_ris
      character*35 namefile_rv
      character*12 b12
      character*9 b9
      character*6 b6
c      character*35 fmt5 
c      character*81 fmt6
      character*1 string1
  
      common /a/ km,sm,ggg,au,yr,pi
      common /b/ pc,dist_sun
      
      integer i_m,k0,i_clu_par,i_clu_rv,i_clu_par_tot,i_clu_rv_tot
      integer control_number,k_iclu,i_u,ki_u
     
      dimension m_test_sm(7)
           data m_test_sm/0.1,0.2,0.3,0.4,0.5,0.6,0.7/
c                         1   2   3   4   5   6   7
      
      
c     declaration of function names      
      real*8 time_dest_r,rto_cm
c234567      
      
      open(unit=0, file='BaumgardtGlobularParameter.dat', 
     & action='read', status='old',iostat= k0)
     
       km  = 1.d5    ! km in  cm
       sm  = 1.99d33 ! solarmass in gr
       pc  = 3.09d18 ! parsec in cm
       ggg = 6.67d-8 ! gravitational constant in  dyne cm**2/g
       au  = 1.5d13  ! astronomical unit in cm
       yr  = 3.2d7   ! year in s
       pi=4*atan(1.0)! pi greco constant
       
       
     
  4     format (f6.2,a4,f18.2)  
  7     format (a23,f6.2,a12,f6.2,a9,f5.2,a6,f4.2) ! format of parameters 
      
  
c     open files of parameters and the other file_rv: in the
c     file of parameters there are 166 clusters but in file_rv there 
c     are less globular clusters, before doing profile we need to check 
c     if namecluster_s present in parameter file mathces with 
c     namecluster_read present in the file_rv
      
      open(unit=0, file='BaumgardtGlobularParameter.dat', 
     & action='read', status='old',iostat= k0)
    
      if (k0 .ne. 0) then 
      write (*,*) 'BaumgardtGlobularParameter.dat cannot be opened'
      end if
      
      i_clu_rv_tot = 155
      !the total number of clusters having a rv profile
      i_clu_par_tot = 166
      !the total number of clusters in par file
      
      i_clu_par = 1 ! starts from 1  
      i_clu_rv = 0
      
      read(0,*) ! skip the first line
            
c234567     
  55  continue ! until loop
      
      read(0, fmt=7) namecluster,
     & dist_sun,b12,m_tot_sm,b9,r_half_m_pc,b6,m_mean_sm
      read(0,*) control_number   
     
      i_clu_par = i_clu_par + 1 
                              
      if (control_number .eq. 0) then 
       write (*,*) "for the cluster:", namecluster
       write (*,*) "the rv_file.dat doesn't exist!, so I continue from"
       write (*,*) "the subsequent cluster in par file"
       go to 55
      end if 
      
      i_clu_rv = i_clu_rv + 1 ! the num in the read_rv unit is the same
c234567                       ! i_clu_rv

      write(*,*) "namecluster ",namecluster
      write(*,*) "total mass in solar masses =",  m_tot_sm
      write(*,*) "core radius in pc = ", r_half_m_pc
      write(*,*) "mean mass in solar masses =",m_mean_sm
      write(*,*) "distance from sun in kpc =",dist_sun
     
      r_half_m = r_half_m_pc * pc
      m_tot    = m_tot_sm * sm
      m_mean   = m_mean_sm * sm
      
      do 77 i_m = 1,7 
      
      write(*,*)
      write(*,*) "for i_m =", i_m
      write(*,*)
      
      i_u = 155 + (i_clu_par -1)*7 + i_m ! files in output
c234567      
      string1 = char(i_m + 48)
      
c    because in ascii table numbers start from 48 
      
      namefile_rv ='data_rv_'//namecluster//'.dat'
      
      open(unit=i_clu_rv,file=namefile_rv,action='read',status='old'
     &  ,iostat= k_iclu)
    
        if (k_iclu .ne. 0) then 
         write (*,*) namefile_rv, "cannot be opened"
         write (*,*) "solve the namefile_rv problem!"
         stop
        end if
        
      namefile_ris= 'profile_'//namecluster//'_'//string1//'.ris'
c234567
      open (unit=i_u,file=namefile_ris,status='replace', action='write',
     & iostat= ki_u)
     
      m_test = m_test_sm(i_m)*sm
      
        if (ki_u .ne. 0) then 
         write (*,*) namefile_ris, "cannot be opened"
         write (*,*) "solve the namefile_ris problem!"
         stop
        end if
c234567      
      write(i_u,*) "# The time vs radius profile for the" 
      write(i_u,*) "# globular cluser :", namecluster
      write(i_u,*) "# for mass star test (sm) =", m_test_sm(i_m) 
      write(i_u,*) "#"
   
c in order to the article of F. Selsis et al. 2007 the orbital radius
c changes with the mass of the star test
      
      if (i_m == 1 ) orb_r_au   = 0.04
      if (i_m == 2 ) orb_r_au   = 0.09
      if (i_m == 3 ) orb_r_au   = 0.15
      if (i_m == 4 ) orb_r_au   = 0.20
      if (i_m == 5 ) orb_r_au   = 0.25
      if (i_m == 6 ) orb_r_au   = 0.30
      if (i_m == 7 ) orb_r_au   = 0.45
      
      orb_r   = orb_r_au * au 
      dest = orb_r * (2*m_mean_sm/m_test_sm(i_m))**(1./3.)
   
      write(i_u,*) "#  for generic radii"
      write(i_u,*) "#  radius(pc) time (year)"
         
      
c calculus of the time of destabilization of an orbital planet traiectory
c from the data presents on the online database 
c https://people.smp.uq.edu.au/HolgerBaumgardt/globular/veldis.html
c put in the files: <namefile_rv>.dat

      read (i_clu_rv,*) !skip the first line (title) before 66 loop
      
      do 66
      read (i_clu_rv,*) r,v ! r in arcsec and v in km/s
      
      if(r == 0 .or. v == 0 ) go to 88
      
      r_cm = rto_cm(r)
      time_r = time_dest_r(dest,r_cm,v,m_test,m_mean)
      time_yr_r = time_r/yr 
      
      write(unit=i_u,fmt =4) r_cm/pc,'    ', time_yr_r 
 
  66  continue 
  
  88  close(i_u)
      close(i_clu_rv)
      write(*,*)
      write(*,*) "ho chiuso il file ris =",namefile_ris
      write(*,*) "dell'unità", i_u
      write(*,*) "ho chiuso il file rv.dat =",namefile_rv
      write(*,*) "dell'unità i_clu_rv =", i_clu_rv
      write(*,*)
  77  continue
  
      if((k0 .eq. 0) .and. (i_clu_par .lt. i_clu_par_tot)) then 
      go to 55
      else 
      close(0)
      write(*,*) "ho finito tutti i cluster nel par file"
      write(*,*) "i_clu_par =", i_clu_par
      write(*,*) "i_clu_rv  =", i_clu_rv
      endif
      
      end program dest_time_gcs_rv
      


c=====================================================================
c functions and subroutines

c function for conversion from '' to cm
      real*8 function rto_cm (rf)
      implicit none
      real*8 rf,pc,dist_sun
      common /b/ pc,dist_sun
      rto_cm = rf*dist_sun*1000*pc/206265 ! conversion from '' to cm
      return
      end 
      
      
c calculus of time of destabilization for generic radius
      real*8 function time_dest_r(destf,r_cmf,vf,m_testf,m_meanf)
      implicit none
      real*8  km,sm,ggg,au,yr,pi
      common /a/ km,sm,ggg,au,yr,pi
      
      real*8 destf,r_cmf,vf,m_testf,m_meanf
      real*8 v_cm,m_r,d_r,v_quad_r,focusg_r
      
      v_cm = km*vf !conversion in cm/s
      
      m_r = (r_cmf)*6*(v_cm**2)/ggg
   
      v_quad_r = v_cm**2
      d_r = 3*m_r/(8*m_meanf*pi*r_cmf**3) !density at r
      focusg_r  = (destf**2 + (ggg*m_testf*destf)/v_quad_r)
      time_dest_r = 1/(4*sqrt(pi)*v_cm*d_r*focusg_r) 
      return
      end 

