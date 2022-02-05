function krylov_get_integer_option(key) result(value)

    use kinds, only: IK
    use errors, only: NO_SUCH_OPTION
    use krylov, only: config
    implicit none

    character(len=*), intent(in) :: key
    integer(IK) :: value

    if (config%find_option(key) == NO_SUCH_OPTION) then
        value = NO_SUCH_OPTION
        return
    end if

    value = config%get_integer_option(key)

end function krylov_get_integer_option

