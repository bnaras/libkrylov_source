function krylov_complex_eigenvalue_equation_resize_solutions(equation, solution_dim) result(error)

    use kinds, only: IK, RK, CK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: complex_eigenvalue_equation_t
    implicit none

    class(complex_eigenvalue_equation_t), intent(inout) :: equation
    integer(IK), intent(in) :: solution_dim
    integer(IK) :: error

    real(RK), allocatable :: eigenvalues_tmp(:)
    complex(CK), allocatable :: solutions_tmp(:, :), residuals_tmp(:, :), basis_solutions_tmp(:, :)

    ! Nothing to do
    if (solution_dim == equation%solution_dim) then
        error = OK
        return
    end if

    if (solution_dim > equation%full_dim) then
        error = INVALID_DIMENSION
        return
    end if

    if (solution_dim > equation%solution_dim) then

        allocate (solutions_tmp(1_IK:equation%full_dim, solution_dim), &
                  residuals_tmp(1_IK:equation%full_dim, solution_dim), &
                  eigenvalues_tmp(solution_dim), &
                  basis_solutions_tmp(1_IK:equation%basis_dim, solution_dim))

        solutions_tmp = (0.0_CK, 0.0_CK)
        residuals_tmp = (0.0_CK, 0.0_CK)
        eigenvalues_tmp = 0.0_RK
        basis_solutions_tmp = (0.0_CK, 0.0_CK)

        solutions_tmp(:, 1_IK:equation%solution_dim) = equation%solutions
        residuals_tmp(:, 1_IK:equation%solution_dim) = equation%residuals
        eigenvalues_tmp(1_IK:equation%solution_dim) = equation%eigenvalues
        basis_solutions_tmp(:, 1_IK:equation%solution_dim) = equation%basis_solutions

        call move_alloc(solutions_tmp, equation%solutions)
        call move_alloc(residuals_tmp, equation%residuals)
        call move_alloc(eigenvalues_tmp, equation%eigenvalues)
        call move_alloc(basis_solutions_tmp, equation%basis_solutions)

    else

        deallocate (equation%solutions, equation%residuals, equation%eigenvalues, &
                    equation%basis_solutions)

        allocate (equation%solutions(equation%full_dim, solution_dim), &
                  equation%residuals(equation%full_dim, solution_dim), &
                  equation%eigenvalues(solution_dim), &
                  equation%basis_solutions(equation%basis_dim, solution_dim))

        equation%solutions = (0.0_CK, 0.0_CK)
        equation%residuals = (0.0_CK, 0.0_CK)
        equation%eigenvalues = 0.0_RK
        equation%basis_solutions = (0.0_CK, 0.0_CK)

    end if

    equation%solution_dim = solution_dim

    error = OK

end function krylov_complex_eigenvalue_equation_resize_solutions
