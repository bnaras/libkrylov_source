function krylov_get_space_last_basis_dim(index) result(last_basis_dim)

    use kinds, only: IK
    use errors, only: NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    integer(IK) :: last_basis_dim

    if (index > krylov_get_num_spaces()) then
        last_basis_dim = NO_SUCH_SPACE
        return
    end if

    associate (space => spaces(index)%space_p)
        last_basis_dim = space%convergence%get_last_basis_dim()
    end associate

end function krylov_get_space_last_basis_dim
