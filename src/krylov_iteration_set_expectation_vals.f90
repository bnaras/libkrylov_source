function krylov_iteration_set_expectation_vals(iteration, solution_dim, expectation_vals) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: iteration_t

    class(iteration_t), intent(inout) :: iteration
    integer(IK), intent(in) :: solution_dim
    real(RK), intent(in) :: expectation_vals(solution_dim)
    integer(IK) :: error

    if (solution_dim /= iteration%solution_dim) then
        error = INVALID_DIMENSION
        return
    end if

    iteration%expectation_vals = expectation_vals

    error = OK

end function krylov_iteration_set_expectation_vals
