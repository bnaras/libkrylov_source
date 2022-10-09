function krylov_complex_sylvester_equation_get_expectation_vals(equation, solution_dim, expectation_vals) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: complex_sylvester_equation_t
    implicit none

    class(complex_sylvester_equation_t), intent(inout) :: equation
    integer(IK), intent(in) :: solution_dim
    real(RK), intent(out) :: expectation_vals(solution_dim)
    integer(IK) :: error

    ! TODO
    expectation_vals = 0.0_RK
    error = OK

end function krylov_complex_sylvester_equation_get_expectation_vals
