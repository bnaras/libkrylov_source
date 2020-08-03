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
  use libkrylovinterface_cmplx_dp , only: &
  &   base => base_cdp, &
  &   kind_float => lkl_cmplx_dp_k, &
  &   kind_integer => lkl_int_cdp_k, &
  &   libkrylov_matrix_subroutine => libkrylov_matrix_cmplx_dp, &
  &   libkrylov_vector_subroutine => libkrylov_vector_cmplx_dp, &
  &   libkrylov_start_subroutine => libkrylov_start_cmplx_dp, &
  &   libkrylov_guess_subroutine => libkrylov_guess_cmplx_dp, &
  &   libkrylov_mvp_subroutine => libkrylov_mvp_cmplx_dp, &
  &   libkrylov_problem_a_input => &
  &   libkrylov_problem_a_input_cmplx_dp, &
  &   libkrylov_problem_a_output => &
  &   libkrylov_problem_a_output_cmplx_dp, &
  &   libkrylov_problem_b_input => &
  &   libkrylov_problem_b_input_cmplx_dp, &
  &   libkrylov_problem_b_output => &
  &   libkrylov_problem_b_output_cmplx_dp, &
  &   libkrylov_problem_c_input => &
  &   libkrylov_problem_c_input_cmplx_dp, &
  &   libkrylov_problem_c_output => &
  &   libkrylov_problem_c_output_cmplx_dp
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
