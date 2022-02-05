function krylov_complex_shifted_linear_equation_make_residuals(equation) result(error)

    use kinds, only: IK, CK
    use errors, only: OK
    use blaswrapper, only: complex_gemv
    use krylov, only: complex_shifted_linear_equation_t
    implicit none

    class(complex_shifted_linear_equation_t), intent(inout) :: equation
    integer(IK) :: error

    integer(IK) :: sol

    equation%residuals = equation%rhs

    do sol = 1_IK, equation%solution_dim

        call complex_gemv('n', equation%full_dim, equation%basis_dim, (1.0_CK, 0.0_CK), equation%products, &
                          equation%full_dim, equation%basis_solutions(:, sol), 1_IK, (-1.0_CK, 0.0_CK), &
                          equation%residuals(:, sol), 1_IK)

        call complex_gemv('n', equation%full_dim, equation%basis_dim, -cmplx(equation%shifts(sol), 0.0_CK, CK), &
                          equation%vectors, equation%full_dim, equation%basis_solutions(:, sol), 1_IK, &
                          (1.0_CK, 0.0_CK), equation%residuals(:, sol), 1_IK)

    end do

    error = OK

end function krylov_complex_shifted_linear_equation_make_residuals
