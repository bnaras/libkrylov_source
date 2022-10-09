function krylov_complex_jdall_preconditioner_set_eigenvalues(preconditioner, solution_dim, eigenvalues) result(error)

    use kinds, only: IK, RK, LK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: complex_jdall_preconditioner_t
    implicit none

    class(complex_jdall_preconditioner_t), intent(inout) :: preconditioner
    integer(IK), intent(in) :: solution_dim
    real(RK), intent(in) :: eigenvalues(solution_dim)
    integer(IK) :: error

    integer(IK) :: err

    if (solution_dim /= preconditioner%solution_dim) then
        error = INVALID_DIMENSION
        return
    end if

    preconditioner%eigenvalues = eigenvalues

    err = preconditioner%config%set_logical_option('has_eigenvalues', .true._LK)
    if (err /= OK) then
        error = err
        return
    end if

    error = OK

end function krylov_complex_jdall_preconditioner_set_eigenvalues
