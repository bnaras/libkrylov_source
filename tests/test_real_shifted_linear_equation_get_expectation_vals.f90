program test_real_shifted_linear_equation_get_expectation_vals

    use kinds, only: IK, RK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_vec
    use krylov, only: real_shifted_linear_equation_t
    implicit none

    type(real_shifted_linear_equation_t) :: equation
    type(config_t) :: config
    real(RK) :: basis_solutions(2_IK, 2_IK), basis_rhs(2_IK, 2_IK), expectation_vals(2_IK), &
                expectation_vals_ref(2_IK)
    integer(IK) :: error

    basis_solutions = reshape((/0.5_RK, 0.5_RK, 0.5_RK, 0.5_RK/), (/2_IK, 2_IK/))
    basis_rhs = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 1.0_RK/), (/2_IK, 2_IK/))
    expectation_vals_ref = (/-0.5_RK, -0.5_RK/)

    error = config%initialize()
    if (error /= OK) stop 1

    error = equation%initialize(3_IK, 2_IK, 2_IK, config)
    if (error /= OK) stop 1

    equation%basis_solutions = basis_solutions
    equation%basis_rhs = basis_rhs

    error = equation%get_expectation_vals(2_IK, expectation_vals)
    if (error /= OK) stop 1

    if (expectation_vals /= near_real_vec(expectation_vals_ref)) stop 1

end program test_real_shifted_linear_equation_get_expectation_vals
