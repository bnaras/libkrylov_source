function krylov_define_space_enum_option(index, key, values) result(error)

    use kinds, only: IK, AK
    use errors, only: NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=*, kind=AK), intent(in) :: key, values
    integer(IK) :: error

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        return
    end if

    error = spaces(index)%space_p%config%define_enum_option(key, values)

end function krylov_define_space_enum_option
