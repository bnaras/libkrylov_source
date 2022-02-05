function krylov_get_logical_option(key) result(value)

    use krylov, only: config
    use errors, only: NO_SUCH_OPTION
    implicit none

    character(len=*), intent(in) :: key
    logical :: value

    if (config%find_option(key) == NO_SUCH_OPTION) then
        value = .false.
        return
    end if

    value = config%get_logical_option(key)

end function krylov_get_logical_option
