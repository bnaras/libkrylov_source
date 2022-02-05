function krylov_complex_sylvester_equation_resize_solutions(equation, solution_dim) result(error)

    use kinds, only: IK, CK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: complex_sylvester_equation_t
    implicit none

    class(complex_sylvester_equation_t), intent(inout) :: equation
    integer(IK), intent(in) :: solution_dim
    integer(IK) :: error

    complex(CK), allocatable :: solutions_tmp(:, :), residuals_tmp(:, :), rhs_tmp(:, :), &
                                sylvester_b_tmp(:, :), basis_solutions_tmp(:, :), basis_rhs_tmp(:, :)

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
                  rhs_tmp(1_IK:equation%full_dim, solution_dim), &
                  sylvester_b_tmp(solution_dim, solution_dim), &
                  basis_solutions_tmp(1_IK:equation%basis_dim, solution_dim), &
                  basis_rhs_tmp(1_IK:equation%basis_dim, solution_dim))

        solutions_tmp = (0.0_CK, 0.0_CK)
        residuals_tmp = (0.0_CK, 0.0_CK)
        rhs_tmp = (0.0_CK, 0.0_CK)
        sylvester_b_tmp = (0.0_CK, 0.0_CK)
        basis_solutions_tmp = (0.0_CK, 0.0_CK)
        basis_rhs_tmp = (0.0_CK, 0.0_CK)

        solutions_tmp(:, 1_IK:equation%solution_dim) = equation%solutions
        residuals_tmp(:, 1_IK:equation%solution_dim) = equation%residuals
        rhs_tmp(:, 1_IK:equation%solution_dim) = equation%rhs
        sylvester_b_tmp(1_IK:equation%solution_dim, 1_IK:equation%solution_dim) = equation%sylvester_b
        basis_solutions_tmp(:, 1_IK:equation%solution_dim) = equation%basis_solutions
        basis_rhs_tmp(:, 1_IK:equation%solution_dim) = equation%basis_rhs

        call move_alloc(solutions_tmp, equation%solutions)
        call move_alloc(residuals_tmp, equation%residuals)
        call move_alloc(rhs_tmp, equation%rhs)
        call move_alloc(sylvester_b_tmp, equation%sylvester_b)
        call move_alloc(basis_solutions_tmp, equation%basis_solutions)
        call move_alloc(basis_rhs_tmp, equation%basis_rhs)

    else

        deallocate (equation%solutions, equation%residuals, equation%rhs, &
                    equation%sylvester_b, equation%basis_solutions, equation%basis_rhs)

        allocate (equation%solutions(equation%full_dim, solution_dim), &
                  equation%residuals(equation%full_dim, solution_dim), &
                  equation%rhs(equation%full_dim, solution_dim), &
                  equation%sylvester_b(equation%solution_dim, equation%solution_dim), &
                  equation%basis_solutions(equation%basis_dim, solution_dim), &
                  equation%basis_rhs(equation%basis_dim, solution_dim))

        equation%solutions = (0.0_CK, 0.0_CK)
        equation%residuals = (0.0_CK, 0.0_CK)
        equation%rhs = (0.0_CK, 0.0_CK)
        equation%sylvester_b = (0.0_CK, 0.0_CK)
        equation%basis_solutions = (0.0_CK, 0.0_CK)
        equation%basis_rhs = (0.0_CK, 0.0_CK)

    end if

    equation%solution_dim = solution_dim

    error = OK

end function krylov_complex_sylvester_equation_resize_solutions
