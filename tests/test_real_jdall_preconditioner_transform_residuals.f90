program test_real_jdall_preconditioner_transform_residuals

    use kinds, only: IK, RK
    use errors, only: OK, INCOMPLETE_PRECONDITIONER
    use options, only: config_t
    use blaswrapper, only: real_dot
    use testing, only: near_real_mat, near_real_num
    use krylov, only: real_jdall_preconditioner_t
    implicit none

    type(real_jdall_preconditioner_t) :: preconditioner
    type(config_t) :: config
    real(RK) :: residuals(4_IK, 2_IK), eigenvalues(2_IK), diagonal(4_IK), solutions(4_IK, 2_IK), &
                preconditioned(4_IK, 2_IK), preconditioned_ref(4_IK, 2_IK), dot_product
    integer(IK) :: error, sol1, sol2

    residuals = reshape((/1.0_RK, -1.0_RK, -3.0_RK, 3.0_RK, 1.5_RK, -1.5_RK, 0.5_RK, -0.5_RK/), (/4_IK, 2_IK/))
    diagonal = (/2.0_RK, -3.0_RK, 6.0_RK, -1.0_RK/)
    eigenvalues = (/-6.0_RK, 7.0_RK/)
    solutions = reshape((/0.5_RK, 0.5_RK, -0.5_RK, -0.5_RK, 0.5_RK, 0.5_RK, 0.5_RK, 0.5_RK/), (/4_IK, 2_IK/))
    preconditioned_ref = reshape((/0.161868424095271_RK, -0.161868424095271_RK, -0.465892010637068_RK, 0.465892010637068_RK, &
                                   -0.211272979535206_RK, 0.211272979535206_RK, -0.100589663544918_RK, 0.100589663544918_RK/), &
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

    if (preconditioner%get_status() /= INCOMPLETE_PRECONDITIONER) stop 1

    error = preconditioner%set_solutions(4_IK, 2_IK, solutions)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%transform_residuals(4_IK, 2_IK, residuals, preconditioned)
    if (error /= OK) stop 1

    if (preconditioned /= near_real_mat(preconditioned_ref)) stop 1

    do sol1 = 1_IK, 2_IK
        do sol2 = 1_IK, 2_IK
            dot_product = abs(real_dot(4_IK, residuals(:, sol1), 1_IK, solutions(:, sol2), 1_IK))
            if (dot_product /= near_real_num(0.0_RK)) stop 1
        end do
    end do

    do sol1 = 1_IK, 2_IK
        do sol2 = 1_IK, 2_IK
            dot_product = abs(real_dot(4_IK, preconditioned(:, sol1), 1_IK, solutions(:, sol2), 1_IK))
            if (dot_product /= near_real_num(0.0_RK)) stop 1
        end do
    end do

end program test_real_jdall_preconditioner_transform_residuals
