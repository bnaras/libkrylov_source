!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
module driver1types
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This module implements functions that are input
!< to the solver in libkrylov.
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
! libkrylov solver input functions signatures and functions
  use libkrylovinterface
  use libkrylovinterface2
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

  type, extends(libkrylov_problem_a_subroutine) :: kl_problem_a
! external data required for the function
! character string for problem
! pointer to target set outside of solver
! must be set before calling solver
    character(len=22), pointer :: problem_string => null()
! character string for preconditioner selection
! pointer to target set outside of solver
! must be set before calling solver
    character(len=32), pointer :: precon_string => null()
! size of the matrix problem
! must be set before calling solver
    integer(kind_integer) :: n_size
! restart level integer
! must be set before calling solver
    integer(kind_integer) :: irestart
! number of roots to be solved
! must be set before calling solver
    integer(kind_integer) :: nroots
  contains
    procedure :: lkl_problem_a => eval_kl_problem_a
  end type kl_problem_a

  type, extends(libkrylov_problem_b_subroutine) :: kl_problem_b
! external data required for the function
! character string for problem
! pointer to target set outside of solver
! must be set before calling solver
    character(len=22), pointer :: problem_string => null()
! character string for preconditioner selection
! pointer to target set outside of solver
! must be set before calling solver
    character(len=32), pointer :: precon_string => null()
! size of the matrix problem
! must be set before calling solver
    integer(kind_integer) :: n_size
! number of right hand sides
! must be set before calling solver
    integer(kind_integer) :: n_rhs
! restart level integer
! must be set before calling solver
    integer(kind_integer) :: irestart
  contains
    procedure :: lkl_problem_b => eval_kl_problem_b
  end type kl_problem_b

  type, extends(libkrylov_problem_c_subroutine) :: kl_problem_c
! external data required for the function
! character string for problem
! pointer to target set outside of solver
! must be set before calling solver
    character(len=22), pointer :: problem_string => null()
! character string for preconditioner selection
! pointer to target set outside of solver
! must be set before calling solver
    character(len=32), pointer :: precon_string => null()
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
    procedure :: lkl_problem_c => eval_kl_problem_c
  end type kl_problem_c

  type, extends(libkrylov_vector_subroutine) :: kl_approx
! external data required for the function
! contains the matrix problem
! pointer to target set outside of solver
! shared with kl_mvp, must be set before calling solver
    real(kind_float), pointer :: krylov_d(:) => null()
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

  type, extends(libkrylov_output_a_subroutine) :: kl_output_a
! external data required for the function
!   no external data
  contains
    procedure :: lkl_output_a => eval_kl_output_a
  end type kl_output_a

  type, extends(libkrylov_output_b_subroutine) :: kl_output_b
! external data required for the function
!   no external data
  contains
    procedure :: lkl_output_b => eval_kl_output_b
  end type kl_output_b

  type, extends(libkrylov_output_c_subroutine) :: kl_output_c
! external data required for the function
!   no external data
  contains
    procedure :: lkl_output_c => eval_kl_output_c
  end type kl_output_c

!--------------------------------------------------------------------

contains
!--------------------------------------------------------------------
! Implementation of input subroutines
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine eval_kl_problem_a(data,nbasis,nroots,&
  &     minstart,maxstart,threshold,maxiter,&
  &     id_string,precon_string,iverb,irestart,ierr)
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
    class(kl_problem_a) :: data
!--------------------------------------------------------------------
! Variables
!--------------------------------------------------------------------
! matching interface defined in krylovtypes_a
    integer(kind_integer), intent(inout) :: nbasis
    integer(kind_integer), intent(inout) :: nroots
    integer(kind_integer), intent(inout) :: minstart
    integer(kind_integer), intent(inout) :: maxstart
    real(kind_float), intent(inout) :: threshold
    integer(kind_integer), intent(inout) :: maxiter
    character(len=22), intent(inout) :: id_string
    character(len=32), intent(inout) :: precon_string
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: irestart
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!! set nbasis based on size in file 
    nbasis = data%n_size

!! choice based on problem description
    if (nbasis.lt.16) then
      nroots = nbasis
      minstart = nbasis
      maxstart = nbasis
    else if (nbasis.lt.50) then
      nroots = 2
      minstart = 0
      maxstart = 16
    else if (nbasis.lt.200) then
      nroots = 5
      minstart = 20
      maxstart = floor(0.8*nbasis,kind=kind_integer)
    else
      nroots = 5
      minstart = 0
      maxstart = floor(0.3*nbasis,kind=kind_integer)
    end if

!! set nroots based on user input if reasonable
    if ((data%nroots.gt.0).and.(data%nroots.lt.maxstart)) then
      nroots = data%nroots
    end if

!! choice based on problem description
!! threshold
    threshold = (-logeps)/2
!    if (floattype_string.eq.'dp') then
!      threshold = real(8,kind=kind_float)
!    else if (floattype_string.eq.'sp') then
!      threshold = real(4,kind=kind_float)
!    end if

!! reasonable number of iterations before things go bad
    maxiter = 25

!! set id_string based on basetypes
    id_string = data%problem_string

!! set precon_string based on basetypes
    precon_string = data%precon_string

!! set iverb to most verbose operation
    iverb = 5

!! no restart option for solving from file!
    irestart = data%irestart

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine eval_kl_problem_a
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine eval_kl_problem_b(data,nbasis,nrhs,&
  &     minstart,maxstart,threshold,maxiter,&
  &     id_string,precon_string,iverb,irestart,ierr)
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
    class(kl_problem_b) :: data
!--------------------------------------------------------------------
! Variables
!--------------------------------------------------------------------
! matching interface defined in krylovtypes_a
    integer(kind_integer), intent(inout) :: nbasis
    integer(kind_integer), intent(inout) :: nrhs
    integer(kind_integer), intent(inout) :: minstart
    integer(kind_integer), intent(inout) :: maxstart
    real(kind_float), intent(inout) :: threshold
    integer(kind_integer), intent(inout) :: maxiter
    character(len=22), intent(inout) :: id_string
    character(len=32), intent(inout) :: precon_string
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: irestart
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!! set nbasis based on size in file 
    nbasis = data%n_size

    nrhs = data%n_rhs

!! choice based on problem description
!! threshold
    threshold = (-logeps)/2
!    if (floattype_string.eq.'dp') then
!      threshold = real(8,kind=kind_float)
!    else if (floattype_string.eq.'sp') then
!      threshold = real(4,kind=kind_float)
!    end if

!! reasonable number of iterations before things go bad
    maxiter = 25


    if (nbasis.lt.16) then
      minstart = nbasis
      maxstart = nbasis
    else if (nbasis.lt.50) then
      minstart = 0
      maxstart = 16
    else if (nbasis.lt.200) then
      minstart = 0
      maxstart = floor(0.5*nbasis,kind=kind_integer)
    else
      minstart = 0
      maxstart = floor(0.3*nbasis,kind=kind_integer)
    end if


!! set id_string based on basetypes
    id_string = data%problem_string

!! set iverb to most verbose operation
    iverb = 5

!! restart options for solving from file!
    irestart = data%irestart

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine eval_kl_problem_b
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine eval_kl_problem_c(data,nbasis,nomega,nrhs,&
  &     minstart,maxstart,threshold,maxiter,unique_rhs_omega,&
  &     id_string,precon_string,iverb,irestart,ierr)
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
    class(kl_problem_c) :: data
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
    character(len=32), intent(inout) :: precon_string
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
!! threshold
    threshold = (-logeps)/2
!    if (floattype_string.eq.'dp') then
!      threshold = real(8,kind=kind_float)
!    else if (floattype_string.eq.'sp') then
!      threshold = real(4,kind=kind_float)
!    end if

!! reasonable number of iterations before things go bad
    maxiter = 25

!! take value from above
    unique_rhs_omega = data%one_rhs_per_omega

    if (nbasis.lt.16) then
      minstart = nbasis
      maxstart = nbasis
    else if (nbasis.lt.50) then
      minstart = 0
      maxstart = 16
    else if (nbasis.lt.200) then
      minstart = 0
!      minstart = floor(0.2*nbasis,kind=kind_integer)
      maxstart = floor(0.5*nbasis,kind=kind_integer)
    else
      minstart = 0
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
  end subroutine eval_kl_problem_c
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
      obj(j) = data%krylov_d(j)
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
    real(kind_float), intent(inout) :: obj(n1,n2)
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
   real(kind_float), intent(inout) :: basis_vectors(n1,n2)
   real(kind_float), intent(inout) :: mvproduct(n1,n2)
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
  subroutine eval_kl_output_a(data,n1,n2,n3,n4,&
  &     jconverged,roots,lagrangian,solutions,&
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
!  for file i/o : printing operations
    use arrayfile
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! External data (defined in the interface above)
!--------------------------------------------------------------------
    class(kl_output_a) :: data
!--------------------------------------------------------------------
! Variables
!--------------------------------------------------------------------
! matching interface defined in krylovtypes_a
    integer(kind_integer), intent(in) :: n1
    integer(kind_integer), intent(in) :: n2
    integer(kind_integer), intent(in) :: n3
    integer(kind_integer), intent(in) :: n4
    logical, intent(in) :: jconverged(n3)
    real(kind_float), intent(in) :: roots(n3)
    real(kind_float), intent(in) :: lagrangian(n3)
    real(kind_float), intent(in) :: solutions(n1,n3)
    real(kind_float), intent(in) :: euc_norm(n3)
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
! file name for lagrangian string
    character(len=32) :: lagr_string
! converged roots
    real(kind_float), allocatable :: converged_roots(:)
! converged solutions
    type(base), allocatable :: converged_solutions(:,:)
! converged lagrangians
    type(base), allocatable :: converged_lagrangian(:,:)
! integer for loops
    integer(kind_integer) :: j,k = 0
!--------------------------------------------------------------------

!! file names
    vector_string = trim(id_string)//'_vecs'
    values_string = trim(id_string)//'_vals'
    data_string = trim(id_string)//'_allr'
    lagr_string = trim(id_string)//'_lagr'

    allocate(converged_roots(n4))
    allocate(converged_lagrangian(1,n4))
    allocate(converged_solutions(n1,n4))

    k = 0
    do j = 1, n3
      if (jconverged(j)) then
        k = k + 1
        converged_roots(k) = roots(j)
        converged_lagrangian(1,k) = lagrangian(j)
        converged_solutions(1:n1,k) = solutions(1:n1,j)
      end if
    end do

!! print to file
    call array_print_float(data_string,n3,roots,ierr)

!! print to file
    call array_print_float(values_string,n4,converged_roots,ierr)

!! print to file
    call array_print_base(vector_string,n1,n4,converged_solutions,ierr)

!! print to file
    call array_print_base(lagr_string,1,n4,converged_lagrangian,ierr)

    deallocate(converged_roots)
    deallocate(converged_lagrangian)
    deallocate(converged_solutions)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine eval_kl_output_a
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine eval_kl_output_b(data,n1,n2,n3,n4,&
  &     jconverged,rhs,lagrangian,solutions,&
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
    class(kl_output_b) :: data
!--------------------------------------------------------------------
! Variables
!--------------------------------------------------------------------
! matching interface defined in krylovtypes_b
    integer(kind_integer), intent(in) :: n1
    integer(kind_integer), intent(in) :: n2
    integer(kind_integer), intent(in) :: n3
    integer(kind_integer), intent(in) :: n4
    logical, intent(in) :: jconverged(n3)
    real(kind_float), intent(in) :: rhs(n1,n3)
    real(kind_float), intent(in) :: lagrangian(n3)
    real(kind_float), intent(in) :: solutions(n1,n3)
    real(kind_float), intent(in) :: euc_norm(n3)
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
! all roots
    type(base), allocatable :: all_lagrangian(:,:)
! converged roots
    type(base), allocatable :: converged_lagrangian(:,:)
! converged solutions
    type(base), allocatable :: converged_solutions(:,:)
! integer for loops
    integer(kind_integer) :: j,k = 0
!--------------------------------------------------------------------

!! file names
    vector_string = trim(id_string)//'_vecs'
    values_string = trim(id_string)//'_lagr'
    data_string = trim(id_string)//'_allr'

    allocate(all_lagrangian(1,n3))
    allocate(converged_lagrangian(1,n4))
    allocate(converged_solutions(n1,n4))

    k = 0
    do j = 1, n3
      all_lagrangian(1,j) = lagrangian(j)
      if (jconverged(j)) then
        k = k + 1
        converged_lagrangian(1,k) = lagrangian(j)
        converged_solutions(1:n1,k) = solutions(1:n1,j)
      end if
    end do


!! print to file
    call array_print_base(data_string,1,n3,all_lagrangian,ierr)

!! print to file
    call array_print_base(values_string,1,n4,converged_lagrangian,ierr)


!! print to file
    call array_print_base(vector_string,n1,n4,converged_solutions,ierr)

!! deallocate solutions
    deallocate(all_lagrangian)
    deallocate(converged_lagrangian)
    deallocate(converged_solutions)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine eval_kl_output_b
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine eval_kl_output_c(data,n1,n2,n3,n4,n5,n6,&
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
    class(kl_output_c) :: data
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
    real(kind_float), intent(in) :: rhs(n1,n4)
    real(kind_float), intent(in) :: lagrangian(n5)
    real(kind_float), intent(in) :: solutions(n1,n5)
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
  end subroutine eval_kl_output_c
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module driver1types
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
