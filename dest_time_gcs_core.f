      program dest_time_gcs_core
      implicit none

      integer i_m,k0,k2,k3,i_clu,i_clu_max,i_bh,control_number
      
      dimension m_test_sm(7)
           data m_test_sm/0.1,0.2,0.3,0.4,0.5,0.6,0.7/
c                         1   2   3   4   5   6   7
            dimension m_bh_sm(6)
           data m_bh_sm/500.,1000.,1500.,2000.,2500.,5000./
c                         1   2     3     4     5     6   
      dimension t_bh(6)
           data t_bh/0.,0.,0.,0.,0.,0./
c                           1  2  3  4  5  6   
      
      real*8  km,sm,ggg,au,yr,pi,pc,dist_sun
      real*8  m_tot,m_test,m_test_sm,m_tot_sm,m_mean_sm,m_mean,m_bh_sm
      real*8  r_half_m,orb_r,r_half_m_pc,orb_r_au,dest
      real*8  rest_time_half_mr,res_time_ns,t_bh,time,time_yr
            
  
      
      character*12 b12
      character*9 b9
      character*6 b6
      character*4 b4
      character*35 fmt5 
      character*82 fmt6

      character*24 namecluster
     
      
c common blocks      
      common /a/ km,sm,ggg,au,yr,pi
      common /b/ pc,dist_sun
      
c     declaration of function names      
      real*8 time_destf,time_dest_ns,t_d_bh,rto_cm     

c      initialization of constants   
  
       km = 1.d5     ! km in  cm
       sm  = 1.99d33 ! solarmass in gr
       pc  = 3.09d18 ! parsec in cm
       ggg = 6.67d-8 ! gravitational constant in  dyne cm**2/g
       au  = 1.5d13  ! astronomical unit in cm
       yr  = 3.2d7   ! year in s
       pi=4*atan(1.0)! pi greco constant
              
  2     format (f6.2,a4,f4.2) 
  3     format (f6.2)     
  7     format (a23,f6.2,a12,f6.2,a9,f5.2,a6,f4.2) ! format of parameters 
  
c     open files of parameters and the other file_rv: in the
c     file of parameters there are 166 clusters but in file_rv there 
c     are less globular clusters, before doing profile we need to check 
c     if namecluster_s present in parameter file mathces with 
c     namecluster_read present in the file_rv
          
      open(unit=0, file='BaumgardtGlobularParameter_comp.dat', 
     & action='read', status='old',iostat= k0)
      
      if (k0 .ne. 0) then 
       write (*,*) "BaumgardtGlobularParameter.dat cannot be opened"
      end if
     
c     in this file unit=2 put the resulting time calculated in years for core radius
c     ns and bh for every cluster in format 5 (see the connection with 
c     using a format Fortran 77 with gnuplot library)
      
      open(unit=2,file='resultsGC_half_mass_NSs.ris',action='write'
     & ,status='replace')
      write(2,*)"# result of dest_time(yr) for core and NS"
      write(2,*)"# namecluster,m_test(sm), dest_time_core, dest_time_NS"
      write(2,*)"#"
      
c     in this file unit=3 put the resulting time calculated in years for core radius
c     ns and bh for every cluster in format 6 (see the connection with 
c     using a format Fortran 77 with gnuplot library)

      open(unit=3,file='resultsGCs_bh.ris',action='write',
     & status='replace')
      write(3,*)"# dest_time(yr) for bh in centre"
      write(3,*)"# m_test(sm),m_bh =500,1000, 1500, 2000, 2500, 5000 sm"
      
      i_clu_max = 166
      !the total number of clusters in par file!
      i_clu = 0 

      read(0,*) ! skip the first line in the par file      
      
  55  continue ! until loop for par file
      
      i_clu = i_clu +1 
      
      read(0, fmt=7) namecluster,
     & dist_sun,b12,m_tot_sm,b9,r_half_m_pc,b6,m_mean_sm
       
      read(0,*) control_number
       if(control_number .eq. 0) then 
       print *,"ci sono solo quantità del core per il cluster corrente"
       print *,namecluster
       endif
         
      write(*,*) "namecluster ",namecluster
      write(*,*) "total mass in solar masses =",m_tot_sm
      write(*,*) "distance from sun in kpc =",dist_sun
      write(*,*) "half mass radius in pc = ",r_half_m_pc
      write(*,*) "mean mass in solar masses =",m_mean_sm
      
      r_half_m = r_half_m_pc * pc
      m_tot    = m_tot_sm * sm
      
     
      write(3,*) "#"
      write(3,*) "# for cluster:  ", namecluster
      write(2,*) "#"
      
      do 13 i_m = 1,7 ! do loop for i_m
      
      
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
      m_test = m_test_sm(i_m) * sm
      
c calculus of time of destabilization for half mass radius
      
      time = time_destf(dest,m_tot_sm,r_half_m,m_mean_sm,m_test)
      time_yr = time/yr 
      rest_time_half_mr = time_yr
      
      time = time_dest_ns(dest,m_tot,r_half_m,m_mean_sm,m_test)
      time_yr = time/yr 
      res_time_ns = time_yr
      
      
      write(2,*)"#namecluster, m_test(sm), dets_time_core, dest_time_NS"
      
      fmt5 = "(a24,a4,f3.1,a4,es9.2e2,a4,es9.2e2)"  
c             12345678901234567890123456789012345
      b12 = "            "
      b4 = "    " 
      
      write(2,fmt =fmt5) namecluster,b4,m_test_sm(i_m),b4,
     & rest_time_half_mr,b4,res_time_ns
      
      fmt6 =  "(f3.1,a4,es9.2e2,a4,es9.2e2,a4,es9.2e2,a4,es9.2e2,a4,es9.
     + 2e2,a4,es9.2e2)"  
c              123456789012345678901234567890123456789012345678901234567
c     8901232456789012
      
      
      !filling t_bh array
      do i_bh =1,6
      t_bh(i_bh)=t_d_bh(m_tot,r_half_m,m_bh_sm(i_bh),m_test_sm(i_m))/yr
      enddo
      
      write(3,*)"# m_test(sm),m_bh =500,1000, 1500, 2000, 2500, 5000 sm"
      write(3,fmt =fmt6) m_test_sm(i_m),b4,t_bh(1),b4,t_bh(2),b4,t_bh(3)
     + ,b4,t_bh(4),b4,t_bh(5),b4,t_bh(6)
                
  13  continue ! do loop for i_m = 1, 7
      
      if((k0 .eq. 0) .and. (i_clu .lt. i_clu_max)) then
      go to 55 !until loop 55
      elseif (i_clu .eq. i_clu_max) then 
      print *, "ho finito tutti i clusters! , i_clu_tot:", i_clu
      else  
      go to 55 !until loop 55
      endif
      
  66  close(0)
      close(2)
      close(3)
     
      end program dest_time_gcs_core
      


c=====================================================================
c functions and subroutines

c calculus of time of destabilization for core radius   
      real*8 function time_destf(df,m_totsm_f,r_cor_f,mean_mfsm,mtestf)
      implicit none
      real*8  km,sm,ggg,au,yr,pi
      common /a/ km,sm,ggg,au,yr,pi
      
      real*8 df,m_totsm_f,r_cor_f,mean_mfsm,mtestf
      real*8 v_quad_f, v_mean_f, d_core_f, focusg_f, m_tot_f
      
      m_tot_f = m_totsm_f*sm
      v_quad_f    = m_tot_f * ggg/(6 * r_cor_f)
      v_mean_f  = sqrt(v_quad_f)
      d_core_f = 3*m_totsm_f/(8*mean_mfsm*pi*r_cor_f**3)
      focusg_f  = (df**2 + (ggg * mtestf *df)/v_quad_f)
      time_destf = 1/(4*sqrt(pi)*v_mean_f*d_core_f*focusg_f) 
      return
      end 

c this function yelds the time of destabilization for a star mass
c with mass = m_test due to about 100 neutron stars of mass m = 1.4 sm
c in the core of the cluster: ref Hills&Day(1976)
      real*8 function time_dest_ns(df,m_tot_f,r_cor_f,mean_mfsm,mtestf)
      implicit none
      real*8  km,sm,ggg,au,yr,pi
      common /a/ km,sm,ggg,au,yr,pi
      
      real*8 df,m_tot_f,r_cor_f,mean_mfsm,mtestf
      real*8 v_quad_f,v_mean_f,v_mean_ns,d_core_ns
      real*8 crossec0, l, v_inf_quad, gamma, vol
     
      v_quad_f  = m_tot_f * ggg/(6 * r_cor_f)
      v_mean_f  = sqrt(v_quad_f)
      vol = (4/3)*pi*(r_cor_f**3)
      d_core_ns = 100/vol
      l = (sqrt(1.4/(2*(mean_mfsm + 1.4))))/v_mean_f
      v_inf_quad = 2*ggg*(mtestf + 1.4*sm)/df
      crossec0 = pi*(df**2)
      gamma = 2*l*crossec0*(1/(l**2) + v_inf_quad)/sqrt(pi)
      time_dest_ns = 1/(d_core_ns*gamma)
      return
      end 
      
c function for conversion from '' to cm
      real*8 function rto_cm (rf)
      implicit none
      real*8 rf,pc,dist_sun
      common /b/ pc,dist_sun
      rto_cm = rf*dist_sun*1000*pc/206265 ! conversion from '' to cm
      return
      end
      
c these function and subroutine yeld the time of destabilization for a star mass
c with mass = m_test due to a IMBH at the centre of cluster
c of mass m_bh = 500, 1000, 1500, 2000, 2500, 5000 sm
c in the core of the cluster: ref Hills&Day(1976),  Peebles(1972)
c for r_inf     
  
      real*8 function t_d_bh(m_tot_f,r_cor_f,m_bh_smf,m_test_smf)
      implicit none
      real*8  km,sm,ggg,au,yr,pi
      common /a/ km,sm,ggg,au,yr,pi
      
      
      real*8 m_tot_f,r_cor_f,m_bh_smf,m_test_smf
      real*8 v_quad_f,v_mean_f,d_core_bh,r_inf
      real*8 crossec0,l,v_inf_quad,gamma,vol
      
      ! il parametro d'impatto b_0 o r_coll stavolta è r_inf
      v_quad_f  = m_tot_f*ggg/(6 * r_cor_f)
      r_inf =  m_bh_smf*sm*ggg/v_quad_f
      v_mean_f  = sqrt(v_quad_f)
      vol = (4/3)*pi*(r_cor_f**3)
      d_core_bh = 1/vol
      l = (sqrt(m_bh_smf/(2*(m_test_smf + m_bh_smf))))/v_mean_f
      v_inf_quad = 2*ggg*sm*(m_test_smf + m_bh_smf)/r_inf
      crossec0 = pi*(r_inf**2)
      gamma = 2*l*crossec0*(1/(l**2) + v_inf_quad)/sqrt(pi)
      t_d_bh = 1/(d_core_bh*gamma)
      return
      end 
      
