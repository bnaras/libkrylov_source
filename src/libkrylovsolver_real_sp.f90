!--------------------------------------------------------------------
!--------------------------------------------------------------------
module libkrylovsolver_real_sp
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
  use libkrylovinterface_real_sp
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
  subroutine problem_a_real_sp(krylov_approx,krylov_start,&
    & krylov_problem_a,&
    & krylov_guess,krylov_mvp,krylov_precon,&
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
    use libkrylovinterface_real_sp
    use libkrylovsolver
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input functions
!--------------------------------------------------------------------
    class(libkrylov_vector_real_sp) ::    krylov_approx
    class(libkrylov_start_real_sp) ::     krylov_start
    class(libkrylov_problem_a_real_sp) :: krylov_problem_a
    class(libkrylov_guess_real_sp) ::     krylov_guess
    class(libkrylov_mvp_real_sp) ::       krylov_mvp
    class(libkrylov_precon_real_sp) ::    krylov_precon
    class(libkrylov_output_a_real_sp) ::  krylov_output_a
!! variable for error variable
    integer(kind_integer), intent(inout) :: ierr 
!--------------------------------------------------------------------

    call problem_a_solver(krylov_approx,krylov_start,&
  &  krylov_problem_a,&
  &  krylov_guess,krylov_mvp,krylov_precon,&
  &  krylov_output_a,ierr)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine problem_a_real_sp 
!--------------------------------------------------------------------
!--------------------------------------------------------------------


!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module libkrylovsolver_real_sp
!--------------------------------------------------------------------
!--------------------------------------------------------------------
