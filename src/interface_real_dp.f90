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
  &   base => base_rdp, &
  &   kind_float => lkl_real_dp_k, &
  &   kind_integer => lkl_int_rdp_k, &
  &   libkrylov_matrix_subroutine => libkrylov_matrix_real_dp, &
  &   libkrylov_vector_subroutine => libkrylov_vector_real_dp, &
  &   libkrylov_start_subroutine => libkrylov_start_real_dp, &
  &   libkrylov_guess_subroutine => libkrylov_guess_real_dp, &
  &   libkrylov_mvp_subroutine => libkrylov_mvp_real_dp, &
  &   libkrylov_problem_a_input => &
  &   libkrylov_problem_a_input_real_dp, &
  &   libkrylov_problem_a_output => &
  &   libkrylov_problem_a_output_real_dp, &
  &   libkrylov_problem_b_input => &
  &   libkrylov_problem_b_input_real_dp, &
  &   libkrylov_problem_b_output => &
  &   libkrylov_problem_b_output_real_dp, &
  &   libkrylov_problem_c_input => &
  &   libkrylov_problem_c_input_real_dp, &
  &   libkrylov_problem_c_output => &
  &   libkrylov_problem_c_output_real_dp
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
