function krylov_iteration_get_residual_norms(iteration, solution_dim, residual_norms) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: iteration_t

    class(iteration_t), intent(in) :: iteration
    integer(IK), intent(in) :: solution_dim
    real(RK), intent(out) :: residual_norms(solution_dim)
    integer(IK) :: error

    if (solution_dim /= iteration%solution_dim) then
        error = INVALID_DIMENSION
        return
    end if

    residual_norms = iteration%residual_norms

    error = OK

end function krylov_iteration_get_residual_norms
