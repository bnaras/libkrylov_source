!--------------------------------------------------------------------
!--------------------------------------------------------------------
program test_libkrylovinterface
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
!! these two modules are used to load our machine precision
  use basekinds
  use floatformat
  use basetypes
  use libkrylovinterface
  use libkrylovinterface2
!--------------------------------------------------------------------
!
  implicit none
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
! External data
  type(lkl_s_elec_gas) :: data_s_elec_gas
  type(lkl_g_unit_vec) :: data_g_unit_vec
! parameter for array sizes for the test
  integer(kind_integer), parameter :: n1 = 100
  integer(kind_integer), parameter :: n2 = 4
  integer(kind_integer), parameter :: n3 = 0
  integer(kind_integer), parameter :: n4 = 4
! integer for loops
  integer(kind_integer) :: j1,j2 = 0
! test and reference for real numbers
  real(kind_float) :: r_test(n2)
  real(kind_float) :: r_ref(n2) 
  real(kind_float) :: r_test2
  real(kind_float) :: r_ref2
! test and reference for integers
  integer(kind_integer) :: i_test(n2)
  integer(kind_integer) :: i_ref(n2)
! indexing of array to be sorted
  integer(kind_integer) :: dex(n2)
! array for sorting
  real(kind_float) :: sorter(n2)
! variable for array tests
  logical :: check = .false.
! integer for error variable
  integer(kind_integer) :: ierr = 0
! file unit
  integer(kind_integer) :: funit = 0
  character(len=32) :: fname = ''
! name of file
  character(len=32) :: name_string = '_libkrylovinterface_test'
! approxiamte spectra
  real(kind_float) :: approx_spectra(n1)
! nstart
  integer(kind_integer) :: nstart
  integer(kind_integer) :: nrstart
! basis vectors
  type(base), allocatable :: basis_vectors(:,:)
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
  fname = trim(base_print_string)//'_interface_test.out'
  
!! open file
  open(unit=funit,file=fname,action='write',status='replace',&
  & iostat=ierr)

!! printing test results as they run
  write(unit=funit,fmt=*) 'Testing subroutines in libkrylovinterface'

  write(unit=funit,fmt=*) 'The interface is for:'
  write(unit=funit,fmt=*) 'matrix elements of type ', trim(basetype_string), ' with '
  write(unit=funit,fmt=*) float_print_string
  
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
  sorter = real(0,kind=kind_float)
  do j1 = 1, n2
    sorter(j1) = real(2*(n2+1-j1),kind=kind_float) 
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
    r_ref = real(0,kind=kind_float)
    do j1 = 1, n2
      r_ref(j1) = real(j1*2,kind=kind_float)
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
    i_ref = int(0,kind=kind_integer)
    do j2 = 1, n2
      i_ref(j2) = int(n2+1-j2,kind=kind_integer)  
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
  approx_spectra = real(0,kind=kind_float)
  approx_spectra(1) = real(1,kind=kind_float)
  do j1 = 2, n1
    approx_spectra(j1) = approx_spectra(j1-1) & 
  & + real(0.1,kind=kind_float)
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
  approx_spectra = real(0,kind=kind_float)
  approx_spectra(1) = real(1,kind=kind_float)
  do j1 = 2, n1
    approx_spectra(j1) = approx_spectra(j1-1) &
  & + real(0.1,kind=kind_float)
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
  & approx_spectra,basis_vectors%element,ierr) 
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
    r_test2 = real(0,kind=kind_float)
!! set check = .false.
    check = .false.
!! using do loops to assign elements in basis_vectors to r_test2 
    do j2 = 1, nstart
      do j1 = 1, n1
        r_test2 = basis_vectors(j1,j2)
!! using if statement to assign r_ref2
        if (j1.eq.j2) then
!! set the diagonal of r_ref2 to real number 1
          r_ref2 = real(1,kind=kind_float)         
        else
!! set the remaining elements in r_ref2 to real number0
          r_ref2 = real(0,kind=kind_float)
        end if
!! compare the r_test2 and r_ref2 elment by element during the do loop
!! to check whether the absolute difference of r_test2 and r_ref2 
!! is greater equal to 0     
        if (abs(r_test2-r_ref2).gt.eps) then
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
!! deallocate basis_vectors
  deallocate(basis_vectors) 



!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program test_libkrylovinterface
!--------------------------------------------------------------------
!--------------------------------------------------------------------
