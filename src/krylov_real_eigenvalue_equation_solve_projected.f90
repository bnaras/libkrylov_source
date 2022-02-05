function krylov_real_eigenvalue_equation_solve_projected(equation, orthonormalizer) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION
    use linalg, only: real_sy_diagonalize
    use krylov, only: real_eigenvalue_equation_t, real_orthonormalizer_t
    implicit none

    class(real_eigenvalue_equation_t), intent(inout) :: equation
    class(real_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK) :: error

    integer(IK) :: err
    real(RK), allocatable :: transformed(:, :), eig(:), eigv(:, :)

    if (equation%basis_dim /= orthonormalizer%basis_dim) then
        error = INVALID_DIMENSION
        return
    end if

    allocate (transformed(equation%basis_dim, equation%basis_dim), eig(equation%basis_dim), &
              eigv(equation%basis_dim, equation%basis_dim))

    err = orthonormalizer%transform_rayleigh(equation%basis_dim, equation%rayleigh, transformed)
    if (err /= OK) then
        error = err
        deallocate (transformed, eig, eigv)
        return
    end if

    err = real_sy_diagonalize(transformed, equation%basis_dim, eig, eigv)
    if (err /= OK) then
        error = err
        deallocate (transformed, eig, eigv)
        return
    end if

    equation%eigenvalues = eig(1_IK:equation%solution_dim)

    err = orthonormalizer%restore_basis_solutions(equation%basis_dim, equation%solution_dim, &
                                                  eigv(:, 1_IK:equation%solution_dim), equation%basis_solutions)
    if (err /= OK) then
        error = err
        deallocate (transformed, eig, eigv)
        return
    end if

    deallocate (transformed, eig, eigv)

    error = OK

end function krylov_real_eigenvalue_equation_solve_projected
