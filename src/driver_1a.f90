!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
program krylovdriver_1a
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
!< (named : <basetype>_1a_prob.raft )
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
  type(kl_problem_a) :: krylov_problem
  type(kl_approx) :: krylov_approx
  type(lkl_s_elec_gas) :: krylov_s_eg
  type(lkl_s_ext_in) :: krylov_s_ext_in
  type(lkl_g_unit_vec) :: krylov_g_uv
  type(lkl_pc_all) :: krylov_pc_all
  type(lkl_mta_all) :: krylov_maket_all
  type(lkl_pc_none) :: krylov_pc_none
  type(lkl_pc_approx) :: krylov_pc_approx
  type(lkl_pc_davidson) :: krylov_pc_davidson
  type(lkl_pc_sleijpen) :: krylov_pc_sleijpen
  type(kl_mvp) :: krylov_mvp
  type(kl_output_a) :: krylov_output
!--------------------------------------------------------------------
! Local Variables for Subroutines and reading problem
!--------------------------------------------------------------------
! command line arguments
  integer(kind_integer) :: counter
! character string for preconditioner string
  character(len=32) :: input,input2 = ''
! character string for preconditioner string
  character(len=32),target :: preconditioner = ''
! contains the matrix problem, read in from file
  type(base), target, allocatable :: krylov_a(:,:)
  real(kind_float), target, allocatable :: krylov_d(:)
! character string to become id_string in solver
  character(len=22), target :: a1_string = ''
! character string for file name that contains the problem
  character(len=32) :: filename_string = ''
! character string for type in file, for checking
  character(len=32) :: filetype_string = ''
! integers for reading size of problem from file
! which becomes nbasis via krylov_problem%n_size
  integer(kind_integer) :: n1 = 0
  integer(kind_integer) :: n2 = 0
  integer(kind_integer) :: j,k = 0
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
  integer(kind_integer) :: ierr = 0
!--------------------------------------------------------------------

!! set default options
  krylov_pc_all%precon_string = 'davidson'
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
        print *, '               default option: davidson'
        print *, ''
        print *, '-irestart     select restart level'
        print *, '               available options: 0 - 4'
        print *, '               default option: 0'
        print *, ''
        print *, '-nroots       select number of roots to solve'
        print *, '               default option: nbasis for nbasis < 17'
        print *, '               default option: 2 for 16 < nbasis < 50'
        print *, '               default option: 5 for 200 < nbasis'
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
        call problem_a_solver(krylov_approx,krylov_s_eg,&
  &       krylov_problem, &
  &       krylov_g_uv,krylov_mvp,krylov_pc_all, &
  &       krylov_maket_all,krylov_output,ierr)
        stop
      else if (input.eq.'-precon') then
        k = k + 1
        call get_command_argument(k,value=input2,status=ierr)
        if (ierr.ne.0) stop
        krylov_pc_all%precon_string = input2
        krylov_maket_all%precon_string = input2
        preconditioner = input2
        print *, 'preconditioner: ',input2
      else if (input.eq.'-irestart') then
        k = k + 1
        call get_command_argument(k,value=input2,status=ierr)
        if (ierr.ne.0) stop
        read(input2,*,iostat=ierr) krylov_problem%irestart
        if (ierr.ne.0) stop
        print *, 'restart level: ',input2
      else if (input.eq.'-nroots') then
        k = k + 1
        call get_command_argument(k,value=input2,status=ierr)
        if (ierr.ne.0) stop
        read(input2,*,iostat=ierr) krylov_problem%nroots
        print *, 'number of roots: ',input2
        if (ierr.ne.0) stop
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
  a1_string = trim(base_print_string)//'_1a'

!! set the filename_string for the file name 
  filename_string = trim(a1_string)//'_prob'

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

!! read problem array size
  call array_read_base(filename_string,krylov_problem%n_size,&
  &   krylov_problem%n_size,krylov_a,ierr)

  if (ierr.ne.0) then
    print *, 'solver failed as problem matrix can not be read!'
    stop
  end if

  do j = 1, krylov_problem%n_size
    krylov_d(j) = krylov_a(j,j)
    krylov_a(j,j) = real(0,kind=kind_float)
  end do

! set pointers to local variables required for input subroutines
  krylov_problem%problem_string => a1_string
  krylov_problem%precon_string => preconditioner
  krylov_approx%krylov_d => krylov_d
  krylov_mvp%krylov_a => krylov_a

! call solver with function to calculate nstart based on electron gas
  if (krylov_s_ext_in%nstart.le.0) then
    call problem_a_solver(krylov_approx,krylov_s_eg,&
  &   krylov_problem, &
  &   krylov_g_uv,krylov_mvp,krylov_pc_all, &
  &   krylov_maket_all,krylov_output,ierr)
  else ! call solver with input nstart
    call problem_a_solver(krylov_approx,krylov_s_ext_in,&
  &   krylov_problem, &
  &   krylov_g_uv,krylov_mvp,krylov_pc_all, &
  &   krylov_maket_all,krylov_output,ierr)
  end if

  print *, 'final ierr value = ',ierr

! no post calculation operations, everything done within solver
  deallocate(krylov_a)
  deallocate(krylov_d)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program krylovdriver_1a
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
