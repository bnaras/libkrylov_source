function krylov_get_space_vector_size(index) result(length)

    use kinds, only: IK
    use errors, only: OK, NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    integer(IK) :: length

    if (index > krylov_get_num_spaces()) then
        length = NO_SUCH_SPACE
        return
    end if

    associate (space => spaces(index)%space_p)
        length = space%full_dim * space%basis_dim
    end associate

end function krylov_get_space_vector_size
