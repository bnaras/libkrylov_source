!--------------------------------------------------------------------
!--------------------------------------------------------------------
program test_arrayfile
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This program tests the array print statements and subroutines
!< defined in the arrayfile and arrayoperations file
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
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!! parameter for array sizes for the test
  integer(kind_integer), parameter :: n = 3
!! variables of the derived type for testing
  real(kind_float) :: x_array1(n)
  real(kind_float) :: x_array2(n)
  type(base) :: z_array1(n,n)
  type(base) :: z_array2(n,n)
!! magnitude for tests
  real(kind_float) :: z1
  real(kind_float) :: z2
! integer for loops
  integer(kind_integer) :: j1,j2 = 0
! integer for testing read size
  integer(kind_integer) :: k1,k2 = 0
! for testing read type
  character(len=32) :: test_string
  character(len=32) :: file_string
! integer for error variable
  integer(kind_integer) :: ierr = 0
!--------------------------------------------------------------------

!! Check matching precision strings
  if(base_print_string.eq.'cmplx_dp') then
    if(float_print_string.ne.'doubleprecision') then
      print *, 'basetype_*.f90 and floatformat_*.f90 failed match, ',&
  &   base_print_string, ' and ',float_print_string
    else
      print *, 'basetype_*.f90 and floatformat_*.f90 match'
    end if
  else if(base_print_string.eq.'real_dp') then
    if(float_print_string.ne.'doubleprecision') then
      print *, 'basetype_*.f90 and floatformat_*.f90 failed match, ',&
  &   base_print_string, ' and ',float_print_string
    else
      print *, 'basetype_*.f90 and floatformat_*.f90 match'
    end if
  else if(base_print_string.eq.'cmplx_sp') then
    if(float_print_string.ne.'singleprecision') then
      print *, 'basetype_*.f90 and floatformat_*.f90 failed match, ',&
  &   base_print_string, ' and ',float_print_string
    else
      print *, 'basetype_*.f90 and floatformat_*.f90 match'
    end if
  else if(base_print_string.eq.'real_sp') then
    if(float_print_string.ne.'singleprecision') then
      print *, 'basetype_*.f90 and floatformat_*.f90 failed match, ',&
  &   base_print_string, ' and ',float_print_string
    else
      print *, 'basetype_*.f90 and floatformat_*.f90 match'
    end if
!  else if(base_print_string.eq.'splitcmplx_dp') then
!    if(float_print_string.ne.'doubleprecision') then
!      print *, 'basetype_*.f90 and floatformat_*.f90 mismatch, ',&
!  &   base_print_string, ' and ',float_print_string
!    else
!      print *, 'basetype_*.f90 and floatformat_*.f90 match'
!    end if
  end if

!! Filling arrays for printing

  if (basetype_string.eq.'cmplx') then
    z_array1 = cmplx(0.0,kind=kind_float)
    do j1 = 1, n
      z_array1(j1,j1) = cmplx(1.0,kind=kind_float)
    end do
    z_array1(2,1) = cmplx(2.4,3.7,kind=kind_float)
    z_array1(1,2) = cmplx(2.4,-3.7,kind=kind_float)
  else if (basetype_string.eq.'real') then
    z_array1 = real(0,kind=kind_float)
    do j1 = 1, n
      z_array1(j1,j1) = real(1,kind=kind_float)
    end do
    z_array1(2,1) = real(2.4,kind=kind_float)
    z_array1(1,2) = real(2.4,kind=kind_float)
!  else if (basetype_string.eq.'splitcmplx') then
!    z_array1 = real(0,kind=kind_float)
!    do j1 = 1, n
!      z_array1(j1,j1) = real(1,kind=kind_float)
!    end do
!    z_array1(2,1) = spcmplx(&
!  & real(2.4,kind=kind_float), &
!  & real(3.7,kind=kind_float)) 
!    z_array2(1,2) = spcmplx(&
!  & real(2.4,kind=kind_float), &
!  & real(-3.7,kind=kind_float)) 
  end if

  x_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    x_array1(j1) = real(j1,kind=kind_float)
  end do

  file_string = (trim(base_print_string)//trim('_file_test'))

! printing type(base) z_array1
  call array_print_base(file_string,n,n,z_array1,ierr)
  if (ierr.eq.0) then
    print *, 'Array of type(base) printed'
  else
    print *, 'failed printing Array of type(base)'
    stop
  end if

! read size printed and tested
  call array_read_base_size(file_string,k1,k2,test_string,ierr)
  if (ierr.eq.0) then
    print *, 'Array of type(base) info read'
  else
    print *, 'failed reading info of Array of type(base)'
    stop
  end if
  if(k1.ne.n) print *, 'failed reading row size of base, should be ',&
  &  n,' not ',k1
  if(k2.ne.n) print *, 'failed reading col size of base, should be ',&
  &  n,' not ',k2
  if(test_string.ne.file_string) then
    print *, 'failed reading basetype info, should be',&
  & file_string, ' not ',test_string
  end if
! read values printed and tested
  call array_read_base(file_string,k1,k2,z_array2,ierr)
  if (ierr.eq.0) then
    print *, 'Array of type(base) read'
  else
    print *, 'failed reading Array of type(base)'
    stop
  end if
  do j1 = 1, n
    do j2 = 1, n
      z1 = conjg(z_array1(j1,j2))*z_array1(j1,j2)
      z1 = sqrt(z1)
      z2 = conjg(z_array2(j1,j2))*z_array2(j1,j2)
      z2 = sqrt(z2)
      if (abs(z1-z2).gt.eps) then
        print *, 'read',z_array2(j1,j2)
        print *, 'printed',z_array1(j1,j2)
        print *, 'failed printing/reading magnitudes at',j1,j2
      end if
      z1 = z_array1(j1,j2)
      z2 = z_array2(j1,j2)
      if (abs(z1-z2).gt.eps) then
        print *, 'read',z_array2(j1,j2)
        print *, 'printed',z_array1(j1,j2)
        print *, 'failed printing/reading sign at',j1,j2
      end if
      z1 = (z_array1(j1,j2))*z_array1(j1,j2)
      z1 = sqrt(z1)
      z2 = (z_array2(j1,j2))*z_array2(j1,j2)
      z2 = sqrt(z2)
      if (abs(z1-z2).gt.eps) then
        print *, 'read',z_array2(j1,j2)
        print *, 'printed',z_array1(j1,j2)
        print *, 'failed printing/reading phase at',j1,j2
      end if
    end do
  end do

  file_string = (trim(base_print_string)//trim('_float_test'))

! printing real(kind_float) eigenvalues
  call array_print_float(file_string,n,x_array1,ierr)
  if (ierr.eq.0) then
    print *, 'Array of real(kind_float) printed'
  else
    print *, 'failed printing Array of real(kind_float)'
    stop
  end if

! read size printed and tested
  call array_read_float_size(file_string,k1,test_string,ierr)
  if (ierr.eq.0) then
    print *, 'Array of real(kind_float) info read'
  else
    print *, 'failed reading info of Array of real(kind_float)'
    stop
  end if
  if(k1.ne.n) print *, 'failed reading size of real(kind_float)',& 
  &  ', should be ',n,' not ',k1

  if(test_string.ne.file_string) then
    print *, 'error reading basetype info, should be',&
  & file_string, ' not ',test_string
  end if

! read values printed and tested
  call array_read_float(file_string,k1,x_array2,ierr)
  if (ierr.eq.0) then
    print *, 'Array of real(kind_float) read'
  else
    print *, 'Failed reading Array of real(kind_float)'
    stop
  end if
  do j1 = 1, n
    if (abs(x_array1(j1)-x_array2(j1)).gt.eps) then
      print *, 'failed printing/reading values at',j1
    end if
  end do

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program test_arrayfile
!--------------------------------------------------------------------
!--------------------------------------------------------------------
