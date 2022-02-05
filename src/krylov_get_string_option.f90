function krylov_get_string_option(key) result(value)

    use krylov, only: config
    use errors, only: NO_SUCH_OPTION
    implicit none

    character(len=*), intent(in) :: key
    character(len=:), allocatable :: value

    if (config%find_option(key) == NO_SUCH_OPTION) then
        value = ''
        return
    end if

    value = config%get_string_option(key)

end function krylov_get_string_option
