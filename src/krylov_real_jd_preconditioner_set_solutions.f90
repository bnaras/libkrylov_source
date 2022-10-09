function krylov_real_jd_preconditioner_set_solutions(preconditioner, full_dim, solution_dim, solutions) result(error)

    use kinds, only: IK, RK, LK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: real_jd_preconditioner_t
    implicit none

    class(real_jd_preconditioner_t), intent(inout) :: preconditioner
    integer(IK), intent(in) :: full_dim, solution_dim
    real(RK), intent(in) :: solutions(full_dim, solution_dim)
    integer(IK) :: error

    integer(IK) :: err

    if (full_dim /= preconditioner%full_dim) then
        error = INVALID_DIMENSION
        return
    end if

    if (solution_dim /= preconditioner%solution_dim) then
        error = INVALID_DIMENSION
        return
    end if

    preconditioner%solutions = solutions

    err = preconditioner%config%set_logical_option('has_solutions', .true._LK)
    if (err /= OK) then
        error = err
        return
    end if

    error = OK

end function krylov_real_jd_preconditioner_set_solutions
