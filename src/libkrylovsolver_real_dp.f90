!--------------------------------------------------------------------
!--------------------------------------------------------------------
module libkrylovsolver_real_dp
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
  use libkrylovinterface_real_dp
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
  subroutine problem_a_real_dp(krylov_approx,krylov_start,&
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
    use libkrylovinterface_real_dp
    use libkrylovsolver
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input functions
!--------------------------------------------------------------------
    class(libkrylov_vector_real_dp) ::    krylov_approx
    class(libkrylov_start_real_dp) ::     krylov_start
    class(libkrylov_problem_a_real_dp) :: krylov_problem_a
    class(libkrylov_guess_real_dp) ::     krylov_guess
    class(libkrylov_mvp_real_dp) ::       krylov_mvp
    class(libkrylov_output_a_real_dp) ::  krylov_output_a
!! variable for error variable
    integer(lkl_int_rdp_k), intent(inout) :: ierr 
!--------------------------------------------------------------------

    call problem_a_solver(krylov_approx,krylov_start,&
  &  krylov_problem_a,&
  &  krylov_guess,krylov_mvp,&
  &  krylov_output_a,ierr)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine problem_a_real_dp 
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine problem_b_real_dp(krylov_approx,krylov_start,krylov_rhs,&
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
    use libkrylovinterface_real_dp
    use libkrylovsolver
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
!--------------------------------------------------------------------
! Input functions
!--------------------------------------------------------------------
    class(libkrylov_vector_subroutine) ::    krylov_approx
    class(libkrylov_start_subroutine) ::     krylov_start
    class(libkrylov_matrix_subroutine) ::    krylov_rhs
    class(libkrylov_problem_b_subroutine) :: krylov_problem_b
    class(libkrylov_guess_subroutine) ::     krylov_guess
    class(libkrylov_mvp_subroutine) ::       krylov_mvp
    class(libkrylov_output_b_subroutine) ::  krylov_output_b
!! variable for error variable
    integer(lkl_int_rdp_k), intent(inout) :: ierr
!--------------------------------------------------------------------
    call  problem_b_solver(krylov_approx,krylov_start,krylov_rhs,&
    & krylov_problem_b,krylov_guess,&
    & krylov_mvp,krylov_output_b,ierr)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine problem_b_real_dp
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine problem_c_real_dp(krylov_approx,krylov_start,krylov_rhs,&
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
    use libkrylovinterface_real_dp
    use libkrylovsolver
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input functions
!--------------------------------------------------------------------
    class(libkrylov_vector_subroutine) ::    krylov_approx
    class(libkrylov_start_subroutine) ::     krylov_start
    class(libkrylov_matrix_subroutine) ::    krylov_rhs
    class(libkrylov_vector_subroutine) ::    krylov_omega
    class(libkrylov_problem_c_subroutine) :: krylov_problem_c
    class(libkrylov_guess_subroutine) ::     krylov_guess
    class(libkrylov_mvp_subroutine) ::       krylov_mvp
    class(libkrylov_output_c_subroutine) ::  krylov_output_c
!! variable for error variable
    integer(lkl_int_rdp_k), intent(inout) :: ierr
!--------------------------------------------------------------------
    call  problem_c_solver(krylov_approx,krylov_start,krylov_rhs,&
    & krylov_omega,krylov_problem_c,krylov_guess,&
    & krylov_mvp,krylov_output_c,ierr)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine problem_c_real_dp
!--------------------------------------------------------------------
!--------------------------------------------------------------------


!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module libkrylovsolver_real_dp
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
