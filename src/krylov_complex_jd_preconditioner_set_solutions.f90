function krylov_complex_jd_preconditioner_set_solutions(preconditioner, full_dim, solution_dim, solutions) result(error)

    use kinds, only: IK, CK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: complex_jd_preconditioner_t
    implicit none

    class(complex_jd_preconditioner_t), intent(inout) :: preconditioner
    integer(IK), intent(in) :: full_dim, solution_dim
    complex(CK), intent(in) :: solutions(full_dim, solution_dim)
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

    err = preconditioner%config%set_logical_option('has_solutions', .true.)
    if (err /= OK) then
        error = err
        return
    end if

    error = OK

end function krylov_complex_jd_preconditioner_set_solutions
