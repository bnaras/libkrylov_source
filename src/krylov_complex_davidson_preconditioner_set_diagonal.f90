function krylov_complex_davidson_preconditioner_set_diagonal(preconditioner, full_dim, diagonal) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: complex_davidson_preconditioner_t
    implicit none

    class(complex_davidson_preconditioner_t), intent(inout) :: preconditioner
    integer(IK), intent(in) :: full_dim
    real(RK), intent(in) :: diagonal(full_dim)
    integer(IK) :: error

    integer(IK) :: err

    if (full_dim /= preconditioner%full_dim) then
        error = INVALID_DIMENSION
        return
    end if

    preconditioner%diagonal = diagonal

    err = preconditioner%config%set_logical_option('has_diagonal', .true.)
    if (err /= OK) then
        error = err
        return
    end if

    error = OK

end function krylov_complex_davidson_preconditioner_set_diagonal
