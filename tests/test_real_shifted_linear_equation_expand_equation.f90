program test_real_shifted_linear_equation_expand_equation

    use kinds, only: IK, RK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_mat
    use krylov, only: real_shifted_linear_equation_t
    implicit none

    type(real_shifted_linear_equation_t) :: equation
    type(config_t) :: config
    real(RK) :: vectors(3_IK, 2_IK), products(3_IK, 2_IK), rhs(3_IK, 2_IK), rayleigh(2_IK, 2_IK), &
                basis_rhs(2_IK, 2_IK)
    integer(IK) :: error

    vectors = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 1.0_RK, 0.0_RK/), (/3_IK, 2_IK/))
    products = reshape((/1.0_RK, 1.0_RK, 0.0_RK, 1.0_RK, -1.0_RK, 0.0_RK/), (/3_IK, 2_IK/))
    rhs = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 1.0_RK, 0.0_RK/), (/3_IK, 2_IK/))
    rayleigh = reshape((/1.0_RK, 1.0_RK, 1.0_RK, -1.0_RK/), (/2_IK, 2_IK/))
    basis_rhs = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 1.0_RK/), (/2_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = equation%initialize(3_IK, 2_IK, 2_IK, config)
    if (error /= OK) stop 1

    equation%vectors = vectors
    equation%products = products
    equation%rhs = rhs

    error = equation%expand_equation()
    if (error /= OK) stop 1

    if (equation%rayleigh /= near_real_mat(rayleigh)) stop 1
    if (equation%basis_rhs /= near_real_mat(basis_rhs)) stop 1

end program test_real_shifted_linear_equation_expand_equation
