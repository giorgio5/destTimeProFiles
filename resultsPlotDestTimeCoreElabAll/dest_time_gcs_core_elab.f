      program dest_time_gcs_core_elab
      implicit none

      integer i_m,k0,k1,k2,k3,i_clu,i_clu_max,i_bh,i_u_res
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

      
      real*8  km,sm,ggg,au,yr,pi,pc,dist_sun_kpc
      real*8  m_tot_sm,m_test,m_test_sm,m_mean_sm,m_bh_sm
      real*8  comp_cox, comp_calc, comp_write
      real*8  r_half_m_pc,orb_r_au,dest_au
      real*8  t,t_half_m_yr,t_half_m_ns_yr,t_half_m_bh_yr
       
      character*2 b2
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
         
c 00 is format for  parameters file "BaumgardtGlobularParameter_new.dat":
c namecluster,b2,dist_sun_kpc,b2,m_tot_sm,b2,r_half_m_pc,b2,m_mean_sm,
c b2,comp_cox,b2,comp_calc
  10    format (a24,a2,f6.2,a2,f6.2,a2,f5.2,a2,f4.2,a2,f4.2,a2,f4.2)
   
c  01 is format for common quantities written ahead in all files.risdat:
c namecluster,b2,m_tot_sm,b2,dist_sun_kpc,b2,r_half_m_pc,b2,m_mean_sm
  01    format (a24,a2,es7.2e1,a2,f6.2,a2,f5.2,a2,f4.2)
  
c 11 and 12 are the formats in file.risdat unit 1 and 2 respectively
c after the line common to all so:
c m_test_sm(i_m),b2,orb_r_au,b2,comp_write,b2,t_half_m_yr 

  11    format (f3.1,a2,f4.2,a2,f4.2,a2,es16.10e2)
  12    format (f3.1,a2,f4.2,a2,f4.2,a2,es16.10e2)
  
c 13 is the format for bh .risdat file and has a different format:
c m_test_sm(i_m),b2,orb_r_au,b2,comp_write,b2,write_bh_sm(i_bh),b2,t_half_m_bh_yr
  13    format (f3.1,a2,f4.2,a2,f4.2,a2,i4,a2,es16.10e2)
  
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
c=================================================================      
c     in this file of results, namely "resultsGC_half_mass_r.risdat"
c     unit = 1 put the resulting time calculated in years for half-mass
c     radius mediated quantities
           
      open(unit=1,file='resultsGC_half_mass_r.risdat',action='write'
     & ,status='replace',iostat= k1)
      write(1,*)"# result of dest-Time for half-mass radius"
      
      
c=================================================================      
c     in this file of results, namely "resultsGC_NSs.risdat"
c     unit = 2 put the resulting time calculated in years for a half-mass
c     radius filled with about 100 NS in the core of the 
c     cluster for every one in format 5, this results file shows 
c     for all result-time the corrispondent orbital radius and impact
c     parameter, that is the minimal distance for the capture. 
c     It's obvious that for orbital radius and smaller impact parameters
c     the time for capture will be greater than those calculated
      
      open(unit=2,file='resultsGC_NSs.risdat',action='write'
     & ,status='replace',iostat= k2)
      write(2,*)"# result of dest_time(yr) for about 100 NS with mass 1,
     *4 sm into the half mass radius"
      
c======================================================================
c      in this file of results, namely "resultsGCs_bh.risdat",
c      unit = 3 put the resulting time calculated in years 
c      for core radius in the case of eventual presence of a central IMBH 
c      with variable mass (500, 1000, 1500, 2000, 2500, 5000 sm respectively
c      for every cluster in format 6 

      open(unit=3,file='resultsGCs_bh.risdat',action='write',
     & status='replace',iostat= k3)
      write(3,*)"# dest_time(yr) for bh in centre"
      
        
c====================================================================
      i_clu_max = 166
      ! total number of clusters in par file
      
      i_clu = 0 

      read(0,*) ! skip the first line in the par file      
      read(0,*) ! skip the second line in the par file 
      
  55  continue ! until loop for par file
      
      i_clu = i_clu + 1 
c234567   
      read(0,fmt=10) namecluster,b2,dist_sun_kpc,b2,m_tot_sm,b2,
     & r_half_m_pc,b2,m_mean_sm,b2,comp_cox,b2,comp_calc
       
             
      write(*,*) "namecluster ",namecluster
      write(*,*) " total mass in solar masses = ",m_tot_sm
      write(*,*) "distance from sun in kpc =",dist_sun_kpc
      write(*,*) "half mass radius in pc = ",r_half_m_pc
      write(*,*) "mean mass in solar masses =",m_mean_sm
      write(*,*) "compactness parameter according Cox =",comp_cox
      write(*,*) "compactness parameter calculated =",comp_calc
      
c      in the parameter file the empty fields for the compactness parameters
c      are substituted by 0, so it have be done a check for this variable
c      something so that if the comp_cox is .eq. 0 use comp_calc and if
c      even this 0 there are no data for this cluster and write always the 
c      simbolic value 0      

      if (comp_cox .eq. 0) then  
       write (*,*) "there are no data for this cluster about compactness 
     + in Cox, Harris&Harris so I will use compactness calculated" 
       comp_write = comp_calc
       else 
       write(*,*) "compactness parameter according Cox =",comp_cox
       comp_write = comp_cox
      endif 
      

c     once a GC this snippet write on the three files.risdat the 
c     parameters of the cluster       
 
      do i_u_res = 1, 3
      write(i_u_res,*) "#"
      write(i_u_res,*) "# namecluster # M_tot(sm) # distanceSun(kpc) # h
     +alf_mass_r(pc) # m_mean(sm)"
      write(i_u_res,01) namecluster,b2,m_tot_sm,b2,dist_sun_kpc,b2,
     & r_half_m_pc,b2,m_mean_sm
      enddo
           
      write(1,*) "# m_test(sm) # orbital radius (au) # compactness(0 for 
     + no data) # dest-Time (yr)"
      write(2,*) "# m_test(sm) # orbital radius (au) # compactness(0 for 
     + no data) # dest-Time (yr)"
      write(3,*) "# m_test(sm) # orbital radius (au) # compactness(0 for 
     + no data) # IMBH_mass (sm) # dest-Time (yr)"
     
     
      do 33 i_m = 1,7 ! do loop for i_m
       
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
      
c calculus of time of destabilization for half mass radius
      
      t = t_d_f(dest_au,m_tot_sm,r_half_m_pc,m_mean_sm,m_test_sm(i_m))
      t_half_m_yr = t/yr
      write(1,fmt=11) m_test_sm(i_m),b2,orb_r_au,b2,comp_write,b2,
     & t_half_m_yr
            
c calculus of time of destabilization for half mass radius due to about 
c 100 NS in core each with mass 1.4 sm 

      t=t_d_ns(dest_au,m_tot_sm,r_half_m_pc,m_mean_sm,m_test_sm(i_m))
      t_half_m_ns_yr = t/yr
      write(2,fmt=12)  m_test_sm(i_m),b2,orb_r_au,b2,comp_write,b2,
     & t_half_m_ns_yr
       
c BH block   
      write(3,*) "#"    
      do i_bh =1,6
      t =t_bh(m_tot_sm,r_half_m_pc,m_bh_sm(i_bh),m_test_sm(i_m))
      t_half_m_bh_yr= t/yr
      write(3,fmt=13) m_test_sm(i_m),b2,orb_r_au,b2,comp_write,b2,
     & write_bh_sm(i_bh),b2,t_half_m_bh_yr
      enddo
      
                
  33  continue ! do loop for i_m = 1, 7
      
      if((k0 .eq. 0) .and. (i_clu .lt. i_clu_max)) then
      go to 55 !until loop 55
      elseif (i_clu .eq. i_clu_max) then 
      print *, "finished job for all clusters! , i_clu_tot:", i_clu
      else  
      go to 55 !until loop 55
      endif
      
  66  close(0)
      close(1)
      close(2)
      close(3)
     
      end program dest_time_gcs_core_elab
      


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

c------------------------------------------------------------
c subroutine per ignorare nella lettura del files .risdat le righe 
c che iniziano con "#" ... DA SISTEMARE

c      subroutine leggifile(miofile.risdat, campo
c      character*100 line
c      integer i
c      open(unit=10, file='miofile.txt', status='old')
c 10   continue
c      read(10,'(a)',iostat=i) line
c      if (i .ne. 0) then
c          stop
c      endif
c      if (line(1:1) .eq. '#') then
c          go to 10  ! salta le linee che iniziano con il carattere '#'
c      endif
c      ! qui puoi processare la riga
c      print *, line
c      go to 10
c      end subroutine leggifile
