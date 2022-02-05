program test_real_eigenvalue_equation_make_residuals

    use kinds, only: IK, RK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_mat
    use krylov, only: real_eigenvalue_equation_t
    implicit none

    type(real_eigenvalue_equation_t) :: equation
    type(config_t) :: config
    real(RK) :: products(3_IK, 2_IK), basis_solutions(2_IK, 1_IK), solutions(3_IK, 1_IK), &
                eigenvalues(1_IK), residuals(3_IK, 1_IK)
    integer(IK) :: error

    products = reshape((/2.0_RK, 1.0_RK, 3.0_RK, 2.0_RK, -1.0_RK, -3.0_RK/), (/3_IK, 2_IK/))
    basis_solutions = reshape((/sqrt(0.5_RK), -sqrt(0.5_RK)/), (/2_IK, 1_IK/))
    solutions = reshape((/sqrt(0.5_RK), -sqrt(0.5_RK), 0.0_RK/), (/3_IK, 1_IK/))
    eigenvalues = (/1.0_RK/)
    residuals = reshape((/-sqrt(0.5_RK), sqrt(4.5_RK), sqrt(18.0_RK)/), (/3_IK, 1_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = equation%initialize(3_IK, 1_IK, 2_IK, config)
    if (error /= OK) stop 1

    equation%products = products
    equation%solutions = solutions
    equation%basis_solutions = basis_solutions
    equation%eigenvalues = eigenvalues

    error = equation%make_residuals()
    if (error /= OK) stop 1

    if (equation%residuals /= near_real_mat(residuals)) stop 1

end program test_real_eigenvalue_equation_make_residuals
