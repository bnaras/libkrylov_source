function krylov_get_space_full_dim(index) result(full_dim)

    use kinds, only: IK
    use errors, only: NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    integer(IK) :: full_dim

    if (index > krylov_get_num_spaces()) then
        full_dim = NO_SUCH_SPACE
        return
    end if

    full_dim = spaces(index)%space_p%full_dim

end function krylov_get_space_full_dim
