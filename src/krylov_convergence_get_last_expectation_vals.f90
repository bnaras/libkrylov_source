function krylov_convergence_get_last_expectation_vals(convergence, solution_dim, last_expectation_vals) result(error)

    use kinds, only: IK, RK
    use errors, only: NO_ITERATIONS
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(in) :: convergence
    integer(IK), intent(in) :: solution_dim
    real(RK), intent(out) :: last_expectation_vals(solution_dim)
    integer(IK) :: error

    integer(IK) :: index

    last_expectation_vals = 0.0_RK

    index = convergence%get_num_iterations()

    if (index == 0_IK) then
        error = NO_ITERATIONS
        return
    end if

    error = convergence%iterations(index)%get_expectation_vals(solution_dim, last_expectation_vals)

end function krylov_convergence_get_last_expectation_vals
