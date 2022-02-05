function krylov_real_jdall_preconditioner_transform_residuals( &
    preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)

    use kinds, only: IK, RK
    use lapackwrapper, only: real_gesv
    use errors, only: OK, INVALID_DIMENSION, INCOMPLETE_CONFIGURATION, INCOMPLETE_PRECONDITIONER, &
                      LINEAR_ALGEBRA_ERROR
    use krylov, only: real_jdall_preconditioner_t
    implicit none

    class(real_jdall_preconditioner_t), intent(inout) :: preconditioner
    integer(IK), intent(in) :: full_dim, solution_dim
    real(RK), intent(in) :: residuals(full_dim, solution_dim)
    real(RK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
    integer(IK) :: error

    integer(IK) :: info, ful, sol1, sol2
    real(RK) :: tmp1, tmp2, diag, min_diag
    real(RK), allocatable :: eps(:, :), denom(:, :)
    integer(IK), allocatable :: ipiv(:)

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

    allocate (eps(solution_dim, solution_dim), denom(solution_dim, solution_dim))

    eps = 0.0_RK
    denom = 0.0_RK
    do sol1 = 1, solution_dim
        do ful = 1, full_dim
            diag = preconditioner%diagonal(ful) - preconditioner%eigenvalues(sol1)
            if (abs(diag) < min_diag) diag = sign(min_diag, diag)
            tmp1 = preconditioner%solutions(ful, sol1) / diag
            tmp2 = residuals(ful, sol1) / diag
            do sol2 = 1, solution_dim
                eps(sol2, sol1) = eps(sol2, sol1) + preconditioner%solutions(ful, sol2) * tmp2
                denom(sol2, sol1) = denom(sol2, sol1) + preconditioner%solutions(ful, sol2) * tmp1
            end do
        end do
    end do

    allocate (ipiv(solution_dim))
    info = 0_IK
    call real_gesv(solution_dim, solution_dim, denom, solution_dim, ipiv, eps, solution_dim, info)
    if (info /= 0_IK) then
        error = LINEAR_ALGEBRA_ERROR
        deallocate (eps, denom, ipiv)
        return
    end if
    deallocate (ipiv)

    ! Solution on eps now
    do sol1 = 1, solution_dim
        do ful = 1, full_dim
            diag = preconditioner%diagonal(ful) - preconditioner%eigenvalues(sol1)
            if (abs(diag) < min_diag) diag = sign(min_diag, diag)
            preconditioned_residuals(ful, sol1) = residuals(ful, sol1) / diag
            do sol2 = 1, solution_dim
                diag = preconditioner%diagonal(ful) - preconditioner%eigenvalues(sol2)
                if (abs(diag) < min_diag) diag = sign(min_diag, diag)
                preconditioned_residuals(ful, sol1) = preconditioned_residuals(ful, sol1) - &
                                                      eps(sol2, sol1) * preconditioner%solutions(ful, sol2) / diag
            end do
        end do
    end do

    deallocate (eps, denom)

    error = OK

end function krylov_real_jdall_preconditioner_transform_residuals
