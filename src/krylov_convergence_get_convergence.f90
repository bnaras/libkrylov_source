function krylov_convergence_get_convergence(convergence) result(status)

    use kinds, only: IK, RK
    use errors, only: OK, NO_ITERATIONS, NOT_CONVERGED, MAX_DIM_REACHED, MAX_ITERATIONS_REACHED, &
                      ILL_CONDITIONED
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(inout) :: convergence
    integer(IK) :: status

    integer(IK) :: num_iterations, max_dim, max_iterations
    real(RK) :: min_gram_rcond, max_residual_norm

    max_dim = convergence%config%get_integer_option('max_dim')
    max_iterations = convergence%config%get_integer_option('max_iterations')
    min_gram_rcond = convergence%config%get_real_option('min_gram_rcond')
    max_residual_norm = convergence%config%get_real_option('max_residual_norm')

    num_iterations = convergence%get_num_iterations()
    if (num_iterations == 0_IK) then
        status = NO_ITERATIONS
        return
    end if

    if (convergence%get_last_gram_rcond() < min_gram_rcond) then
        status = ILL_CONDITIONED
        return
    end if

    if (convergence%get_last_max_residual_norm() > max_residual_norm) then
        if (convergence%get_last_basis_dim() >= max_dim) then
            status = MAX_DIM_REACHED
        elseif (num_iterations >= max_iterations) then
            status = MAX_ITERATIONS_REACHED
        else
            status = NOT_CONVERGED
        end if
    else
        status = OK
    end if

end function krylov_convergence_get_convergence
