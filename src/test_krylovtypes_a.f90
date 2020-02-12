!--------------------------------------------------------------------
!--------------------------------------------------------------------
program test_krylovtypes_a
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
  use krylovtypes
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!!~~~~~~~~~~~~~~~~~~Test settings~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! parameter for array sizes for the test
! nbasis
  integer(kind_integer), parameter :: n1 = 100
! nsubspace1, prev_nsubspace
  integer(kind_integer), parameter :: n2 = 5
! nroots, maximum nresiduals
  integer(kind_integer), parameter :: n3 = 3
! maximum nsubspace2 = n2+n3
  integer(kind_integer), parameter :: n4 = 8
!! threshold for how sensitive this test is
  real(kind_float) :: threshold = logeps+2
! integer for debug error variable
  integer(kind_integer) :: iverb = 5
! logical to generate new reference files
  logical :: generate_new = .true.
!!~~~~~~~~~~~~~~End Test settings~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! nresiduals output
  integer(kind_integer) :: k1,k2 = 0
!! variables of the derived type for testing
  integer(kind_integer) :: dex(n1)
  real(kind_float) :: approx_spectra1(n1)
  real(kind_float) :: approx_spectra2(n1)
  type(base) :: basis_vectors1(n1,n2)
  type(base) :: mvproduct1(n1,n2)
  type(base) :: problem(n1,n1)
  type(base) :: mvproduct2(n1,n4)
  type(base) :: overlap1(n2,n2)
  real(kind_float) :: diag_overlap1(n2)
  real(kind_float) :: roots(n3)
  type(base) :: lagrangian(n3)
  type(base) :: solutions1(n2,n3)
  type(base) :: solutions2(n4,n3)
  type(base) :: residuals(n1,n3)
  real(kind_float) :: euc_norm(n3)
  real(kind_float) :: largest_euc_norm
  logical :: eps_converged(n3)
  real(kind_float) :: fro_norm
  type(kl_pc_davidson) :: krylov_pc_davidson
  type(kl_pc_approx) :: krylov_pc_approx
  type(base) :: basis_vectors2(n1,n4)
  type(base) :: overlap2(n4,n4)
  real(kind_float) :: diag_overlap2(n4)
!! reference arrays read from file for comparison
  real(kind_float) :: ref1(n3)
  real(kind_float) :: ref2(n4)
! integer for loops
  integer(kind_integer) :: j1,j2 = 0
! integer for debug error variable
  integer(kind_integer) :: ierr = 0
! string for printing
  character(len=32) :: file_string
! constants
  type(base) :: one_kb
  type(base) :: zero_kb
! testing preconditioners
  integer :: npass = 0
!--------------------------------------------------------------------

  print *, 'testing krylov subspace subroutines'
  print *, 'Compiler details:'
  print *, 'The basetype is " ',basetype_string,' "' 
  print *, 'With precision " ',float_print_string,' "'
  print *, 'with machine precision ',eps
  print *, 'and log10 of machine precision is ',logeps
  print *, 'threshold for comparing to reference is 10^(',threshold,')'
  print *, ' '
  print *, 'number of basis functions is ',n1
  print *, 'size of subspace is ',n2
  print *, 'number of desired solutions is ',n3
  print *, ' which should also be the number of residuals'

! fill in basis vectors,overlap,diag_overlap with identity
  basis_vectors1 = real(0,kind=kind_float)
  basis_vectors2 = real(0,kind=kind_float)
  overlap1 = real(0,kind=kind_float)
  overlap2 = real(0,kind=kind_float)
  diag_overlap1 = real(1,kind=kind_float)
  diag_overlap2 = real(0,kind=kind_float)
  do j1 = 1, n2
    basis_vectors1(j1,j1) = real(1,kind=kind_float)
    basis_vectors2(j1,j1) = real(1,kind=kind_float)
    overlap1(j1,j1) = real(1,kind=kind_float)
    overlap2(j1,j1) = real(1,kind=kind_float)
    diag_overlap2(j1) = real(1,kind=kind_float)
  end do

! matrix problem
! with natural numbers 1-10 on diagonal
! and all other elements (0.02,0.01)

! matrix vector products 
  mvproduct1 = real(0,kind=kind_float)
  mvproduct2 = real(0,kind=kind_float)
  problem = real(0,kind=kind_float)
  print *, 'matrix problem has multiples of 4 on diagonal'
  print *, 'with all other elements being 0.01'
  do j2 = 1, n1
    do j1 = 1, n1
      if (j1.eq.j2) then
        problem(j1,j1) = real(j1*4,kind=kind_float)
      else 
        problem(j1,j2) = real(0.01,kind=kind_float)
      end if
    end do
  end do
  do j1 = 1, n1
    approx_spectra2(j1) = problem(j1,j1)
  end do
  mvproduct1 = problem(1:n1,1:n2)
  print *, 'arrays filled'

  print *, '~~~~~~~~~~~~'

! test ritz subroutine
  print *, 'testing ritz- the following are'
  print *, 'automatically printed to standard output by subroutine'
  print *, '  one-norm and reciprocal of condition number'
  print *, '  of scaled overlap matrix,'
  print *, '  all solutions on the subspace,'
  print *, '  Lagrangian of desired solutions.'
  call krylov_a_ritz(n1,n2,n3,basis_vectors1,mvproduct1,overlap1,&
  &                diag_overlap1,roots,lagrangian,solutions1,iverb,ierr)
  if (ierr.ne.0) then
    print *, 'krylov ritz(subspace solve) subroutine failed'
    ierr = 0
  end if
  file_string = (trim(base_print_string)//trim('_roots1_test'))
!! line to generate new reference file
  if (generate_new) then
    call array_print_float(file_string,n3,roots,ierr)
    if (ierr.ne.0) then
      print *, 'unable to print new reference for roots'
      ierr = 0
    end if
    print *, '               index                roots'
    do j1 = 1, n3
      print *, j1,roots(j1)
    end do
  else
    call array_read_float(file_string,n3,ref1,ierr)
    if (ierr.eq.0) then
      ref1 = ref1 - roots
      print *, 'comparing to reference on file:'
      do j1 = 1, n3
        if(log10(abs(ref1(j1))).le.threshold) then
          print *, j1,' roots1 within threshold to reference'
        else
          print *, j1,' roots1 significantly different from reference'
        end if 
      end do
      print *, '               index                roots        diff'
      do j1 = 1, n3
        print *, j1,roots(j1),ref1(j1)
      end do
    else
      ierr = 0
      print *, 'unable to read reference for roots'
      print *, '               index                roots'
      do j1 = 1, n3
        print *, j1,roots(j1)
      end do
    end if
  end if
  do j2 = 1, n3
    print *, '               index           solution(',j2,')'
    do j1 = 1, n2
      print *, j1,solutions1(j1,j2)
    end do
  end do
  print *, 'tested ritz'
  print *, '~~~~~~~~~~~~'

  print *, 'testing norms(davidson) - the following are'
  print *, 'automatically printed to standard output by subroutine'
  print *, '  frobenius norm of residual matrix,'
  print *, '  largest euclidean norm of residual matrix,'
  print *, '  all euclidean norms of residual matrix,'
  print *, '  number of residuals with norms above machine precision,'
  print *, '  all euclidean norms of preconditioned residual matrix,'
  print *, '  number of preconditioned residuals for expanding basis,'
  call krylov_a_norms(n1,n2,n3,mvproduct1,basis_vectors1,&
  &              solutions1,overlap1,roots,&
  &              approx_spectra2,krylov_pc_davidson,&
  &              residuals,&
  &              euc_norm,largest_euc_norm,&
  &              fro_norm,k1,iverb,ierr)
  if (ierr.ne.0) then
    print *, 'krylov norms subroutine failed'
    ierr = 0
  end if
  file_string = (trim(base_print_string)//trim('_r_norms1_test'))
!! line to generate new reference file
  if (generate_new) then
    call array_print_float(file_string,n3,euc_norm,ierr)
    if (ierr.ne.0) then
      print *, 'unable to print new reference for euc_norms'
      ierr = 0
    end if
    print *, '               index   residual_euc_norm                    converged'
    do j1 = 1, n3
      print *, j1,euc_norm(j1),eps_converged(j1)
    end do
  else
    call array_read_float(file_string,n3,ref1,ierr)
    if (ierr.eq.0) then
      ref1 = ref1 - euc_norm
      print *, 'comparing to reference on file:'
      do j1 = 1, n3
        if(log10(abs(ref1(j1))).le.threshold) then
          print *, j1,' residual norm1 within threshold to reference'
        else
          print *, j1,' residual norm1 significantly different from reference'
        end if 
      end do
      print *, '               index   residual_euc_norm         diff                    converged'
      do j1 = 1, n3
        print *, j1,euc_norm(j1),ref1(j1),eps_converged(j1)
      end do
    else
      ierr = 0
      print *, 'unable to read reference for euc_norms'
      print *, '               index   residual_euc_norm                    converged'
      do j1 = 1, n3
        print *, j1,euc_norm(j1),eps_converged(j1)
      end do
    end if
  end if
  print *, 'preconditioned residuals'
  print *, '                 row               column   element'
  do j2 = 1, k1
    do j1 = 1, n1
      print *, j1,j2,residuals(j1,j2)
    end do
  end do
  print *, 'tested norms(davidson)'
  print *, '~~~~~~~~~~~~'

  print *, 'testing extend(davidson) - the following are'
  print *, 'automatically printed to standard output by subroutine'
  print *, '  diagonals of overlap matrix,'
  print *, '  roots of overlap matrix.'

  k2 = n2+k1
  call krylov_extend(n1,k2,k1,n2,residuals(1:n1,1:k1),&
  &                basis_vectors2(1:n1,1:k2),&
  &                overlap2(1:k2,1:k2),diag_overlap2(1:k2),iverb,ierr)
  if (ierr.ne.0) then
    if (ierr.eq.-25) then
      print *, 'davidson preconditioning of residuals failed'
    else 
      print *, '(davidson) extension of subspace subroutine failed'
    end if
    ierr = 0
  else
    npass = npass + 1
  end if
  do j2 = 1, k2
    print *, '               index           basis_vector(',j2,')'
    do j1 = 1, n1
      print *, j1,basis_vectors2(j1,j2)
    end do
  end do
  file_string = (trim(base_print_string)//trim('_b_norms1_test'))
!! line to generate new reference file
  if (generate_new) then
    call array_print_float(file_string,k2,diag_overlap2(1:k2),ierr)
    if (ierr.ne.0) then
      print *, 'unable to print new reference for davidson precondition'
      ierr = 0
    end if
    print *, '               index   basis_vector_norm'
    do j1 = 1, k2
      print *, j1,diag_overlap2(j1)
    end do
  else
    call array_read_float(file_string,k2,ref2(1:k2),ierr)
    if (ierr.eq.0) then
      ref2(1:k2) = ref2(1:k2) - diag_overlap2(1:k2)
      print *, 'comparing to reference on file:'
      do j1 = 1, k2
        if(log10(abs(ref2(j1))).le.threshold) then
          print *, j1,' basis_vector1 norms within threshold to reference'
        else
          print *, j1,' basis_vector1 norms significantly different from reference'
        end if 
      end do
      print *, '               index   basis_vector_norm         diff'
      do j1 = 1, k2
        print *, j1,diag_overlap2(j1),ref2(j1)
      end do
    else
      ierr = 0
      print *, 'unable to read reference for davidson precondtion'
      print *, '               index   basis_vector_norm'
      do j1 = 1, k2
        print *, j1,diag_overlap2(j1)
      end do
    end if
  end if
  print *, 'new overlap matrix'
  print *, '                 row               column   element'
  do j2 = 1, k2
    do j1 = 1, k2
      print *, j1,j2,overlap2(j1,j2)
    end do
  end do

  print *, 'tested extend(davidson)'
  print *, '~~~~~~~~~~~~'

  print *, 'testing norms(approx_spectra) - the following are'
  print *, 'automatically printed to standard output by subroutine'
  print *, '  frobenius norm of residual matrix,'
  print *, '  largest euclidean norm of residual matrix,'
  print *, '  all euclidean norms of residual matrix,'
  print *, '  number of residuals with norms above machine precision,'
  print *, '  all euclidean norms of preconditioned residual matrix,'
  print *, '  number of preconditioned residuals for expanding basis,'
  call krylov_a_norms(n1,n2,n3,mvproduct1,basis_vectors1,&
  &              solutions1,overlap1,roots,&
  &              approx_spectra2,krylov_pc_approx,&
  &              residuals,&
  &              euc_norm,largest_euc_norm,&
  &              fro_norm,k1,iverb,ierr)
  if (ierr.ne.0) then
    print *, 'krylov norms subroutine failed'
    ierr = 0
  end if
  file_string = (trim(base_print_string)//trim('_r_norms1_test'))
!! norms should be exactly the same, no generation of new reference file
  if (generate_new) then
    print *, '               index   residual_euc_norm                    converged'
    do j1 = 1, n3
      print *, j1,euc_norm(j1),eps_converged(j1)
    end do
  else
    call array_read_float(file_string,n3,ref1,ierr)
    if (ierr.eq.0) then
      ref1 = ref1 - euc_norm
      print *, 'comparing to reference on file:'
      do j1 = 1, n3
        if(log10(abs(ref1(j1))).le.threshold) then
          print *, j1,' residual norm2 within threshold to reference'
        else
          print *, j1,' residual norm2 significantly different from reference'
        end if 
      end do
      print *, '               index   residual_euc_norm         diff                    converged'
      do j1 = 1, n3
        print *, j1,euc_norm(j1),ref1(j1),eps_converged(j1)
      end do
    else
      ierr = 0
      print *, 'unable to read reference for euc_norms'
      print *, '               index   residual_euc_norm                    converged'
      do j1 = 1, n3
        print *, j1,euc_norm(j1),eps_converged(j1)
      end do
    end if
  end if
  print *, 'preconditioned residuals'
  print *, '                 row               column   element'
  do j2 = 1, k1
    do j1 = 1, n1
      print *, j1,j2,residuals(j1,j2)
    end do
  end do
  print *, 'tested norms(approx_spectra)'
  print *, '~~~~~~~~~~~~'

  print *, 'testing extend(approx_spectra) - the following are'
  print *, 'automatically printed to standard output by subroutine'
  print *, '  diagonals of overlap matrix,'
  print *, '  roots of overlap matrix.'

  k2 = n2+k1
  call krylov_extend(n1,k2,k1,n2,residuals(1:n1,1:k1),&
  &                basis_vectors2(1:n1,1:k2),&
  &                overlap2(1:k2,1:k2),diag_overlap2(1:k2),iverb,ierr)
  if (ierr.ne.0) then
    if (ierr.eq.-25) then
      print *, 'approx_spectra preconditioning of residuals failed'
    else 
      print *, '(approx_spectra) extension of subspace subroutine failed'
    end if
    ierr = 0
  else
    npass = npass + 1
  end if
  do j2 = 1, k2
    print *, '               index           basis_vector(',j2,')'
    do j1 = 1, n1
      print *, j1,basis_vectors2(j1,j2)
    end do
  end do
  file_string = (trim(base_print_string)//trim('_b_norms2_test'))
!! line to generate new reference file
  if (generate_new) then
    call array_print_float(file_string,k2,diag_overlap2(1:k2),ierr)
    print *, '               index   basis_vector_norm'
    do j1 = 1, k2
      print *, j1,diag_overlap2(j1)
    end do
    if (ierr.ne.0) then
      print *, 'unable to print new reference for approx_spectra precondition'
      ierr = 0
    end if
  else
    call array_read_float(file_string,k2,ref2(1:k2),ierr)
    if (ierr.eq.0) then
      ref2(1:k2) = ref2(1:k2) - diag_overlap2(1:k2)
      print *, 'comparing to reference on file:'
      do j1 = 1, k2
        if(log10(abs(ref2(j1))).le.threshold) then
          print *, j1,' basis_vector2 norms within threshold to reference'
        else
          print *, j1,' basis_vector2 norms significantly different from reference'
        end if 
      end do
      print *, '               index   basis_vector_norm         diff'
      do j1 = 1, k2
        print *, j1,diag_overlap2(j1),ref2(j1)
      end do
    else
      ierr = 0
      print *, 'unable to read reference for approx_spectra precondition'
      print *, '               index   basis_vector_norm'
      do j1 = 1, k2
        print *, j1,diag_overlap2(j1)
      end do
    end if
  end if
  print *, 'new overlap matrix'
  print *, '                 row               column   element'
  do j2 = 1, k2
    do j1 = 1, k2
      print *, j1,j2,overlap2(j1,j2)
    end do
  end do

  print *, 'tested extend(approx_spectra)'
  print *, '~~~~~~~~~~~~'

  if (npass.eq.0) then
    print *, 'no preconditioner expands subspace well, failed'
  else if (npass.eq.1) then
    print *, 'only 1 preconditioner expands subspace well, failed'
  else if (npass.eq.2) then
    print *, 'both preconditioners expands subspace well.'
  end if

!  one_kb = real(1,kind=kind_float)
!  zero_kb = real(0,kind=kind_float)
!  call ggemm('n','n',n1,n4,n1,one_kb,problem,n1,&
!  &  basis_vectors2,n1,zero_kb,mvproduct2,n1)
!  print *, 'prepared new mvproduct from new basis vectors'
!  print *, '~~~~~~~~~~~~'



!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program test_krylovtypes_a
!--------------------------------------------------------------------
!--------------------------------------------------------------------
