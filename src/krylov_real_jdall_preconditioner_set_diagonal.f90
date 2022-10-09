function krylov_real_jdall_preconditioner_set_diagonal(preconditioner, full_dim, diagonal) result(error)

    use kinds, only: IK, RK, LK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: real_jdall_preconditioner_t
    implicit none

    class(real_jdall_preconditioner_t), intent(inout) :: preconditioner
    integer(IK), intent(in) :: full_dim
    real(RK), intent(in) :: diagonal(full_dim)
    integer(IK) :: error

    integer(IK) :: err

    if (full_dim /= preconditioner%full_dim) then
        error = INVALID_DIMENSION
        return
    end if

    preconditioner%diagonal = diagonal

    err = preconditioner%config%set_logical_option('has_diagonal', .true._LK)
    if (err /= OK) then
        error = err
        return
    end if

    error = OK

end function krylov_real_jdall_preconditioner_set_diagonal
