function krylov_convergence_get_active(convergence, active_dim, active) result(error)

    use kinds, only: IK
    use errors, only: OK, INVALID_DIMENSION, NO_ITERATIONS, NOT_CONVERGED
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(inout) :: convergence
    integer(IK), intent(in) :: active_dim
    integer(IK), intent(out) :: active(active_dim)
    integer(IK) :: error

    integer(IK) :: sol, index, num_iterations

    num_iterations = convergence%get_num_iterations()

    if (num_iterations == 0_IK) then
        error = NO_ITERATIONS
        return
    end if

    if (active_dim <= 0_IK) then
        error = INVALID_DIMENSION
        return
    end if

    index = 0_IK
    do sol = 1_IK, convergence%solution_dim
        if (convergence%get_solution_convergence(sol) == NOT_CONVERGED) then
            index = index + 1_IK
            if (index > active_dim) then
                error = INVALID_DIMENSION
                return
            end if
            active(index) = sol
        end if
    end do

    error = OK

end function krylov_convergence_get_active
