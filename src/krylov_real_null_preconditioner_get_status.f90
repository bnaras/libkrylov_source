function krylov_real_null_preconditioner_get_status(preconditioner) result(status)

    use kinds, only: IK
    use errors, only: OK
    use krylov, only: real_null_preconditioner_t
    implicit none

    class(real_null_preconditioner_t), intent(inout) :: preconditioner
    integer(IK) :: status

    status = OK

end function krylov_real_null_preconditioner_get_status
