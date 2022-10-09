function krylov_complex_davidson_preconditioner_set_shifts(preconditioner, solution_dim, shifts) result(error)

    use kinds, only: IK, RK, LK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: complex_davidson_preconditioner_t
    implicit none

    class(complex_davidson_preconditioner_t), intent(inout) :: preconditioner
    integer(IK), intent(in) :: solution_dim
    real(RK), intent(in) :: shifts(solution_dim)
    integer(IK) :: error

    integer(IK) :: err

    if (solution_dim /= preconditioner%solution_dim) then
        error = INVALID_DIMENSION
        return
    end if

    preconditioner%shifts = shifts

    err = preconditioner%config%set_logical_option('has_shifts', .true._LK)
    if (err /= OK) then
        error = err
        return
    end if

    error = OK

end function krylov_complex_davidson_preconditioner_set_shifts