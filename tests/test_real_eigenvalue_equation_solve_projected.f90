program test_real_eigenvalue_equation_solve_projected

    use kinds, only: IK, RK, LK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_vec, near_real_mat
    use krylov, only: real_eigenvalue_equation_t, real_ortho_orthonormalizer_t
    implicit none

    type(real_eigenvalue_equation_t) :: equation
    type(real_ortho_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    real(RK) ::  vectors(3_IK, 2_IK), rayleigh(2_IK, 2_IK), eigenvalues(1_IK), &
                basis_solutions(2_IK, 1_IK)
    integer(IK) :: error

    vectors = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 1.0_RK, 0.0_RK/), (/3_IK, 2_IK/))
    rayleigh = reshape((/0.0_RK, 1.0_RK, 1.0_RK, 0.0_RK/), (/2_IK, 2_IK/))
    eigenvalues = (/-1.0_RK/)
    basis_solutions = reshape((/-sqrt(0.5_RK), sqrt(0.5_RK)/), (/2_IK, 1_IK/))

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
    if (equation%basis_solutions /= near_real_mat(basis_solutions, fix_phase=.true._LK)) stop 1

end program test_real_eigenvalue_equation_solve_projected
