program test_complex_eigenvalue_equation_solve_projected

    use kinds, only: IK, RK, CK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_vec, near_complex_mat
    use krylov, only: complex_eigenvalue_equation_t, complex_ortho_orthonormalizer_t
    implicit none

    type(complex_eigenvalue_equation_t) :: equation
    type(complex_ortho_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    complex(CK) ::  vectors(3_IK, 2_IK), rayleigh(2_IK, 2_IK), basis_solutions(2_IK, 1_IK)
    real(RK) :: eigenvalues(1_IK)
    integer(IK) :: error

    vectors = reshape((/(1.0_CK, 0.1_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                        (1.0_CK, 0.1_CK), (0.0_CK, 0.0_CK)/), (/3_IK, 2_IK/))
    rayleigh = reshape((/(0.0_CK, 0.0_CK), (1.0_CK, 0.1_CK), (1.0_CK, -0.1_CK), (0.0_CK, 0.0_CK)/), &
                       (/2_IK, 2_IK/))
    eigenvalues = (/-1.004987562112089_RK/)
    basis_solutions = reshape((/(-0.707106781186548_CK, 0.0_CK), (0.703597544730292_CK, 0.070359754473029_CK)/), &
                              (/2_IK, 1_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = equation%initialize(3_IK, 1_IK, 2_IK, config)
    if (error /= OK) stop 1

    error = orthonormalizer%initialize(config)
    if (error /= OK) stop 1

    error = orthonormalizer%prepare_transform(3_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    equation%rayleigh = rayleigh

    error = equation%solve_projected(orthonormalizer)
    if (error /= OK) stop 1

    if (equation%eigenvalues /= near_real_vec(eigenvalues)) stop 1
    if (equation%basis_solutions /= near_complex_mat(basis_solutions, fix_phase=.true.)) stop 1

end program test_complex_eigenvalue_equation_solve_projected
