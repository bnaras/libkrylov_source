function krylov_get_space_iteration_residual_norms(index, iter, solution_dim, residual_norms) result(error)

    use kinds, only: IK, RK
    use errors, only: NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index, iter, solution_dim
    real(RK), intent(out) :: residual_norms(solution_dim)
    integer(IK) :: error

    residual_norms = 0.0_RK

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        return
    end if

    error = spaces(index)%space_p%convergence%get_iteration_residual_norms(iter, solution_dim, residual_norms)

end function krylov_get_space_iteration_residual_norms
