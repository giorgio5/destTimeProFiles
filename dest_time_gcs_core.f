      program dest_time_gcs_core
      implicit none

      integer i_m,k0,k2,k3,i_clu,i_clu_max,i_bh
      integer write_bh_sm ! format i4
      
      dimension m_test_sm(7)
           data m_test_sm/0.1,0.2,0.3,0.4,0.5,0.6,0.7/
c                         1   2   3   4   5   6   7
      dimension m_bh_sm(6)
           data m_bh_sm/500.,1000.,1500.,2000.,2500.,5000./
c                         1   2     3     4     5     6
      dimension write_bh_sm(6)
           data write_bh_sm/500,1000,1500,2000,2500,5000/
c                           1   2     3     4     5     6   

      
      real*8  km,sm,ggg,au,yr,pi,pc,dist_sun
      real*8  m_tot_sm,m_test,m_test_sm,m_mean_sm,m_bh_sm
      real*8  comp_cox, comp_calc
      real*8  orb_r,r_half_m_pc,orb_r_au,dest_au
      real*8  rest_time_half_mr,res_time_ns,res_time_bh,t
       
      character*2 b2
      character*4 b4
      character*20 write_mass_star_test_sm,write_mass_bh_sm
      character*20 write_t_dest_r_hm
      character*15 write_t_dest_bh
      character*30 write_t_dest_r_hm_ns
      character*24 namecluster
     
      
c common blocks      
      common /a/ km,sm,ggg,au,yr,pi,pc

      
c     declaration of function names      
      real*8 t_d_f,t_d_ns,t_bh    

c      initialization of constants   
  
       km = 1.d5     ! km in  cm
       sm  = 1.99d33 ! solarmass in gr
       pc  = 3.09d18 ! parsec in cm
       ggg = 6.67d-8 ! gravitational constant in  dyne cm**2/g
       au  = 1.5d13  ! astronomical unit in cm
       yr  = 3.2d7   ! year in s
       pi=4*atan(1.0)! pi greco constant
       
c      declaration of test string equal for repetitive output   
       b2 = "  "
       b4 = "    "   
       write_mass_star_test_sm = "for mass_test(sm) = "  
c                                 12345678901234567890    a20
       write_mass_bh_sm = "for IMBH mass(sm) = "
c                          12345678901234567890           a20
       write_t_dest_r_hm = "time_dest at r_hm = "    
c                           12345678901234567890          a20

       write_t_dest_r_hm_ns="time_dest at r_hm for 100 NS= "    
c                            123456789012345678901234567890   a30
       write_t_dest_bh ="time_dest_bh = "    
c                        123456789012345                  a15
  1    format (a24,a2,f6.2,a2,f6.2,a2,f5.2,a2,f4.2,a2,f4.2,a2,f4.2) 
  

c 1 is format for  parameters file "BaumgardtGlobularParameter_new.dat"

 
  2    format (a20,f3.1) ! format for write of m_star_test_sm 
  3    format (a20,es16.10e2) ! format for write of time at half
                                 ! mass radius
  4    format (a30,es16.10e2) ! format for write of time at half
                                 ! mass radius for 100 NS
  5    format (a20,i5,a4,a15,es16.10e2) ! format for write of time for a IMBH
                                 ! in the center 

c      open files of parameters : in the file of parameters, namely
c      "BaumgardtGlobularParameter_new.dat", there are 
c      166 clusters but in file_rv, in the subdirectory there are 
c      155 cluster profiles of rms-velocity, so in this program we 
c      calculate mean values of destabilization time with core radius
c      (half mass radius) and other eventuality (presence of about 100 NS
c      and different mass IMBH in the center) for all these clusters   
      
            
      open(unit=0, file='BaumgardtGlobularParameter_new.dat', 
     & action='read', status='old',iostat= k0)
      
      if (k0 .ne. 0) then 
       write (*,*) "BaumgardtGlobularParameter_all_with_comp.dat cannot+
     +be opened"
      end if
           
      open(unit=2,file='resultsGC_half_mass_NSs.ris',action='write'
     & ,status='replace')
      write(2,*)"# result of dest_time(yr) for core and NS"
      write(2,*)"# namecluster,m_test(sm), dest_time_core, dest_time_NS"
      write(2,*)"#"
      
c     in this file of results, namely "resultsGC_half_mass_NSs.ris"
c     unit = 2 put the resulting time calculated in years for core radius
c     and about 100 NS in the core of the cluster for every one
c     in format 5 

      open(unit=3,file='resultsGCs_bh.ris',action='write',
     & status='replace')
      write(3,*)"# dest_time(yr) for bh in centre"
      write(3,*)"#"
        
c      in this file of results, namely "resultsGCs_bh.ris",
c      unit = 3 put the resulting time calculated in years 
c      for core radius in the case of eventual presence of a central IMBH 
c      with variable mass (500, 1000, 1500, 2000, 2500, 5000 sm respectively
c      for every cluster in format 6 

      i_clu_max = 166
      ! total number of clusters in par file
      
      i_clu = 0 

      read(0,*) ! skip the first line in the par file      
      read(0,*) ! skip the second line in the par file 
      
  55  continue ! until loop for par file
      
      i_clu = i_clu + 1 
c234567   
      read(0,fmt=1) namecluster,b2,dist_sun,b2,m_tot_sm,b2,r_half_m_pc,
     & b2,m_mean_sm,b2,comp_cox,b2,comp_calc
       
             
      write(*,*) "namecluster ",namecluster
      write(*,*) "total mass in solar masses =",m_tot_sm
      write(*,*) "distance from sun in kpc =",dist_sun
      write(*,*) "half mass radius in pc = ",r_half_m_pc
      write(*,*) "mean mass in solar masses =",m_mean_sm
      write(*,*) "compactness parameter according Cox =",comp_cox
      write(*,*) "compactness parameter calculated =",comp_calc
      
c      in the parameter file the empty fields for the compactness parameters
c      are substituted by 0, so it have be done a check for this variable
c      something so that if the comp_cox is .eq. 0 use comp_calc and if
c      even this 0 there are no data for this cluster
      
      
      write(2,*) "#"
      write(2,*) "namecluster ",namecluster
      write(2,*) "total mass in solar masses =",m_tot_sm
      write(2,*) "distance from sun in kpc =",dist_sun
      write(2,*) "half mass radius in pc = ",r_half_m_pc
      write(2,*) "mean mass in solar masses =",m_mean_sm
      
c      in the parameter file the empty fields for the compactness parameters
c      are substituted by 0, so it have be done a check for this variable
c      something so that if the comp_cox is .eq. 0 use comp_calc and if
c      even this 0 there are no data for this cluster

      if (comp_cox .eq. 0) then  
       write (2,*) "there are no data for this cluster about compactness 
     + in Cox, Harris&Harris" 
       else 
       write(2,*) "compactness parameter according Cox =",comp_cox
      endif 
c224567
       if (comp_calc .eq. 0) then  
       write (2,*) "there are no data for this cluster about compactness 
     + neither for calculating it"
       else 
       write(2,*) "compactness parameter calculated =",comp_calc
      endif
      
     
      write(3,*) "#"
      write(3,*) "namecluster ",namecluster
      write(3,*) "total mass in solar masses =",m_tot_sm
      write(3,*) "distance from sun in kpc =",dist_sun
      write(3,*) "half mass radius in pc = ",r_half_m_pc
      write(3,*) "mean mass in solar masses =",m_mean_sm
      
      if (comp_cox .eq. 0) then  
       write (3,*) "there are no data for this cluster about compactness 
     + in Cox, Harris&Harris" 
       else 
       write(3,*) "compactness parameter according Cox =",comp_cox
      endif 
c234567
       if (comp_calc .eq. 0) then  
       write (3,*) "there are no data for this cluster about compactness 
     + neither for calculating it"
       else 
       write(3,*) "compactness parameter calculated =",comp_calc
      endif
      
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
      
      
      dest_au = orb_r_au * (2*m_mean_sm/m_test_sm(i_m))**(1./3.)
      
      
      write(2,fmt=2) write_mass_star_test_sm,m_test_sm(i_m)
      write(3,fmt=2) write_mass_star_test_sm,m_test_sm(i_m)
      
c calculus of time of destabilization for half mass radius
      
      t = t_d_f(dest_au,m_tot_sm,r_half_m_pc,m_mean_sm,m_test_sm(i_m))
      rest_time_half_mr = t/yr
      write(2,fmt=3) write_t_dest_r_hm,rest_time_half_mr
            
      t=t_d_ns(dest_au,m_tot_sm,r_half_m_pc,m_mean_sm,m_test_sm(i_m))
      res_time_ns = t/yr
      write(2,fmt=4) write_t_dest_r_hm_ns,res_time_ns
       
      do i_bh =1,6
      t =t_bh(m_tot_sm,r_half_m_pc,m_bh_sm(i_bh),m_test_sm(i_m))
      res_time_bh= t/yr
      write(3,fmt=5) write_mass_bh_sm, write_bh_sm(i_bh),b4,
     & write_t_dest_bh,res_time_bh
      enddo
      
                
  13  continue ! do loop for i_m = 1, 7
      
      if((k0 .eq. 0) .and. (i_clu .lt. i_clu_max)) then
      go to 55 !until loop 55
      elseif (i_clu .eq. i_clu_max) then 
      print *, "finished job for all clusters! , i_clu_tot:", i_clu
      else  
      go to 55 !until loop 55
      endif
      
  66  close(0)
      close(2)
      close(3)
     
      end program dest_time_gcs_core
      


c=====================================================================
c functions and subroutines

c function for calculus of time of destabilization for half mass radius   
      real*8 function t_d_f(d_au,m_tot_smf,r_hm_pcf,m_mean_smf,
     & m_test_smf)
      implicit none
      real*8  km,sm,ggg,au,yr,pi,pc
      common /a/ km,sm,ggg,au,yr,pi,pc
      
      real*8 d_au,m_tot_smf,r_hm_pcf,m_mean_smf,m_test_smf
      real*8 m_tot_f,r_hm_f,m_test_f,df
      real*8 v_quad_f,v_mean_f,d_core_f,focusg_f

      m_tot_f = m_tot_smf * sm
      r_hm_f = r_hm_pcf * pc
      df = d_au * au
      m_test_f = m_test_smf * sm
      
      v_quad_f  = m_tot_f * ggg/(6 * r_hm_f)
      v_mean_f  = sqrt(v_quad_f)
      d_core_f = 3*m_tot_smf/(8*m_mean_smf*pi*r_hm_f**3)! stellar density 
      focusg_f  = (df**2 + (ggg * m_test_f *df)/v_quad_f)
      t_d_f = 1/(4*sqrt(pi)*v_mean_f*d_core_f*focusg_f) 
      return
      end 

c this function yelds the time of destabilization for a star mass
c with mass = m_test due to about 100 neutron stars of mass m = 1.4 sm
c in the core of the cluster: ref Hills&Day(1976)

      real*8 function t_d_ns(d_au,m_tot_smf,r_hm_pcf,m_mean_smf
     &,m_test_smf)
      implicit none
      real*8  km,sm,ggg,au,yr,pi,pc
      common /a/ km,sm,ggg,au,yr,pi,pc
      
      real*8 d_au,m_tot_smf,r_hm_pcf,m_mean_smf,m_test_smf
      real*8 m_tot_f,r_hm_f,m_test_f,df
      real*8 v_quad_f,v_mean_f,d_core_ns,v_mean_ns
      real*8 crossec0,l,v_inf_quad,gamma,vol
      
      m_tot_f = m_tot_smf * sm
      r_hm_f = r_hm_pcf * pc
      df = d_au * au
      m_test_f = m_test_smf * sm
      
      v_quad_f  = m_tot_f * ggg/(6 * r_hm_f)
      v_mean_f  = sqrt(v_quad_f)

      vol = (4/3)*pi*(r_hm_f**3)
      d_core_ns = 100/vol
      l = (sqrt(1.4/(2*(m_mean_smf+ 1.4))))/v_mean_f
      v_inf_quad = 2*ggg*(m_test_f + 1.4*sm)/df
      crossec0 = pi*(df**2)
      gamma = 2*l*crossec0*(1/(l**2) + v_inf_quad)/sqrt(pi)
      t_d_ns = 1/(d_core_ns*gamma)
      return
      end 
      

      
c this function yeld the time of destabilization for a star mass
c with mass = m_test due to a IMBH at the centre of cluster
c of mass m_bh = 500, 1000, 1500, 2000, 2500, 5000 sm
c in the core of the cluster: ref Hills&Day(1976),  Peebles(1972)
c for r_inf     
 
       
      real*8 function t_bh(m_tot_smf,r_hm_pcf,m_bh_smf,m_test_smf)
      implicit none
      real*8  km,sm,ggg,au,yr,pi,pc
      common /a/ km,sm,ggg,au,yr,pi,pc
      
      real*8 m_tot_smf,r_hm_pcf,m_bh_smf,m_test_smf
      real*8 m_tot_f,r_hm_f,m_test_f,d_core_bh,r_inf
      real*8 crossec0,l,v_inf_quad,gamma,vol,v_quad_f,v_mean_f
      
      m_tot_f = m_tot_smf * sm
      r_hm_f = r_hm_pcf * pc
      m_test_f = m_test_smf * sm
      
      v_quad_f  = m_tot_f * ggg/(6 * r_hm_f)
      v_mean_f  = sqrt(v_quad_f)
      vol = (4/3)*pi*(r_hm_f**3)
      
c     ! now the impact parameter, b_0 or r_coll, is r_inf!
      r_inf =  m_bh_smf*sm*ggg/v_quad_f
      d_core_bh = 1/vol
      l = (sqrt(m_bh_smf/(2*(m_test_smf + m_bh_smf))))/v_mean_f
      v_inf_quad = 2*ggg*sm*(m_test_smf + m_bh_smf)/r_inf
      crossec0 = pi*(r_inf**2)
      gamma = 2*l*crossec0*(1/(l**2) + v_inf_quad)/sqrt(pi)
      t_bh = 1/(d_core_bh*gamma)
      return
      end  
