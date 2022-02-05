program test_complex_shifted_linear_equation_expand_equation

    use kinds, only: IK, CK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_complex_mat
    use krylov, only: complex_shifted_linear_equation_t
    implicit none

    type(complex_shifted_linear_equation_t) :: equation
    type(config_t) :: config
    complex(CK) :: vectors(3_IK, 2_IK), products(3_IK, 2_IK), rhs(3_IK, 2_IK), rayleigh(2_IK, 2_IK), &
                   basis_rhs(2_IK, 2_IK)
    integer(IK) :: error

    vectors = reshape((/(1.0_CK, 0.1_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                        (1.0_CK, 0.1_CK), (0.0_CK, 0.0_CK)/), (/3_IK, 2_IK/))
    products = reshape((/(1.0_CK, 0.1_CK), (1.0_CK, 0.1_CK), (0.0_CK, 0.0_CK), (1.0_CK, 0.1_CK), &
                         (-1.0_CK, -0.1_CK), (0.0_CK, 0.0_CK)/), (/3_IK, 2_IK/))
    rhs = reshape((/(1.0_CK, 0.1_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                    (1.0_CK, 0.1_CK), (0.0_CK, 0.0_CK)/), (/3_IK, 2_IK/))
    rayleigh = reshape((/(1.01_CK, 0.0_CK), (1.01_CK, 0.0_CK), (1.01_CK, 0.0_CK), (-1.01_CK, 0.0_CK)/), (/2_IK, 2_IK/))
    basis_rhs = reshape((/(1.01_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (1.01_CK, 0.0_CK)/), (/2_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = equation%initialize(3_IK, 2_IK, 2_IK, config)
    if (error /= OK) stop 1

    equation%vectors = vectors
    equation%products = products
    equation%rhs = rhs

    error = equation%expand_equation()
    if (error /= OK) stop 1

    if (equation%rayleigh /= near_complex_mat(rayleigh)) stop 1
    if (equation%basis_rhs /= near_complex_mat(basis_rhs)) stop 1

end program test_complex_shifted_linear_equation_expand_equation
