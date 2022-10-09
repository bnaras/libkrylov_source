function krylov_footer() result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use krylov, only: krylov_get_current_datetime
    implicit none

    integer(IK) :: error

    character(len=80, kind=AK) :: end_dt
    integer(IK) :: err

    err = krylov_get_current_datetime(end_dt)
    if (err /= OK) then
        error = err
        return
    end if

    write (*, *)
    write (*, '(a, a)') '  Finished  ', trim(end_dt)
    write (*, *)

    error = OK

end function krylov_footer
