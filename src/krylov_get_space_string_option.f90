function krylov_get_space_string_option(index, key) result(value)

    use kinds, only: IK
    use errors, only: NO_SUCH_OPTION
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=*), intent(in) :: key
    character(len=:), allocatable :: value

    if (index > krylov_get_num_spaces()) then
        value = ''
        return
    end if

    associate (config => spaces(index)%space_p%config)
        if (config%find_option(key) == NO_SUCH_OPTION) then
            value = ''
            return
        end if

        value = config%get_string_option(key)
    end associate

end function krylov_get_space_string_option
