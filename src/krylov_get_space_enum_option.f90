function krylov_get_space_enum_option(index, key, value) result(error)

    use kinds, only: IK, AK
    use errors, only: OK, NO_SUCH_SPACE, NO_SUCH_OPTION
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=*, kind=AK), intent(in) :: key
    character(len=*, kind=AK), intent(out) :: value
    integer(IK) :: error

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        value = ''
        return
    end if

    associate (config => spaces(index)%space_p%config)
        error = config%find_option(key)
        if (error == NO_SUCH_OPTION) then
            value = ''
        else
            value = config%get_enum_option(key)
        end if
    end associate

end function krylov_get_space_enum_option
