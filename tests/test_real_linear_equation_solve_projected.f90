program test_real_linear_equation_solve_projected

    use kinds, only: IK, RK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_mat
    use krylov, only: real_linear_equation_t, real_ortho_orthonormalizer_t
    implicit none

    type(real_linear_equation_t) :: equation
    type(real_ortho_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    real(RK) :: vectors(3_IK, 2_IK), rayleigh(2_IK, 2_IK), basis_rhs(2_IK, 2_IK), &
                basis_solutions(2_IK, 2_IK)
    integer(IK) :: error

    vectors = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 1.0_RK, 0.0_RK/), (/3_IK, 2_IK/))
    rayleigh = reshape((/1.0_RK, 1.0_RK, 1.0_RK, -1.0_RK/), (/2_IK, 2_IK/))
    basis_rhs = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 1.0_RK/), (/2_IK, 2_IK/))
    basis_solutions = reshape((/0.5_RK, 0.5_RK, 0.5_RK, -0.5_RK/), (/2_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = equation%initialize(3_IK, 2_IK, 2_IK, config)
    if (error /= OK) stop 1

    error = orthonormalizer%initialize(config)
    if (error /= OK) stop 1

    error = orthonormalizer%prepare_transform(3_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    equation%rayleigh = rayleigh
    equation%basis_rhs = basis_rhs

    error = equation%solve_projected(orthonormalizer)
    if (error /= OK) stop 1

    if (equation%basis_solutions /= near_real_mat(basis_solutions)) stop 1

end program test_real_linear_equation_solve_projected
