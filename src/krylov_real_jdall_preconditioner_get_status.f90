function krylov_real_jdall_preconditioner_get_status(preconditioner) result(status)

    use kinds, only: IK
    use errors, only: OK, INCOMPLETE_CONFIGURATION, INCOMPLETE_PRECONDITIONER
    use krylov, only: real_jdall_preconditioner_t
    implicit none

    class(real_jdall_preconditioner_t), intent(inout) :: preconditioner
    integer(IK) :: status

    if (preconditioner%config%find_option('has_diagonal') /= OK) then
        status = INCOMPLETE_CONFIGURATION
        return
    end if

    if (preconditioner%config%find_option('has_eigenvalues') /= OK) then
        status = INCOMPLETE_CONFIGURATION
        return
    end if

    if (preconditioner%config%find_option('has_solutions') /= OK) then
        status = INCOMPLETE_CONFIGURATION
        return
    end if

    if (preconditioner%config%get_logical_option('has_diagonal') .and. &
        preconditioner%config%get_logical_option('has_eigenvalues') .and. &
        preconditioner%config%get_logical_option('has_solutions')) then
        status = OK
    else
        status = INCOMPLETE_PRECONDITIONER
    end if

end function krylov_real_jdall_preconditioner_get_status
