function krylov_complex_linear_equation_make_residuals(equation) result(error)

    use kinds, only: IK, CK
    use errors, only: OK
    use blaswrapper, only: complex_gemm
    use krylov, only: complex_linear_equation_t
    implicit none

    class(complex_linear_equation_t), intent(inout) :: equation
    integer(IK) :: error

    equation%residuals = equation%rhs

    call complex_gemm('n', 'n', equation%full_dim, equation%solution_dim, equation%basis_dim, &
                      (1.0_CK, 0.0_CK), equation%products, equation%full_dim, equation%basis_solutions, &
                      equation%basis_dim, (-1.0_CK, 0.0_CK), equation%residuals, equation%full_dim)

    error = OK

end function krylov_complex_linear_equation_make_residuals
