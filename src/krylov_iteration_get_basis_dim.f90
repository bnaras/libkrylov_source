function krylov_iteration_get_basis_dim(iteration) result(basis_dim)

    use kinds, only: IK
    use krylov, only: iteration_t
    implicit none

    class(iteration_t), intent(in) :: iteration
    integer(IK) :: basis_dim

    basis_dim = iteration%basis_dim

end function krylov_iteration_get_basis_dim
