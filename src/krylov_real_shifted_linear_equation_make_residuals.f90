function krylov_real_shifted_linear_equation_make_residuals(equation) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use blaswrapper, only: real_gemv
    use krylov, only: real_shifted_linear_equation_t
    implicit none

    class(real_shifted_linear_equation_t), intent(inout) :: equation
    integer(IK) :: error

    integer(IK) :: sol

    equation%residuals = equation%rhs

    do sol = 1_IK, equation%solution_dim

        call real_gemv('n', equation%full_dim, equation%basis_dim, 1.0_RK, equation%products, &
                       equation%full_dim, equation%basis_solutions(:, sol), 1_IK, &
                       -1.0_RK, equation%residuals(:, sol), 1_IK)

        call real_gemv('n', equation%full_dim, equation%basis_dim, -equation%shifts(sol), &
                       equation%vectors, equation%full_dim, equation%basis_solutions(:, sol), 1_IK, &
                       1.0_RK, equation%residuals(:, sol), 1_IK)

    end do

    error = OK

end function krylov_real_shifted_linear_equation_make_residuals
