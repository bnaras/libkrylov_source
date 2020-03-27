!--------------------------------------------------------------------
!--------------------------------------------------------------------
program test_ritz
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This program tests the subroutines called by solvers
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
  use basekinds
  use floatformat
  use basetypes
  use blastypes
  use libkrylovsolver
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!! parameter for array sizes for the test
  integer(kind_integer), parameter :: n = 100
  integer(kind_integer), parameter :: m = 10
  integer(kind_integer), parameter :: p = 5
  integer(kind_integer), parameter :: q = m+p
!! variables of the derived type for testing
  type(base) :: z1
  type(base) :: z2
  type(base) :: z3
  real(kind_float) :: r_test
  real(kind_float) :: r_ref
  real(kind_float) :: x1(1)
  real(kind_float) :: x2
  real(kind_float) :: x_array1(n)
  real(kind_float) :: r_testarray1(n,n)
  real(kind_float) :: r_refarray1(n,n)
  real(kind_float) :: r_testarray2(n)
  real(kind_float) :: r_refarray2(n)
  integer(kind_integer) :: ipiv(n)
  integer(kind_integer) :: iseed(4)
  type(base) :: z_array1(n,m)
  type(base) :: z_array2(n,q)
  type(base) :: z_array3(q,q)
  type(base) :: z_array4(n,q)
  type(base) :: z_array5(q,m)
  type(base) :: z_array6(q,m)
  real(kind_float) :: r_vector1(q)
  real(kind_float) :: r_vector2(m)
  type(base) :: z_vector1(m)

! integer for verbosity
  integer(kind_integer) :: iverb = 5
! integer for loops
  integer(kind_integer) :: j1,j2 = 0
! integer for error variable
  integer(kind_integer) :: ierr = 0
!! for testing
  integer(kind_integer) :: k1,k2 = 0
! variable for array tests
  logical :: check = .false.
! file unit
  integer(kind_integer) :: funit = 0
  character(len=32) :: fname = ''
!! name of file
  character(len=32) :: name_string = '_ritz_test'
  character(len=32) :: file_string = ''
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
  fname = trim(base_print_string)//trim(name_string)//'.sum'

!! open file
  open(unit=funit,file=fname,action='write',status='replace',iostat=ierr)

!! printing test results as they run
  print *, 'Testing solver subroutines'

  print *, 'This basetype is ',base_print_string

  print *, 'machine precision'
  print *,  eps

  print *, 'log10 of machine precision'
  print *, logeps
  print *, ''


!!! testing krylov_normalize
!! Using do loop to fill in the test input matrix z_array1
!! with 1, 2, 3 on diagonal
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, m
    z_array1(j1,j1) = real(j1,kind=kind_float)
  end do
!! write statement on test
  print *, 'test krylov_normalize',&
  &', which normalizes vectors in a matrix'
  print *, 'input z_array1 is a diagonal square',&
  &' matrix of integer values'
!! call normalize subroutine
  call krylov_normalize(n,m,z_array1,ierr)
!! check ierr value to see whether routine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write routine failed, write the ierr value
    print *, 'krylov_normalize failed, ierr=',ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write subroutine runs
    print *, 'krylov_normalize runs'
  end if
!! write info about output
  print *, 'z_array1 should be identity'
!! write test to check each element
  print *, 'testing each element of z_array1'
!! set logical check = .false.
  check = .false.
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j2 = 1, m 
    do j1 = 1,n
      r_ref = z_array1(j1,j2)
      if (j1.eq.j2) then
        r_test = real(1,kind=kind_float)
      else
        r_test = real(0,kind=kind_float)
      end if
!! test if difference if greater than machine precision
!! (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
        print *, 'failed for elements', j1, j2 
!! set logical check = .true.
        check = .true.
      end if
    end do
  end do
  if (check) then
!! write subroutine failed to output file
    print *, 'subroutine krylov_normalize failed'
    write(unit=funit,fmt=*) 'subroutine krylov_normalize failed'
  else
!! write subroutine succeeded to output file
    print *, 'tested subroutine krylov_normalize'
    write(unit=funit,fmt=*) 'tested subroutine krylov_normalize'
  end if
  print *, ''

!!! tests of krylov_unique
  check = .false.
!!! negative tests of krylov_unique
!! Using do loop to fill in the test input matrix z_array1
!! with 1 on diagonal
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, m
    z_array1(j1,j1) = real(1,kind=kind_float)
  end do
!! write statement on test
  print *, 'negative test krylov_unique',&
  &', which prints to standard output'
  print *, 'input z_array1 is identity with no linear dependence'
!! call normalize subroutine
  call krylov_unique(n,m,z_array1,iverb,ierr)
!! check ierr value to see whether routine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write routine failed, write the ierr value
    print *, 'krylov_unique failed, ierr=',ierr
    check = .true.
!! set ierr to 0
    ierr = 0
  else
!! if false, write gheev runs
    print *, 'krylov_unique runs'
  end if
!! write info about output
  print *, 'z_array1 should be identity, unchanged'
!! write test to check each element
  print *, 'testing each element of z_array1'
!! set logical check = .false.
  check = .false.
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j2 = 1, m 
    do j1 = 1,n
      r_ref = z_array1(j1,j2)
      if (j1.eq.j2) then
        r_test = real(1,kind=kind_float)
      else
        r_test = real(0,kind=kind_float)
      end if
!! test if difference if greater than machine precision
!! (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
        print *, 'failed for elements', j1, j2 
!! set logical check = .true.
        check = .true.
      end if
    end do
  end do
  print *, ''
!!! positive tests of krylov_unique
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, (m-1)
    z_array1(j1,j1) = real(1,kind=kind_float)
  end do
!! write statement on test
  print *, 'positive test krylov_unique',&
  &', which prints to standard output'
  print *, 'input z_array1 is identity with a zero last column'
!! call normalize subroutine
  call krylov_unique(n,m,z_array1,iverb,ierr)
!! check ierr value to see whether routine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write routine failed, write the ierr value
    print *, 'krylov_unique exited, ierr=',ierr
    print *, 'which should be -50'
!! set ierr to 0
    ierr = 0
  else
!! if false, write routine runs
    print *, 'krylov_unique did not error out, thus failed'
    check = .true.
  end if

  if (check) then
!! write subroutine failed to output file
    print *, 'subroutine krylov_unique failed'
    write(unit=funit,fmt=*) 'subroutine krylov_unique failed'
  else
!! write subroutine gheev succeeded to output file
    print *, 'tested subroutine krylov_unique'
    write(unit=funit,fmt=*) 'tested subroutine krylov_unique'
  end if
  print *, ''
 
!!! testing krylov_extend
!! set logical check = .false.
  check = .false.
!! Using do loop to fill in the test input matrix z_array1
!! with 1, 2, 3 on diagonal
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, m
    z_array1(p+j1,j1) = real(1,kind=kind_float)
  end do
  z_array2 = real(0,kind=kind_float)
  do j1 = 1, p
    z_array2(j1,j1) = real(1,kind=kind_float)
  end do
  z_array3 = real(0,kind=kind_float)
  do j1 = 1, p
    z_array3(j1,j1) = real(1,kind=kind_float)
  end do
  r_vector1 = real(0,kind=kind_float)
  do j1 = 1, p
    r_vector1(j1) = real(1,kind=kind_float)
  end do
!! write statement on test
  print *, 'test krylov_extend',&
  &', which computes overlap of basis vectors'
  print *, 'input z_array2 when extended with z_array1',&
  &' gives identity'
  print *, 'thus z_array3 is also identity',&
  &' and rvector1 is all 1'
!! call normalize subroutine
  call krylov_extend(n,q,m,p,z_array1,z_array2,z_array3,r_vector1,iverb,ierr)
!! check ierr value to see whether routine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write routine failed, write the ierr value
    print *, 'krylov_extend failed, ierr=',ierr
!! set ierr to 0
    ierr = 0
    check = .true.
  else
!! if false, write subroutine runs
    print *, 'krylov_extend runs'
  end if
!! write info about output
  print *, 'z_array2 should be identity'
!! write test to check each element
  print *, 'testing each element of z_array2'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j2 = 1, p 
    do j1 = 1,n
      r_ref = z_array2(j1,j2)
      if (j1.eq.j2) then
        r_test = real(1,kind=kind_float)
      else
        r_test = real(0,kind=kind_float)
      end if
!! test if difference if greater than machine precision
!! (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
        print *, 'failed for elements', j1, j2 
!! set logical check = .true.
        check = .true.
      end if
    end do
  end do
!! write info about output
  print *, 'z_array3 should be identity'
!! write test to check each element
  print *, 'testing each element of z_array3'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j2 = 1, q 
    do j1 = 1, q
      r_ref = z_array3(j1,j2)
      if (j1.eq.j2) then
        r_test = real(1,kind=kind_float)
      else
        r_test = real(0,kind=kind_float)
      end if
!! test if difference if greater than machine precision
!! (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
        print *, 'failed for elements', j1, j2 
!! set logical check = .true.
        check = .true.
      end if
    end do
  end do
!! write info about output
  print *, 'r_vector1 should be all 1'
!! write test to check each element
  print *, 'testing each element of r_vector1'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  r_test = real(1,kind=kind_float)
  do j1 = 1, q 
!! test if difference if greater than machine precision
!! (defined by the constant eps)
    if (abs(r_test-r_vector1(j1)).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
      print *, 'failed for element', j1 
!! set logical check = .true.
      check = .true.
    end if
  end do
  if (check) then
!! write subroutine failed to output file
    print *, 'subroutine krylov_extend failed'
    write(unit=funit,fmt=*) 'subroutine krylov_extend failed'
  else
!! write subroutine gheev succeeded to output file
    print *, 'tested subroutine krylov_normalize'
    write(unit=funit,fmt=*) 'tested subroutine krylov_extend'
  end if
  print *, ''

!!! tests of krylov_check
  check = .false.
!!! negative tests of krylov_check
!! Using do loop to fill in the test input matrix z_array3
!! with 1 on diagonal
  z_array3 = real(0,kind=kind_float)
  do j1 = 1, q
    z_array3(j1,j1) = real(1,kind=kind_float)
  end do
  r_vector1 = real(0,kind=kind_float)
  do j1 = 1, q
    r_vector1(j1) = real(1,kind=kind_float)
  end do
!! write statement on test
  print *, 'negative test krylov_unique',&
  &', which prints to standard output'
  print *, 'input z_array3 is identity which is positive definite'
  print *, 'input r_vector1 is all 1'
!! call subroutine
  call krylov_check(q,z_array3,r_vector1,iverb,ierr)
!! check ierr value to see whether routine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write routine failed, write the ierr value
    print *, 'krylov_check failed, ierr=',ierr
    check = .true.
!! set ierr to 0
    ierr = 0
  else
!! if false, write gheev runs
    print *, 'krylov_check runs'
  end if
!! write info about output
  print *, 'z_array3 should be identity, unchanged'
!! write test to check each element
  print *, 'testing each element of z_array3'
!! set logical check = .false.
  check = .false.
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j2 = 1, q 
    do j1 = 1, q
      r_ref = z_array3(j1,j2)
      if (j1.eq.j2) then
        r_test = real(1,kind=kind_float)
      else
        r_test = real(0,kind=kind_float)
      end if
!! test if difference if greater than machine precision
!! (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
        print *, 'failed for elements', j1, j2 
!! set logical check = .true.
        check = .true.
      end if
    end do
  end do
!! write info about output
  print *, 'r_vector1 should be all 1'
!! write test to check each element
  print *, 'testing each element of r_vector1'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  r_test = real(1,kind=kind_float)
  do j1 = 1, q 
!! test if difference if greater than machine precision
!! (defined by the constant eps)
    if (abs(r_test-r_vector1(j1)).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
      print *, 'failed for element', j1 
!! set logical check = .true.
      check = .true.
    end if
  end do
  if (check) then
!! write subroutine failed to output file
    print *, 'subroutine krylov_check failed'
    write(unit=funit,fmt=*) 'subroutine krylov_check failed'
  else
!! write subroutine succeeded to output file
    print *, 'tested subroutine krylov_unique'
    write(unit=funit,fmt=*) 'tested subroutine krylov_check'
  end if
  print *, ''

!!! Testing restart reading and writing
!! Filling arrays for printing

  if (basetype_string.eq.'cmplx') then
    z_array2 = cmplx(0.0,kind=kind_float)
    do j1 = 1, q
      z_array2(j1,j1) = cmplx(j1,kind=kind_float)
    end do
    z_array2(2,1) = cmplx(2.4,3.7,kind=kind_float)
    z_array2(1,2) = cmplx(2.4,-3.7,kind=kind_float)
  else if (basetype_string.eq.'real') then
    z_array2 = real(0,kind=kind_float)
    do j1 = 1, q
      z_array2(j1,j1) = real(j1,kind=kind_float)
    end do
    z_array2(2,1) = real(2.4,kind=kind_float)
    z_array2(1,2) = real(2.4,kind=kind_float)
  end if

  file_string = trim(base_print_string)//"_restart"

  check = .false.
  call array_print_rstrt(file_string,n,m,z_array1,iverb,ierr)
!! check ierr value to see whether routine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write routine failed, write the ierr value
    print *, 'array_print_rstrt failed, ierr=',ierr
    check = .true.
!! set ierr to 0
    ierr = 0
  else
!! if false, write runs
    print *, 'array_print_rstrt runs'
  end if

  call array_read_rstrt_size(file_string,k1,k2,iverb,ierr)
!! check ierr value to see whether routine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write routine failed, write the ierr value
    print *, 'array_read_rstrt_size failed, ierr=',ierr
    check = .true.
!! set ierr to 0
    ierr = 0
  else
!! if false, write runs
    print *, 'array_read_rstrt_size runs'
  end if
  if (k1.ne.n) then
    print *, 'failed reading row size of rstrt, should be ',&
  & n,' not ',k1
    check = .true.
  end if
  if (k2.ne.m) then
    print *, 'failed reading col size of rstrt, should be ',&
  &  m,' not ',k2
  check = .true.
  end if
  call array_read_rstrt(file_string,n,m,z_array4,iverb,ierr)
!! check ierr value to see whether routine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write routine failed, write the ierr value
    print *, 'array_read_rstrt failed, ierr=',ierr
    check = .true.
!! set ierr to 0
    ierr = 0
  else
!! if false, write runs
    print *, 'array_read_rstrt runs'
  end if
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j2 = 1, m
    do j1 = 1, n
      r_ref = sqrt(base_det(z_array1(j1,j2)))
      r_test = sqrt(base_det(z_array4(j1,j2)))
!! test if difference if greater than machine precision
!! (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
        print *, 'failed for elements', j1, j2 
!! set logical check = .true.
        check = .true.
      end if
    end do
  end do
  if (check) then
!! write subroutine failed to output file
    print *, 'subroutines for restart failed'
    write(unit=funit,fmt=*) 'subroutines for restart failed'
  else
!! write subroutine succeeded to output file
    print *, 'tested subroutines for restart'
    write(unit=funit,fmt=*) 'tested subroutines for restart'
  end if
  print *, ''

!!!! The ritz tests begin here

!! Using do loop to fill in the test input
  z_array2 = real(0,kind=kind_float)
  do j1 = 1, q
    z_array2(j1,j1) = real(1,kind=kind_float)
  end do
  z_array4 = real(0,kind=kind_float)
  do j1 = 1, q
    z_array4(j1,j1) = real(j1,kind=kind_float)
  end do
  z_array3 = real(0,kind=kind_float)
  do j1 = 1, q
    z_array3(j1,j1) = real(1,kind=kind_float)
  end do
  r_vector1 = real(0,kind=kind_float)
  do j1 = 1, q
    r_vector1(j1) = real(1,kind=kind_float)
  end do
  z_array6 = real(0,kind=kind_float)
  do j1 = 1, m
    z_array6(j1,j1) = real(j1,kind=kind_float)
  end do
!!! testing ritz_a
!! set logical check = .false.
  check = .false.
!! zeroing output
  r_vector2 = real(0,kind=kind_float)
  z_vector1 = real(0,kind=kind_float)
  z_array5 = real(0,kind=kind_float)
!! write statement on test
  print *, 'test krylov_a_ritz',&
  &', which does the ritz step of an eigenvalue problem'
  print *, 'input z_array2(basis_vectors) is identity'
  print *, 'input z_array4(mvp) is a diagonal',&
  &' matrix of integer values'
  print *, 'input z_array3(overlap) is identity'
  print *, 'input r_vector1(diag_overlap) is all 1'
!! call normalize subroutine
  call krylov_a_ritz(n,q,m,z_array2,z_array4,z_array3,&
  & r_vector1,r_vector2,z_vector1,z_array5,iverb,ierr)
!! check ierr value to see whether routine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write routine failed, write the ierr value
    print *, 'krylov_a_ritz failed, ierr=',ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write subroutine runs
    print *, 'krylov_a_ritz runs'
  end if
!! write info about output
  print *, 'output r_vector2(roots) should be integers'
!! write test to check each element
  print *, 'testing each element of r_vectors2'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j1 = 1, m 
    r_ref = real(j1,kind=kind_float)
!! test if difference if greater than machine precision
!! (defined by the constant eps)
    if (abs(r_vector2(j1)-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
      print *, 'failed for elements', j1
!! set logical check = .true.
      check = .true.
    end if
  end do
!! write info about output
  print *, 'output z_vector1(lagrangian) should be integers'
!! write test to check each element
  print *, 'testing each element of z_vector1'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j1 = 1, m 
    r_test = z_vector1(j1)
    r_ref = real(j1,kind=kind_float)
!! test if difference if greater than machine precision
!! (defined by the constant eps)
    if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
      print *, 'failed for elements', j1
!! set logical check = .true.
      check = .true.
    end if
  end do
!! write info about output
  print *, 'output z_array5(solutions) should be identity'
!! write test to check each element
  print *, 'testing each element of z_array5'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j2 = 1, m 
    do j1 = 1, q
      r_ref = z_array5(j1,j2)
      if (j1.eq.j2) then
        r_test = real(1,kind=kind_float)
      else
        r_test = real(0,kind=kind_float)
      end if
!! test if difference if greater than machine precision
!! (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
        print *, 'failed for elements', j1, j2 
!! set logical check = .true.
        check = .true.
      end if
    end do
  end do
  if (check) then
!! write subroutine failed to output file
    print *, 'subroutine krylov_a_ritz failed'
    write(unit=funit,fmt=*) 'subroutine krylov_a_ritz failed'
  else
!! write subroutine succeeded to output file
    print *, 'tested subroutine krylov_a_ritz'
    write(unit=funit,fmt=*) 'tested subroutine krylov_a_ritz'
  end if
  print *, ''


!!! testing ritz_b
!! set logical check = .false.
  check = .false.
!! zeroing output
  z_vector1 = real(0,kind=kind_float)
  z_array5 = real(0,kind=kind_float)
!! write statement on test
  print *, 'test krylov_b_ritz',&
  &', which does the ritz step of a linear problem'
  print *, 'input z_array2(basis_vectors) is identity'
  print *, 'input z_array4(mvp) is a diagonal',&
  &' matrix of integer values'
  print *, 'input z_array6(projected rhs) is a diagonal',&
  &' matrix of integer values'
  print *, 'input z_array3(overlap) is identity'
  print *, 'input r_vector1(diag_overlap) is all 1'
!! call normalize subroutine
  call krylov_b_ritz(n,q,m,z_array2,z_array4,z_array6,z_array3,&
  & r_vector1,z_vector1,z_array5,iverb,ierr)
!! check ierr value to see whether routine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write routine failed, write the ierr value
    print *, 'krylov_b_ritz failed, ierr=',ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write subroutine runs
    print *, 'krylov_b_ritz runs'
  end if
!! write info about output
  print *, 'output z_vector1(lagrangian) should be -integers'
!! write test to check each element
  print *, 'testing each element of z_vector1'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j1 = 1, m 
    r_test = z_vector1(j1)
    r_ref = real(-j1,kind=kind_float)
!! test if difference if greater than machine precision
!! (defined by the constant eps)
    if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
      print *, 'failed for elements', j1
!! set logical check = .true.
      check = .true.
    end if
  end do
!! write info about output
  print *, 'output z_array5(solutions) should be identity'
!! write test to check each element
  print *, 'testing each element of z_array5'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j2 = 1, m 
    do j1 = 1, q
      r_ref = z_array5(j1,j2)
      if (j1.eq.j2) then
        r_test = real(1,kind=kind_float)
      else
        r_test = real(0,kind=kind_float)
      end if
!! test if difference if greater than machine precision
!! (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
        print *, 'failed for elements', j1, j2 
!! set logical check = .true.
        check = .true.
      end if
    end do
  end do
  if (check) then
!! write subroutine failed to output file
    print *, 'subroutine krylov_b_ritz failed'
    write(unit=funit,fmt=*) 'subroutine krylov_b_ritz failed'
  else
!! write subroutine succeeded to output file
    print *, 'tested subroutine krylov_b_ritz'
    write(unit=funit,fmt=*) 'tested subroutine krylov_b_ritz'
  end if
  print *, ''

!!! testing ritz_c
!! set logical check = .false.
  check = .false.
!! setting unique input
  x1 = real(-5,kind=kind_float)
  z_array4 = real(0,kind=kind_float)
  do j1 = 1, q
    z_array4(j1,j1) = real(j1+x1(1),kind=kind_float)
  end do
!! zeroing output
  z_vector1 = real(0,kind=kind_float)
  z_array5 = real(0,kind=kind_float)
!! write statement on test
  print *, 'test krylov_c_ritz',&
  &', which does the ritz step of a linear problem'
  print *, 'input z_array2(basis_vectors) is identity'
  print *, 'input z_array4(mvp) is a diagonal',&
  &' matrix of (integer+x1) values'
  print *, 'input z_array6(projected rhs) is a diagonal',&
  &' matrix of integer values'
  print *, 'input z_array3(overlap) is identity'
  print *, 'input r_vector1(diag_overlap) is all 1'
  print *, 'input x1(omega) is -5'
!! call normalize subroutine
  call krylov_c_ritz(n,q,1,m,m,z_array2,z_array4,z_array6,z_array3,&
  & r_vector1,x1,z_vector1,z_array5,iverb,ierr)
!! check ierr value to see whether routine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write routine failed, write the ierr value
    print *, 'krylov_c_ritz failed, ierr=',ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write subroutine runs
    print *, 'krylov_c_ritz runs'
  end if
!! write info about output
  print *, 'output z_vector1(lagrangian) should be -integers'
!! write test to check each element
  print *, 'testing each element of z_vector1'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j1 = 1, m 
    r_test = z_vector1(j1)
    r_ref = real(-j1,kind=kind_float)
!! test if difference if greater than machine precision
!! (defined by the constant eps)
    if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
      print *, 'failed for elements', j1
!! set logical check = .true.
      check = .true.
    end if
  end do
!! write info about output
  print *, 'output z_array5(solutions) should be identity'
!! write test to check each element
  print *, 'testing each element of z_array5'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j2 = 1, m 
    do j1 = 1, q
      r_ref = z_array5(j1,j2)
      if (j1.eq.j2) then
        r_test = real(1,kind=kind_float)
      else
        r_test = real(0,kind=kind_float)
      end if
!! test if difference if greater than machine precision
!! (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
        print *, 'failed for elements', j1, j2 
!! set logical check = .true.
        check = .true.
      end if
    end do
  end do
  if (check) then
!! write subroutine failed to output file
    print *, 'subroutine krylov_c_ritz failed'
    write(unit=funit,fmt=*) 'subroutine krylov_c_ritz failed'
  else
!! write subroutine succeeded to output file
    print *, 'tested subroutine krylov_c_ritz'
    write(unit=funit,fmt=*) 'tested subroutine krylov_c_ritz'
  end if
  print *, ''

!! close file
  close(unit=funit,iostat=ierr,status='keep')

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program test_ritz
!--------------------------------------------------------------------
!--------------------------------------------------------------------
