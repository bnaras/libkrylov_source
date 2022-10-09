function krylov_get_space_structure(index, structure) result(error)

    use kinds, only: IK, AK
    use errors, only: OK, NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=*, kind=AK), intent(out) :: structure
    integer(IK) :: error

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        structure = ''
        return
    end if

    structure = spaces(index)%space_p%config%get_enum_option('structure')

    error = OK

end function krylov_get_space_structure
