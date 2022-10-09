function krylov_set_real_space_vectors_from_diagonal(index, full_dim, basis_dim, diagonal) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION, NO_SUCH_SPACE, INCOMPLETE_CONFIGURATION, &
                      INCOMPATIBLE_EQUATION, INCOMPATIBLE_SPACE, LINEARLY_DEPENDENT_BASIS
    use krylov, only: real_space_t, real_eigenvalue_equation_t, real_linear_equation_t, &
                      real_shifted_linear_equation_t, spaces, krylov_get_num_spaces
    use linalg, only: real_ge_orthonormalize
    use utils, only: real_argsort
    implicit none

    integer(IK), intent(in) :: index, full_dim, basis_dim
    real(RK), intent(in) :: diagonal(full_dim)
    integer(IK) :: error

    integer(IK), allocatable :: indices(:)
    integer(IK) :: err, ful, bas, new_dim
    real(RK) :: thr_zero, min_diag, diag

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        return
    end if

    if (basis_dim > full_dim) then
        error = INVALID_DIMENSION
        return
    end if

    associate (space => spaces(index)%space_p)
        if (space%full_dim /= full_dim) then
            error = INVALID_DIMENSION
            return
        end if

        select type (space)
        type is (real_space_t)
            select type (equation => space%equation)
            type is (real_eigenvalue_equation_t)
                allocate (indices(full_dim))
                err = real_argsort(diagonal, full_dim, indices)
                if (err /= OK) then
                    error = err
                    deallocate (indices)
                    return
                end if

                equation%vectors = 0.0_RK
                do bas = 1_IK, basis_dim
                    equation%vectors(indices(bas), bas) = 1.0_RK
                end do
                deallocate (indices)
            type is (real_linear_equation_t)
                if (basis_dim > equation%solution_dim) then
                    error = INVALID_DIMENSION
                    return
                end if

                if (equation%config%find_option('min_diagonal_scaling') /= OK) then
                    error = INCOMPLETE_CONFIGURATION
                    return
                end if

                min_diag = equation%config%get_real_option('min_diagonal_scaling')

                equation%vectors = 0.0_RK
                do bas = 1_IK, basis_dim
                    do ful = 1_IK, full_dim
                        diag = diagonal(ful)
                        if (abs(diag) < min_diag) diag = sign(min_diag, diag)
                        equation%vectors(ful, bas) = equation%rhs(ful, bas)/diag
                    end do
                end do

                if (equation%config%find_option('min_basis_vector_norm') /= OK) then
                    error = INCOMPLETE_CONFIGURATION
                    return
                end if

                thr_zero = equation%config%get_real_option('min_basis_vector_norm')

                err = real_ge_orthonormalize(equation%vectors, full_dim, basis_dim, thr_zero, new_dim)
                if (err /= OK) then
                    error = err
                    return
                end if
                if (new_dim /= basis_dim) then
                    error = LINEARLY_DEPENDENT_BASIS
                    return
                end if
            type is (real_shifted_linear_equation_t)
                if (basis_dim > equation%solution_dim) then
                    error = INVALID_DIMENSION
                    return
                end if

                if (equation%config%find_option('min_diagonal_scaling') /= OK) then
                    error = INCOMPLETE_CONFIGURATION
                    return
                end if

                min_diag = equation%config%get_real_option('min_diagonal_scaling')

                equation%vectors = 0.0_RK
                do bas = 1_IK, basis_dim
                    do ful = 1_IK, full_dim
                        diag = diagonal(ful) - equation%shifts(bas)
                        if (abs(diag) < min_diag) diag = sign(min_diag, diag)
                        equation%vectors(ful, bas) = equation%rhs(ful, bas)/diag
                    end do
                end do

                if (equation%config%find_option('min_basis_vector_norm') /= OK) then
                    error = INCOMPLETE_CONFIGURATION
                    return
                end if

                thr_zero = equation%config%get_real_option('min_basis_vector_norm')

                err = real_ge_orthonormalize(equation%vectors, full_dim, basis_dim, thr_zero, new_dim)
                if (err /= OK) then
                    error = err
                    return
                end if
                if (new_dim /= basis_dim) then
                    error = LINEARLY_DEPENDENT_BASIS
                    return
                end if
            class default
                error = INCOMPATIBLE_EQUATION
                return
            end select
        class default
            error = INCOMPATIBLE_SPACE
            return
        end select
    end associate

    error = OK

end function krylov_set_real_space_vectors_from_diagonal
