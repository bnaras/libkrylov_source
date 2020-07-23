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
! krylov subspace function signatures
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

!--------------------------------------------------------------------

contains
!--------------------------------------------------------------------
! Implementation of input subroutines
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
!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module driver1types
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
