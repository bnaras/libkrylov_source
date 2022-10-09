function krylov_length_space_string_option(index, key) result(length)

    use kinds, only: IK, AK
    use errors, only: OK, NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=*, kind=AK), intent(in) :: key
    integer(IK) :: length

    integer(IK) :: err

    if (index > krylov_get_num_spaces()) then
        length = NO_SUCH_SPACE
        return
    end if

    associate (config => spaces(index)%space_p%config)
        err = config%find_option(key)
        if (err /= OK) then
            length = err
            return
        end if
        length = config%length_string_option(key)
    end associate

end function krylov_length_space_string_option
