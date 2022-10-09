function krylov_iteration_get_expectation_vals(iteration, solution_dim, expectation_vals) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: iteration_t

    class(iteration_t), intent(in) :: iteration
    integer(IK), intent(in) :: solution_dim
    real(RK), intent(out) :: expectation_vals(solution_dim)
    integer(IK) :: error

    if (solution_dim /= iteration%solution_dim) then
        error = INVALID_DIMENSION
        return
    end if

    expectation_vals = iteration%expectation_vals

    error = OK

end function krylov_iteration_get_expectation_vals
