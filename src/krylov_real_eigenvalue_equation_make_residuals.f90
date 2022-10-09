function krylov_real_eigenvalue_equation_make_residuals(equation) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use blaswrapper, only: real_gemm
    use krylov, only: real_eigenvalue_equation_t
    implicit none

    class(real_eigenvalue_equation_t), intent(inout) :: equation
    integer(IK) :: error

    integer(IK) :: sol

    do sol = 1_IK, equation%solution_dim
        equation%residuals(:, sol) = -equation%solutions(:, sol)*equation%eigenvalues(sol)
    end do

    call real_gemm('n', 'n', equation%full_dim, equation%solution_dim, equation%basis_dim, &
                   1.0_RK, equation%products, equation%full_dim, equation%basis_solutions, equation%basis_dim, &
                   1.0_RK, equation%residuals, equation%full_dim)

    error = OK

end function krylov_real_eigenvalue_equation_make_residuals
