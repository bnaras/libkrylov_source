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
  use libkrylovinterface_cmplx_dp , only: &
  &   quicksort_stl_float => quicksort_stl_float_cdp, &
  &   lkl_s_elec_gas => lkl_s_elec_gas_cdp, &
  &   lkl_start_elec_gas => lkl_start_elec_gas_cdp, &
  &   lkl_g_unit_vec => lkl_g_unit_vec_cdp, &
  &   lkl_guess_unit_vec => lkl_guess_unit_vec_cdp, &
  &   lkl_pc_all => lkl_pc_all_cdp, &
  &   lkl_precon_all => lkl_precon_all_cdp, &
  &   lkl_pc_none => lkl_pc_none_cdp, &
  &   lkl_precon_none => lkl_precon_none_cdp, &
  &   lkl_pc_approx => lkl_pc_approx_cdp, &
  &   lkl_precon_approx => lkl_precon_approx_cdp, &
  &   lkl_pc_davidson => lkl_pc_davidson_cdp, &
  &   lkl_precon_davidson => lkl_precon_davidson_cdp, &
  &   lkl_pc_sleijpen => lkl_pc_sleijpen_cdp, &
  &   lkl_precon_sleijpen => lkl_precon_sleijpen_cdp, &
  &   lkl_mta_all => lkl_mta_all_cdp, &
  &   lkl_maket_a_all => lkl_maket_a_all_cdp, &
  &   lkl_mtb_all => lkl_mtb_all_cdp, &
  &   lkl_maket_b_all => lkl_maket_b_all_cdp, &
  &   lkl_mtc_all => lkl_mtc_all_cdp, &
  &   lkl_maket_c_all => lkl_maket_c_all_cdp
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
