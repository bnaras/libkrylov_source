function krylov_iteration_initialize(iteration, basis_dim, solution_dim, gram_rcond, lagrangian) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION, INVALID_INPUT
    use krylov, only: iteration_t
    implicit none

    class(iteration_t), intent(inout) :: iteration
    integer(IK), intent(in) :: basis_dim, solution_dim
    real(RK), intent(in) :: gram_rcond, lagrangian
    integer(IK) :: error

    if (basis_dim <= 0_IK) then
        error = INVALID_DIMENSION
        return
    end if

    if (solution_dim <= 0_IK) then
        error = INVALID_DIMENSION
        return
    end if

    if (gram_rcond <= 0.0_RK) then
        error = INVALID_INPUT
        return
    end if

    iteration%basis_dim = basis_dim
    iteration%solution_dim = solution_dim
    iteration%gram_rcond = gram_rcond
    iteration%lagrangian = lagrangian

    if (allocated(iteration%expectation_vals)) deallocate (iteration%expectation_vals)
    if (allocated(iteration%residual_norms)) deallocate (iteration%residual_norms)
    allocate (iteration%expectation_vals(iteration%solution_dim), iteration%residual_norms(iteration%solution_dim))

    error = OK

end function krylov_iteration_initialize
