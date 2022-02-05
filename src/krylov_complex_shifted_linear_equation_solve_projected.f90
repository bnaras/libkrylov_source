function krylov_complex_shifted_linear_equation_solve_projected(equation, orthonormalizer) result(error)

    use kinds, only: IK, CK
    use errors, only: OK, INVALID_DIMENSION
    use linalg, only: complex_he_solve_linear
    use krylov, only: complex_shifted_linear_equation_t, complex_orthonormalizer_t
    implicit none

    class(complex_shifted_linear_equation_t), intent(inout) :: equation
    class(complex_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK) :: error
    
    integer(IK) :: err, sol, vec
    complex(CK), allocatable :: shifted(:, :), transformed(:, :), solution(:)

    if (equation%basis_dim /= orthonormalizer%basis_dim) then
        error = INVALID_DIMENSION
        return
    end if

    allocate (shifted(equation%basis_dim, equation%basis_dim), &
              transformed(equation%basis_dim, equation%basis_dim), &
              solution(equation%basis_dim))

    do sol = 1_IK, equation%solution_dim

        shifted = equation%rayleigh
        do vec = 1_IK, equation%basis_dim
            shifted(vec, vec) = shifted(vec, vec) - equation%shifts(sol)
        end do

        err = orthonormalizer%transform_rayleigh(equation%basis_dim, shifted, transformed)
        if (err /= OK) then
            deallocate (shifted, transformed, solution)
            error = err
            return
        end if

        err = complex_he_solve_linear(transformed, equation%basis_rhs(:, sol), equation%basis_dim, &
                                      1_IK, solution)
        if (err /= OK) then
            deallocate (shifted, transformed, solution)
            error = err
            return
        end if

        err = orthonormalizer%restore_basis_solutions(equation%basis_dim, 1_IK, solution, &
                                                      equation%basis_solutions(:, sol))
        if (err /= OK) then
            deallocate (shifted, transformed, solution)
            error = err
            return
        end if

    end do

    deallocate (shifted, transformed, solution)

    error = OK

end function krylov_complex_shifted_linear_equation_solve_projected
