function krylov_get_space_last_max_residual_norm(index) result(last_max_residual_norm)

    use kinds, only: IK, RK
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    real(RK) :: last_max_residual_norm

    if (index > krylov_get_num_spaces()) then
        last_max_residual_norm = -1.0_RK
    end if

    last_max_residual_norm = spaces(index)%space_p%convergence%get_last_max_residual_norm()

end function krylov_get_space_last_max_residual_norm
