!--------------------------------------------------------------------
!--------------------------------------------------------------------
program test_libkrylovinterface_real_dp
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This program tests the subroutines
!< defined in the libkrylovinterface file
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
  use basekinds
  use floatformat
  use basetypes
  use blastypes
  use arrayfile
  use libkrylovinterface
!--------------------------------------------------------------------
!
  implicit none
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
! External data
  class(lkl_s_elec_gas), pointer :: data_s_elec_gas
  class(lkl_g_unit_vec), pointer :: data_g_unit_vec
  class(lkl_pc_davidson), pointer :: data_pc_davidson
  class(lkl_pc_none), pointer :: data_pc_none
  class(lkl_pc_approx), pointer :: data_pc_approx
! parameter for array sizes for the test
  integer(lkl_int_k), parameter :: n1 = 100
  integer(lkl_int_k), parameter :: n2 = 4
  integer(lkl_int_k), parameter :: n3 = 0
  integer(lkl_int_k), parameter :: n4 = 1
! integer for loops
  integer(lkl_int_k) :: j1,j2 = 0
! test and reference for real numbers
  real(lkl_double_k) :: r_test(n2)
  real(lkl_double_k) :: r_ref(n2) 
  real(lkl_double_k) :: r_test2(1)
  real(lkl_double_k) :: r_ref2(1)
! test and reference for integers
  integer(lkl_int_k) :: i_test(n2)
  integer(lkl_int_k) :: i_ref(n2)
! indexing of array to be sorted
  integer(lkl_int_k) :: dex(n2)
! array for sorting
  real(lkl_double_k) :: sorter(n2)
! variable for array tests
  logical :: check = .false.
! integer for error variable
  integer(lkl_int_k) :: ierr = 0
! file unit
  integer(lkl_int_k) :: funit = 0
  character(len=32) :: fname = ''
! name of file
  character(len=32) :: name_string = '_libkrylovinterface_test'
! approxiamte spectra
  real(lkl_double_k) :: approx_spectra(n1)
! nstart
  integer(lkl_int_k) :: nstart
  integer(lkl_int_k) :: nrstart
! basis vectors
  real(lkl_double_k), allocatable :: basis_vectors(:,:)
! frequencies
  real(lkl_double_k), allocatable :: precon_roots(:)
! residuals
  real(lkl_double_k), allocatable :: residuals(:,:)
! full solutions
  real(lkl_double_k), allocatable :: full_solutions(:,:)
!--------------------------------------------------------------------
!!  find free unit numbers for files
!!  presumes first 14 unit numbers are saved for
!!  specific use.
  call find_free_file_unit(funit,ierr)
  if (ierr.ne.0) then
    print *, 'No free file units!, test failed'
    stop
  end if
  
!! define fname
  fname = 'real_dp_interface_test.out'

!! open file
  open(unit=funit,file=fname,action='write',status='replace',&
  & iostat=ierr)

!! printing test results as they run
  write(unit=funit,fmt=*) 'Testing subroutines in libkrylovinterface'

  write(unit=funit,fmt=*) 'The interface is for:'
  write(unit=funit,fmt=*) 'type real, double precision elements'
  
  write(unit=funit,fmt=*) 'machine precision'
  write(unit=funit,fmt=*) eps
 
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!!! test quicksort_stl_float
!! using a do loop to fill in input dex array
!! with 1,2,3,4 
!! dex contains the ordering to match the new order to the old
  do j1 = 1, n2
    dex(j1) = j1
  end do 
!! using do loop to fill in input array sorter
!! with 8,6,4,2
  sorter = real(0,kind=lkl_double_k)
  do j1 = 1, n2
    sorter(j1) = real(2*(n2+1-j1),kind=lkl_double_k) 
  end do
!! write quick_stl_float and test operation on test input
  write(unit=funit,fmt=*) 'test quick_sort_stl_float', &
  &', to sort a linear array of real(kind_float)', &
  &', from the smallest to the largest'
!! call quicksort_stl_float on test input onto test output
  call quicksort_stl_float(n2,sorter,dex,1,n2,ierr)
!! check ierr value to see whether 
!! this subroutine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write this subroutine failed and write the ierr value
    write(unit=funit,fmt=*) 'quicksort_stl_float failed, ierr=', ierr
!! set ierr to 0 for the next test
    ierr = 0
!! if wrong, write this subroutine runs
  else
    write(unit=funit,fmt=*) 'quicksort_stl_float runs'
!! write an explanation of the result
    write(unit=funit,fmt=*) 'sorter should be in an ascending order'
    write(unit=funit,fmt=*) 'dex should be in an descending order'
!! assign the test output to real(kind_float) test array
!! for comparison to reference
    r_test = sorter
!! assign the reference array (real(kind_float))
!! by operations on real(kind_float) numbers
!! using a do loop to fill in the reference array
    r_ref = real(0,kind=lkl_double_k)
    do j1 = 1, n2
      r_ref(j1) = real(j1*2,kind=lkl_double_k)
    end do 
   write(unit=funit,fmt=*) 'test sorters, for each element'
!! set logical check=.false.
  check = .false.
!! using a do loop to take the absolute difference
!! between the elements in test array
!! and the elements in reference array
    do j1 = 1, n2
!! test of difference is greater than 0
      if (abs(r_test(j1)-r_ref(j1)).gt.eps) then
!! if true, write failed element
        write(unit=funit,fmt=*) 'failed for element', j1
!! set logical check = .true.
        check = .true.
      else
!! if false, write succeeded element
        write(unit=funit,fmt=*) 'succeeded for element', j1
      end if
    end do
!! assign the test output to integer(kind_float)
!! for comparison to reference
    i_test = dex
!! assign the reference array (intger(kind_float))
!! by operations on integer(kind_float) numbers
!! using a do loop to fill in the reference array
    i_ref = int(0,kind=lkl_int_k)
    do j2 = 1, n2
      i_ref(j2) = int(n2+1-j2,kind=lkl_int_k)  
    end do
   write(unit=funit,fmt=*) 'test dex, for each element'
!! using a do loop to take the absolute difference
!! between the elements in test array
!! and the elements in reference array
    do j2 = 1, n2
!! test if difference is greater than 0
      if (abs(i_test(j2)-i_ref(j2)).gt.0) then
!! if true, write the position of the failed element
        write(unit=funit,fmt=*) 'failed for element', j2
!! set logical check = .true.
        check = .true.
      else
!! if false, write the position of the succeeded element
        write(unit=funit,fmt=*) 'succeeded for element', j2
      end if
    end do
!! check value of logical check
    if (check) then
!! if true, write this subroutine failed to output and output file
      write(unit=funit,fmt=*) 'subroutine quicksort_stl_float failed'
      print *, 'subroutine quicksort_stl_float failed'
    else
!! if false, write this subroutine succeeded to output and output file
      write(unit=funit,fmt=*) 'subroutine quicksort_stl_float tested'
      print *, 'subroutine quicksort_stl_float tested'
    end if
  end if



!!! test lkl_start_elec_gas
!! fill in the approx_spectra with real(kind_float) elements
!! approx_spectra is an array with 100 elements 
!! first element is real number 1
!! every element after is increased by 0.1
  approx_spectra = real(0,kind=lkl_double_k)
  approx_spectra(1) = real(1,kind=lkl_double_k)
  do j1 = 2, n1
    approx_spectra(j1) = approx_spectra(j1-1) & 
  & + real(0.1,kind=lkl_double_k)
  end do
!! write lkl_start_elec_gas and operation on test input
  write(unit=funit,fmt=*) 'test lkl_start_elec_gas',&
  &', to determine the number of guess vectors'
!! call lkl_start_elec_gas to get the output nstart
  call lkl_start_elec_gas(data_s_elec_gas,n1,n2,&
  & approx_spectra,nstart,ierr)    
!! checking ierr value to see if the subtoutine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write this subroutine failed and write the ierr value
    write(unit=funit,fmt=*) 'quicksort_stl_float failed, ierr=', ierr
!! set ierr to 0 for the next test
    ierr = 0
!! if wrong, write this subroutine runs
  else
    write(unit=funit,fmt=*) 'lkl_start_elec runs'
!! write the subroutine output nstart
    write(unit=funit,fmt=*) 'nstart', nstart
!! write an explanation for the result of nstart
    write(unit=funit,fmt=*) 'nstart should be 11' 
!! assign value in nstart to nrstart (integer(kind_float))
    nrstart = nstart
!! using a do loop to reassign numbers in approx_spectra
!! between nstart+1 and nstart+2 to the same number
!! as the number in approx_spectra(nstart)
!! to save a new input based on the result 
    do j1 = (nstart+1),(nstart+2)
      approx_spectra(j1) = approx_spectra(nstart) 
    end do
!! call lkl_start_elec_gas to get the new output nstart
    call lkl_start_elec_gas(data_s_elec_gas,n1,n2,&
  & approx_spectra,nstart,ierr)    
!! write the new subroutine output 
    write(unit=funit,fmt=*) 'nstart', nstart
!! write an explanation for the result of new start
    write(unit=funit,fmt=*) 'nstart should be 13'
!! two numbers chosen to be equal to 
!! the same number as approx_spectra(nstart)
    write(unit=funit,fmt=*) 'nrstart-nstart should be equal to 2'
!! test if the absolute difference of new subroutine output nstart
!! and the old subroutine output nstart is equal to 2
    if (abs(nrstart-nstart).eq.2) then
!! if true, write the subroutine tested in output and output file
      write(unit=funit,fmt=*) 'subroutine lkl_start_elec_gas tested'
      print *, 'subroutine lkl_start_elec_gas tested'
    else
!! if false, write the subroutine failed in output and output file
      write(unit=funit,fmt=*) 'subroutine lkl_start_elec_gas failed'
      print *, 'subroutine lkl_start_elec_gas failed'
    end if
  end if


!!! test lkl_guess_unit_vec
!! allocate basis_vectors
  allocate(basis_vectors(n1,nstart)) 
!! fill in the approx_spectra with real(kind_float) elements
!! approx_spectra is an array with 100 elements 
!! first element is real number 1
!!  every element after is increased by 0.1
  approx_spectra = real(0,kind=lkl_double_k)
  approx_spectra(1) = real(1,kind=lkl_double_k)
  do j1 = 2, n1
    approx_spectra(j1) = approx_spectra(j1-1) &
  & + real(0.1,kind=lkl_double_k)
  end do
!! call lkl_start_elec_gas to get the output nstart
  call lkl_start_elec_gas(data_s_elec_gas,n1,n2,&
  & approx_spectra,nstart,ierr)    
!! using a do loop to reassign numbers in approx_spectra
!! between nstart+1 and nstart+2 to the same number
!! as the number in approx_spectra(nstart)
!! to save a new input based on the result 
  do j1 = (nstart+1),(nstart+2)
    approx_spectra(j1) = approx_spectra(nstart) 
  end do
!! call lkl_start_elec_gas to get the new output nstart
  call lkl_start_elec_gas(data_s_elec_gas,n1,n2,&
  & approx_spectra,nstart,ierr)    
!! write lkl_guess_unit_vec and operation on test output
  write(unit=funit,fmt=*) 'test lkl_guess_unit_vec',&
  &', to determine the initial guess vectors'
!! call lkl_guess_unit_vec on test input
  call lkl_guess_unit_vec(data_g_unit_vec,n1,nstart,n3,&
  & approx_spectra,basis_vectors,ierr) 
!! check ierr value to see if the subroutine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write the subroutine failed and write the ierr value
    write(unit=funit,fmt=*) 'lkl_guess_unit_vec failed, ierr=', ierr
!! set ierr to 0
    ierr = 0
!! if wrong, write the subroutine runs
  else
    write(unit=funit,fmt=*) 'lkl_guess_unit_vec runs'
!! write the explanation for the result
    write(unit=funit,fmt=*) 'basis_vectors should be an identity' 
!! set the real number 0 to the original r_test2
    r_test2 = real(0,kind=lkl_double_k)
!! set check = .false.
    check = .false.
!! using do loops to assign elements in basis_vectors to r_test2 
    do j2 = 1, nstart
      do j1 = 1, n1
        r_test2 = basis_vectors(j1,j2)
!! using if statement to assign r_ref2
        if (j1.eq.j2) then
!! set the diagonal of r_ref2 to real number 1
          r_ref2 = real(1,kind=lkl_double_k)         
        else
!! set the remaining elements in r_ref2 to real number0
          r_ref2 = real(0,kind=lkl_double_k)
        end if
!! compare the r_test2 and r_ref2 elment by element during the do loop
!! to check whether the absolute difference of r_test2 and r_ref2 
!! is greater equal to 0     
        if (abs(r_test2(1)-r_ref2(1)).gt.eps) then
!! if true, write out the position of the failed element
          write(unit=funit,fmt=*) 'failed for element', j1, j2
!! set check = .true.
          check = .true.
        end if
      end do
    end do
!! check value of logical check
    if (check) then
!! if true, write the subroutine failed to the output and output file
      write(unit=funit,fmt=*) 'subroutine lkl_guess_unit_vec failed'
      print *, 'subroutine lkl_guess_unit_vec failed'   
    else
!! if false, write the subroutine tested to the output and output file
      write(unit=funit,fmt=*) 'subroutine lkl_guess_unit_vec tested'
      print *, 'subroutine lkl_guess_unit_vec tested'
    end if
  end if
  


!!! test lkl_precon_none
!! alocate precon_roots and residuals
  allocate(precon_roots(n4))   
  allocate(residuals(n1,n4))
  allocate(full_solutions(n1,n4))
!! fill in the approx_spectra with real(kind_float) elements
!! approx_spectra is an array with 100 elements
!! first element is real number 1
!! every element after is increased by 0.1
  approx_spectra = real(0,kind=lkl_double_k)
  approx_spectra(1) = real(1,kind=lkl_double_k)
  do j1 = 2, n1
    approx_spectra(j1) = approx_spectra(j1-1) + real(0.1,kind=lkl_double_k)
  end do
  full_solutions = real(0,kind=lkl_double_k)
  do j1 = 1, n4
    full_solutions(j1,j1) = real(1,kind=lkl_double_k)
  end do
!! assign input precon_roots as real number 0.5
!! assign input residuals as real number 1
  precon_roots = real(0.5,kind=lkl_double_k)
  residuals = real(1,kind=lkl_double_k)
!! write lkl_precon_none and operation on test input
  write(unit=funit,fmt=*) 'test lkl_precon_none', &
  & ', to solve for preconditiing and it remains the same as output'
!! call lkl_precon_none on test input
  call lkl_precon_none(data_pc_none,n1,n4,n3,approx_spectra,&
  & precon_roots,full_solutions,residuals,ierr)
!! check ierr value to see if the subroutine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write the subroutine failed, write the ierr value
    write(unit=funit,fmt=*) 'lkl_precon_none failed, ierr=', ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write the subroutine runs
    write(unit=funit,fmt=*) 'lkl_precon_none runs'
!! write an explanation of the subroutine
    write(unit=funit,fmt=*) 'residuals should be an identity'
!! set r_test2 and r_ref2 to real number 0
    r_test2= real(0,kind=lkl_double_k)
    r_ref2= real(0,kind=lkl_double_k)
!! set check = .false.
    check = .false.
!! using do loop to fill in elements in from test output to residuals
!! assign real number 1 to r_ref2
    do j2 = 1, n4
      do j1 = 1, n1
        r_test2 = residuals(j1,j2)
        r_ref2 = real(1,kind=lkl_double_k)
!! test if the difference of r_test2 and r_ref2 is greater than 0
         if (abs(r_test2(1)-r_ref2(1)).gt.eps) then
!! if true, write the position of the failed element
           write(unit=funit,fmt=*) 'failed for element', j1, j2
!! set check = .true.
           check = .true.
         end if
      end do
    end do
!! check value of logical check
    if (check) then
!! if true, write the subroutine failed to output and output file
      write(unit=funit,fmt=*) 'subroutine lkl_precon_none failed'
      print *, 'subroutine lkl_precon_none failed'   
    else
!! if false, write the subroutine tested to output and output file
      write(unit=funit,fmt=*) 'subroutine lkl_precon_none tested'
      print *, 'subroutine lkl_precon_none tested'
    end if
  end if



!!! test lkl_precon_approx
!! fill in the approx_spectra with real(kind_float) elements
!! approx_spectra is an array with 100 elements
!! first element is real number 1
!! every element after is increased by 0.1 
  approx_spectra = real(0,kind=lkl_double_k)
  approx_spectra(1) = real(1,kind=lkl_double_k)
  do j1 = 2, n1
    approx_spectra(j1) = approx_spectra(j1-1) + real(0.1,kind=lkl_double_k)
  end do
  full_solutions = real(0,kind=lkl_double_k)
  do j1 = 1, n4
    full_solutions(j1,j1) = real(1,kind=lkl_double_k)
  end do
!! assign input precon_roots as real number 0.5
!! assign input residuals as real number 1
  precon_roots = real(0.5,kind=lkl_double_k)
  residuals = real(1,kind=lkl_double_k)
!! write lkl_precon_approx and operation on test input
  write(unit=funit,fmt=*) 'test lkl_precon_approx', &
  & ', to solve for preconditiing in inverse approximate spectra'
!! call lkl_precon_approx on test input
  call lkl_precon_approx(data_pc_approx,n1,n4,n3,approx_spectra,&
  & precon_roots,full_solutions,residuals,ierr)
!! check ierr value to see if the subroutine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write the subroutine failed, write the ierr value
    write(unit=funit,fmt=*) 'lkl_precon_approx failed, ierr=', ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write the subroutine runs
    write(unit=funit,fmt=*) 'lkl_precon_approx runs'
!! write an explanation of the subroutine
    write(unit=funit,fmt=*) 'residuals should be the inverse of &
    & approx_spectra'
!! set r_test2 and r_ref2 to real number 0
    r_test2= real(0,kind=lkl_double_k)
    r_ref2= real(0,kind=lkl_double_k)
!! set check = .false.
    check = .false.
!! using do loop to fill in elements from test output to residuals
!! assign the inverse of approx_spectra to r_ref2
     do j2 = 1, n4
      do j1 = 1, n1
        r_test2 = residuals(j1,j2)
        r_ref2 = real(1,kind=lkl_double_k) / approx_spectra(j1)
!! test if the absolute difference of r_test2 and r_ref2
!! is greater than eps
         if (abs(r_test2(1)-r_ref2(1)).gt.eps) then
!! if true, write the position of the failed element
           write(unit=funit,fmt=*) 'failed for element', j1, j2
!! set check = .true.
           check = .true.
         end if
      end do
    end do
!! check value of logical check
    if (check) then
!! if true, write the subroutine failed to the output and output file
      write(unit=funit,fmt=*) 'subroutine lkl_precon_approx failed'
      print *, 'subroutine lkl_precon_approx failed'   
    else
!! if false, write the subroutine tested to the output and output file
      write(unit=funit,fmt=*) 'subroutine lkl_precon_approx tested'
      print *, 'subroutine lkl_precon_approx tested'
    end if
  end if


!!! test lkl_precon_davidsion
!! fill in the approx_spectra with real(kind_float) elements
!! approx_spectra is an array with 100 elements
!! first element is real number 1
!! every element after is increased by 0.1  
  approx_spectra = real(0,kind=lkl_double_k)
  approx_spectra(1) = real(1,kind=lkl_double_k)
  do j1 = 2, n1
    approx_spectra(j1) = approx_spectra(j1-1) + real(0.1,kind=lkl_double_k)
  end do
  full_solutions = real(0,kind=lkl_double_k)
  do j1 = 1, n4
    full_solutions(j1,j1) = real(1,kind=lkl_double_k)
  end do
!! assign input precon_roots as real number 0.5
!! assign input residuals as real number 1
  precon_roots = real(0.5,kind=lkl_double_k)
  residuals = real(1,kind=lkl_double_k)
!! write subroutine lkl_precon_davidson and operation on test input
  write(unit=funit,fmt=*) 'test lkl_precon_davidson&
  &, solve for preconditing davison'
!! call lkl_precon_davidson on test output
  call lkl_precon_davidson(data_pc_davidson,n1,n4,n3,approx_spectra,&
  & precon_roots,full_solutions,residuals,ierr)
!! check ierr value to see if the subtoutine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write the subroutine failed, write the ierr value
    write(unit=funit,fmt=*) 'lkl_precon_davidson failed, ierr=', ierr
!! set check = .false.
    check = .false.
  else
!! if false, write the subroutine runs
    write(unit=funit,fmt=*) 'lkl_precon_davidson runs'
!! write an explanation of the subroutine
    write(unit=funit,fmt=*) 'residuals should be the inverse of&
    & the substraction of approx_spectra and precon_roots'
!! set r_test2 and r_ref2 to real number 0  
    r_test2= real(0,kind=lkl_double_k)
    r_ref2= real(0,kind=lkl_double_k)
!! set check = .false.
    check = .false.
!! using do loop to fill in elements from test output to residuals
!! assign inverse of the difference of approx_spectra and precon_roots
    do j2 = 1, n4
      do j1 = 1, n1
        r_test2 = residuals(j1,j2)
        r_ref2 = real(1,kind=lkl_double_k) / &
        & (approx_spectra(j1) - precon_roots(j2))
!! test if the absolute difference of r_test2 and r_ref2
!! is greater than eps
        if (abs(r_test2(1)-r_ref2(1)).gt.eps) then
!! if true, write the position of the failed element
           write(unit=funit,fmt=*) 'failed for element', j1, j2
!! set check = .true.
           check = .true.
        end if
      end do
    end do
!! check value of logical check
    if (check) then
!! if true, write the subroutine failed to the output and output file
      write(unit=funit,fmt=*) 'subroutine lkl_precon_davidson failed'
      print *, 'subroutine lkl_precon_davidson failed'   
    else
!! if false, write the subroutine tested to the output and output file
      write(unit=funit,fmt=*) 'subroutine lkl_precon_davidson tested'
      print *, 'subroutine lkl_precon_davidson tested'
    end if
  end if
  






!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program test_libkrylovinterface_real_dp
!--------------------------------------------------------------------
!--------------------------------------------------------------------
