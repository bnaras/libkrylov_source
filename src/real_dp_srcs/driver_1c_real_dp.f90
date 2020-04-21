!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
program krylovdriver_1c
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This program acts as a wrapper for the eigen_solver subroutine in
!< krylovtypes_a and the input functions described above,
!< which when combined create a krylov space eigenvalue
!< solver which reads in the matrix problem from file
!< (named : <basetype>_1c_prob.raft )
!< solves the lowest 5% of the eigenvalues,
!< starting from the smallest 20% of the subspace.
!< and prints the solutions to file
!< (eigenvectors named : <basetype>_1c_vecs.raft )
!< (eigenvalues named : <basetype>_1c_vals.raft )
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
  use driver1types_real_dp
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
  implicit none
!--------------------------------------------------------------------
!  Input Subroutines
!--------------------------------------------------------------------
  type(kl_problem_c) :: krylov_problem
  type(kl_approx) :: krylov_approx
  type(lkl_s_elec_gas) :: krylov_s_eg
  type(kl_rhs) :: krylov_rhs
  type(kl_omega) :: krylov_omega
  type(lkl_g_unit_vec) :: krylov_g_uv
  type(lkl_pc_none) :: krylov_pc_none
  type(lkl_pc_approx) :: krylov_pc_approx
  type(lkl_pc_davidson) :: krylov_pc_davidson
  type(lkl_pc_sleijpen) :: krylov_pc_sleijpen
  type(kl_mvp) :: krylov_mvp
  type(kl_output_c) :: krylov_output
!--------------------------------------------------------------------
! Local Variables for Subroutines and reading problem
!--------------------------------------------------------------------
! character string for preconditioner string
  character(len=32) :: preconditioner = ''
! contains the matrix of problem, read in from file
  type(base), target, allocatable :: krylov_a(:,:)
! contains the frequencies of the problem, read in from file
  real(kind_float), target, allocatable :: krylov_o(:)
! contains the rhs of problem, read in from file
  type(base), target, allocatable :: krylov_p(:,:)
! character string to become id_string in solver
  character(len=22), target :: c1_string = ''
! character string for file name that is to be read at the moment
  character(len=32) :: filename_string = ''
! character string for type in file, for checking
  character(len=32) :: filetype_string = ''
! integers for reading size of problem from file
! which becomes nbasis via krylov_problem%n_size
  integer(kind_integer) :: n1 = 0
  integer(kind_integer) :: n2 = 0
! which becomes the number of frequencies
  integer(kind_integer) :: n3 = 0
! which becomes the size of rhs
  integer(kind_integer) :: n4 = 0
  integer(kind_integer) :: n5 = 0
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
  c1_string = trim(base_print_string)//'_1c'

!! set the filename_string for the file name of prob
  filename_string = trim(c1_string)//'_prob'

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

!! set the filename_string for the file name of frequencies
  filename_string = trim(c1_string)//'_freq'

!! read frequencies array size
  call array_read_float_size(filename_string,n3,filetype_string,ierr)

  if (ierr.ne.0) then
!! frequency file does not exist
    print *, 'solver failed as freq can not be read!'
    stop
  else if (ierr.eq.0) then
!! no errors reading frequency file
    if (filetype_string.ne.filename_string) then
      print *, 'solver failed as type in frequency file is incorrect!'
      stop
    end if
    if (n1.gt.n3) then
      krylov_problem%n_omega = n3
    else
      print *, 'solver failed as too many frequencies given!'
      stop
    end if
  !! allocate array to contain problem
    allocate(krylov_o(krylov_problem%n_omega))
  !! read problem array size
    call array_read_float(filename_string,krylov_problem%n_omega,&
  &   krylov_o,ierr)
    if (ierr.ne.0) then
      print *, 'solver failed as frequencies can not be read!'
      stop
    end if
  end if

!! set the filename_string for the file name of rhs
  filename_string = trim(c1_string)//'_rhs'

!! read rhs array size
  call array_read_base_size(filename_string,n4,n5,filetype_string,ierr)

  if (ierr.ne.0) then
    print *, 'solver failed as there is no rhs to be solved!'
    stop
  else if (filetype_string.ne.filename_string) then
    print *, 'solver failed as type in rhs file is incorrect!'
    stop
  end if

  if (n4.ne.krylov_problem%n_size) then
    print *, 'solver failed as rhs basis does not match problem!'
    stop
  end if

  if (n5.gt.n4) then
    print *, 'solver failed as too many rhs given!'
    stop
  end if

  krylov_problem%one_rhs_per_omega = .false.
  if ((n5*n3).gt.n1) then
    if (n5.eq.n3) then
      print *, 'solver forced to solve only one rhs per frequency'
      krylov_problem%one_rhs_per_omega = .true.
    else ! n5 .ne. n3
      print *, 'solver failed as too many rhs*freq given!'
      stop
    end if
  end if 

  krylov_problem%n_rhs = n5 

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
  krylov_problem%problem_string => c1_string
  krylov_approx%krylov_a => krylov_a
  krylov_mvp%krylov_a => krylov_a
  krylov_omega%krylov_o => krylov_o
  krylov_rhs%krylov_p => krylov_p

! call solver
  if (preconditioner.eq.'sleijpen') then
    call problem_c_solver(krylov_approx,krylov_s_eg,&
  &   krylov_rhs,krylov_omega, &
  &   krylov_problem,krylov_g_uv,krylov_mvp,krylov_pc_sleijpen, &
  &   krylov_output,ierr)
  else if (preconditioner.eq.'davidson') then
    call problem_c_solver(krylov_approx,krylov_s_eg,&
  &   krylov_rhs,krylov_omega, &
  &   krylov_problem,krylov_g_uv,krylov_mvp,krylov_pc_davidson, &
  &   krylov_output,ierr)
  else if (preconditioner.eq.'approx_spectra') then
    call problem_c_solver(krylov_approx,krylov_s_eg,&
  &   krylov_rhs,krylov_omega, &
  &   krylov_problem,krylov_g_uv,krylov_mvp,krylov_pc_approx, &
  &   krylov_output,ierr)
  else if (preconditioner.eq.'none') then
    call problem_c_solver(krylov_approx,krylov_s_eg,&
  &   krylov_rhs,krylov_omega, &
  &   krylov_problem,krylov_g_uv,krylov_mvp,krylov_pc_none, &
  &   krylov_output,ierr)
  else
    print *, 'unrecognised preconditioner string'
    print *, 'using davidson'
    call problem_c_solver(krylov_approx,krylov_s_eg, &
  &   krylov_rhs,krylov_omega, &
  &   krylov_problem,krylov_g_uv,krylov_mvp,krylov_pc_davidson, &
  &   krylov_output,ierr)
  end if

  print *, 'final ierr value = ',ierr

! no post calculation operations, everything done within solver
  deallocate(krylov_a)
  deallocate(krylov_o)
  deallocate(krylov_p)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program krylovdriver_1c
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
