!--------------------------------------------------------------------
!--------------------------------------------------------------------
module libkrylovinterface_real_sp
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
!! modules - This module is required 
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
  & lkl_real_sp_k = 4

!! 8 byte parameter for integers 
  integer, parameter :: lkl_int_rsp_k = 8

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! type and interface for interacting 
! with real(single_precision) vectors and matrices
!--------------------------------------------------------------------

!! abstract type for a function that
!! interacts with a real array with two dimensions
  type, abstract :: libkrylov_matrix_real_sp
  contains
    procedure(libkrylov_matrix_interface), deferred :: matrix_fill
  end type libkrylov_matrix_real_sp
  abstract interface
    subroutine libkrylov_matrix_interface(data,n1,n2,obj,ierr)
      import :: lkl_real_sp_k, lkl_int_rsp_k,libkrylov_matrix_real_sp
      class(libkrylov_matrix_real_sp) :: data
!!    rows of obj
      integer(lkl_int_rsp_k), intent(in) :: n1
!!    columns of obj
      integer(lkl_int_rsp_k), intent(in) :: n2
!!    obj to be interacted with
      real(lkl_real_sp_k), intent(inout) :: obj(n1,n2)
      integer(lkl_int_rsp_k), intent(inout) :: ierr
    end subroutine libkrylov_matrix_interface
  end interface

!! abstract type for a function that
!! interacts with a real vector with one dimensions
  type, abstract :: libkrylov_vector_real_sp
  contains
    procedure(libkrylov_vector_interface), deferred :: vector_fill
  end type libkrylov_vector_real_sp
  abstract interface
    subroutine libkrylov_vector_interface(data,n1,obj,ierr)
      import :: lkl_real_sp_k, lkl_int_rsp_k,libkrylov_vector_real_sp
      class(libkrylov_vector_real_sp) :: data
!!    rows of obj
      integer(lkl_int_rsp_k), intent(in) :: n1
!!    obj to be interacted with
      real(lkl_real_sp_k), intent(inout) :: obj(n1)
      integer(lkl_int_rsp_k), intent(inout) :: ierr
    end subroutine libkrylov_vector_interface
  end interface

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Abstract interface for all solvers
!--------------------------------------------------------------------

!! abstract type for krylov_start function
!! function to determine initial number of basis vectors
!! using minstart, maxstart and an approximate spectra as input
  type, abstract :: libkrylov_start_real_sp
  contains
    procedure(libkrylov_start_interface), deferred :: lkl_start
  end type libkrylov_start_real_sp
  abstract interface
    subroutine libkrylov_start_interface(data,n1,n2,approx_spectra,&
  &   nstart,ierr)
      import :: lkl_int_rsp_k, lkl_real_sp_k , libkrylov_start_real_sp
      class(libkrylov_start_real_sp) :: data
!!    nbasis (for approx spec)
      integer(lkl_int_rsp_k), intent(in) :: n1
!!    nroots
      integer(lkl_int_rsp_k), intent(in) :: n2
!!    approximate spectra
      real(lkl_real_sp_k), intent(in) :: approx_spectra(n1)
!!    guess vectors
      integer(lkl_int_rsp_k), intent(inout) :: nstart
!!    error variable
      integer(lkl_int_rsp_k), intent(inout) :: ierr
    end subroutine libkrylov_start_interface
  end interface

!! abstract type for krylov_guess function
!! function to determine initial basis vectors, basis_vectors
!! and overlap of the basis_vectors
!! using an approximate spectra as input
!! preserving the first n3 basis_vectors, but recalculating 
!! entire overlap
  type, abstract :: libkrylov_guess_real_sp
  contains
    procedure(libkrylov_guess_interface), deferred :: lkl_guess
  end type libkrylov_guess_real_sp
  abstract interface
    subroutine libkrylov_guess_interface(data,n1,n2,n3,approx_spectra,&
  &   basis_vectors,ierr)
      import :: lkl_int_rsp_k, lkl_real_sp_k , libkrylov_guess_real_sp
      class(libkrylov_guess_real_sp) :: data
!!    rows of guess vectors, nbasis
      integer(lkl_int_rsp_k), intent(in) :: n1
!!    columns of guess vectors, nstart
      integer(lkl_int_rsp_k), intent(in) :: n2
!!    last index of approx spectra already considered
      integer(lkl_int_rsp_k), intent(in) :: n3
!!    approximate spectra
      real(lkl_real_sp_k), intent(in) :: approx_spectra(n1)
!!    guess vectors
      real(lkl_real_sp_k), intent(inout) :: basis_vectors(n1,n2)
!!    error variable
      integer(lkl_int_rsp_k), intent(inout) :: ierr
    end subroutine libkrylov_guess_interface
  end interface


!! abstract type for krylov_mvp function
!! function to determine matrix-vector products, mvproducts
!! the products of a problem matrix with a set of basis vectors
  type, abstract :: libkrylov_mvp_real_sp
  contains
    procedure(libkrylov_mvp_interface), deferred :: lkl_mvp
  end type libkrylov_mvp_real_sp
  abstract interface
    subroutine libkrylov_mvp_interface(data,n1,n2,basis_vectors,&
  &   mvproduct,ierr)
      import :: lkl_int_rsp_k, libkrylov_mvp_real_sp, lkl_real_sp_k
      class(libkrylov_mvp_real_sp) :: data
!!    rows of guess vectors, nbasis
      integer(lkl_int_rsp_k), intent(in) :: n1
!!    columns of guess vectors, nsubspace
      integer(lkl_int_rsp_k), intent(in) :: n2
!!    guess vectors
      real(lkl_real_sp_k), intent(inout) :: basis_vectors(n1,n2)
!!    desired matrix vector products, mvproducts
      real(lkl_real_sp_k), intent(inout) :: mvproduct(n1,n2)
!!    error variable
      integer(lkl_int_rsp_k), intent(inout) :: ierr
    end subroutine libkrylov_mvp_interface
  end interface

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! extend type for example input functions 
!--------------------------------------------------------------------

!! defining input function for number of starting basis vectors
  type, extends(libkrylov_start_real_sp) :: lkl_s_elec_gas_rsp
! external data required for the function
!! IDEALLY, NO EXTERNAL DATA
  contains
    procedure :: lkl_start => lkl_start_elec_gas_rsp
  end type lkl_s_elec_gas_rsp

!! defining input function for number of starting basis vectors
  type, extends(libkrylov_start_real_sp) :: lkl_s_ext_in_rsp
! external data required for the function
    integer(lkl_int_rsp_k) :: nstart = 0
  contains
    procedure :: lkl_start => lkl_start_ext_in_rsp
  end type lkl_s_ext_in_rsp

!! defining input function for initial basis vectors
  type, extends(libkrylov_guess_real_sp) :: lkl_g_unit_vec_rsp
! external data required for the function
!! IDEALLY, NO EXTERNAL DATA
  contains
    procedure :: lkl_guess => lkl_guess_unit_vec_rsp
  end type lkl_g_unit_vec_rsp

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Abstract interface for input functions of solver_a
!--------------------------------------------------------------------

!! abstract type for krylov_problem function for problem_a
!! function to determining parameters of the problem to be solved
  type, abstract :: libkrylov_problem_a_real_sp
  contains
    procedure(libkrylov_problem_a_interface), deferred :: lkl_problem_a
  end type libkrylov_problem_a_real_sp
  abstract interface
    subroutine libkrylov_problem_a_interface(data,nbasis,nroots,&
  &   minstart,maxstart,threshold,maxiter,&
  &   id_string,precon_string,iverb,irestart,ierr)
      import :: lkl_int_rsp_k, libkrylov_problem_a_real_sp, lkl_real_sp_k
      class(libkrylov_problem_a_real_sp) :: data
      integer(lkl_int_rsp_k), intent(inout) :: nbasis
      integer(lkl_int_rsp_k), intent(inout) :: nroots
      integer(lkl_int_rsp_k), intent(inout) :: minstart
      integer(lkl_int_rsp_k), intent(inout) :: maxstart
      real(lkl_real_sp_k), intent(inout) :: threshold
      integer(lkl_int_rsp_k), intent(inout) :: maxiter
      character(len=22), intent(inout) :: id_string
      character(len=32), intent(inout) :: precon_string
      integer(lkl_int_rsp_k), intent(inout) :: iverb
      integer(lkl_int_rsp_k), intent(inout) :: irestart
      integer(lkl_int_rsp_k), intent(inout) :: ierr
    end subroutine libkrylov_problem_a_interface
  end interface

!! abstract type for krylov_output function of problem_a
!! function that takes the output from the solver
!! and does what the user wants with them
!! wheter printing or passing out of the solver
  type, abstract :: libkrylov_output_a_real_sp
  contains
    procedure(libkrylov_output_a_interface), deferred :: lkl_output_a
  end type libkrylov_output_a_real_sp
  abstract interface
    subroutine libkrylov_output_a_interface(data,n1,n2,n3,n4,&
  &   jconverged,roots,lagrangian,solutions,&
  &   euc_norm,fro_norm,id_string,ierr)
      import :: lkl_int_rsp_k, libkrylov_output_a_real_sp, lkl_real_sp_k
      class(libkrylov_output_a_real_sp) :: data
!!    rows of solutions, nbasis
      integer(lkl_int_rsp_k), intent(in) :: n1
!!    size of subspace , not used
      integer(lkl_int_rsp_k), intent(in) :: n2
!!    columns of solutions, nroots
      integer(lkl_int_rsp_k), intent(in) :: n3
!!    number of converged solutions, nconverged
      integer(lkl_int_rsp_k), intent(in) :: n4
!!    array for which solutions are converged
      logical, intent(in) :: jconverged(n3)
!!    eigenvalues
      real(lkl_real_sp_k), intent(in) :: roots(n3)
!!    functional
      real(lkl_real_sp_k), intent(in) :: lagrangian(n3)
!!    solutions on the full space, stored on mvproduct
      real(lkl_real_sp_k), intent(in) :: solutions(n1,n3)
!!    residual norms of each vector
      real(lkl_real_sp_k), intent(in) :: euc_norm(n3)
!!    residual norm of all vectors
      real(lkl_real_sp_k), intent(in) :: fro_norm
!!    id_string 
      character(len=22), intent(in) :: id_string
!!    error variable
      integer(lkl_int_rsp_k), intent(inout) :: ierr
    end subroutine libkrylov_output_a_interface
  end interface

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Abstract interface for input functions of solver_b
!--------------------------------------------------------------------

!! abstract type for krylov_problem function for problem_b
!! function to determining parameters of the problem to be solved
  type, abstract :: libkrylov_problem_b_real_sp
  contains
    procedure(libkrylov_problem_b_interface), deferred :: lkl_problem_b
  end type libkrylov_problem_b_real_sp
  abstract interface
    subroutine libkrylov_problem_b_interface(data,nbasis,nrhs,&
  &   minstart,maxstart,threshold,maxiter,&
  &   id_string,precon_string,iverb,irestart,ierr)
      import :: lkl_int_rsp_k, libkrylov_problem_b_real_sp, lkl_real_sp_k
      class(libkrylov_problem_b_real_sp) :: data
      integer(lkl_int_rsp_k), intent(inout) :: nbasis
      integer(lkl_int_rsp_k), intent(inout) :: nrhs
      integer(lkl_int_rsp_k), intent(inout) :: minstart
      integer(lkl_int_rsp_k), intent(inout) :: maxstart
      real(lkl_real_sp_k), intent(inout) :: threshold
      integer(lkl_int_rsp_k), intent(inout) :: maxiter
      character(len=22), intent(inout) :: id_string
      character(len=32), intent(inout) :: precon_string
      integer(lkl_int_rsp_k), intent(inout) :: iverb
      integer(lkl_int_rsp_k), intent(inout) :: irestart
      integer(lkl_int_rsp_k), intent(inout) :: ierr
    end subroutine libkrylov_problem_b_interface
  end interface

!! abstract type for krylov_output function of problem_b
!! function that takes the output from the solver
!! and does what the user wants with them
!! wheter printing or passing out of the solver
  type, abstract :: libkrylov_output_b_real_sp
  contains
    procedure(libkrylov_output_b_interface), deferred :: lkl_output_b
  end type libkrylov_output_b_real_sp
  abstract interface
    subroutine libkrylov_output_b_interface(data,n1,n2,n3,n4,&
  &   jconverged,rhs,lagrangian,solutions,&
  &   euc_norm,fro_norm,id_string,ierr)
      import :: lkl_int_rsp_k, libkrylov_output_b_real_sp, lkl_real_sp_k
      class(libkrylov_output_b_real_sp) :: data
!!    rows of solutions, nbasis
      integer(lkl_int_rsp_k), intent(in) :: n1
!!    size of subspace , not used
      integer(lkl_int_rsp_k), intent(in) :: n2
!!    columns of solutions, nrhs
      integer(lkl_int_rsp_k), intent(in) :: n3
!!    number of converged solutions, nconverged
      integer(lkl_int_rsp_k), intent(in) :: n4
!!    array for which solutions are converged
      logical, intent(in) :: jconverged(n3)
!!    rhs
      real(lkl_real_sp_k), intent(in) :: rhs(n1,n3)
!!    functional
      real(lkl_real_sp_k), intent(in) :: lagrangian(n3)
!!    solutions on the full space, stored on mvproduct
      real(lkl_real_sp_k), intent(in) :: solutions(n1,n3)
!!    residual norms of each vector
      real(lkl_real_sp_k), intent(in) :: euc_norm(n3)
!!    residual norm of all vectors
      real(lkl_real_sp_k), intent(in) :: fro_norm
!!    id_string 
      character(len=22), intent(in) :: id_string
!!    error variable
      integer(lkl_int_rsp_k), intent(inout) :: ierr
    end subroutine libkrylov_output_b_interface
  end interface

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Abstract interface for input functions of solver_c
!--------------------------------------------------------------------

!! abstract type for krylov_problem function for problem_c
!! function to determining parameters of the problem to be solved
  type, abstract :: libkrylov_problem_c_real_sp
  contains
    procedure(libkrylov_problem_c_interface), deferred :: lkl_problem_c
  end type libkrylov_problem_c_real_sp
  abstract interface
    subroutine libkrylov_problem_c_interface(data,nbasis,nomega,nrhs,&
  &   minstart,maxstart,threshold,maxiter,unique_rhs_omega,&
  &   id_string,precon_string,iverb,irestart,ierr)
      import :: lkl_int_rsp_k, libkrylov_problem_c_real_sp, lkl_real_sp_k
      class(libkrylov_problem_c_real_sp) :: data
      integer(lkl_int_rsp_k), intent(inout) :: nbasis
      integer(lkl_int_rsp_k), intent(inout) :: nomega
      integer(lkl_int_rsp_k), intent(inout) :: nrhs
      integer(lkl_int_rsp_k), intent(inout) :: minstart
      integer(lkl_int_rsp_k), intent(inout) :: maxstart
      real(lkl_real_sp_k), intent(inout) :: threshold
      integer(lkl_int_rsp_k), intent(inout) :: maxiter
      logical, intent(inout) :: unique_rhs_omega
      character(len=22), intent(inout) :: id_string
      character(len=32), intent(inout) :: precon_string
      integer(lkl_int_rsp_k), intent(inout) :: iverb
      integer(lkl_int_rsp_k), intent(inout) :: irestart
      integer(lkl_int_rsp_k), intent(inout) :: ierr
    end subroutine libkrylov_problem_c_interface
  end interface

!! abstract type for krylov_output function of problem_c
!! function that takes the output from the solver
!! and does what the user wants with them
!! wheter printing or passing out of the solver
  type, abstract :: libkrylov_output_c_real_sp
  contains
    procedure(libkrylov_output_c_interface), deferred :: lkl_output_c
  end type libkrylov_output_c_real_sp
  abstract interface
    subroutine libkrylov_output_c_interface(data,n1,n2,n3,n4,n5,n6,&
  &   jconverged,omega,rhs,lagrangian,solutions,&
  &   euc_norm,fro_norm,id_string,ierr)
      import :: lkl_int_rsp_k, libkrylov_output_c_real_sp, lkl_real_sp_k
      class(libkrylov_output_c_real_sp) :: data
!!    rows of solutions, nbasis
      integer(lkl_int_rsp_k), intent(in) :: n1
!!    size of subspace , not used
      integer(lkl_int_rsp_k), intent(in) :: n2
!!    number of frequencies, nomega
      integer(lkl_int_rsp_k), intent(in) :: n3
!!    number of rhs, nrhs
      integer(lkl_int_rsp_k), intent(in) :: n4
!!    columns of solutions, nroots
      integer(lkl_int_rsp_k), intent(in) :: n5
!!    number of solutions converged
      integer(lkl_int_rsp_k), intent(in) :: n6
!!    array for which solutions are converged
      logical, intent(in) :: jconverged(n5)
!!    omega
      real(lkl_real_sp_k), intent(in) :: omega(n3)
!!    rhs
      real(lkl_real_sp_k), intent(in) :: rhs(n1,n4)
!!    lagrangian
      real(lkl_real_sp_k), intent(in) :: lagrangian(n5)
!!    solutions on the full space, stored on mvproduct
      real(lkl_real_sp_k), intent(in) :: solutions(n1,n5)
!!    residual norms of each vector
      real(lkl_real_sp_k), intent(in) :: euc_norm(n5)
!!    residual norm of all vectors
      real(lkl_real_sp_k), intent(in) :: fro_norm
!!    id_string 
      character(len=22), intent(in) :: id_string
!!    error variable
      integer(lkl_int_rsp_k), intent(inout) :: ierr
    end subroutine libkrylov_output_c_interface
  end interface

!--------------------------------------------------------------------

!--------------------------------------------------------------------
contains
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Required subroutines for example start and guess function
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  recursive subroutine quicksort_stl_float_rsp(n,obj,dex,first,last,ierr)
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
    integer(lkl_int_rsp_k), intent(in) :: n
!!  array to be sorted
    real(lkl_real_sp_k), intent(inout) :: obj(n)
!! indexing of array to be sorted
    integer(lkl_int_rsp_k), intent(inout) :: dex(n)
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! first element
    integer(lkl_int_rsp_k), intent(in) :: first
!! the last element
    integer(lkl_int_rsp_k), intent(in) :: last
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(lkl_int_rsp_k), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!!  pivot value, by default is the value in the middle of first and last
    real(lkl_real_sp_k) :: p
!!  dummy variable for copying
    real(lkl_real_sp_k) :: t
!!  dummy variable for copying
    integer(lkl_int_rsp_k) :: k = 0
!!  integer for do loops
    integer(lkl_int_rsp_k) :: j1,j2 = 0
!--------------------------------------------------------------------

    p = obj(int((first+last)*0.5,kind=lkl_int_rsp_k))
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
      call quicksort_stl_float_rsp(n,obj,dex,first,j1-1,ierr)
    end if
    if (last.gt.j2+1) then
      call quicksort_stl_float_rsp(n,obj,dex,j2+1,last,ierr)
    end if

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine quicksort_stl_float_rsp
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Example start functions
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine lkl_start_elec_gas_rsp(data,n1,n2,approx_spectra,&
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
    class(lkl_s_elec_gas_rsp) :: data
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!!   nbasis
    integer(lkl_int_rsp_k), intent(in) :: n1
!!   nroots
    integer(lkl_int_rsp_k), intent(in) :: n2
!!    approximate spectra
    real(lkl_real_sp_k), intent(in) :: approx_spectra(n1)
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! nstart
    integer(lkl_int_rsp_k), intent(inout) :: nstart
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(lkl_int_rsp_k), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! test values
    real(lkl_real_sp_k), parameter :: T100000K_au = &
  &  real(1.380649,kind=lkl_real_sp_k) &
  &  /real(4.3597447222071,kind=lkl_real_sp_k)
    real(lkl_real_sp_k) :: occupation_limit = 0
!!  integer for do loops
    integer(lkl_int_rsp_k) :: j,k,l = 0
!!  array for sorting
    real(lkl_real_sp_k), allocatable :: sorter(:)
!! indexing of approx spectra for sorting
    integer(lkl_int_rsp_k), allocatable :: dex(:)
!! threshold "energy" value
    real(lkl_real_sp_k) :: test_value
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
    call quicksort_stl_float_rsp(n1,sorter,dex,1,n1,ierr)
    if (ierr.ne.0) then
      return ! abort subroutine, return to call
    end if

!! set the occupation for the threshold 'energy'
!! of the fermi dirac distribution
    occupation_limit = real(0.1,kind=lkl_real_sp_k)
!! threshold 'energy' is the test_value
    test_value = T100000K_au*log((1/occupation_limit)-1)&
  &      +((sorter(n2+1)+sorter(n2))&
  &      *real(0.5,kind=lkl_real_sp_k))

!! set nstart to full basis first, as an error condition
!! where all energies are below test_value
    nstart = n1
!! loop to find the first diagonal element greater than
!! test value
    do j = (n2+1), n1
      if ((sorter(j)-test_value).gt.&
  &        epsilon(real(0,kind=lkl_real_sp_k))) then
        nstart = j-1
        exit ! set nstart
      end if
    end do

!! deallocate local arrays
    deallocate(sorter)
    deallocate(dex)

!--------------------------------------------------------------------
  end subroutine lkl_start_elec_gas_rsp
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine lkl_start_ext_in_rsp(data,n1,n2,approx_spectra,&
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
    class(lkl_s_ext_in_rsp) :: data
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!!   nbasis
    integer(lkl_int_rsp_k), intent(in) :: n1
!!   nroots
    integer(lkl_int_rsp_k), intent(in) :: n2
!!    approximate spectra
    real(lkl_real_sp_k), intent(in) :: approx_spectra(n1)
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! nstart
    integer(lkl_int_rsp_k), intent(inout) :: nstart
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(lkl_int_rsp_k), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! Blank
!--------------------------------------------------------------------

    nstart = data%nstart

!--------------------------------------------------------------------
  end subroutine lkl_start_ext_in_rsp
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Example guess functions
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine lkl_guess_unit_vec_rsp(data,n1,n2,n3,approx_spectra,&
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
    class(lkl_g_unit_vec_rsp) :: data
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!!    rows of guess vectors, nbasis
    integer(lkl_int_rsp_k), intent(in) :: n1
!!    columns of guess vectors, nstart
    integer(lkl_int_rsp_k), intent(in) :: n2
!!    last index of basis vectors that is input
    integer(lkl_int_rsp_k), intent(in) :: n3
!!    approximate spectra
    real(lkl_real_sp_k), intent(in) :: approx_spectra(n1)
!--------------------------------------------------------------------
! Input/Output Parameters
!--------------------------------------------------------------------
!!    guess vectors
    real(lkl_real_sp_k), intent(inout) :: basis_vectors(n1,n2)
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(lkl_int_rsp_k), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! number of new vectors, n2-n3
    integer(lkl_int_rsp_k) :: n4
!!  integer for do loops
    integer(lkl_int_rsp_k) :: j,k,l = 0
!!  array for sorting
    real(lkl_real_sp_k), allocatable :: sorter(:)
!! indexing of approx spectra for sorting
    integer(lkl_int_rsp_k), allocatable :: dex(:)
!! norm checking
    real(lkl_real_sp_k) :: test_value_sq
    real(lkl_real_sp_k) :: test_value
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
    call quicksort_stl_float_rsp(n1,sorter,dex,1,n1,ierr)
    if (ierr.ne.0) then
      return ! abort subroutine, return to call
    end if

    if (n3.eq.0) then
!! all basis vectors are new
! zero basis vectors
      basis_vectors = real(0,kind=lkl_real_sp_k)
      do j = 1, n2
! make delta function
        basis_vectors(dex(j),j) = real(1,kind=lkl_real_sp_k)
      end do
    else 
! need to use previous vectors and generate new ones!
! zero only sections that need to be zeroed
      basis_vectors(1:n1,(n3+1):n2) = real(0,kind=lkl_real_sp_k)
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
          if (abs(real(1,kind=lkl_real_sp_k)-test_value).gt.&
  &             epsilon(real(0,kind=lkl_real_sp_k))) then
            test_orthogonal(k) = .true.
          end if
        end do
! accept new basis vector if test passed
        if (all(test_orthogonal)) then
          ! fill in new basis vector
          basis_vectors(dex(j),l) = real(1,kind=lkl_real_sp_k)
          l = l +1
        end if
      end do
    end if

!! deallocate local arrays
    deallocate(sorter)
    deallocate(dex)
    deallocate(test_orthogonal)

!--------------------------------------------------------------------
  end subroutine lkl_guess_unit_vec_rsp
!--------------------------------------------------------------------


!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module libkrylovinterface_real_sp
!--------------------------------------------------------------------
!--------------------------------------------------------------------
