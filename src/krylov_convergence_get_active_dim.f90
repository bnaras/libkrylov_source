function krylov_convergence_get_active_dim(convergence) result(active_dim)

    use kinds, only: IK
    use errors, only: NOT_CONVERGED
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(inout) :: convergence
    integer(IK) :: active_dim

    integer(IK) :: sol, num_iterations

    num_iterations = convergence%get_num_iterations()

    if (num_iterations == 0_IK) then
        active_dim = 0_IK
        return
    end if

    active_dim = 0_IK
    do sol = 1_IK, convergence%solution_dim
        if (convergence%get_solution_convergence(sol) == NOT_CONVERGED) active_dim = active_dim + 1_IK
    end do

end function krylov_convergence_get_active_dim
