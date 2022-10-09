function krylov_get_space_last_residual_norms(index, solution_dim, last_residual_norms) result(error)

    use kinds, only: IK, RK
    use errors, only: NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index, solution_dim
    real(RK), intent(out) :: last_residual_norms(solution_dim)
    integer(IK) :: error

    last_residual_norms = 0.0_RK

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        return
    end if

    error = spaces(index)%space_p%convergence%get_last_residual_norms(solution_dim, last_residual_norms)

end function krylov_get_space_last_residual_norms
