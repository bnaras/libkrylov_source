function krylov_real_linear_equation_solve_projected(equation, orthonormalizer) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION
    use linalg, only: real_sy_solve_linear
    use krylov, only: real_linear_equation_t, real_orthonormalizer_t
    implicit none

    class(real_linear_equation_t), intent(inout) :: equation
    class(real_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK) :: error

    integer(IK) :: err
    real(RK), allocatable :: transformed_rayleigh(:, :), transformed_basis_rhs(:, :), solutions(:, :)

    if (equation%basis_dim /= orthonormalizer%basis_dim) then
        error = INVALID_DIMENSION
        return
    end if

    allocate (transformed_rayleigh(equation%basis_dim, equation%basis_dim), &
              transformed_basis_rhs(equation%basis_dim, equation%solution_dim), &
              solutions(equation%basis_dim, equation%solution_dim))

    err = orthonormalizer%transform_rayleigh(equation%basis_dim, equation%rayleigh, transformed_rayleigh)
    if (err /= OK) then
        deallocate (transformed_rayleigh, transformed_basis_rhs, solutions)
        error = err
        return
    end if

    err = orthonormalizer%transform_basis_rhs(equation%basis_dim, equation%solution_dim, equation%basis_rhs, &
                                              transformed_basis_rhs)
    if (err /= OK) then
        deallocate (transformed_rayleigh, transformed_basis_rhs, solutions)
        error = err
        return
    end if

    err = real_sy_solve_linear(transformed_rayleigh, transformed_basis_rhs, equation%basis_dim, &
                               equation%solution_dim, solutions)
    if (err /= OK) then
        deallocate (transformed_rayleigh, transformed_basis_rhs, solutions)
        error = err
        return
    end if

    err = orthonormalizer%restore_basis_solutions(equation%basis_dim, equation%solution_dim, &
                                                  solutions, equation%basis_solutions)
    if (err /= OK) then
        deallocate (transformed_rayleigh, transformed_basis_rhs, solutions)
        error = err
        return
    end if

    deallocate (transformed_rayleigh, transformed_basis_rhs, solutions)

    error = OK

end function krylov_real_linear_equation_solve_projected
