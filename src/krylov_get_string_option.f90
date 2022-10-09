function krylov_get_string_option(key, value) result(error)

    use kinds, only: IK, AK
    use errors, only: NO_SUCH_OPTION
    use krylov, only: config
    implicit none

    character(len=*, kind=AK), intent(in) :: key
    character(len=*, kind=AK), intent(out) :: value
    integer(IK) :: error

    error = config%find_option(key)

    if (error == NO_SUCH_OPTION) then
        value = ''
    else
        value = config%get_string_option(key)
    end if

end function krylov_get_string_option
