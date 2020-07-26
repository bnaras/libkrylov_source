!--------------------------------------------------------------------
!--------------------------------------------------------------------
module libkrylovinterface2
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
  &   lkl_constr_a_1 => lkl_constr_a_1_csp, &
  &   lkl_destr_a_1 => lkl_destr_a_1_csp, &
  &   lkl_constr_b_1 => lkl_constr_b_1_csp, &
  &   lkl_destr_b_1 => lkl_destr_b_1_csp, &
  &   lkl_constr_c_1 => lkl_constr_c_1_csp, &
  &   lkl_destr_c_1 => lkl_destr_c_1_csp, &
  &   quicksort_stl_float => quicksort_stl_float_csp, &
  &   lkl_s_elec_gas => lkl_s_elec_gas_csp, &
  &   lkl_start_elec_gas => lkl_start_elec_gas_csp, &
  &   lkl_s_ext_in => lkl_s_ext_in_csp, &
  &   lkl_start_ext_in => lkl_start_ext_in_csp, &
  &   lkl_g_unit_vec => lkl_g_unit_vec_csp, &
  &   lkl_guess_unit_vec => lkl_guess_unit_vec_csp, &
  &   lkl_mvp_n_mul => lkl_mvp_n_mul_csp, &
  &   lkl_mvp_naive_multiply => lkl_mvp_naive_multiply_csp
!--------------------------------------------------------------------
! Implicit none
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module libkrylovinterface2
!--------------------------------------------------------------------
!--------------------------------------------------------------------
