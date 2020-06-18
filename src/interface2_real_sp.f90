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
  use libkrylovinterface_real_dp , only: &
  &   quicksort_stl_float => quicksort_stl_float_rsp, &
  &   lkl_s_elec_gas => lkl_s_elec_gas_rsp, &
  &   lkl_start_elec_gas => lkl_start_elec_gas_rsp, &
  &   lkl_g_unit_vec => lkl_g_unit_vec_rsp, &
  &   lkl_guess_unit_vec => lkl_guess_unit_vec_rsp, &
  &   lkl_pc_all => lkl_pc_all_rsp, &
  &   lkl_precon_all => lkl_precon_all_rsp, &
  &   lkl_pc_none => lkl_pc_none_rsp, &
  &   lkl_precon_none => lkl_precon_none_rsp, &
  &   lkl_pc_approx => lkl_pc_approx_rsp, &
  &   lkl_precon_approx => lkl_precon_approx_rsp, &
  &   lkl_pc_davidson => lkl_pc_davidson_rsp, &
  &   lkl_precon_davidson => lkl_precon_davidson_rsp, &
  &   lkl_pc_sleijpen => lkl_pc_sleijpen_rsp, &
  &   lkl_precon_sleijpen => lkl_precon_sleijpen_rsp, &
  &   lkl_mta_all => lkl_mta_all_rsp, &
  &   lkl_maket_a_all => lkl_maket_a_all_rsp, &
  &   lkl_mtb_all => lkl_mtb_all_rsp, &
  &   lkl_maket_b_all => lkl_maket_b_all_rsp, &
  &   lkl_mtc_all => lkl_mtc_all_rsp, &
  &   lkl_maket_c_all => lkl_maket_c_all_rsp
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
