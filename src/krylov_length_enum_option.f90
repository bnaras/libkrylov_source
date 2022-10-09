function krylov_length_enum_option(key) result(length)

    use kinds, only: IK, AK
    use errors, only: NO_SUCH_OPTION
    use krylov, only: config
    implicit none

    character(len=*, kind=AK), intent(in) :: key
    integer(IK) :: length

    integer(IK) :: err

    err = config%find_option(key)
    if (err == NO_SUCH_OPTION) then
        length = err
        return
    end if

    length = config%length_enum_option(key)

end function krylov_length_enum_option