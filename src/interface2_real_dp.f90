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
  &   quicksort_stl_float => quicksort_stl_float_rdp, &
  &   lkl_s_elec_gas => lkl_s_elec_gas_rdp, &
  &   lkl_start_elec_gas => lkl_start_elec_gas_rdp, &
  &   lkl_g_unit_vec => lkl_g_unit_vec_rdp, &
  &   lkl_guess_unit_vec => lkl_guess_unit_vec_rdp, &
  &   lkl_pc_all => lkl_pc_all_rdp, &
  &   lkl_precon_all => lkl_precon_all_rdp, &
  &   lkl_pc_none => lkl_pc_none_rdp, &
  &   lkl_precon_none => lkl_precon_none_rdp, &
  &   lkl_pc_approx => lkl_pc_approx_rdp, &
  &   lkl_precon_approx => lkl_precon_approx_rdp, &
  &   lkl_pc_davidson => lkl_pc_davidson_rdp, &
  &   lkl_precon_davidson => lkl_precon_davidson_rdp, &
  &   lkl_pc_sleijpen => lkl_pc_sleijpen_rdp, &
  &   lkl_precon_sleijpen => lkl_precon_sleijpen_rdp, &
  &   lkl_mta_all => lkl_mta_all_rdp, &
  &   lkl_maket_a_all => lkl_maket_a_all_rdp
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
