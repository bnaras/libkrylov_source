function krylov_complex_davidson_preconditioner_get_status(preconditioner) result(status)

    use kinds, only: IK
    use errors, only: OK, INCOMPLETE_CONFIGURATION, INCOMPLETE_PRECONDITIONER
    use krylov, only: complex_davidson_preconditioner_t
    implicit none

    class(complex_davidson_preconditioner_t), intent(inout) :: preconditioner
    integer(IK) :: status

    if (preconditioner%config%find_option('has_diagonal') /= OK) then
        status = INCOMPLETE_CONFIGURATION
        return
    end if

    if (preconditioner%config%find_option('has_eigenvalues') /= OK) then
        status = INCOMPLETE_CONFIGURATION
        return
    end if

    if (preconditioner%config%find_option('has_shifts') /= OK) then
        status = INCOMPLETE_CONFIGURATION
        return
    end if

    if (preconditioner%config%get_logical_option('has_diagonal')) then
        status = OK
    else
        status = INCOMPLETE_PRECONDITIONER
    end if

end function krylov_complex_davidson_preconditioner_get_status
