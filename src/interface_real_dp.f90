!--------------------------------------------------------------------
!--------------------------------------------------------------------
module libkrylovinterface
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
  use libkrylovinterface_real_dp , only: &
  &   libkrylov_scalar_subroutine => libkrylov_scalar_real_dp, &
  &   libkrylov_matrix_subroutine => libkrylov_matrix_real_dp, &
  &   libkrylov_vector_subroutine => libkrylov_vector_real_dp, &
  &   libkrylov_start_subroutine => libkrylov_start_real_dp, &
  &   libkrylov_guess_subroutine => libkrylov_guess_real_dp, &
  &   libkrylov_mvp_subroutine => libkrylov_mvp_real_dp, &
  &   libkrylov_problem_a_subroutine => libkrylov_problem_a_real_dp, &
  &   libkrylov_output_a_subroutine => libkrylov_output_a_real_dp, &
  &   libkrylov_problem_b_subroutine => libkrylov_problem_b_real_dp, &
  &   libkrylov_output_b_subroutine => libkrylov_output_b_real_dp, &
  &   libkrylov_problem_c_subroutine => libkrylov_problem_c_real_dp, &
  &   libkrylov_output_c_subroutine => libkrylov_output_c_real_dp
!--------------------------------------------------------------------
! Implicit none
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module libkrylovinterface
!--------------------------------------------------------------------
!--------------------------------------------------------------------
