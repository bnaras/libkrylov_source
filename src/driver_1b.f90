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
  use driver1types
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
  type(lkl_s_ext_in) :: krylov_s_ext_in
  type(kl_rhs) :: krylov_rhs
  type(lkl_g_unit_vec) :: krylov_g_uv
  type(kl_mvp) :: krylov_mvp
  type(kl_output_b) :: krylov_output
!--------------------------------------------------------------------
! Local Variables for Subroutines and reading problem
!--------------------------------------------------------------------
  integer(kind_integer) :: counter = 0
  character(len=32) :: input,input2 = ''
! character string for preconditioner string
  character(len=32), target :: preconditioner = ''
! contains the matrix of problem, read in from file
  type(base), target, allocatable :: krylov_a(:,:)
  real(kind_float), target, allocatable :: krylov_d(:)
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
  integer(kind_integer) :: j,k = 0
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
  integer(kind_integer) :: ierr = 0
!--------------------------------------------------------------------

!! set default options
  preconditioner = 'davidson'
  krylov_problem%irestart = 0
  krylov_s_ext_in%nstart = 0
!! checking command line options:
  counter = command_argument_count()
!! loop over command line
  k = 1
  if (counter.gt.0) then
    do 
      call get_command_argument(k,value=input,status=ierr)
      if (ierr.ne.0) stop
      if ((input.eq.'-help').or.(input.eq.'--help')) then
        print *, 'driver for libkrylov problem_a_solver '
        print *, ' where problem is on file:'
        print *, ''
        print *, 'options:'
        print *, '--help        display this message'
        print *, ''
        print *, '-precon       select preconditioner'
        print *, '               available options:'
        print *, '                none'
        print *, '                approx_spectra'
        print *, '                davidson'
        print *, '                sleijpen'
        print *, '                half_sleijpen'
        print *, '               default option: davidson'
        print *, ''
        print *, '-irestart     select restart level'
        print *, '               available options: 0 - 4'
        print *, '               default option: 0'
        print *, ''
        print *, '-nstart       select size of initial subspace'
        print *, '               default option: estimated'
        print *, ''
        print *, '-test         call solver with ierr .ne. 0'
        print *, '               to see subroutine description'
        print *, ''
        stop
      else if (input.eq.'-test') then
        ierr = 20
        call problem_b_solver(krylov_approx,krylov_s_eg, &
  &       krylov_rhs, &
  &       krylov_problem,krylov_g_uv,krylov_mvp, &
  &       krylov_output,ierr)
        stop
      else if (input.eq.'-precon') then
        k = k + 1
        call get_command_argument(k,value=input2,status=ierr)
        if (ierr.ne.0) stop
        preconditioner = input2
        print *, 'preconditioner: ',input2
      else if (input.eq.'-irestart') then
        k = k + 1
        call get_command_argument(k,value=input2,status=ierr)
        if (ierr.ne.0) stop
        read(input2,*,iostat=ierr) krylov_problem%irestart
        if (ierr.ne.0) stop
        print *, 'restart level: ',input2
      else if (input.eq.'-nstart') then
        k = k + 1
        call get_command_argument(k,value=input2,status=ierr)
        if (ierr.ne.0) stop
        read(input2,*,iostat=ierr) krylov_s_ext_in%nstart
        print *, 'starting subspace size: ',input2
        if (ierr.ne.0) stop
      else if (input.eq.'>') then
        exit
      else if (input.eq.'>>') then
        exit
      end if
      k = k + 1
      if (k.gt.counter) exit
    end do
  end if 

!! setting up the problem before calling solver

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
  allocate(krylov_d(krylov_problem%n_size))

!! read problem array
  call array_read_base(filename_string,krylov_problem%n_size,&
  &    krylov_problem%n_size,krylov_a,ierr)

  if (ierr.ne.0) then
    print *, 'solver failed as problem can not be read!'
    stop
  end if

  do j = 1, krylov_problem%n_size
    krylov_d(j) = krylov_a(j,j)
    krylov_a(j,j) = real(0,kind=kind_float)
  end do


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
  krylov_problem%precon_string => preconditioner
  krylov_approx%krylov_d => krylov_d
  krylov_mvp%krylov_a => krylov_a
  krylov_rhs%krylov_p => krylov_p

! call solver with function to calculate nstart based on electron gas
  if (krylov_s_ext_in%nstart.le.0) then
! call solver
    call problem_b_solver(krylov_approx,krylov_s_eg, &
  &   krylov_rhs, &
  &   krylov_problem,krylov_g_uv,krylov_mvp, &
  &   krylov_output,ierr)
  else ! use input nstart
    call problem_b_solver(krylov_approx,krylov_s_ext_in, &
  &   krylov_rhs, &
  &   krylov_problem,krylov_g_uv,krylov_mvp, &
  &   krylov_output,ierr)
  end if

  print *, 'final ierr value = ',ierr

! no post calculation operations, everything done within solver
  deallocate(krylov_a)
  deallocate(krylov_d)
  deallocate(krylov_p)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program krylovdriver_1b
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
