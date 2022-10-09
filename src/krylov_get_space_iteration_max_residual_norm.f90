function krylov_get_space_iteration_max_residual_norm(index, iter) result(max_residual_norm)

    use kinds, only: IK, RK
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index, iter
    real(RK) :: max_residual_norm

    if (index > krylov_get_num_spaces()) then
        max_residual_norm = -1.0_RK
        return
    end if

    max_residual_norm = spaces(index)%space_p%convergence%get_iteration_max_residual_norm(iter)

end function krylov_get_space_iteration_max_residual_norm
