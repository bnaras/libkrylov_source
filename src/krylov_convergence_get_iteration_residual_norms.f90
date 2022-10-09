function krylov_convergence_get_iteration_residual_norms(convergence, index, solution_dim, residual_norms) &
    result(error)

    use kinds, only: IK, RK
    use errors, only: NO_SUCH_ITERATION
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(in) :: convergence
    integer(IK), intent(in) :: index, solution_dim
    real(RK), intent(out) :: residual_norms(solution_dim)
    integer(IK) :: error

    if (index > convergence%get_num_iterations()) then
        error = NO_SUCH_ITERATION
        return
    end if

    error = convergence%iterations(index)%get_residual_norms(solution_dim, residual_norms)

end function krylov_convergence_get_iteration_residual_norms
