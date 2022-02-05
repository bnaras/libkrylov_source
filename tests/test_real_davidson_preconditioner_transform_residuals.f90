program test_real_davidson_preconditioner_transform_residuals

    use kinds, only: IK, RK
    use errors, only: OK, INCOMPLETE_PRECONDITIONER
    use options, only: config_t
    use testing, only: near_real_mat
    use krylov, only: real_davidson_preconditioner_t
    implicit none

    type(real_davidson_preconditioner_t) :: preconditioner
    type(config_t) :: config
    real(RK) :: residuals(4_IK, 2_IK), diagonal(4_IK), eigenvalues(2_IK), &
                preconditioned(4_IK, 2_IK), preconditioned_ref(4_IK, 2_IK)
    integer(IK) :: error

    residuals = reshape((/1.0_RK, -1.0_RK, -3.0_RK, 3.0_RK, 1.5_RK, -1.5_RK, 0.5_RK, -0.5_RK/), (/4_IK, 2_IK/))
    diagonal = (/2.0_RK, -3.0_RK, 6.0_RK, -1.0_RK/)
    eigenvalues = (/-6.0_RK, 7.0_RK/)
    preconditioned_ref = reshape((/0.125_RK, -0.333333333333333_RK, -0.25_RK, 0.6_RK, -0.3_RK, 0.15_RK, -0.5_RK, 0.0625_RK/), &
                                 (/4_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = config%set_real_option('min_diagonal_scaling', 1.0E-6_RK)
    if (error /= OK) stop 1

    error = preconditioner%initialize(4_IK, 2_IK, config)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= INCOMPLETE_PRECONDITIONER) stop 1

    error = preconditioner%set_diagonal(4_IK, diagonal)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= INCOMPLETE_PRECONDITIONER) stop 1

    error = preconditioner%set_eigenvalues(2_IK, eigenvalues)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%transform_residuals(4_IK, 2_IK, residuals, preconditioned)
    if (error /= OK) stop 1

    if (preconditioned /= near_real_mat(preconditioned_ref)) stop 1

end program test_real_davidson_preconditioner_transform_residuals
