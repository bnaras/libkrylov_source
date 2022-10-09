function krylov_convergence_get_last_residual_norms(convergence, solution_dim, last_residual_norms) result(error)

    use kinds, only: IK, RK
    use errors, only: NO_ITERATIONS
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(in) :: convergence
    integer(IK), intent(in) :: solution_dim
    real(RK), intent(out) :: last_residual_norms(solution_dim)
    integer(IK) :: error

    integer(IK) :: index

    last_residual_norms = 0.0_RK

    index = convergence%get_num_iterations()

    if (index == 0_IK) then
        error = NO_ITERATIONS
        return
    end if

    error = convergence%iterations(index)%get_residual_norms(solution_dim, last_residual_norms)

end function krylov_convergence_get_last_residual_norms
