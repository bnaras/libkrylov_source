program test_get_space_convergence

    use kinds, only: IK, RK
    use errors, only: OK, NOT_CONVERGED
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_get_space_convergence, spaces, iteration_t
    implicit none

    type(iteration_t) :: iteration
    integer(IK) :: error, index, status

    error = krylov_initialize()
    if (error /= OK) stop 1

    index = krylov_add_space('r', 's', 'e', 100_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    associate (space => spaces(index)%space_p)
        error = iteration%initialize(3_IK, 2_IK, 1.0E-7_RK, 1.5E-3_RK)
        if (error /= OK) stop 1
        error = iteration%set_residual_norms(2_IK, (/1.0E-6_RK, 1.0E-7_RK/))
        if (error /= OK) stop 1
        index = space%convergence%add_iteration(iteration)
        if (index /= 1_IK) stop 1

        status = krylov_get_space_convergence(1_IK)
        if (status /= NOT_CONVERGED) stop 1
    end associate

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_convergence
