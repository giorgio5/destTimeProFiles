c in this program source F77 file there will be the analysis of the 
c results: in particular the analisis if there is somewhat a 
c correlation between the compactness factor c_write (if it is no 0 
c because in this case we have no data on the compactness factor of a GC)
c and the time of destabilization of dest-time for the case of IMBH 
c and NS 

c234567
      program elab_covar_3resdat
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
         
c 10 is format for  parameters file "BaumgardtGlobularParameter_new.dat":
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
      
      
      
      
      
      
      
      
      
c234567
      end program elab_covar_3resdat
