function krylov_get_logical_option(key) result(value)

    use kinds, only: AK, LK
    use errors, only: NO_SUCH_OPTION
    use krylov, only: config
    implicit none

    character(len=*, kind=AK), intent(in) :: key
    logical(LK) :: value

    if (config%find_option(key) == NO_SUCH_OPTION) then
        value = .false._LK
        return
    end if

    value = config%get_logical_option(key)

end function krylov_get_logical_option
