!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
program krylovdriver_1b
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This program acts as a wrapper for the eigen_solver subroutine in
!< krylovtypes_b and the input functions described above,
!< which when combined create a krylov space eigenvalue
!< solver which reads in the matrix problem from file
!< (named : <basetype>_1a_prob.raft )
!< solves the lowest 5% of the eigenvalues,
!< starting from the smallest 20% of the subspace.
!< and prints the solutions to file
!< (eigenvectors named : <basetype>_1a_vecs.raft )
!< (eigenvalues named : <basetype>_1a_vals.raft )
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
  use basekinds
! define parameters of precision of real(kind_float)
  use floatformat
! define type(base) and type(basereal) and associated operations
  use basetypes
  use blastypes
! for file i/o : reading size and contents operations
  use arrayfile
! set interfaces
  use libkrylovsolver
! define the input subroutines
  use driver1types_cmplx_sp
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
  implicit none
!--------------------------------------------------------------------
!  Input Subroutines
!--------------------------------------------------------------------
  type(kl_problem_b) :: krylov_problem
  type(kl_approx) :: krylov_approx
  type(lkl_s_elec_gas) :: krylov_s_eg
  type(kl_rhs) :: krylov_rhs
  type(lkl_g_unit_vec) :: krylov_g_uv
  type(lkl_pc_none) :: krylov_pc_none
  type(lkl_pc_approx) :: krylov_pc_approx
  type(lkl_pc_davidson) :: krylov_pc_davidson
  type(kl_mvp) :: krylov_mvp
  type(kl_output_b) :: krylov_output
!--------------------------------------------------------------------
! Local Variables for Subroutines and reading problem
!--------------------------------------------------------------------
! character string for preconditioner string
  character(len=32) :: preconditioner = ''
! contains the matrix of problem, read in from file
  type(base), target, allocatable :: krylov_a(:,:)
! contains the rhs of problem, read in from file
  type(base), target, allocatable :: krylov_p(:,:)
! character string to become id_string in solver
  character(len=22), target :: b1_string = ''
! character string for file name that is to be read at the moment
  character(len=32) :: filename_string = ''
! character string for type in file, for checking
  character(len=32) :: filetype_string = ''
! integers for reading size of problem from file
! which becomes nbasis via krylov_problem%n_size
  integer(kind_integer) :: n1 = 0
  integer(kind_integer) :: n2 = 0
! which becomes the size of rhs
  integer(kind_integer) :: n3 = 0
  integer(kind_integer) :: n4 = 0
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
  integer(kind_integer) :: ierr = 0
!--------------------------------------------------------------------

!! setting up the problem before calling solver

!! ask for user input on preconditoner
  print *, 'Please enter an option for the preconditioner'
  read (*,*) preconditioner
  print *, preconditioner,' entered'

!! set irestart
  krylov_problem%irestart = 0

!! set a1_string based on basetypes
  b1_string = trim(base_print_string)//'_1b'

!! set the filename_string for the file name of prob
  filename_string = trim(b1_string)//'_prob'

!! read problem array size
  call array_read_base_size(filename_string,n1,n2,filetype_string,ierr)

  if (ierr.ne.0) then
    print *, 'solver failed as there is no problem to be solved!'
    stop
  else if (filetype_string.ne.filename_string) then
    print *, 'solver failed as type in problem file is incorrect!'
    stop
  end if

  if (n1.gt.n2) then
    krylov_problem%n_size = n1
  else
    krylov_problem%n_size = n2 
  end if

!! allocate array to contain problem
  allocate(krylov_a(krylov_problem%n_size,krylov_problem%n_size))

!! read problem array
  call array_read_base(filename_string,krylov_problem%n_size,&
  &    krylov_problem%n_size,krylov_a,ierr)

  if (ierr.ne.0) then
    print *, 'solver failed as problem can not be read!'
    stop
  end if


!! set the filename_string for the file name of rhs
  filename_string = trim(b1_string)//'_rhs'

!! read rhs array size
  call array_read_base_size(filename_string,n3,n4,filetype_string,ierr)

  if (ierr.ne.0) then
    print *, 'solver failed as there is no rhs to be solved!'
    stop
  else if (filetype_string.ne.filename_string) then
    print *, 'solver failed as type in rhs file is incorrect!'
    stop
  end if

  if (n3.ne.krylov_problem%n_size) then
    print *, 'solver failed as rhs basis does not match problem!'
    stop
  end if

  if (n4.gt.n3) then
    print *, 'solver failed as too many rhs given!'
    stop
  end if

  krylov_problem%n_rhs = n4

!! allocate array to contain problem
  allocate(krylov_p(krylov_problem%n_size,krylov_problem%n_rhs))

!! read problem array
  call array_read_base(filename_string,krylov_problem%n_size,&
  &    krylov_problem%n_rhs,krylov_p,ierr)

  if (ierr.ne.0) then
    print *, 'solver failed as rhs can not be read!'
    stop
  end if

! set pointers to local variables required for input subroutines
  krylov_problem%problem_string => b1_string
  krylov_approx%krylov_a => krylov_a
  krylov_mvp%krylov_a => krylov_a
  krylov_rhs%krylov_p => krylov_p

! call solver
  if (preconditioner.eq.'davidson') then
    print *, 'equivalent to approx_spectra'
    call problem_b_solver(krylov_approx,krylov_s_eg,&
  &   krylov_rhs, &
  &   krylov_problem,krylov_g_uv,krylov_mvp,krylov_pc_davidson, &
  &   krylov_output,ierr)
  else if (preconditioner.eq.'approx_spectra') then
    call problem_b_solver(krylov_approx,krylov_s_eg,&
  &   krylov_rhs, &
  &   krylov_problem,krylov_g_uv,krylov_mvp,krylov_pc_approx, &
  &   krylov_output,ierr)
  else if (preconditioner.eq.'none') then
    call problem_b_solver(krylov_approx,krylov_s_eg,&
  &   krylov_rhs, &
  &   krylov_problem,krylov_g_uv,krylov_mvp,krylov_pc_none, &
  &   krylov_output,ierr)
  else
    print *, 'unrecognised preconditioner string'
    print *, 'using approx_spectra'
    call problem_b_solver(krylov_approx,krylov_s_eg, &
  &   krylov_rhs, &
  &   krylov_problem,krylov_g_uv,krylov_mvp,krylov_pc_approx, &
  &   krylov_output,ierr)
  end if

  print *, 'final ierr value = ',ierr

! no post calculation operations, everything done within solver
  deallocate(krylov_a)
  deallocate(krylov_p)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program krylovdriver_1b
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
