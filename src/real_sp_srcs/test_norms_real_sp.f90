!--------------------------------------------------------------------
!--------------------------------------------------------------------
program test_norms_real_sp
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This program tests the solver subroutines in libkrylovsolver
!< that use libkrylovinterface
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
  use arrayfile
  use libkrylovinterface
!--------------------------------------------------------------------
!
  implicit none
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
! External types
  type(lkl_pc_none) :: krylov_pc_none
  type(lkl_pc_approx) :: krylov_pc_approx
  type(lkl_pc_davidson) :: krylov_pc_davidson
! parameter for array sizes for the test
! nbasis
  integer(kind_integer), parameter :: n1 = 10
! nsubspace
  integer(kind_integer), parameter :: n2 = 4
! nroots or nhs
  integer(kind_integer), parameter :: n3 = 4
! nomega
  integer(kind_integer), parameter :: n4 = 1
! nroots
  integer(kind_integer), parameter :: n5 = n3*n4
! integer for loops
  integer(kind_integer) :: j1,j2 = 0
! test and reference for real numbers
  real(kind_float) :: r_test
  real(kind_float) :: r_ref 
! variable for array tests
  logical :: check = .false.
! integer for error variable
  integer(kind_integer) :: ierr = 0
! file unit
  integer(kind_integer) :: funit = 0
  character(len=32) :: fname = ''
! name of file
  character(len=32) :: name_string = '_norms_test'
! approxiamte spectra
  real(kind_float) :: approx_spectra(n1)
! omega
  real(kind_float) :: omega(n4)
! basis vectors
  type(base) :: mvproduct(n1,n2)
! basis vectors
  type(base) :: basis_vectors(n1,n2)
! solutions
  type(base) :: solutions(n2,n3)
! solutions
  type(base) :: full_solutions(n1,n3)
! rhs
  type(base) :: rhs(n1,n3)
! overlap
  type(base) :: overlap(n2,n2)
! roots
  real(kind_float) :: roots(n3)
! residuals
  type(base) :: residuals(n1,n3)
! euc_norms
  real(kind_float) :: euc_norm(n3)
! largest_euc_norms
  real(kind_float) :: largest_euc_norm
! fro_norm
  real(kind_float) :: fro_norm
! nresiduals
  integer(kind_integer) :: nresiduals
! iverb
  integer(kind_integer) :: iverb = 5 
!--------------------------------------------------------------------
!!  find free unit numbers for files
!!  presumes first 14 unit numbers are saved for
!!  specific use.

  if (2*n2.gt.n1) then
    print *, 'Test failed!'
    print *, 'program compiled with bad parameters'
    print *, 'nsubspace(n2) must be at most half of nbasis(n1)'
    stop
  end if


  call find_free_file_unit(funit,ierr)
  if (ierr.ne.0) then
    print *, 'No free file units!, test failed'
    stop
  end if
  
!! define fname
  fname = trim(base_print_string)//trim(name_string)//'.sum'

!! open file
  open(unit=funit,file=fname,action='write',status='replace',&
  & iostat=ierr)

!! printing test results as they run
  print *, 'Testing solver norms'

  print *, 'This basetype is ',base_print_string

  print *, 'machine precision'
  print *,  eps

  print *, 'log10 of machine precision'
  print *, logeps
  print *, ''
 
!! Using do loop to fill in the test input
  approx_spectra = real(0,kind=kind_float)
  do j1 = 1, n1
    approx_spectra(j1) = real(j1,kind=kind_float)
  end do
  basis_vectors = real(0,kind=kind_float)
  do j1 = 1, n2
    basis_vectors(j1,j1) = real(1,kind=kind_float)
  end do
  mvproduct = real(0,kind=kind_float)
  do j1 = 1, n2
    mvproduct(j1,j1) = real(j1,kind=kind_float)
  end do
  do j1 = 1, n2
    mvproduct(1+n1-j1,j1) = &
  & (real(j1,kind=kind_float)&
  & *real(0.1,kind=kind_float))
  end do
  solutions = real(0,kind=kind_float)
  do j1 = 1, n3
    solutions(j1,j1) = real(1,kind=kind_float)
  end do
  full_solutions = real(0,kind=kind_float)
  do j1 = 1, n3
    full_solutions(j1,j1) = real(1,kind=kind_float)
  end do
  roots = real(0,kind=kind_float)
  do j1 = 1, n3
    roots(j1) = real(j1,kind=kind_float)
  end do
  rhs = real(0,kind=kind_float)
  do j1 = 1, n3
    rhs(j1,j1) = real(j1,kind=kind_float)
  end do
  omega = real(-5,kind=kind_float)
  overlap = real(0,kind=kind_float)
  do j1 = 1, n2
    overlap(j1,j1) = real(1,kind=kind_float)
  end do
!!! testing norms_a
!! set logical check = .false.
  check = .false.
!! zeroing output
  nresiduals = 0
  residuals = real(0,kind=kind_float)
  euc_norm = real(0,kind=kind_float)
  largest_euc_norm = real(0,kind=kind_float)
  fro_norm = real(0,kind=kind_float)
!! write statement on test
  print *, 'test krylov_a_norms',&
  &', which does the norms step of an eigenvalue problem'
  print *, 'input preconditioner does no preconditioning'
  print *, 'input approx_spectra are integers'
  print *, 'input basis_vectors is identity'
  print *, 'input mvproduct is a diagonal',&
  &' matrix of integer values with',&
  &' (integer)x(0.1) values on the counter diagonal'
  print *, 'input overlap is identity'
  print *, 'input roots are integers'
!! call normalize subroutine
  call krylov_a_norms(n1,n2,n3,mvproduct,basis_vectors,full_solutions,&
  & solutions,overlap,roots,approx_spectra,krylov_pc_none,&
  & residuals,euc_norm,largest_euc_norm,fro_norm,nresiduals,iverb,ierr)
!! check ierr value to see whether routine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write routine failed, write the ierr value
    print *, 'krylov_a_norms failed, ierr=',ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write subroutine runs
    print *, 'krylov_a_norms runs'
  end if
!! write info about output
  print *, 'output residuals should be counter diagonal'
  print *, ' of integer(x0.1) values'
!! write test to check each element
  print *, 'testing each element of residuals'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
!! write info about output
  do j2 = 1, n2 
    do j1 = 1, n1
      r_ref = residuals(j1,j2)
      if (j1.eq.n1+1-j2) then
        r_test = real(0.1,kind=kind_float)&
  &              *real(j2,kind=kind_float)
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
  print *, 'output euc_norm should be integers(x0.1)'
!! write test to check each element
  print *, 'testing each element of euc_norm'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j1 = 1, n3
    r_ref = real(j1,kind=kind_float)*real(0.1,kind=kind_float)
!! test if difference if greater than machine precision
!! (defined by the constant eps)
    if (abs(euc_norm(j1)-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
      print *, 'failed for elements', j1
!! set logical check = .true.
      check = .true.
    end if
  end do
!! write info about output
  print *, 'output largest_euc_norm should be nroots(x0.1)'
!! take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  r_ref = real(n3,kind=kind_float)*real(0.1,kind=kind_float)
!! test if difference if greater than machine precision
!! (defined by the constant eps)
  if (abs(largest_euc_norm-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
    print *, 'failed to obtain correct largest_euc_norm'
!! set logical check = .true.
    check = .true.
  end if
!! write info about output
  print *, 'output fro_norm should be sqrt(sum(euc_norm^2))'
!! take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  r_ref = real(0,kind=kind_float)
  do j1 = 1, n3
    r_ref = r_ref + (euc_norm(j1)*euc_norm(j1))
  end do
  r_ref = sqrt(r_ref)
!! test if difference if greater than machine precision
!! (defined by the constant eps)
  if (abs(fro_norm-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
    print *, 'failed to obtain correct fro_norm'
!! set logical check = .true.
    check = .true.
  end if
!! write info about output
  print *, 'output nresiduals should be nroots'
!! take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
!! test if difference if greater than machine precision
!! (defined by the constant eps)
  if (abs(nresiduals-n3).gt.0) then
!! if true, write failed for elements
!! and the position of the element that failed
    print *, 'failed to obtain correct nresiduals'
!! set logical check = .true.
    check = .true.
  end if
  if (check) then
!! write subroutine failed to output file
    print *, 'subroutine krylov_a_norms failed'
    write(unit=funit,fmt=*) 'subroutine krylov_a_norms failed'
  else
!! write subroutine succeeded to output file
    print *, 'tested subroutine krylov_a_norms'
    write(unit=funit,fmt=*) 'tested subroutine krylov_a_norms'
  end if
  print *, ''

!!! testing norms_b
!! set logical check = .false.
  check = .false.
!! zeroing output
  nresiduals = 0
  residuals = real(0,kind=kind_float)
  euc_norm = real(0,kind=kind_float)
  largest_euc_norm = real(0,kind=kind_float)
  fro_norm = real(0,kind=kind_float)
!! write statement on test
  print *, 'test krylov_b_norms',&
  &', which does the norms step of a linear problem'
  print *, 'input preconditioner does no preconditioning'
  print *, 'input approx_spectra are integers'
  print *, 'input basis_vectors is identity'
  print *, 'input mvproduct is a diagonal',&
  &' matrix of integer values with',&
  &' (integer)x(0.1) values on the counter diagonal'
  print *, 'input overlap is identity'
  print *, 'input rhs are diagonal matrix of integers'
!! call normalize subroutine
  call krylov_b_norms(n1,n2,n3,mvproduct,basis_vectors,full_solutions,&
  & solutions,overlap,rhs,approx_spectra,krylov_pc_none,&
  & residuals,euc_norm,largest_euc_norm,fro_norm,nresiduals,iverb,ierr)
!! check ierr value to see whether routine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write routine failed, write the ierr value
    print *, 'krylov_b_norms failed, ierr=',ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write subroutine runs
    print *, 'krylov_b_norms runs'
  end if
!! write info about output
  print *, 'output residuals should be counter diagonal'
  print *, ' of integer(x0.1) values'
!! write test to check each element
  print *, 'testing each element of residuals'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
!! write info about output
  do j2 = 1, n2 
    do j1 = 1, n1
      r_ref = residuals(j1,j2)
      if (j1.eq.n1+1-j2) then
        r_test = real(0.1,kind=kind_float)&
  &              *real(j2,kind=kind_float)
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
  print *, 'output euc_norm should be integers(x0.1)'
!! write test to check each element
  print *, 'testing each element of euc_norm'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j1 = 1, n3
    r_ref = real(j1,kind=kind_float)*real(0.1,kind=kind_float)
!! test if difference if greater than machine precision
!! (defined by the constant eps)
    if (abs(euc_norm(j1)-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
      print *, 'failed for elements', j1
!! set logical check = .true.
      check = .true.
    end if
  end do
!! write info about output
  print *, 'output largest_euc_norm should be nroots(x0.1)'
!! take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  r_ref = real(n3,kind=kind_float)*real(0.1,kind=kind_float)
!! test if difference if greater than machine precision
!! (defined by the constant eps)
  if (abs(largest_euc_norm-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
    print *, 'failed to obtain correct largest_euc_norm'
!! set logical check = .true.
    check = .true.
  end if
!! write info about output
  print *, 'output fro_norm should be sqrt(sum(euc_norm^2))'
!! take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  r_ref = real(0,kind=kind_float)
  do j1 = 1, n3
    r_ref = r_ref + (euc_norm(j1)*euc_norm(j1))
  end do
  r_ref = sqrt(r_ref)
!! test if difference if greater than machine precision
!! (defined by the constant eps)
  if (abs(fro_norm-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
    print *, 'failed to obtain correct fro_norm'
!! set logical check = .true.
    check = .true.
  end if
!! write info about output
  print *, 'output nresiduals should be nroots'
!! take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
!! test if difference if greater than machine precision
!! (defined by the constant eps)
  if (abs(nresiduals-n3).gt.0) then
!! if true, write failed for elements
!! and the position of the element that failed
    print *, 'failed to obtain correct nresiduals'
!! set logical check = .true.
    check = .true.
  end if
  if (check) then
!! write subroutine failed to output file
    print *, 'subroutine krylov_b_norms failed'
    write(unit=funit,fmt=*) 'subroutine krylov_b_norms failed'
  else
!! write subroutine succeeded to output file
    print *, 'tested subroutine krylov_b_norms'
    write(unit=funit,fmt=*) 'tested subroutine krylov_b_norms'
  end if
  print *, ''

!! unique input for krylov_c_norms
  mvproduct = real(0,kind=kind_float)
  do j1 = 1, n2
    mvproduct(j1,j1) = real(j1+omega(1),kind=kind_float)
  end do
  do j1 = 1, n2
    mvproduct(1+n1-j1,j1) = &
  & (real(j1,kind=kind_float)&
  & *real(0.1,kind=kind_float))
  end do
!!! testing norms_c
!! set logical check = .false.
  check = .false.
!! zeroing output
  nresiduals = 0
  residuals = real(0,kind=kind_float)
  euc_norm = real(0,kind=kind_float)
  largest_euc_norm = real(0,kind=kind_float)
  fro_norm = real(0,kind=kind_float)
!! write statement on test
  print *, 'test krylov_c_norms',&
  &', which does the norms step of a Sylvester problem'
  print *, 'input preconditioner does no preconditioning'
  print *, 'input approx_spectra are integers'
  print *, 'input basis_vectors is identity'
  print *, 'input mvproduct is a diagonal',&
  &' matrix of integer+omega values with',&
  &' (integer)x(0.1) values on the counter diagonal'
  print *, 'input overlap is identity'
  print *, 'input rhs are diagonal matrix of integers'
!! call normalize subroutine
  call krylov_c_norms(n1,n2,n4,n3,n5,mvproduct,basis_vectors,&
  & full_solutions,solutions,&
  & overlap,omega,rhs,approx_spectra,krylov_pc_none,&
  & residuals,euc_norm,largest_euc_norm,fro_norm,nresiduals,iverb,ierr)
!! check ierr value to see whether routine terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write routine failed, write the ierr value
    print *, 'krylov_c_norms failed, ierr=',ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write subroutine runs
    print *, 'krylov_c_norms runs'
  end if
!! write info about output
  print *, 'output residuals should be counter diagonal'
  print *, ' of integer(x0.1) values'
!! write test to check each element
  print *, 'testing each element of residuals'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
!! write info about output
  do j2 = 1, n2 
    do j1 = 1, n1
      r_ref = residuals(j1,j2)
      if (j1.eq.n1+1-j2) then
        r_test = real(0.1,kind=kind_float)&
  &              *real(j2,kind=kind_float)
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
  print *, 'output euc_norm should be integers(x0.1)'
!! write test to check each element
  print *, 'testing each element of euc_norm'
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  do j1 = 1, n3
    r_ref = real(j1,kind=kind_float)*real(0.1,kind=kind_float)
!! test if difference if greater than machine precision
!! (defined by the constant eps)
    if (abs(euc_norm(j1)-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
      print *, 'failed for elements', j1
!! set logical check = .true.
      check = .true.
    end if
  end do
!! write info about output
  print *, 'output largest_euc_norm should be nroots(x0.1)'
!! take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  r_ref = real(n3,kind=kind_float)*real(0.1,kind=kind_float)
!! test if difference if greater than machine precision
!! (defined by the constant eps)
  if (abs(largest_euc_norm-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
    print *, 'failed to obtain correct largest_euc_norm'
!! set logical check = .true.
    check = .true.
  end if
!! write info about output
  print *, 'output fro_norm should be sqrt(sum(euc_norm^2))'
!! take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
  r_ref = real(0,kind=kind_float)
  do j1 = 1, n3
    r_ref = r_ref + (euc_norm(j1)*euc_norm(j1))
  end do
  r_ref = sqrt(r_ref)
!! test if difference if greater than machine precision
!! (defined by the constant eps)
  if (abs(fro_norm-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
    print *, 'failed to obtain correct fro_norm'
!! set logical check = .true.
    check = .true.
  end if
!! write info about output
  print *, 'output nresiduals should be nroots'
!! take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
!! test if difference if greater than machine precision
!! (defined by the constant eps)
  if (abs(nresiduals-n3).gt.0) then
!! if true, write failed for elements
!! and the position of the element that failed
    print *, 'failed to obtain correct nresiduals'
!! set logical check = .true.
    check = .true.
  end if
  if (check) then
!! write subroutine failed to output file
    print *, 'subroutine krylov_c_norms failed'
    write(unit=funit,fmt=*) 'subroutine krylov_c_norms failed'
  else
!! write subroutine succeeded to output file
    print *, 'tested subroutine krylov_c_norms'
    write(unit=funit,fmt=*) 'tested subroutine krylov_c_norms'
  end if
  print *, ''

!! close file
  close(unit=funit,iostat=ierr,status='keep')

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program test_norms_real_sp
!--------------------------------------------------------------------
!--------------------------------------------------------------------
