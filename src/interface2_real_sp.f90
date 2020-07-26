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
  use libkrylovinterface_real_sp , only: &
  &   lkl_constr_a_1 => lkl_constr_a_1_rsp, &
  &   lkl_destr_a_1 => lkl_destr_a_1_rsp, &
  &   lkl_constr_b_1 => lkl_constr_b_1_rsp, &
  &   lkl_destr_b_1 => lkl_destr_b_1_rsp, &
  &   lkl_constr_c_1 => lkl_constr_c_1_rsp, &
  &   lkl_destr_c_1 => lkl_destr_c_1_rsp, &
  &   quicksort_stl_float => quicksort_stl_float_rsp, &
  &   lkl_s_elec_gas => lkl_s_elec_gas_rsp, &
  &   lkl_start_elec_gas => lkl_start_elec_gas_rsp, &
  &   lkl_s_ext_in => lkl_s_ext_in_rsp, &
  &   lkl_start_ext_in => lkl_start_ext_in_rsp, &
  &   lkl_g_unit_vec => lkl_g_unit_vec_rsp, &
  &   lkl_guess_unit_vec => lkl_guess_unit_vec_rsp, &
  &   lkl_mvp_n_mul => lkl_mvp_n_mul_rsp, &
  &   lkl_mvp_naive_multiply => lkl_mvp_naive_multiply_rsp
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
