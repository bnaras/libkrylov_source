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
  use libkrylovinterface_real_sp , only: &
  &   base => base_rsp, &
  &   kind_float => lkl_real_sp_k, &
  &   kind_integer => lkl_int_rsp_k, &
  &   libkrylov_matrix_subroutine => libkrylov_matrix_real_sp, &
  &   libkrylov_vector_subroutine => libkrylov_vector_real_sp, &
  &   libkrylov_start_subroutine => libkrylov_start_real_sp, &
  &   libkrylov_guess_subroutine => libkrylov_guess_real_sp, &
  &   libkrylov_mvp_subroutine => libkrylov_mvp_real_sp, &
  &   libkrylov_problem_a_subroutine => libkrylov_problem_a_real_sp, &
  &   libkrylov_output_a_subroutine => libkrylov_output_a_real_sp, &
  &   libkrylov_problem_b_subroutine => libkrylov_problem_b_real_sp, &
  &   libkrylov_output_b_subroutine => libkrylov_output_b_real_sp, &
  &   libkrylov_problem_c_subroutine => libkrylov_problem_c_real_sp, &
  &   libkrylov_output_c_subroutine => libkrylov_output_c_real_sp
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
