function krylov_get_current_datetime(current_dt) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    implicit none

    character(len=80, kind=AK) :: current_dt
    integer(IK) :: error

    integer :: dt(8)

    call date_and_time(values=dt)

    write (current_dt, '(i4, a, i0.2, a, i0.2, a, i0.2, a, i0.2, a, i0.2)') &
        dt(1), '-', dt(2), '-', dt(3), ' ', dt(5), ':', dt(6), ':', dt(7)

    error = OK

end function krylov_get_current_datetime
