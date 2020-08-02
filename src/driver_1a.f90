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
  use libkrylovinterface
  use libkrylovinterface2
  use libkrylovsolver
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
  implicit none
!--------------------------------------------------------------------
!  Input Subroutines
!--------------------------------------------------------------------
  type(libkrylov_problem_a_input) :: krylov_problem
!  type(kl_approx) :: krylov_approx
  type(lkl_s_elec_gas) :: krylov_s_eg
  type(lkl_s_ext_in) :: krylov_s_ext_in
  type(lkl_g_unit_vec) :: krylov_g_uv
  type(lkl_mvp_n_mul) :: krylov_mvp
  type(libkrylov_problem_a_output) :: krylov_output
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
  type(base), allocatable :: krylov_x(:,:)
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
  integer(kind_integer) :: nbasis,nroots,ntriangle,irestart = 0
  integer(kind_integer) :: maxiter,totalmaxiter = 0
  logical :: no_stop
! file name for eigenvectors
  character(len=32) :: vector_string
! file name for eigenvalues
  character(len=32) :: values_string
! file name for roots included unconverged ones
  character(len=32) :: data_string
! file name for lagrangian string
  character(len=32) :: lagr_string
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
  integer(kind_integer) :: ierr = 0
!--------------------------------------------------------------------

!! set default options
  preconditioner = 'davidson'
  irestart = 0
  nroots = 0
  krylov_s_ext_in%nstart = 0
  maxiter = 0
  totalmaxiter = 0
  no_stop = .false.
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
        print *, '                conjugate_gradient'
        print *, '                davidson'
        print *, '                sleijpen'
        print *, '                half_sleijpen'
        print *, '               default option: davidson'
        print *, ''
        print *, '-irestart     select restart level'
        print *, '               available options: 0 - 3'
        print *, '               1 enables saving and using the solution vectors'
        print *, '               2 saves the basis vectors if calculation is killed'
        print *, '               3 saves the MV vectors if calculation is killed'
        print *, '               default option: 0'
        print *, ''
        print *, '-nroots       select number of roots to solve'
        print *, '               options: less than full space'
        print *, '               default option: nbasis for nbasis < 17'
        print *, '               default option: 2 for 16 < nbasis < 50'
        print *, '               default option: 5 for 200 < nbasis'
        print *, ''
        print *, '-nstart       select size of initial subspace'
        print *, '               options: less than full space'
        print *, '               default option: determined by solver'
        print *, ''
        print *, '-maxiter       select number of iterations before restart'
        print *, '               default option: 30'
        print *, ''
        print *, '-totalmaxiter  select number of iterations before exit'
        print *, '               default option: 80'
        print *, ''
        print *, '-no-stop       set threshold to machine precision'
        print *, ''
        print *, '-test         call solver with ierr .ne. 0'
        print *, '               to see subroutine description'
        print *, ''
        stop
      else if (input.eq.'-test') then
        ierr = 20
        call problem_a_solver1(&
  &       krylov_problem, &
  &       krylov_d,krylov_s_ext_in, &
  &       krylov_g_uv,krylov_mvp, &
  &       krylov_x, &
  &       krylov_output,ierr)
        stop
      else if (input.eq.'-precon') then
        k = k + 1
        call get_command_argument(k,value=input2,status=ierr)
        if (ierr.ne.0) exit
        preconditioner = input2
        print *, 'preconditioner: ',input2
      else if (input.eq.'-irestart') then
        k = k + 1
        call get_command_argument(k,value=input2,status=ierr)
        if (ierr.ne.0) exit
        read(input2,*,iostat=ierr) irestart
        if (ierr.ne.0) exit
        print *, 'restart level: ',input2
      else if (input.eq.'-nroots') then
        k = k + 1
        call get_command_argument(k,value=input2,status=ierr)
        if (ierr.ne.0) exit
        read(input2,*,iostat=ierr) nroots
        print *, 'number of roots: ',input2
        if (ierr.ne.0) exit
      else if (input.eq.'-nstart') then
        k = k + 1
        call get_command_argument(k,value=input2,status=ierr)
        if (ierr.ne.0) exit
        read(input2,*,iostat=ierr) krylov_s_ext_in%nstart
        print *, 'starting subspace size: ',input2
        if (ierr.ne.0) exit
      else if (input.eq.'-maxiter') then
        k = k + 1
        call get_command_argument(k,value=input2,status=ierr)
        if (ierr.ne.0) exit
        read(input2,*,iostat=ierr) maxiter
        print *, 'maximum iterations before restart: ',input2
        if (ierr.ne.0) exit
      else if (input.eq.'-totalmaxiter') then
        k = k + 1
        call get_command_argument(k,value=input2,status=ierr)
        if (ierr.ne.0) exit
        read(input2,*,iostat=ierr) totalmaxiter
        print *, 'maximum iterations before exit: ',input2
        if (ierr.ne.0) exit
      else if (input.eq.'-no-stop') then
        no_stop = .true.
      else if (input.eq.'>') then
        exit
      else if (input.eq.'>>') then
        exit
      end if
      k = k + 1
      if (k.gt.counter) exit
    end do
  end if 
  if (ierr.ne.0) then
    print *, 'faulty input!'
    stop
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

  if (n1.ge.n2) then
    nbasis = n2
  else
    nbasis = n1 
  end if

  if (nroots.le.0) then
    if (nbasis.le.16) then
      nroots = 16
    else if (nbasis.le.50) then
      nroots = 2
    else
      nroots = 5
    end if
  end if

!! allocate array to contain problem
  allocate(krylov_a(nbasis,nbasis))
  allocate(krylov_problem%approx_spectra(nbasis))
  allocate(krylov_output%solutions(nbasis,nroots))

!! read problem array size
  call array_read_base(filename_string,nbasis,&
  &   nbasis,krylov_a,ierr)

  if (ierr.ne.0) then
    print *, 'solver failed as problem matrix can not be read!'
    stop
  end if

  do j = 1, nbasis
    krylov_problem%approx_spectra(j) = krylov_a(j,j)
    krylov_a(j,j) = real(0,kind=kind_float)
  end do

! set pointers to local variables required for input subroutines
  krylov_problem%nbasis = nbasis
  krylov_problem%nroots = nroots
  krylov_problem%precon_string = preconditioner
  krylov_problem%id_string = a1_string
  krylov_problem%minstart = nroots
  krylov_problem%nstart = 0
  krylov_problem%maxstart = nbasis
  if (no_stop) then
    krylov_problem%threshold = real(-logeps,kind=kind_float)
  else
    krylov_problem%threshold = real(-logeps/2,kind=kind_float)
  end if
  if (maxiter.le.0) then
    krylov_problem%maxiter = 30
  else
    krylov_problem%maxiter = maxiter
  end if 
  if (totalmaxiter.le.0) then
    krylov_problem%totalmaxiter = 80
  else
    krylov_problem%totalmaxiter = totalmaxiter
  end if 
  krylov_problem%iverb = 5
  krylov_problem%irestart = irestart

  ntriangle = nroots*(nroots+1)/2

  allocate(krylov_output%roots(ntriangle))
!  krylov_approx%krylov_d => krylov_d
  krylov_mvp%matrix => krylov_a%element

! call solver with function to calculate nstart based on electron gas
  if (krylov_s_ext_in%nstart.le.0) then
    call problem_a_solver1(&
  &   krylov_problem, &
  &   krylov_d,krylov_s_eg, &
  &   krylov_g_uv,krylov_mvp, &
  &   krylov_x, &
  &   krylov_output,ierr)
  else ! call solver with input nstart
    call problem_a_solver1(&
  &   krylov_problem, &
  &   krylov_d,krylov_s_ext_in, &
  &   krylov_g_uv,krylov_mvp, &
  &   krylov_x, &
  &   krylov_output,ierr)
  end if

  print *, 'final ierr value = ',ierr

!! file names
  vector_string = trim(a1_string)//'_vecs'
  values_string = trim(a1_string)//'_vals'
  data_string = trim(a1_string)//'_allr'
  lagr_string = trim(a1_string)//'_lagr'

!! print to file
  call array_print_float(values_string,ntriangle,krylov_output%roots,ierr)

!! print to file
  call array_print_base(vector_string,nbasis,nroots,&
  &          krylov_output%solutions,ierr)

  print *, 'Final Lagrangian: ',krylov_output%lagrangian


  deallocate(krylov_a)
  deallocate(krylov_problem%approx_spectra)
  deallocate(krylov_output%solutions)
  deallocate(krylov_output%roots)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program krylovdriver_1a
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
