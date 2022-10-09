program test_convergence_get_convergence_status

    use kinds, only: IK, RK
    use errors, only: OK, NO_ITERATIONS, NOT_CONVERGED, MAX_ITERATIONS_REACHED, ILL_CONDITIONED
    use options, only: config_t
    use testing, only: near_real_num, near_real_vec
    use krylov, only: convergence_t, iteration_t
    implicit none

    type(convergence_t) :: conv, conv1, conv2
    type(config_t) :: config, config1, config2
    type(iteration_t) :: iteration
    integer(IK) :: error, index, status, num_iterations
    real(RK) ::  expectation_vals(1_IK), residual_norms(1_IK)

    ! Initialize configuration options
    error = config%initialize()
    if (error /= OK) stop 1

    error = config%set_integer_option('max_dim', 10_IK)
    if (error /= OK) stop 1
    error = config%set_integer_option('max_iterations', 4_IK)
    if (error /= OK) stop 1
    error = config%set_real_option('min_gram_rcond', 1.0E-12_RK)
    if (error /= OK) stop 1
    error = config%set_real_option('max_residual_norm', 1.0E-5_RK)
    if (error /= OK) stop 1

    ! Initialize convergence object
    error = conv%initialize(1_IK, config)
    if (error /= OK) stop 1

    ! No iterations
    num_iterations = conv%get_num_iterations()
    if (num_iterations /= 0_IK) stop 1

    status = conv%get_convergence()
    if (status /= NO_ITERATIONS) stop 1

    ! Add first iteration, no convergence
    error = iteration%initialize(1_IK, 1_IK, 1.0E-6_RK, 2.0E-3_RK)
    if (error /= OK) stop 1
    error = iteration%set_expectation_vals(1_IK, (/2.0E-3_RK/))
    if (error /= OK) stop 1
    error = iteration%set_residual_norms(1_IK, (/1.0E-2_RK/))
    if (error /= OK) stop 1
    index = conv%add_iteration(iteration)
    if (index /= 1_IK) stop 1

    status = conv%get_convergence()
    if (status /= NOT_CONVERGED) stop 1

    ! Add second iteration, convergence
    error = iteration%initialize(2_IK, 1_IK, 1.0E-7_RK, 1.5E-3_RK)
    if (error /= OK) stop 1
    error = iteration%set_expectation_vals(1_IK, (/1.5E-3_RK/))
    if (error /= OK) stop 1
    error = iteration%set_residual_norms(1_IK, (/1.0E-6_RK/))
    if (error /= OK) stop 1
    index = conv%add_iteration(iteration)
    if (index /= 2_IK) stop 1

    status = conv%get_convergence()
    if (status /= OK) stop 1

    ! Get iteration data
    if (conv%get_iteration_basis_dim(1_IK) /= 1_IK) stop 1
    if (conv%get_iteration_gram_rcond(1_IK) /= near_real_num(1.0E-6_RK)) stop 1
    if (conv%get_iteration_lagrangian(1_IK) /= near_real_num(2.0E-3_RK)) stop 1
    if (conv%get_iteration_max_residual_norm(1_IK) /= near_real_num(1.0E-2_RK)) stop 1

    error = conv%get_iteration_expectation_vals(1_IK, 1_IK, expectation_vals)
    if (error /= OK) stop 1
    if (expectation_vals /= near_real_vec((/2.0E-3_RK/))) stop 1

    error = conv%get_iteration_residual_norms(1_IK, 1_IK, residual_norms)
    if (error /= OK) stop 1
    if (residual_norms /= near_real_vec((/1.0E-2_RK/))) stop 1

    ! Get last iteration data
    if (conv%get_last_basis_dim() /= 2_IK) stop 1
    if (conv%get_last_gram_rcond() /= near_real_num(1.0E-7_RK)) stop 1
    if (conv%get_last_lagrangian() /= near_real_num(1.5E-3_RK)) stop 1
    if (conv%get_last_max_residual_norm() /= near_real_num(1.0E-6_RK)) stop 1

    error = conv%get_last_expectation_vals(1_IK, expectation_vals)
    if (error /= OK) stop 1
    if (expectation_vals /= near_real_vec((/1.5E-3_RK/))) stop 1

    error = conv%get_last_residual_norms(1_IK, residual_norms)
    if (error /= OK) stop 1
    if (residual_norms /= near_real_vec((/1.0E-6_RK/))) stop 1

    ! Initialize configuration options
    error = config1%initialize()
    if (error /= OK) stop 1

    error = config1%set_integer_option('max_dim', 12_IK)
    if (error /= OK) stop 1
    error = config1%set_integer_option('max_iterations', 2_IK)
    if (error /= OK) stop 1
    error = config1%set_real_option('min_gram_rcond', 1.0E-12_RK)
    if (error /= OK) stop 1
    error = config1%set_real_option('max_residual_norm', 1.0E-5_RK)
    if (error /= OK) stop 1

    ! Initialize convergence object
    error = conv1%initialize(1_IK, config1)
    if (error /= OK) stop 1

    ! No iterations
    num_iterations = conv1%get_num_iterations()
    if (num_iterations /= 0_IK) stop 1

    status = conv1%get_convergence()
    if (status /= NO_ITERATIONS) stop 1

    ! Add first iteration, no convergence
    error = iteration%initialize(2_IK, 1_IK, 1.0E-6_RK, 2.0E-3_RK)
    if (error /= OK) stop 1
    error = iteration%set_expectation_vals(1_IK, (/2.0E-3_RK/))
    if (error /= OK) stop 1
    error = iteration%set_residual_norms(1_IK, (/1.0E-2_RK/))
    if (error /= OK) stop 1
    index = conv1%add_iteration(iteration)
    if (index /= 1_IK) stop 1

    status = conv1%get_convergence()
    if (status /= NOT_CONVERGED) stop 1

    ! Add second iteration, no convergence
    error = iteration%initialize(4_IK, 1_IK, 1.0E-7_RK, 1.5E-3_RK)
    if (error /= OK) stop 1
    error = iteration%set_expectation_vals(1_IK, (/1.5E-3_RK/))
    if (error /= OK) stop 1
    error = iteration%set_residual_norms(1_IK, (/1.0E-4_RK/))
    if (error /= OK) stop 1
    index = conv1%add_iteration(iteration)
    if (index /= 2_IK) stop 1

    status = conv1%get_convergence()
    if (status /= MAX_ITERATIONS_REACHED) stop 1

    ! Initialize configuration options
    error = config2%initialize()
    if (error /= OK) stop 1

    error = config2%set_integer_option('max_dim', 100_IK)
    if (error /= OK) stop 1
    error = config2%set_integer_option('max_iterations', 2_IK)
    if (error /= OK) stop 1
    error = config2%set_real_option('min_gram_rcond', 1.0E-12_RK)
    if (error /= OK) stop 1
    error = config2%set_real_option('max_residual_norm', 1.0E-5_RK)
    if (error /= OK) stop 1

    ! Initialize convergence object
    error = conv2%initialize(1_IK, config2)
    if (error /= OK) stop 1

    ! No iterations
    num_iterations = conv2%get_num_iterations()
    if (num_iterations /= 0_IK) stop 1

    status = conv2%get_convergence()
    if (status /= NO_ITERATIONS) stop 1

    ! Add first iteration, no convergence
    error = iteration%initialize(1_IK, 1_IK, 1.0E-6_RK, 2.0E-3_RK)
    if (error /= OK) stop 1
    error = iteration%set_expectation_vals(1_IK, (/2.0E-3_RK/))
    if (error /= OK) stop 1
    error = iteration%set_residual_norms(1_IK, (/1.0E-2_RK/))
    if (error /= OK) stop 1
    index = conv2%add_iteration(iteration)
    if (index /= 1_IK) stop 1

    status = conv2%get_convergence()
    if (status /= NOT_CONVERGED) stop 1

    ! Add second iteration, ill conditioned
    error = iteration%initialize(2_IK, 1_IK, 1.0E-14_RK, 1.5E-3_RK)
    if (error /= OK) stop 1
    error = iteration%set_expectation_vals(1_IK, (/1.5E-3_RK/))
    if (error /= OK) stop 1
    error = iteration%set_residual_norms(1_IK, (/1.0E-4_RK/))
    if (error /= OK) stop 1
    index = conv2%add_iteration(iteration)
    if (index /= 2_IK) stop 1

    status = conv2%get_convergence()
    if (status /= ILL_CONDITIONED) stop 1

end program test_convergence_get_convergence_status
