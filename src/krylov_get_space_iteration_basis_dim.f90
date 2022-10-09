function krylov_get_space_iteration_basis_dim(index, iter) result(basis_dim)

    use kinds, only: IK
    use errors, only: NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index, iter
    integer(IK) :: basis_dim

    if (index > krylov_get_num_spaces()) then
        basis_dim = NO_SUCH_SPACE
        return
    end if

    basis_dim = spaces(index)%space_p%convergence%get_iteration_basis_dim(iter)

end function krylov_get_space_iteration_basis_dim
