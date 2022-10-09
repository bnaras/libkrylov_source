program test_get_space_convergence

    use kinds, only: IK, RK
    use errors, only: OK, NOT_CONVERGED
    use testing, only: near_real_num, near_real_vec
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_get_space_num_iterations, krylov_get_space_last_basis_dim, &
                      krylov_get_space_last_expectation_vals, &
                      krylov_get_space_last_lagrangian, krylov_get_space_last_residual_norms, &
                      krylov_get_space_last_max_residual_norm, &
                      krylov_get_space_last_gram_rcond, krylov_get_space_convergence, &
                      spaces, iteration_t
    implicit none

    type(iteration_t) :: iteration
    integer(IK) :: error, index, status, num_iterations, last_basis_dim
    real(RK) :: last_max_residual_norm, last_lagrangian, last_gram_rcond
    real(RK) :: residual_norms(2_IK), last_residual_norms(2_IK), expectation_vals(2_IK), &
                last_expectation_vals(2_IK)

    expectation_vals = (/0.0_RK, 1.0_RK/)
    residual_norms = (/1.0E-6_RK, 1.0E-7_RK/)

    error = krylov_initialize()
    if (error /= OK) stop 1

    index = krylov_add_space('r', 's', 'e', 100_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    associate (space => spaces(index)%space_p)
        error = iteration%initialize(3_IK, 2_IK, 1.0E-7_RK, 1.5E-3_RK)
        if (error /= OK) stop 1

        error = iteration%set_expectation_vals(2_IK, expectation_vals)
        if (error /= OK) stop 1

        error = iteration%set_residual_norms(2_IK, residual_norms)
        if (error /= OK) stop 1

        index = space%convergence%add_iteration(iteration)
        if (index /= 1_IK) stop 1

        num_iterations = krylov_get_space_num_iterations(index)
        if (num_iterations /= 1_IK) stop 1

        last_basis_dim = krylov_get_space_last_basis_dim(index)
        if (last_basis_dim /= 3_IK) stop 1

        last_gram_rcond = krylov_get_space_last_gram_rcond(index)
        if (near_real_num(last_gram_rcond) /= 1.0E-7_RK) stop 1

        error = krylov_get_space_last_expectation_vals(index, 2_IK, last_expectation_vals)
        if (near_real_vec(last_expectation_vals) /= expectation_vals) stop 1

        last_lagrangian = krylov_get_space_last_lagrangian(index)
        if (near_real_num(last_lagrangian) /= 1.5E-3_RK) stop 1

        error = krylov_get_space_last_residual_norms(index, 2_IK, last_residual_norms)
        if (near_real_vec(last_residual_norms) /= residual_norms) stop 1

        last_max_residual_norm = krylov_get_space_last_max_residual_norm(index)
        if (near_real_num(last_max_residual_norm) /= 1.0E-6_RK) stop 1

        status = krylov_get_space_convergence(1_IK)
        if (status /= NOT_CONVERGED) stop 1
    end associate

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_convergence
