!--------------------------------------------------------------------
!--------------------------------------------------------------------
module libkrylovsolver_cmplx_sp
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This module wraps the interface for user input/output functions
!< for a libkrylov solver for compile time polymorphism
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Varaibles
!--------------------------------------------------------------------
  use libkrylovinterface_cmplx_sp
  use libkrylovsolver
!--------------------------------------------------------------------
! Implicit none
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------
contains
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine problem_a_cmplx_sp(krylov_approx,krylov_start,&
    & krylov_problem_a,&
    & krylov_guess,krylov_mvp,&
    & krylov_output_a,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine wraps libkrylovsolver problem_a_solver to solve
!< a problem with the form 'problem_a'
!< with the non-orthonormal krylov subspace method

  !< This subroutine requires the following 
  !< user-defined subroutines:
  !< krylov_approx for the approximate spectra
  !< krylov_start for determining number of start vectors
  !< krylov_problem  for details of the problem
  !< krylov_guess for initializing more guess vectors and their
  !< overlap
  !< krylov_mvp for matrix vector products
  !< krylov_precon for preconditioning
  !< krylov_output for what to do with the eigenvectors and eigenvalues
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
    use libkrylovinterface_cmplx_sp
    use libkrylovsolver
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input functions
!--------------------------------------------------------------------
    class(libkrylov_vector_cmplx_sp) ::    krylov_approx
    class(libkrylov_start_cmplx_sp) ::     krylov_start
    class(libkrylov_problem_a_cmplx_sp) :: krylov_problem_a
    class(libkrylov_guess_cmplx_sp) ::     krylov_guess
    class(libkrylov_mvp_cmplx_sp) ::       krylov_mvp
    class(libkrylov_output_a_cmplx_sp) ::  krylov_output_a
!! variable for error variable
    integer(lkl_int_csp_k), intent(inout) :: ierr 
!--------------------------------------------------------------------

    call problem_a_solver(krylov_approx,krylov_start,&
  &  krylov_problem_a,&
  &  krylov_guess,krylov_mvp,&
  &  krylov_output_a,ierr)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine problem_a_cmplx_sp 
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine problem_b_cmplx_sp(krylov_approx,krylov_start,krylov_rhs,&
    & krylov_problem_b,krylov_guess,&
    & krylov_mvp,krylov_output_b,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine solves a problem with the form 'problem_b'
!< with the non-orthonormal krylov subspace method

  !< This subroutine requires the following 
  !< user-defined subroutines:
  !< krylov_approx for the approximate spectra
  !< krylov_start for determining number of start vectors
  !< krylov_rhs for the right hand side
  !< krylov_problem  for details of the problem
  !< krylov_guess for initializing more guess vectors and their
  !< overlap
  !< krylov_mvp for matrix vector products
  !< krylov_output for what to do with the eigenvectors
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
    use libkrylovinterface_cmplx_sp
    use libkrylovsolver
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
!--------------------------------------------------------------------
! Input functions
!--------------------------------------------------------------------
    class(libkrylov_vector_cmplx_sp) ::    krylov_approx
    class(libkrylov_start_cmplx_sp) ::     krylov_start
    class(libkrylov_matrix_cmplx_sp) ::    krylov_rhs
    class(libkrylov_problem_b_cmplx_sp) :: krylov_problem_b
    class(libkrylov_guess_cmplx_sp) ::     krylov_guess
    class(libkrylov_mvp_cmplx_sp) ::       krylov_mvp
    class(libkrylov_output_b_cmplx_sp) ::  krylov_output_b
!! variable for error variable
    integer(lkl_int_csp_k), intent(inout) :: ierr
!--------------------------------------------------------------------
    call  problem_b_solver(krylov_approx,krylov_start,krylov_rhs,&
    & krylov_problem_b,krylov_guess,&
    & krylov_mvp,krylov_output_b,ierr)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine problem_b_cmplx_sp
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine problem_c_cmplx_sp(krylov_approx,krylov_start,krylov_rhs,&
    & krylov_omega,krylov_problem_c,krylov_guess,&
    & krylov_mvp,krylov_output_c,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine solves a problem with the form 'problem_a'
!< with the non-orthonormal krylov subspace method

  !< This subroutine requires the following 
  !< user-defined subroutines:
  !< krylov_approx for the approximate spectra
  !< krylov_start for determining number of start vectors
  !< krylov_rhs for the right hand side
  !< krylov_omega for the frequencies
  !< krylov_problem  for details of the problem
  !< krylov_guess for initializing more guess vectors and their
  !< overlap
  !< krylov_mvp for matrix vector products
  !< krylov_output for what to do with the eigenvectors and frequencies
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
    use libkrylovinterface_cmplx_sp
    use libkrylovsolver
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input functions
!--------------------------------------------------------------------
    class(libkrylov_vector_cmplx_sp) ::    krylov_approx
    class(libkrylov_start_cmplx_sp) ::     krylov_start
    class(libkrylov_matrix_cmplx_sp) ::    krylov_rhs
    class(libkrylov_vector_cmplx_sp) ::    krylov_omega
    class(libkrylov_problem_c_cmplx_sp) :: krylov_problem_c
    class(libkrylov_guess_cmplx_sp) ::     krylov_guess
    class(libkrylov_mvp_cmplx_sp) ::       krylov_mvp
    class(libkrylov_output_c_cmplx_sp) ::  krylov_output_c
!! variable for error variable
    integer(lkl_int_csp_k), intent(inout) :: ierr
!--------------------------------------------------------------------
    call  problem_c_solver(krylov_approx,krylov_start,krylov_rhs,&
    & krylov_omega,krylov_problem_c,krylov_guess,&
    & krylov_mvp,krylov_output_c,ierr)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine problem_c_cmplx_sp
!--------------------------------------------------------------------
!--------------------------------------------------------------------


!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module libkrylovsolver_cmplx_sp
!--------------------------------------------------------------------
!--------------------------------------------------------------------
