function krylov_complex_jd_preconditioner_transform_residuals( &
    preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)

    use kinds, only: IK, RK, CK
    use errors, only: OK, INVALID_DIMENSION, INCOMPLETE_CONFIGURATION, INCOMPLETE_PRECONDITIONER
    use krylov, only: complex_jd_preconditioner_t
    implicit none

    class(complex_jd_preconditioner_t), intent(inout) :: preconditioner
    integer(IK), intent(in) :: full_dim, solution_dim
    complex(CK), intent(in) :: residuals(full_dim, solution_dim)
    complex(CK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
    integer(IK) :: error

    integer(IK) :: ful, sol1
    real(RK) :: diag, min_diag
    complex(CK) :: numerator, denom

    if (full_dim /= preconditioner%full_dim) then
        error = INVALID_DIMENSION
        return
    end if

    if (solution_dim /= preconditioner%solution_dim) then
        error = INVALID_DIMENSION
        return
    end if

    if (preconditioner%get_status() /= OK) then
        error = INCOMPLETE_PRECONDITIONER
        return
    end if

    if (preconditioner%config%find_option('min_diagonal_scaling') /= OK) then
        error = INCOMPLETE_CONFIGURATION
        return
    end if

    min_diag = preconditioner%config%get_real_option('min_diagonal_scaling')

    do sol1 = 1_IK, solution_dim
        numerator = (0.0_CK, 0.0_CK)
        denom = (0.0_CK, 0.0_CK)
        do ful = 1_IK, full_dim
            diag = preconditioner%diagonal(ful) - preconditioner%eigenvalues(sol1)
            if (abs(diag) < min_diag) diag = sign(min_diag, diag)
            numerator = numerator + conjg(preconditioner%solutions(ful, sol1)) * residuals(ful, sol1) / diag
            denom = denom + conjg(preconditioner%solutions(ful, sol1)) * preconditioner%solutions(ful, sol1) / diag
        end do

        do ful = 1_IK, full_dim
            diag = preconditioner%diagonal(ful) - preconditioner%eigenvalues(sol1)
            if (abs(diag) < min_diag) diag = sign(min_diag, diag)
            preconditioned_residuals(ful, sol1) = (residuals(ful, sol1) - preconditioner%solutions(ful, sol1) * &
                                                   (numerator / denom)) / diag
        end do
    end do

    error = OK

end function krylov_complex_jd_preconditioner_transform_residuals
