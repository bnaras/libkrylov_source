function krylov_get_compiled_datetime(compiled_dt) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use versions, only: krylov_compiled_dt
    implicit none

    character(len=*, kind=AK), intent(out) :: compiled_dt
    integer(IK) :: error

    compiled_dt = krylov_compiled_dt

    error = OK

end function krylov_get_compiled_datetime
