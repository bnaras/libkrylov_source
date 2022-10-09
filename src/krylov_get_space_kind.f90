function krylov_get_space_kind(index, kind) result(error)

    use kinds, only: IK, AK
    use errors, only: OK, NO_SUCH_SPACE
    use krylov, only: spaces, space_t, real_space_t, complex_space_t, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=*, kind=AK), intent(out) :: kind
    integer(IK) :: error

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
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

    error = OK

end function krylov_get_space_kind
