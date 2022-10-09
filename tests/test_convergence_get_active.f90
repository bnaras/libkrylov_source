program test_convergence_get_active

    use kinds, only: IK, RK
    use errors, only: OK, NO_ITERATIONS
    use options, only: config_t
    use krylov, only: convergence_t, iteration_t
    implicit none

    type(convergence_t) :: convergence
    type(iteration_t) :: iteration
    type(config_t) :: config
    integer(IK) :: error, active_dim, index
    real(RK) :: residual_norms(2_IK)
    integer(IK) :: active(1_IK)

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
    error = convergence%initialize(2_IK, config)
    if (error /= OK) stop 1

    active_dim = convergence%get_active_dim()
    if (active_dim /= 0_IK) stop 1

    error = convergence%get_active(active_dim, active)
    if (error /= NO_ITERATIONS) stop 1

    error = iteration%initialize(3_IK, 2_IK, 1.0E-10_RK, 1.0E-3_RK)
    if (error /= OK) stop 1
    residual_norms = (/1.0E-4_RK, 1.0E-8_RK/)
    error = iteration%set_residual_norms(2_IK, residual_norms)
    if (error /= OK) stop 1
    index = convergence%add_iteration(iteration)
    if (index /= 1_IK) stop 1

    active_dim = convergence%get_active_dim()
    if (active_dim /= 1_IK) stop 1

    error = convergence%get_active(active_dim, active)
    if (error /= OK) stop 1

    if (active(1_IK) /= 1_IK) stop 1

end program test_convergence_get_active
