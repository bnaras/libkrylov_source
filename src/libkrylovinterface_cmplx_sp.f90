!--------------------------------------------------------------------
!--------------------------------------------------------------------
module libkrylovinterface_cmplx_sp
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This module defines the interface for user input/output functions
!< for a libkrylov solver.
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Varaibles
!--------------------------------------------------------------------
!! This module is self-contained to ease interfacing with external
!! modules - The contents are required
!! for writing input/output functions
!--------------------------------------------------------------------
! Implicit none
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------


!--------------------------------------------------------------------
! kind parameters for interface
!--------------------------------------------------------------------

!! single precision parameter
  integer, parameter :: &
  & lkl_cmplx_sp_k = kind(16e0)

!! 8 byte parameter for integers 
  integer, parameter :: lkl_int_csp_k = 8

!--------------------------------------------------------------------
! Base type for arrays 
!--------------------------------------------------------------------

  type :: base_csp
    complex(lkl_cmplx_sp_k) :: element
  end type base_csp

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! abstract type and interface for interacting 
! with vectors and matrices
!--------------------------------------------------------------------

!! abstract type for a function that
!! interacts with a complex array with two dimensions
  type, abstract :: libkrylov_matrix_cmplx_sp
  contains
    procedure(libkrylov_matrix_intrfc_csp), deferred :: matrix_fill
  end type libkrylov_matrix_cmplx_sp
  abstract interface
    subroutine libkrylov_matrix_intrfc_csp(data,n1,n2,obj,ierr)
      import :: lkl_cmplx_sp_k, lkl_int_csp_k,libkrylov_matrix_cmplx_sp
      class(libkrylov_matrix_cmplx_sp) :: data
!!    rows of obj
      integer(lkl_int_csp_k), intent(in) :: n1
!!    columns of obj
      integer(lkl_int_csp_k), intent(in) :: n2
!!    obj to be interacted with
      complex(lkl_cmplx_sp_k), intent(inout) :: obj(n1,n2)
      integer(lkl_int_csp_k), intent(inout) :: ierr
    end subroutine libkrylov_matrix_intrfc_csp
  end interface

!! abstract type for a function that
!! interacts with a real vector with one dimensions
  type, abstract :: libkrylov_vector_cmplx_sp
  contains
    procedure(libkrylov_vector_intrfc_csp), deferred :: vector_fill
  end type libkrylov_vector_cmplx_sp
  abstract interface
    subroutine libkrylov_vector_intrfc_csp(data,n1,obj,ierr)
      import :: lkl_cmplx_sp_k, lkl_int_csp_k,libkrylov_vector_cmplx_sp
      class(libkrylov_vector_cmplx_sp) :: data
!!    rows of obj
      integer(lkl_int_csp_k), intent(in) :: n1
!!    obj to be interacted with
      real(lkl_cmplx_sp_k), intent(inout) :: obj(n1)
      integer(lkl_int_csp_k), intent(inout) :: ierr
    end subroutine libkrylov_vector_intrfc_csp
  end interface

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Abstract types and interface shared by solvers
!--------------------------------------------------------------------

!! abstract type for krylov_start function
!! function to determine initial number of basis vectors
!! using minstart, maxstart and an approximate spectra as input
  type, abstract :: libkrylov_start_cmplx_sp
  contains
    procedure(libkrylov_start_intrfc_csp), deferred :: lkl_start
  end type libkrylov_start_cmplx_sp
  abstract interface
    subroutine libkrylov_start_intrfc_csp(data,n1,n2,approx_spectra,&
  &   nstart,ierr)
      import :: lkl_int_csp_k, lkl_cmplx_sp_k , libkrylov_start_cmplx_sp
      class(libkrylov_start_cmplx_sp) :: data
!!    nbasis (for approx spec)
      integer(lkl_int_csp_k), intent(in) :: n1
!!    nroots
      integer(lkl_int_csp_k), intent(in) :: n2
!!    approximate spectra
      real(lkl_cmplx_sp_k), intent(in) :: approx_spectra(n1)
!!    guess vectors
      integer(lkl_int_csp_k), intent(inout) :: nstart
!!    error variable
      integer(lkl_int_csp_k), intent(inout) :: ierr
    end subroutine libkrylov_start_intrfc_csp
  end interface

!! abstract type for krylov_guess function
!! function to determine initial basis vectors, basis_vectors
!! and overlap of the basis_vectors
!! using an approximate spectra as input
!! preserving the first n3 basis_vectors, but recalculating 
!! entire overlap
  type, abstract :: libkrylov_guess_cmplx_sp
  contains
    procedure(libkrylov_guess_intrfc_csp), deferred :: lkl_guess
  end type libkrylov_guess_cmplx_sp
  abstract interface
    subroutine libkrylov_guess_intrfc_csp(data,n1,n2,n3,approx_spectra,&
  &   basis_vectors,ierr)
      import :: lkl_int_csp_k, lkl_cmplx_sp_k , libkrylov_guess_cmplx_sp
      class(libkrylov_guess_cmplx_sp) :: data
!!    rows of guess vectors, nbasis
      integer(lkl_int_csp_k), intent(in) :: n1
!!    columns of guess vectors, nstart
      integer(lkl_int_csp_k), intent(in) :: n2
!!    last index of approx spectra already considered
      integer(lkl_int_csp_k), intent(in) :: n3
!!    approximate spectra
      real(lkl_cmplx_sp_k), intent(in) :: approx_spectra(n1)
!!    guess vectors
      complex(lkl_cmplx_sp_k), intent(inout) :: basis_vectors(n1,n2)
!!    error variable
      integer(lkl_int_csp_k), intent(inout) :: ierr
    end subroutine libkrylov_guess_intrfc_csp
  end interface


!! abstract type for krylov_mvp function
!! function to determine matrix-vector products, mvproducts
!! the products of a problem matrix with a set of basis vectors
  type, abstract :: libkrylov_mvprod_cmplx_sp
  contains
    procedure(libkrylov_mvprod_intrfc_csp), deferred :: lkl_mvp
  end type libkrylov_mvprod_cmplx_sp
  abstract interface
    subroutine libkrylov_mvprod_intrfc_csp(data,n1,n2,basis_vectors,&
  &   mvproduct,ierr)
      import :: lkl_int_csp_k, libkrylov_mvprod_cmplx_sp, lkl_cmplx_sp_k
      class(libkrylov_mvprod_cmplx_sp) :: data
!!    rows of guess vectors, nbasis
      integer(lkl_int_csp_k), intent(in) :: n1
!!    columns of guess vectors, nsubspace
      integer(lkl_int_csp_k), intent(in) :: n2
!!    guess vectors
      complex(lkl_cmplx_sp_k), intent(inout) :: basis_vectors(n1,n2)
!!    desired matrix vector products, mvproducts
      complex(lkl_cmplx_sp_k), intent(inout) :: mvproduct(n1,n2)
!!    error variable
      integer(lkl_int_csp_k), intent(inout) :: ierr
    end subroutine libkrylov_mvprod_intrfc_csp
  end interface

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! type extension for example input functions 
!--------------------------------------------------------------------

!! defining input function for number of starting basis vectors
  type, extends(libkrylov_start_cmplx_sp) :: lkl_s_elec_gas_csp
  contains
    procedure :: lkl_start => lkl_start_elec_gas_csp
  end type lkl_s_elec_gas_csp

!! defining input function for number of starting basis vectors
  type, extends(libkrylov_start_cmplx_sp) :: lkl_s_ext_in_csp
! external data required for the function
! value of number of starting basis vectors
    integer(lkl_int_csp_k) :: nstart = 0
  contains
    procedure :: lkl_start => lkl_start_ext_in_csp
  end type lkl_s_ext_in_csp

!! defining input function for initial basis vectors
  type, extends(libkrylov_guess_cmplx_sp) :: lkl_g_unit_vec_csp
  contains
    procedure :: lkl_guess => lkl_guess_unit_vec_csp
  end type lkl_g_unit_vec_csp

  type, extends(libkrylov_mvprod_cmplx_sp) :: lkl_mvp_n_mul_csp
! external data required for the function
! contains the matrix problem
! pointer to target set outside of solver
! shared with kl_approx, must be set before calling solver
    complex(lkl_cmplx_sp_k), pointer :: matrix(:,:) => null()
  contains
    procedure :: lkl_mvp => lkl_mvp_naive_multiply_csp
  end type lkl_mvp_n_mul_csp

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Abstract types for functions specific to solvers
!--------------------------------------------------------------------

!! type for krylov_problem function for problem_a
!! to determine parameters of the problem to be solved
  type :: libkrylov_problem_a_input_csp
    integer(lkl_int_csp_k) :: nbasis
    integer(lkl_int_csp_k) :: nroots
    integer(lkl_int_csp_k) :: minstart
    integer(lkl_int_csp_k) :: nstart
    integer(lkl_int_csp_k) :: maxstart
    real(lkl_cmplx_sp_k) :: threshold
    integer(lkl_int_csp_k) :: maxiter
    integer(lkl_int_csp_k) :: totalmaxiter
    character(len=22) :: id_string
    character(len=32) :: precon_string
    integer(lkl_int_csp_k) :: iverb
    integer(lkl_int_csp_k) :: irestart
    real(lkl_cmplx_sp_k), allocatable :: approx_spectra(:)
  end type libkrylov_problem_a_input_csp

!! type for krylov_output function of problem_a
!! function that takes the output from the solver
  type :: libkrylov_problem_a_output_csp
    type(base_csp), allocatable :: solutions(:,:)
!!  eigenvalues
    real(lkl_cmplx_sp_k), allocatable :: roots(:,:)
!!  functional
    type(base_csp) :: lagrangian
!!  residual norm of all vectors
    real(lkl_cmplx_sp_k) :: fro_norm
  end type libkrylov_problem_a_output_csp

!! function to determining parameters of the problem to be solved
  type :: libkrylov_problem_b_input_csp
    integer(lkl_int_csp_k) :: nbasis
    integer(lkl_int_csp_k) :: nrhs
    integer(lkl_int_csp_k) :: minstart
    integer(lkl_int_csp_k) :: nstart
    integer(lkl_int_csp_k) :: maxstart
    real(lkl_cmplx_sp_k) :: threshold
    integer(lkl_int_csp_k) :: maxiter
    integer(lkl_int_csp_k) :: totalmaxiter
    character(len=22) :: id_string
    character(len=32) :: precon_string
    integer(lkl_int_csp_k) :: iverb
    integer(lkl_int_csp_k) :: irestart
    real(lkl_cmplx_sp_k), allocatable :: approx_spectra(:)
    type(base_csp), allocatable :: rhs(:,:)
  end type libkrylov_problem_b_input_csp

!! type for krylov_output function of problem_b
!! that takes the output from the solver
  type :: libkrylov_problem_b_output_csp
    type(base_csp), allocatable :: solutions(:,:)
!!  functional
    type(base_csp) :: lagrangian
!!  residual norm of all vectors
    real(lkl_cmplx_sp_k) :: fro_norm
  end type libkrylov_problem_b_output_csp

!! type for krylov_problem function for problem_c
!! function to determining parameters of the problem to be solved
  type :: libkrylov_problem_c_input_csp
    integer(lkl_int_csp_k) :: nbasis
    integer(lkl_int_csp_k) :: nomega
    integer(lkl_int_csp_k) :: nrhs
    logical :: unique_rhs_omega
    integer(lkl_int_csp_k) :: minstart
    integer(lkl_int_csp_k) :: nstart
    integer(lkl_int_csp_k) :: maxstart
    real(lkl_cmplx_sp_k) :: threshold
    integer(lkl_int_csp_k) :: maxiter
    integer(lkl_int_csp_k) :: totalmaxiter
    character(len=22) :: id_string
    character(len=32) :: precon_string
    integer(lkl_int_csp_k) :: iverb
    integer(lkl_int_csp_k) :: irestart
    real(lkl_cmplx_sp_k), allocatable :: approx_spectra(:)
    real(lkl_cmplx_sp_k), allocatable :: omega(:)
    type(base_csp), allocatable :: rhs(:,:)
  end type libkrylov_problem_c_input_csp

!! type for krylov_output function of problem_c
!! that takes the output from the solver
  type :: libkrylov_problem_c_output_csp
    type(base_csp), allocatable :: solutions(:,:)
!!  functional
    type(base_csp) :: lagrangian
!!  residual norm of all vectors
    real(lkl_cmplx_sp_k) :: fro_norm
  end type libkrylov_problem_c_output_csp

!--------------------------------------------------------------------

!--------------------------------------------------------------------
contains
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Constructors and Destructors for libkrylov solvers
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine lkl_constr_a_1_csp(nbasis,nroots,problem_a,&
   &   output_a)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!! Constructor required for problem a solver 1
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! External data (IDEALLY EMPTY)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!!   nbasis
    integer(lkl_int_csp_k), intent(in) :: nbasis
!!   nroots
    integer(lkl_int_csp_k), intent(in) :: nroots
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!!  problem parameters
    class(libkrylov_problem_a_input_csp), intent(out) :: problem_a
!!  output parameters
    class(libkrylov_problem_a_output_csp) :: output_a
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
    integer(lkl_int_csp_k) :: ntriangle
!--------------------------------------------------------------------
    
    ntriangle = nroots*(nroots+1)/2    
 
    problem_a%nbasis = nbasis
    problem_a%nroots = nroots
    problem_a%minstart = nroots
    problem_a%nstart = 0
    problem_a%maxstart = nbasis
    problem_a%threshold = real(4,kind=lkl_cmplx_sp_k)
    problem_a%maxiter = 30
    problem_a%totalmaxiter = 80
    problem_a%id_string = "problem_a_solver_1"
    problem_a%precon_string = "davidson"
    problem_a%iverb = 5
    problem_a%irestart = 0
    allocate(problem_a%approx_spectra(nbasis))
    problem_a%approx_spectra = real(0,kind=lkl_cmplx_sp_k)
    allocate(output_a%solutions(nbasis,nroots))
    output_a%solutions%element = real(0,kind=lkl_cmplx_sp_k)
    allocate(output_a%roots(nroots,nroots))
    output_a%roots= real(0,kind=lkl_cmplx_sp_k)
    output_a%lagrangian%element = real(0,kind=lkl_cmplx_sp_k)
    output_a%fro_norm = real(0,kind=lkl_cmplx_sp_k)
!--------------------------------------------------------------------
  end subroutine lkl_constr_a_1_csp
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine lkl_destr_a_1_csp(&
   &   problem_a,output_a)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!! Destructor required for problem a solver 1
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! External data (IDEALLY EMPTY)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!!  output parameters
    class(libkrylov_problem_a_input_csp) :: problem_a
    class(libkrylov_problem_a_output_csp) :: output_a
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------
    deallocate(problem_a%approx_spectra)
    deallocate(output_a%solutions)
    deallocate(output_a%roots)
!--------------------------------------------------------------------
  end subroutine lkl_destr_a_1_csp
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine lkl_constr_b_1_csp(nbasis,nrhs,problem_b,&
   &   output_b)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!! Constructor required for problem b solver 1
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! External data (IDEALLY EMPTY)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!!   nbasis
    integer(lkl_int_csp_k), intent(in) :: nbasis
!!   nrhs
    integer(lkl_int_csp_k), intent(in) :: nrhs
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!!  problem parameters
    class(libkrylov_problem_b_input_csp), intent(out) :: problem_b
!!  output parameters
    class(libkrylov_problem_b_output_csp) :: output_b
!--------------------------------------------------------------------
    problem_b%nbasis = nbasis
    problem_b%nrhs = nrhs
    problem_b%minstart = nrhs
    problem_b%nstart = 0
    problem_b%maxstart = nbasis
    problem_b%threshold = real(4,kind=lkl_cmplx_sp_k)
    problem_b%maxiter = 30
    problem_b%totalmaxiter = 80
    problem_b%id_string = "problem_b_solver_1"
    problem_b%precon_string = "approx_spectra"
    problem_b%iverb = 5
    problem_b%irestart = 0
    allocate(problem_b%approx_spectra(nbasis))
    problem_b%approx_spectra = real(0,kind=lkl_cmplx_sp_k)
    allocate(problem_b%rhs(nbasis,nrhs))
    problem_b%rhs%element = real(0,kind=lkl_cmplx_sp_k)
    allocate(output_b%solutions(nbasis,nrhs))
    output_b%solutions%element = real(0,kind=lkl_cmplx_sp_k)
    output_b%lagrangian%element = real(0,kind=lkl_cmplx_sp_k)
    output_b%fro_norm = real(0,kind=lkl_cmplx_sp_k)
!--------------------------------------------------------------------
  end subroutine lkl_constr_b_1_csp
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine lkl_destr_b_1_csp(&
   &   problem_b,output_b)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!! Destructor required for problem b solver 1
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! External data (IDEALLY EMPTY)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!!  output parameters
    class(libkrylov_problem_b_input_csp) :: problem_b
    class(libkrylov_problem_b_output_csp) :: output_b
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------
    deallocate(problem_b%approx_spectra)
    deallocate(problem_b%rhs)
    deallocate(output_b%solutions)
!--------------------------------------------------------------------
  end subroutine lkl_destr_b_1_csp
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine lkl_constr_c_1_csp(nbasis,nomega,nrhs,unique,problem_c,&
   &   output_c)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!! Constructor required for problem c solver 1
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! External data (IDEALLY EMPTY)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!!   nbasis
    integer(lkl_int_csp_k), intent(in) :: nbasis
!!   nomega
    integer(lkl_int_csp_k), intent(in) :: nomega
!!   nrhs
    integer(lkl_int_csp_k), intent(in) :: nrhs
!!   is nroots not nomega*nrhs
    logical, intent(in) :: unique 
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!!  problem parameters
    class(libkrylov_problem_c_input_csp), intent(out) :: problem_c
!!  output parameters
    class(libkrylov_problem_c_output_csp) :: output_c
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
    integer(lkl_int_csp_k) :: nroots
!--------------------------------------------------------------------

    if (unique) then
      if (nomega.ne.nrhs) stop
      nroots = nrhs
    else
      nroots = nomega*nrhs
    end if

    problem_c%nbasis = nbasis
    problem_c%nomega = nomega
    problem_c%nrhs = nrhs
    problem_c%unique_rhs_omega = unique
    problem_c%minstart = nroots
    problem_c%nstart = 0
    problem_c%maxstart = nbasis
    problem_c%threshold = real(4,kind=lkl_cmplx_sp_k)
    problem_c%maxiter = 30
    problem_c%totalmaxiter = 80
    problem_c%id_string = "problem_c_solver_1"
    problem_c%precon_string = "davidson"
    problem_c%iverb = 5
    problem_c%irestart = 0
    allocate(problem_c%approx_spectra(nbasis))
    problem_c%approx_spectra = real(0,kind=lkl_cmplx_sp_k)
    allocate(problem_c%omega(nomega))
    problem_c%omega = real(0,kind=lkl_cmplx_sp_k)
    allocate(problem_c%rhs(nbasis,nrhs))
    problem_c%rhs%element = real(0,kind=lkl_cmplx_sp_k)
    allocate(output_c%solutions(nbasis,nroots))
    output_c%solutions%element = real(0,kind=lkl_cmplx_sp_k)
    output_c%lagrangian%element = real(0,kind=lkl_cmplx_sp_k)
    output_c%fro_norm = real(0,kind=lkl_cmplx_sp_k)
!--------------------------------------------------------------------
  end subroutine lkl_constr_c_1_csp
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine lkl_destr_c_1_csp(&
   &   problem_c,output_c)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!! Destructor required for problem c solver 1
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! External data (IDEALLY EMPTY)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!!  output parameters
    class(libkrylov_problem_c_input_csp) :: problem_c
    class(libkrylov_problem_c_output_csp) :: output_c
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------
    deallocate(problem_c%approx_spectra)
    deallocate(problem_c%omega)
    deallocate(problem_c%rhs)
    deallocate(output_c%solutions)
!--------------------------------------------------------------------
  end subroutine lkl_destr_c_1_csp
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Required subroutines for example start and guess function
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  recursive subroutine quicksort_stl_float_csp(n,obj,dex,first,last,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!! reference to: https://gist.github.com/t-nissie/479f0f16966925fa29ea
!! sorts a linear array of real(kind_float), obj, 
!! from smallest to largest
!! dex contains the ordering, to match the new order to the old,
!! i.e. dex(1) is the original position of the smallest eigenvalue
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input/Output Parameters
!--------------------------------------------------------------------
!! size of obj and dex
    integer(lkl_int_csp_k), intent(in) :: n
!!  array to be sorted
    real(lkl_cmplx_sp_k), intent(inout) :: obj(n)
!! indexing of array to be sorted
    integer(lkl_int_csp_k), intent(inout) :: dex(n)
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! first element
    integer(lkl_int_csp_k), intent(in) :: first
!! the last element
    integer(lkl_int_csp_k), intent(in) :: last
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(lkl_int_csp_k), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!!  pivot value, by default is the value in the middle of first and last
    real(lkl_cmplx_sp_k) :: p
!!  dummy variable for copying
    real(lkl_cmplx_sp_k) :: t
!!  dummy variable for copying
    integer(lkl_int_csp_k) :: k = 0
!!  integer for do loops
    integer(lkl_int_csp_k) :: j1,j2 = 0
!--------------------------------------------------------------------

    p = obj(int((first+last)*0.5,kind=lkl_int_csp_k))
    j1 = first
    j2 = last
    do
      do while (obj(j1).lt.p)
        j1 = j1+1
      end do
      do while (obj(j2).gt.p)
        j2 = j2-1
      end do
      if (j1.ge.j2) exit
      t = obj(j1)
      k = dex(j1)
      obj(j1) = obj(j2)
      dex(j1) = dex(j2)
      obj(j2) = t
      dex(j2) = k
      j1 = j1+1
      j2 = j2-1
    end do
    if (first.lt.j1-1) then
      call quicksort_stl_float_csp(n,obj,dex,first,j1-1,ierr)
    end if
    if (last.gt.j2+1) then
      call quicksort_stl_float_csp(n,obj,dex,j2+1,last,ierr)
    end if

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine quicksort_stl_float_csp
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Example start functions
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine lkl_start_elec_gas_csp(data,n1,n2,approx_spectra,&
   &   nstart,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!! subroutine to determine the number of initial guess vectors
!! by treating the approximate spectra as energy states in
!! atomic units belonging to a fermi dirac distribution at 
!! a finite temperature.
!! Constants T100000K_au are defined for that temperature.
!! Since the energy states correspond to an occupation in
!! the distribution,
!! a minimum occupation(0.1) is used to determine a threshold energy
!! has significant contributions to the problem, set in 
!! occupation_limit. The approximate spectra are compared
!! against this threshold to set the starting vectors space.
!!
!! This requires sorting.
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! External data (IDEALLY EMPTY)
!--------------------------------------------------------------------
    class(lkl_s_elec_gas_csp) :: data
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!!   nbasis
    integer(lkl_int_csp_k), intent(in) :: n1
!!   nroots
    integer(lkl_int_csp_k), intent(in) :: n2
!!    approximate spectra
    real(lkl_cmplx_sp_k), intent(in) :: approx_spectra(n1)
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! nstart
    integer(lkl_int_csp_k), intent(inout) :: nstart
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(lkl_int_csp_k), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! test values
    real(lkl_cmplx_sp_k), parameter :: T100000K_au = &
  &  real(1.380649,kind=lkl_cmplx_sp_k) &
  &  /real(4.3597447222071,kind=lkl_cmplx_sp_k)
    real(lkl_cmplx_sp_k) :: occupation_limit = 0
!!  integer for do loops
    integer(lkl_int_csp_k) :: j,k,l = 0
!!  array for sorting
    real(lkl_cmplx_sp_k), allocatable :: sorter(:)
!! indexing of approx spectra for sorting
    integer(lkl_int_csp_k), allocatable :: dex(:)
!! threshold "energy" value
    real(lkl_cmplx_sp_k) :: test_value
!--------------------------------------------------------------------

!! allocate local arrays
    allocate(sorter(n1))
    allocate(dex(n1))

!! fill dex before sorting
    do j = 1, n1
      dex(j) = j
    end do

!! sorter will be overwritten
    sorter = approx_spectra

!! sort to fill dex, sorter can be ignored
    call quicksort_stl_float_csp(n1,sorter,dex,1,n1,ierr)
    if (ierr.ne.0) then
      return ! abort subroutine, return to call
    end if

!! set the occupation for the threshold 'energy'
!! of the fermi dirac distribution
    occupation_limit = real(0.1,kind=lkl_cmplx_sp_k)
!! threshold 'energy' is the test_value
    test_value = T100000K_au*log((1/occupation_limit)-1)&
  &      +((sorter(n2+1)+sorter(n2))&
  &      *real(0.5,kind=lkl_cmplx_sp_k))

!! set nstart to full basis first, as an error condition
!! where all energies are below test_value
    nstart = n1
!! loop to find the first diagonal element greater than
!! test value
    do j = (n2+1), n1
      if ((sorter(j)-test_value).gt.&
  &        epsilon(real(0,kind=lkl_cmplx_sp_k))) then
        nstart = j-1
        exit ! set nstart
      end if
    end do

!! deallocate local arrays
    deallocate(sorter)
    deallocate(dex)

!--------------------------------------------------------------------
  end subroutine lkl_start_elec_gas_csp
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine lkl_start_ext_in_csp(data,n1,n2,approx_spectra,&
   &   nstart,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!! subroutine to determine the number of initial guess vectors
!! by external data input
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! External data (IDEALLY EMPTY)
!--------------------------------------------------------------------
    class(lkl_s_ext_in_csp) :: data
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!!   nbasis
    integer(lkl_int_csp_k), intent(in) :: n1
!!   nroots
    integer(lkl_int_csp_k), intent(in) :: n2
!!    approximate spectra
    real(lkl_cmplx_sp_k), intent(in) :: approx_spectra(n1)
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! nstart
    integer(lkl_int_csp_k), intent(inout) :: nstart
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(lkl_int_csp_k), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! Blank
!--------------------------------------------------------------------

    nstart = data%nstart

!--------------------------------------------------------------------
  end subroutine lkl_start_ext_in_csp
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Example guess functions
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine lkl_guess_unit_vec_csp(data,n1,n2,n3,approx_spectra,&
   &   basis_vectors,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!! subroutine to determine the initial guess vectors
!! as unit vectors/delta functions based on the approximate spectra
!!
!! This requires sorting.
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! External data (IDEALLY EMPTY)
!--------------------------------------------------------------------
    class(lkl_g_unit_vec_csp) :: data
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!!    rows of guess vectors, nbasis
    integer(lkl_int_csp_k), intent(in) :: n1
!!    columns of guess vectors, nstart
    integer(lkl_int_csp_k), intent(in) :: n2
!!    last index of basis vectors that is input
    integer(lkl_int_csp_k), intent(in) :: n3
!!    approximate spectra
    real(lkl_cmplx_sp_k), intent(in) :: approx_spectra(n1)
!--------------------------------------------------------------------
! Input/Output Parameters
!--------------------------------------------------------------------
!!    guess vectors
    complex(lkl_cmplx_sp_k), intent(inout) :: basis_vectors(n1,n2)
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(lkl_int_csp_k), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! number of new vectors, n2-n3
    integer(lkl_int_csp_k) :: n4
!!  integer for do loops
    integer(lkl_int_csp_k) :: j,k,l = 0
!!  array for sorting
    real(lkl_cmplx_sp_k), allocatable :: sorter(:)
!! indexing of approx spectra for sorting
    integer(lkl_int_csp_k), allocatable :: dex(:)
!! norm checking
    real(lkl_cmplx_sp_k) :: test_value_sq
    real(lkl_cmplx_sp_k) :: test_value
    logical, allocatable :: test_orthogonal(:)
!--------------------------------------------------------------------

!! determine n4
    n4 = n2 - n3

!! allocate local arrays
    allocate(sorter(n1))
    allocate(dex(n1))
    allocate(test_orthogonal(n3))

!! fill dex before sorting
    do j = 1, n1
      dex(j) = j
    end do

!! sorter will be overwritten
    sorter = approx_spectra

!! sort to fill dex, sorter can be ignored
    call quicksort_stl_float_csp(n1,sorter,dex,1,n1,ierr)
    if (ierr.ne.0) then
      return ! abort subroutine, return to call
    end if

    if (n3.eq.0) then
!! all basis vectors are new
! zero basis vectors
      basis_vectors = real(0,kind=lkl_cmplx_sp_k)
      do j = 1, n2
! make delta function
        basis_vectors(dex(j),j) = real(1,kind=lkl_cmplx_sp_k)
      end do
    else 
! need to use previous vectors and generate new ones!
! zero only sections that need to be zeroed
      basis_vectors(1:n1,(n3+1):n2) = real(0,kind=lkl_cmplx_sp_k)
!!! check for linear dependence with new delta functions
      l = n3+1
! l is the new basis vector being created
      do j = 1, (n1+1)
! j is the jth delta function being tested
! stop loop over full basis when all start vectors are produced
        if (l.eq.(n2+1)) then
          exit
        end if
! stop loop over full basis when all basis vectors have been checked
! and error out
        if (j.eq.(n1+1)) then
          ierr = -17
          exit
        end if
! calculate overlap of proposed delta function with old vectors, 
! use to check linear dependence
        do k = 1, n3
          test_value_sq = &
  &        basis_vectors(dex(j),k)*basis_vectors(dex(j),k)
!  &        conjg(basis_vectors(dex(j),k))*basis_vectors(dex(j),k)
          test_value = sqrt(test_value_sq)
          if (abs(real(1,kind=lkl_cmplx_sp_k)-test_value).gt.&
  &             epsilon(real(0,kind=lkl_cmplx_sp_k))) then
            test_orthogonal(k) = .true.
          end if
        end do
! accept new basis vector if test passed
        if (all(test_orthogonal)) then
          ! fill in new basis vector
          basis_vectors(dex(j),l) = real(1,kind=lkl_cmplx_sp_k)
          l = l +1
        end if
      end do
    end if

!! deallocate local arrays
    deallocate(sorter)
    deallocate(dex)
    deallocate(test_orthogonal)

!--------------------------------------------------------------------
  end subroutine lkl_guess_unit_vec_csp
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine lkl_mvp_naive_multiply_csp(data,n1,n2,&
  &     basis_vectors,mvproduct,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine does the matrix vector product directly
!< and does the matrix-vector products naively and explicitly.
!< using a BLAS call
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! External data (defined in the interface above)
!--------------------------------------------------------------------
    class(lkl_mvp_n_mul_csp) :: data
!--------------------------------------------------------------------
! Variables
!--------------------------------------------------------------------
! matching interface defined in krylovtypes_a
   integer(lkl_int_csp_k), intent(in) :: n1
   integer(lkl_int_csp_k), intent(in) :: n2
   complex(lkl_cmplx_sp_k), intent(inout) :: basis_vectors(n1,n2)
   complex(lkl_cmplx_sp_k), intent(inout) :: mvproduct(n1,n2)
   integer(lkl_int_csp_k), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!! calculate matrix-vector product
   call cgemm('n','n',n1,n2,n1,&
  &   cmplx(1,kind=lkl_cmplx_sp_k),data%matrix,n1,&
  &   basis_vectors,n1,cmplx(0,kind=lkl_cmplx_sp_k),&
  &   mvproduct,n1)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine lkl_mvp_naive_multiply_csp
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module libkrylovinterface_cmplx_sp
!--------------------------------------------------------------------
!--------------------------------------------------------------------
