!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
module drivertypes_1c
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This module implements functions that are input
!< to the solver in krylovtypes_c.
!< Specifically defining the solver reading a slyvester problem
!< already present on file and pointed to before calling the solver
!< this module uses the basetype.f90 selected at compile time
!< and is thus generic with respect to base type 
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Varaibles
!--------------------------------------------------------------------
! single, double and integer kind parameters
  use basekinds
! precision parameters defining real(kind_float)
  use floatformat
! type(base) of the problem 
! with elementary functions and BLAS calls
  use basetypes
  use blastypes
! krylov subspace function signatures
  use libkrylovinterface
! krylov subspace function signatures, specifically
! for a symmetric slyvester problem
!--------------------------------------------------------------------
! Implicit none
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Extending the abstract interface
!--------------------------------------------------------------------

  type, extends(libkrylov_problem_c_subroutine) :: kl_problem
! external data required for the function
! character string for problem
! pointer to target set outside of solver
! must be set before calling solver
    character(len=22), pointer :: problem_string => null()
! size of the matrix problem
! must be set before calling solver
    integer(kind_integer) :: n_size
! number of frequencies
! must be set before calling solver
    integer(kind_integer) :: n_omega
! number of right hand sides
! must be set before calling solver
    integer(kind_integer) :: n_rhs
! logical for unique rhs per omenga
    logical :: one_rhs_per_omega
! restart level integer
! must be set before calling solver
    integer(kind_integer) :: irestart
  contains
    procedure :: lkl_problem_c => eval_kl_problem
  end type kl_problem

  type, extends(libkrylov_vector_subroutine) :: kl_approx
! external data required for the function
! contains the matrix problem
! pointer to target set outside of solver
! shared with kl_mvp, must be set before calling solver
    type(base), pointer :: krylov_a(:,:) => null()
  contains
    procedure :: vector_fill => fill_kl_approx
  end type kl_approx
  
  type, extends(libkrylov_matrix_subroutine) :: kl_rhs
! external data required for the function
! contains the matrix problem
! pointer to target set outside of solver
! shared with kl_mvp, must be set before calling solver
    type(base), pointer :: krylov_p(:,:) => null()
  contains
    procedure :: matrix_fill => fill_kl_rhs
  end type kl_rhs

  type, extends(libkrylov_vector_subroutine) :: kl_omega
! external data required for the function
! contains the matrix problem
! pointer to target set outside of solver
! shared with kl_mvp, must be set before calling solver
    real(kind_float), pointer :: krylov_o(:) => null()
  contains
    procedure :: vector_fill => fill_kl_omega
  end type kl_omega

  type, extends(libkrylov_mvp_subroutine) :: kl_mvp
! external data required for the function
! contains the matrix problem
! pointer to target set outside of solver
! shared with kl_approx, must be set before calling solver
    type(base), pointer :: krylov_a(:,:) => null()
  contains
    procedure :: lkl_mvp => eval_kl_mvp
  end type kl_mvp

  type, extends(libkrylov_output_c_subroutine) :: kl_output
! external data required for the function
!   no external data
  contains
    procedure :: lkl_output_c => eval_kl_output
  end type kl_output
!--------------------------------------------------------------------

contains
!--------------------------------------------------------------------
! Implementation of input subroutines
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine eval_kl_problem(data,nbasis,nomega,nrhs,&
  &     minstart,maxstart,threshold,maxiter,unique_rhs_omega,&
  &     id_string,iverb,irestart,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine fits into the kl_problem_eval type signature,
!< of user_krylov_a_problem_subroutine
!< setting up the problem with fixed parameters described in 
!< subroutine
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define type(base) and type(basereal) and associated operations
    use floatformat
    use basetypes
    use blastypes
! set interface for this subroutine
    use libkrylovinterface
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! External data (defined in the interface above)
!--------------------------------------------------------------------
    class(kl_problem) :: data
!--------------------------------------------------------------------
! Variables
!--------------------------------------------------------------------
! matching interface defined in krylovtypes_a
    integer(kind_integer), intent(inout) :: nbasis
    integer(kind_integer), intent(inout) :: nomega
    integer(kind_integer), intent(inout) :: nrhs
    integer(kind_integer), intent(inout) :: minstart
    integer(kind_integer), intent(inout) :: maxstart
    real(kind_float), intent(inout) :: threshold
    integer(kind_integer), intent(inout) :: maxiter
    logical, intent(inout) :: unique_rhs_omega
    character(len=22), intent(inout) :: id_string
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: irestart
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!! set nbasis based on size in file 
    nbasis = data%n_size

    nomega = data%n_omega

    nrhs = data%n_rhs

!! choice based on problem description
    if (kind_float.eq.kind_double) then
      threshold = real(8,kind=kind_float)
    else if (kind_float.eq.kind_single) then
      threshold = real(4,kind=kind_float)
    else
      threshold = sqrt(abs(logeps))
    end if 

!! reasonable number of iterations before things go bad
    maxiter = 25

!! take value from above
    unique_rhs_omega = data%one_rhs_per_omega

    if (nbasis.lt.16) then
      minstart = nbasis
      maxstart = nbasis
    else if (nbasis.lt.50) then
      minstart = 8
      maxstart = 16
    else if (nbasis.lt.200) then
      minstart = floor(0.2*nbasis,kind=kind_integer)
      maxstart = floor(0.5*nbasis,kind=kind_integer)
    else
      minstart = floor(0.1*nbasis,kind=kind_integer)
      maxstart = floor(0.3*nbasis,kind=kind_integer)
    end if


!! set id_string based on basetypes
    id_string = data%problem_string

!! set iverb to most verbose operation
    iverb = 5

!! no restart option for solving from file!
    irestart = data%irestart

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine eval_kl_problem
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine fill_kl_approx(data,n1,obj,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine fits into the flaot_fill type signature
!< of user_float_subroutine
!< and makes the approximate spectra 
!< by taking the diagonal of the problem matrix
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
    use floatformat
! define type(base) and type(basereal) and associated operations
    use basetypes
    use blastypes
! set interface for this subroutine
    use libkrylovsolver
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! External data (defined in the interface above)
!--------------------------------------------------------------------
    class(kl_approx) :: data
!--------------------------------------------------------------------
! Variables
!--------------------------------------------------------------------
! matching interface defined in krylovtypes_a
    integer(kind_integer), intent(in) :: n1
    real(kind_float), intent(inout) :: obj(n1)
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!! integer for loops
    integer(kind_integer) :: j = 0
!--------------------------------------------------------------------

!! obtain approximate spectra from diagonal of problem
    do j = 1, n1
      obj(j) = data%krylov_a(j,j)
    end do    

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine fill_kl_approx
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine fill_kl_rhs(data,n1,n2,obj,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine fits into the flaot_fill type signature
!< of user_float_subroutine
!< and makes the approximate spectra 
!< by taking the diagonal of the problem matrix
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
    use floatformat
! define type(base) and type(basereal) and associated operations
    use basetypes
    use blastypes
! set interface for this subroutine
    use libkrylovsolver
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! External data (defined in the interface above)
!--------------------------------------------------------------------
    class(kl_rhs) :: data
!--------------------------------------------------------------------
! Variables
!--------------------------------------------------------------------
! matching interface defined in krylovtypes_a
    integer(kind_integer), intent(in) :: n1
    integer(kind_integer), intent(in) :: n2
    complex(kind_float), intent(inout) :: obj(n1,n2)
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!! integer for loops
    integer(kind_integer) :: j = 0
!--------------------------------------------------------------------

!! copy in all right hand sides
    obj(1:n1,1:n2) = data%krylov_p(1:n1,1:n2)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine fill_kl_rhs
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine fill_kl_omega(data,n1,obj,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine fits into the flaot_fill type signature
!< of user_float_subroutine
!< and makes the approximate spectra 
!< by taking the diagonal of the problem matrix
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
    use floatformat
! define type(base) and type(basereal) and associated operations
    use basetypes
    use blastypes
! set interface for this subroutine
    use libkrylovsolver
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! External data (defined in the interface above)
!--------------------------------------------------------------------
    class(kl_omega) :: data
!--------------------------------------------------------------------
! Variables
!--------------------------------------------------------------------
! matching interface defined in krylovtypes_a
    integer(kind_integer), intent(in) :: n1
    real(kind_float), intent(inout) :: obj(n1)
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!! copy all frequencies
    obj(1:n1) = data%krylov_o(1:n1)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine fill_kl_omega
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine eval_kl_mvp(data,n1,n2,&
  &     basis_vectors,mvproduct,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine fits into the kl_mvp_eval type signature
!< of user_krylov_mvp_subroutine
!< and does the matrix-vector products naively and explicitly.
!< using a BLAS call
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
    use floatformat
! define type(base) and type(basereal) and associated operations
    use basetypes
    use blastypes
! set interface for this subroutine
    use libkrylovinterface
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! External data (defined in the interface above)
!--------------------------------------------------------------------
    class(kl_mvp) :: data
!--------------------------------------------------------------------
! Variables
!--------------------------------------------------------------------
! matching interface defined in krylovtypes_a
   integer(kind_integer), intent(in) :: n1
   integer(kind_integer), intent(in) :: n2
   complex(kind_float), intent(inout) :: basis_vectors(n1,n2)
   complex(kind_float), intent(inout) :: mvproduct(n1,n2)
   integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
! constants for blas calls
   type(base) :: one_kb
   type(base) :: zero_kb
! mapping for ggemm
   type(base), allocatable :: bv(:,:)
   type(base), allocatable :: mvp(:,:)
!--------------------------------------------------------------------


   allocate(bv(n1,n2))
   allocate(mvp(n1,n2))

!! make basis vectors type(base)
   bv = basis_vectors

!! Set constants required for BLAS
   one_kb = real(1,kind=kind_float)
   zero_kb = real(0,kind=kind_float)

!! calculate matrix-vector product
   call ggemm('n','n',n1,n2,n1,&
  &   one_kb,data%krylov_a,n1,&
  &   bv,n1,zero_kb,&
  &   mvp,n1)

!! make mvp real
   mvproduct = mvp

   deallocate(bv)
   deallocate(mvp)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine eval_kl_mvp
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine eval_kl_output(data,n1,n2,n3,n4,n5,n6,&
  &     jconverged,omega,rhs,lagrangian,solutions,&
  &     euc_norm,fro_norm,id_string,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine fits into the kl_output_eval type signature
!< of user_krylov_a_output_subroutine
!< and prints the roots and solutions to file.
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! precision parameters for real(kind_float)
    use floatformat
! define type(base)and associated operations
    use basetypes
    use blastypes
! set interface for this subroutine
    use libkrylovinterface
! for file i/o : printing operations
    use arrayfile
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! External data (defined in the interface above)
!--------------------------------------------------------------------
    class(kl_output) :: data
!--------------------------------------------------------------------
! Variables
!--------------------------------------------------------------------
! matching interface defined in krylovtypes_b
    integer(kind_integer), intent(in) :: n1
    integer(kind_integer), intent(in) :: n2
    integer(kind_integer), intent(in) :: n3
    integer(kind_integer), intent(in) :: n4
    integer(kind_integer), intent(in) :: n5
    integer(kind_integer), intent(in) :: n6
    logical, intent(in) :: jconverged(n5)
    real(kind_float), intent(in) :: omega(n3)
    complex(kind_float), intent(in) :: rhs(n1,n4)
    complex(kind_float), intent(in) :: lagrangian(n5)
    complex(kind_float), intent(in) :: solutions(n1,n5)
    real(kind_float), intent(in) :: euc_norm(n5)
    real(kind_float), intent(in) :: fro_norm
    character(len=22), intent(in) :: id_string
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
! file name for eigenvectors
    character(len=32) :: vector_string
! file name for eigenvalues
    character(len=32) :: values_string
! file name for roots included unconverged ones
    character(len=32) :: data_string
! file name for roots included unconverged ones
    character(len=32) :: freq_string
! all roots
    type(base), allocatable :: all_lagrangian(:,:)
! converged roots
    type(base), allocatable :: converged_lagrangian(:,:)
! converged solutions
    type(base), allocatable :: converged_solutions(:,:)
! converged freq
    real(kind_float), allocatable :: converged_freq(:)
! integer for loops
    integer(kind_integer) :: j,k,l,m = 0
!--------------------------------------------------------------------

!! file names
    vector_string = trim(id_string)//'_vecs'
    values_string = trim(id_string)//'_lagr'
    data_string = trim(id_string)//'_allr'
    freq_string = trim(id_string)//'_indx'

    allocate(all_lagrangian(1,n5))
    allocate(converged_lagrangian(1,n6))
    allocate(converged_solutions(n1,n6))
    allocate(converged_freq(n6))

    k = 0
    l = 0 ! cycle over rhs
    m = 1 ! cycle over frequencies
    if (((n3.eq.n4).and.(n4.eq.n5)).or.(n4.eq.1)) then
      do j = 1, n5
        all_lagrangian(1,j) = lagrangian(j)
        if (jconverged(j)) then
          k = k + 1
          converged_freq(k) = omega(j)
          converged_lagrangian(1,k) = lagrangian(j)
          converged_solutions(1:n1,k) = solutions(1:n1,j)
        end if
      end do
    else
      do j = 1, n5
        l = l + 1
        if (l.gt.n4) then
          l = 1
          m = m + 1
        end if
        all_lagrangian(1,j) = lagrangian(j)
        if (jconverged(j)) then
          k = k + 1
          converged_freq(k) = omega(m)
          converged_lagrangian(1,k) = lagrangian(j)
          converged_solutions(1:n1,k) = solutions(1:n1,j)
        end if
      end do
    end if


!! print to file
    call array_print_base(data_string,1,n5,all_lagrangian,ierr)

!! print to file
    call array_print_base(values_string,1,n6,converged_lagrangian,ierr)

!! print to file
    call array_print_float(freq_string,n6,converged_freq,ierr)

!! print to file
    call array_print_base(vector_string,n1,n6,converged_solutions,ierr)

!! deallocate solutions
    deallocate(converged_freq)
    deallocate(converged_lagrangian)
    deallocate(converged_solutions)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine eval_kl_output
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module drivertypes_1c
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------


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
  use drivertypes_1c
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
  implicit none
!--------------------------------------------------------------------
!  Input Subroutines
!--------------------------------------------------------------------
  type(kl_problem) :: krylov_problem
  type(kl_approx) :: krylov_approx
  type(lkl_s_elec_gas) :: krylov_s_eg
  type(kl_rhs) :: krylov_rhs
  type(kl_omega) :: krylov_omega
  type(lkl_g_unit_vec) :: krylov_g_uv
  type(lkl_pc_none) :: krylov_pc_none
  type(lkl_pc_approx) :: krylov_pc_approx
  type(lkl_pc_davidson) :: krylov_pc_davidson
  type(kl_mvp) :: krylov_mvp
  type(kl_output) :: krylov_output
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
  if (preconditioner.eq.'davidson') then
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
