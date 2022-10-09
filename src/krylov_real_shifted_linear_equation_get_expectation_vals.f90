function krylov_real_shifted_linear_equation_get_expectation_vals(equation, solution_dim, expectation_vals) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use blaswrapper, only: real_dot
    use krylov, only: real_shifted_linear_equation_t
    implicit none

    class(real_shifted_linear_equation_t), intent(inout) :: equation
    integer(IK), intent(in) :: solution_dim
    real(RK), intent(out) :: expectation_vals(solution_dim)
    integer(IK) :: error

    integer(IK) :: sol

    do sol = 1_IK, solution_dim
        expectation_vals(sol) = -real_dot(equation%basis_dim, equation%basis_rhs(:, sol), 1_IK, &
                                          equation%basis_solutions(:, sol), 1_IK)
    end do

    error = OK

end function krylov_real_shifted_linear_equation_get_expectation_vals
