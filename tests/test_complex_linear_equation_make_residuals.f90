program test_complex_linear_equation_make_residuals

    use kinds, only: IK, CK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_complex_mat
    use krylov, only: complex_linear_equation_t
    implicit none

    type(complex_linear_equation_t) :: equation
    type(config_t) :: config
    complex(CK) :: products(3_IK, 2_IK), basis_solutions(2_IK, 2_IK), rhs(3_IK, 2_IK), &
                   residuals(3_IK, 2_IK)
    integer(IK) :: error

    products = reshape((/(1.0_CK, 0.1_CK), (1.0_CK, 0.1_CK), (0.0_CK, 0.0_CK), (1.0_CK, 0.1_CK), &
                         (-1.0_CK, -0.1_CK), (0.0_CK, 0.0_CK)/), (/3_IK, 2_IK/))
    rhs = reshape((/(1.0_CK, 0.1_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                    (1.0_CK, 0.1_CK), (0.0_CK, 0.0_CK)/), (/3_IK, 2_IK/))
    basis_solutions = reshape((/(2.0_CK, 0.1_CK), (1.0_CK, 0.1_CK), (1.0_CK, 0.1_CK), &
                                (-2.0_CK, -0.1_CK)/), (/2_IK, 2_IK/))
    residuals = reshape((/(1.98_CK, 0.4_CK), (1.0_CK, 0.1_CK), (0.0_CK, 0.0_CK), (-1.0_CK, -0.1_CK), &
                          (1.98_CK, 0.4_CK), (0.0_CK, 0.0_CK)/), (/3_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = equation%initialize(3_IK, 2_IK, 2_IK, config)
    if (error /= OK) stop 1

    equation%products = products
    equation%basis_solutions = basis_solutions
    equation%rhs = rhs

    error = equation%make_residuals()
    if (error /= OK) stop 1

    if (equation%residuals /= near_complex_mat(residuals)) stop 1

end program test_complex_linear_equation_make_residuals
