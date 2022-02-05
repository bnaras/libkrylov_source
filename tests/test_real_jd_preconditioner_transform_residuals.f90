program test_real_jd_preconditioner_transform_residuals

    use kinds, only: IK, RK
    use errors, only: OK, INCOMPLETE_PRECONDITIONER
    use options, only: config_t
    use blaswrapper, only: real_dot
    use testing, only: near_real_num, near_real_mat
    use krylov, only: real_jd_preconditioner_t
    implicit none

    type(real_jd_preconditioner_t) :: preconditioner
    type(config_t) :: config
    real(RK) :: residuals(4_IK, 2_IK), diagonal(4_IK), eigenvalues(2_IK), solutions(4_IK, 2_IK), &
                preconditioned(4_IK, 2_IK), preconditioned_ref(4_IK, 2_IK), dot_product
    integer(IK) :: error, sol1

    residuals = reshape((/1.0_RK, -1.0_RK, -3.0_RK, 3.0_RK, 1.5_RK, -1.5_RK, 0.5_RK, -0.5_RK/), (/4_IK, 2_IK/))
    diagonal = (/2.0_RK, -3.0_RK, 6.0_RK, -1.0_RK/)
    eigenvalues = (/-6.0_RK, 7.0_RK/)
    solutions = reshape((/0.5_RK, 0.5_RK, -0.5_RK, -0.5_RK, 0.5_RK, 0.5_RK, 0.5_RK, 0.5_RK/), (/4_IK, 2_IK/))
    preconditioned_ref = reshape((/0.219101123595506_RK, -0.08239700374531837_RK, -0.312734082397004_RK, 0.449438202247191_RK, &
                                   -0.217543859649123_RK, 0.191228070175439_RK, -0.08771929824561403_RK, 0.114035087719298_RK/), &
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
        dot_product = abs(real_dot(4_IK, residuals(:, sol1), 1_IK, solutions(:, sol1), 1_IK))
        if (dot_product /= near_real_num(0.0_RK)) stop 1
    end do

end program test_real_jd_preconditioner_transform_residuals
