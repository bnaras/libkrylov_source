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
  use libkrylovinterface_cmplx_sp , only: &
  &   libkrylov_matrix_subroutine => libkrylov_matrix_cmplx_sp, &
  &   libkrylov_vector_subroutine => libkrylov_vector_cmplx_sp, &
  &   libkrylov_start_subroutine => libkrylov_start_cmplx_sp, &
  &   libkrylov_guess_subroutine => libkrylov_guess_cmplx_sp, &
  &   libkrylov_mvp_subroutine => libkrylov_mvp_cmplx_sp, &
  &   libkrylov_precon_subroutine => libkrylov_precon_cmplx_sp, &
  &   libkrylov_problem_a_subroutine => libkrylov_problem_a_cmplx_sp, &
  &   libkrylov_output_a_subroutine => libkrylov_output_a_cmplx_sp, &
  &   libkrylov_problem_b_subroutine => libkrylov_problem_b_cmplx_sp, &
  &   libkrylov_output_b_subroutine => libkrylov_output_b_cmplx_sp, &
  &   libkrylov_problem_c_subroutine => libkrylov_problem_c_cmplx_sp, &
  &   libkrylov_output_c_subroutine => libkrylov_output_c_cmplx_sp
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
