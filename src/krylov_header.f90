function krylov_header() result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use krylov, only: krylov_get_version, krylov_get_compiled_datetime, &
                      krylov_get_current_datetime
    implicit none

    integer(IK) :: error

    character(len=80, kind=AK) :: version, compiled_dt, start_dt
    integer :: err

    err = krylov_get_version(version)
    if (err /= OK) then
        error = err
        return
    end if

    err = krylov_get_compiled_datetime(compiled_dt)
    if (err /= OK) then
        error = err
        return
    end if

    err = krylov_get_current_datetime(start_dt)
    if (err /= OK) then
        error = err
        return
    end if

    write (*, *)
    write (*, '(a)') '      ___ __    __              __'
    write (*, '(a)') '     / (_) /_  / /_________  __/ /___ _   __'
    write (*, '(a)') '    / / / __ \/ //_/ ___/ / / / / __ \ | / /'
    write (*, '(a)') '   / / / /_/ / ,< / /  / /_/ / / /_/ / |/ /'
    write (*, '(a)') '  /_/_/_.___/_/|_/_/   \__, /_/\____/|___/'
    write (*, '(a)') '                      /____/'
    write (*, *)
    write (*, '(a, a)') '  Version   ', trim(version)
    write (*, '(a, a)') '  Compiled  ', trim(compiled_dt)
    write (*, '(a, a)') '  Started   ', trim(start_dt)
    write (*, *)

    error = OK

end function krylov_header
