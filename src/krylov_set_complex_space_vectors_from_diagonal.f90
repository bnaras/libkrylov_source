function krylov_set_complex_space_vectors_from_diagonal(index, full_dim, basis_dim, diagonal) result(error)

    use kinds, only: IK, RK, CK
    use errors, only: OK, INVALID_DIMENSION, NO_SUCH_SPACE, INCOMPLETE_CONFIGURATION, &
                      INCOMPATIBLE_EQUATION, INCOMPATIBLE_SPACE, LINEARLY_DEPENDENT_BASIS
    use krylov, only: complex_space_t, complex_eigenvalue_equation_t, complex_linear_equation_t, &
                      complex_shifted_linear_equation_t, spaces, krylov_get_num_spaces
    use linalg, only: complex_ge_block_orthonormalize
    use utils, only: real_argsort
    implicit none

    integer(IK), intent(in) :: index, full_dim, basis_dim
    real(RK), intent(in) :: diagonal(full_dim)
    integer(IK) :: error

    integer(IK), allocatable :: indices(:)
    integer(IK) :: err, ful, bas, new_dim
    real(RK) :: thr_zero, min_diag, diag
    complex(CK) :: dum(1_IK, 1_IK)

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
        type is (complex_space_t)
            select type (equation => space%equation)
            type is (complex_eigenvalue_equation_t)
                allocate (indices(full_dim))
                err = real_argsort(diagonal, full_dim, indices)
                if (err /= OK) then
                    error = err
                    deallocate (indices)
                    return
                end if

                do bas = 1_IK, basis_dim
                    equation%vectors(indices(bas), bas) = (1.0_CK, 0.0_CK)
                end do
                deallocate (indices)
            type is (complex_linear_equation_t)
                if (equation%config%find_option('min_diagonal_scaling') /= OK) then
                    error = INCOMPLETE_CONFIGURATION
                    return
                end if

                min_diag = equation%config%get_real_option('min_diagonal_scaling')

                do bas = 1_IK, basis_dim
                    do ful = 1_IK, full_dim
                        diag = diagonal(ful)
                        if (abs(diag) < min_diag) diag = sign(min_diag, diag)
                        equation%vectors(ful, bas) = equation%rhs(ful, bas) / diag
                    end do
                end do

                if (equation%config%find_option('min_basis_vector_norm') /= OK) then
                    error = INCOMPLETE_CONFIGURATION
                    return
                end if

                thr_zero = equation%config%get_real_option('min_basis_vector_norm')

                err = complex_ge_block_orthonormalize(equation%vectors, dum, full_dim, basis_dim, 0_IK, thr_zero, new_dim)
                if (err /= OK) then
                    error = err
                    return
                end if
                if (new_dim /= full_dim) then
                    error = LINEARLY_DEPENDENT_BASIS
                    return
                end if
            type is (complex_shifted_linear_equation_t)
                if (equation%config%find_option('min_diagonal_scaling') /= OK) then
                    error = INCOMPLETE_CONFIGURATION
                    return
                end if

                min_diag = equation%config%get_real_option('min_diagonal_scaling')

                do bas = 1_IK, basis_dim
                    do ful = 1_IK, full_dim
                        diag = diagonal(ful) - equation%shifts(bas)
                        if (abs(diag) < min_diag) diag = sign(min_diag, diag)
                        equation%vectors(ful, bas) = equation%rhs(ful, bas) / diag
                    end do
                end do

                if (equation%config%find_option('min_basis_vector_norm') /= OK) then
                    error = INCOMPLETE_CONFIGURATION
                    return
                end if

                thr_zero = equation%config%get_real_option('min_basis_vector_norm')

                err = complex_ge_block_orthonormalize(equation%vectors, dum, full_dim, basis_dim, 0_IK, thr_zero, new_dim)
                if (err /= OK) then
                    error = err
                    return
                end if
                if (new_dim /= full_dim) then
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

end function krylov_set_complex_space_vectors_from_diagonal
