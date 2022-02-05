function krylov_iteration_set_residual_norms(iteration, solution_dim, residual_norms) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: iteration_t

    class(iteration_t), intent(inout) :: iteration
    integer(IK), intent(in) :: solution_dim
    real(RK), intent(in) :: residual_norms(solution_dim)
    integer(IK) :: error

    if (solution_dim /= iteration%solution_dim) then
        error = INVALID_DIMENSION
        return
    end if

    iteration%residual_norms = residual_norms

    error = OK

end function krylov_iteration_set_residual_norms
