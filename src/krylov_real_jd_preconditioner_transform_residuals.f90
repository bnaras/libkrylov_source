function krylov_real_jd_preconditioner_transform_residuals( &
    preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION, INCOMPLETE_CONFIGURATION, INCOMPLETE_PRECONDITIONER
    use krylov, only: real_jd_preconditioner_t
    implicit none

    class(real_jd_preconditioner_t), intent(inout) :: preconditioner
    integer(IK), intent(in) :: full_dim, solution_dim
    real(RK), intent(in) :: residuals(full_dim, solution_dim)
    real(RK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
    integer(IK) :: error

    integer(IK) :: ful, sol1
    real(RK) :: numerator, denom, diag, min_diag

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
        numerator = 0.0_RK
        denom = 0.0_RK
        do ful = 1_IK, full_dim
            diag = preconditioner%diagonal(ful) - preconditioner%eigenvalues(sol1)
            if (abs(diag) < min_diag) diag = sign(min_diag, diag)
            numerator = numerator + preconditioner%solutions(ful, sol1) * residuals(ful, sol1) / diag
            denom = denom + preconditioner%solutions(ful, sol1) * preconditioner%solutions(ful, sol1) / diag
        end do
        do ful = 1_IK, full_dim
            diag = preconditioner%diagonal(ful) - preconditioner%eigenvalues(sol1)
            if (abs(diag) < min_diag) diag = sign(min_diag, diag)
            preconditioned_residuals(ful, sol1) = (residuals(ful, sol1) - preconditioner%solutions(ful, sol1) * &
                                                   (numerator / denom)) / diag
        end do
    end do

    error = OK

end function krylov_real_jd_preconditioner_transform_residuals
