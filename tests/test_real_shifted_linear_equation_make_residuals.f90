program test_real_shifted_linear_equation_make_residuals

    use kinds, only: IK, RK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_mat
    use krylov, only: real_shifted_linear_equation_t
    implicit none

    type(real_shifted_linear_equation_t) :: equation
    type(config_t) :: config
    real(RK) :: vectors(3_IK, 2_IK), products(3_IK, 2_IK), shifts(2_IK), basis_solutions(2_IK, 2_IK), &
                rhs(3_IK, 2_IK), residuals(3_IK, 2_IK)
    integer(IK) :: error

    vectors = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 1.0_RK, 0.0_RK/), (/3_IK, 2_IK/))
    products = reshape((/1.0_RK, 1.0_RK, 1.0_RK, 1.0_RK, -1.0_RK, 1.0_RK/), (/3_IK, 2_IK/))
    shifts = (/1.0_RK, -1.0_RK/)
    rhs = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 1.0_RK, 0.0_RK/), (/3_IK, 2_IK/))
    basis_solutions = reshape((/2.0_RK, 1.0_RK, 1.0_RK, -2.0_RK/), (/2_IK, 2_IK/))
    residuals = reshape((/0.0_RK, 0.0_RK, 3.0_RK, 0.0_RK, 0.0_RK, -1.0_RK/), (/3_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = equation%initialize(3_IK, 2_IK, 2_IK, config)
    if (error /= OK) stop 1

    equation%vectors = vectors
    equation%products = products
    equation%shifts = shifts
    equation%basis_solutions = basis_solutions
    equation%rhs = rhs

    error = equation%make_residuals()
    if (error /= OK) stop 1

    if (equation%residuals /= near_real_mat(residuals)) stop 1

end program test_real_shifted_linear_equation_make_residuals
