function krylov_convergence_get_solution_convergence(convergence, index) result(status)

    use kinds, only: IK, RK
    use errors, only: OK, NO_ITERATIONS, NO_SUCH_SOLUTION, NOT_CONVERGED, INCOMPLETE_CONFIGURATION
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(inout) :: convergence
    integer(IK), intent(in) :: index
    integer(IK) :: status

    integer(IK) :: num_iterations, err
    real(RK) :: max_residual_norm
    real(RK), allocatable :: residual_norms(:)

    num_iterations = convergence%get_num_iterations()

    if (num_iterations == 0_IK) then
        status = NO_ITERATIONS
        return
    end if

    if (index > convergence%solution_dim) then
        status = NO_SUCH_SOLUTION
        return
    end if

    if (convergence%config%find_option('max_residual_norm') /= OK) then
        status = INCOMPLETE_CONFIGURATION
        return
    end if

    max_residual_norm = convergence%config%get_real_option('max_residual_norm')

    allocate (residual_norms(convergence%solution_dim))

    err = convergence%iterations(num_iterations)%get_residual_norms(convergence%solution_dim, residual_norms)
    if (err /= OK) then
        status = err
        deallocate (residual_norms)
        return
    end if

    if (residual_norms(index) > max_residual_norm) then
        status = NOT_CONVERGED
    else
        status = OK
    end if

    deallocate (residual_norms)

end function krylov_convergence_get_solution_convergence
