program test_get_real_block_convergence

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_SPACE, NOT_CONVERGED
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_get_real_block_convergence, spaces, iteration_t
    implicit none

    integer(IK) :: error, index, status
    real(RK) :: residual_norms(2_IK)
    type(iteration_t) :: iteration

    error = krylov_initialize()
    if (error /= OK) stop 1

    index = krylov_add_space('r', 's', 'e', 100_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    index = krylov_add_space('r', 's', 'e', 100_IK, 2_IK, 3_IK)
    if (index /= 2_IK) stop 1

    status = krylov_get_real_block_convergence()
    if (status /= NOT_CONVERGED) stop 1

    associate (space => spaces(1_IK)%space_p)
        error = iteration%initialize(3_IK, 2_IK, 1.0E-10_RK, 1.0E-3_RK)
        if (error /= OK) stop 1
        residual_norms = (/1.0E-8_RK, 1.0E-8_RK/)
        error = iteration%set_residual_norms(2_IK, residual_norms)
        if (error /= OK) stop 1
        index = space%convergence%add_iteration(iteration)
        if (index /= 1_IK) stop 1
    end associate
    status = krylov_get_real_block_convergence()
    if (status /= NOT_CONVERGED) stop 1

    associate (space => spaces(2_IK)%space_p)
        error = iteration%initialize(3_IK, 2_IK, 1.0E-10_RK, 1.0E-3_RK)
        if (error /= OK) stop 1
        residual_norms = (/1.0E-8_RK, 1.0E-8_RK/)
        error = iteration%set_residual_norms(2_IK, residual_norms)
        if (error /= OK) stop 1
        index = space%convergence%add_iteration(iteration)
        if (index /= 1_IK) stop 1
    end associate
    status = krylov_get_real_block_convergence()
    if (status /= OK) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_real_block_convergence
