function krylov_get_space_iteration_expectation_vals(index, iter, solution_dim, expectation_vals) result(error)

    use kinds, only: IK, RK
    use errors, only: NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index, iter, solution_dim
    real(RK), intent(out) :: expectation_vals(solution_dim)
    integer(IK) :: error

    expectation_vals = 0.0_RK

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        return
    end if

    error = spaces(index)%space_p%convergence%get_iteration_expectation_vals(iter, solution_dim, expectation_vals)

end function krylov_get_space_iteration_expectation_vals
