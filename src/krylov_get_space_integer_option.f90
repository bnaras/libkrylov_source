function krylov_get_space_integer_option(index, key) result(value)

    use kinds, only: IK
    use errors, only: NO_SUCH_SPACE, NO_SUCH_OPTION
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=*), intent(in) :: key
    integer(IK) :: value

    if (index > krylov_get_num_spaces()) then
        value = NO_SUCH_SPACE
        return
    end if

    associate (config => spaces(index)%space_p%config)
        if (config%find_option(key) == NO_SUCH_OPTION) then
            value = NO_SUCH_OPTION
            return
        end if

        value = config%get_integer_option(key)
    end associate

end function krylov_get_space_integer_option
