program test_real_eigenvalue_equation_get_expectation_vals

    use kinds, only: IK, RK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_vec
    use krylov, only: real_eigenvalue_equation_t
    implicit none

    type(real_eigenvalue_equation_t) :: equation
    type(config_t) :: config
    real(RK) :: eigenvalues(2_IK), expectation_vals(2_IK)
    integer(IK) :: error

    eigenvalues = (/1.0_RK, 2.0_RK/)

    error = config%initialize()
    if (error /= OK) stop 1

    error = equation%initialize(3_IK, 2_IK, 2_IK, config)
    if (error /= OK) stop 1

    equation%eigenvalues = eigenvalues

    error = equation%get_expectation_vals(2_IK, expectation_vals)
    if (error /= OK) stop 1

    if (near_real_vec(expectation_vals) /= eigenvalues) stop 1

end program test_real_eigenvalue_equation_get_expectation_vals
