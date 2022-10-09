function krylov_real_eigenvalue_equation_get_expectation_vals(equation, solution_dim, expectation_vals) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: real_eigenvalue_equation_t
    implicit none

    class(real_eigenvalue_equation_t), intent(inout) :: equation
    integer(IK), intent(in) :: solution_dim
    real(RK), intent(out) :: expectation_vals(solution_dim)
    integer(IK) :: error

    expectation_vals = equation%eigenvalues

    error = OK

end function krylov_real_eigenvalue_equation_get_expectation_vals
