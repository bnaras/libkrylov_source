function krylov_get_space_kind(index) result(kind)

    use kinds, only: IK
    use krylov, only: spaces, space_t, real_space_t, complex_space_t, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=1) :: kind

    if (index > krylov_get_num_spaces()) then
        kind = ''
        return
    end if

    select type (space => spaces(index)%space_p)
    type is (real_space_t)
        kind = 'r'
    type is (complex_space_t)
        kind = 'c'
    class default
        kind = ''
    end select

end function krylov_get_space_kind
