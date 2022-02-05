function krylov_complex_null_preconditioner_transform_residuals( &
    preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: complex_null_preconditioner_t
    implicit none

    class(complex_null_preconditioner_t), intent(inout) :: preconditioner
    integer(IK), intent(in) :: full_dim, solution_dim
    complex(RK), intent(in) :: residuals(full_dim, solution_dim)
    complex(RK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
    integer(IK) :: error

    if (full_dim /= preconditioner%full_dim) then
        error = INVALID_DIMENSION
        return
    end if

    if (solution_dim /= preconditioner%solution_dim) then
        error = INVALID_DIMENSION
        return
    end if

    preconditioned_residuals = residuals

    error = OK

end function krylov_complex_null_preconditioner_transform_residuals
