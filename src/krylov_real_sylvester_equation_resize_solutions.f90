function krylov_real_sylvester_equation_resize_solutions(equation, solution_dim) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: real_sylvester_equation_t
    implicit none

    class(real_sylvester_equation_t), intent(inout) :: equation
    integer(IK), intent(in) :: solution_dim
    integer(IK) :: error

    real(RK), allocatable :: solutions_tmp(:, :), residuals_tmp(:, :), rhs_tmp(:, :), &
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

        solutions_tmp = 0.0_RK
        residuals_tmp = 0.0_RK
        rhs_tmp = 0.0_RK
        sylvester_b_tmp = 0.0_RK
        basis_solutions_tmp = 0.0_RK
        basis_rhs_tmp = 0.0_RK

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

        equation%solutions = 0.0_RK
        equation%residuals = 0.0_RK
        equation%rhs = 0.0_RK
        equation%sylvester_b = 0.0_RK
        equation%basis_solutions = 0.0_RK
        equation%basis_rhs = 0.0_RK

    end if

    equation%solution_dim = solution_dim

    error = OK

end function krylov_real_sylvester_equation_resize_solutions
