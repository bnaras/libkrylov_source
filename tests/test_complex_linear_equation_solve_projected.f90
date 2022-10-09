program test_complex_linear_equation_solve_projected

    use kinds, only: IK, RK, CK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_complex_mat
    use krylov, only: complex_linear_equation_t, complex_ortho_orthonormalizer_t
    use linalg, only: complex_he_solve_linear
    implicit none

    type(complex_linear_equation_t) :: equation
    type(complex_ortho_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    complex(CK) :: vectors(4_IK, 2_IK), rayleigh(2_IK, 2_IK), basis_rhs(2_IK, 2_IK), &
                   basis_solutions(2_IK, 2_IK)
    integer(IK) :: error

    vectors = reshape((/(0.4_CK, 0.3_CK), (0.4_CK, 0.3_CK), (-0.4_CK, -0.3_CK), (-0.4_CK, -0.3_CK), &
                        (0.4_CK, 0.3_CK), (0.4_CK, 0.3_CK), (0.4_CK, 0.3_CK), (0.4_CK, 0.3_CK)/), (/4_IK, 2_IK/))
    rayleigh = reshape((/(1.0_CK, 0.0_CK), (2.0_CK, -1.0_CK), (2.0_CK, 1.0_CK), (3.0_CK, 0.0_CK)/), (/2_IK, 2_IK/))
    basis_rhs = reshape((/(0.1_CK, 0.1_CK), (0.1_CK, -0.1_CK), (0.1_CK, 0.1_CK), (0.1_CK, -0.3_CK)/), (/2_IK, 2_IK/))
    basis_solutions = reshape((/(0.0_CK, -0.2_CK), (0.1_CK, 0.1_CK), (0.1_CK, -0.4_CK), (0.1_CK, 0.2_CK)/), (/2_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = equation%initialize(4_IK, 2_IK, 2_IK, config)
    if (error /= OK) stop 1

    error = orthonormalizer%initialize(config)
    if (error /= OK) stop 1

    error = orthonormalizer%prepare_transform(4_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    equation%rayleigh = rayleigh
    equation%basis_rhs = basis_rhs

    error = equation%solve_projected(orthonormalizer)
    if (error /= OK) stop 1

    if (equation%basis_solutions /= near_complex_mat(basis_solutions, thr=1.0E-12_RK)) stop 1

end program test_complex_linear_equation_solve_projected
