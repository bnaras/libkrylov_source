function krylov_get_space_structure(index) result(structure)

    use kinds, only: IK
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=1) :: structure

    if (index > krylov_get_num_spaces()) then
        structure = ''
        return
    end if

    structure = spaces(index)%space_p%config%get_enum_option('structure')

end function krylov_get_space_structure
