function krylov_convergence_get_iteration_basis_dim(convergence, index) result(basis_dim)

    use kinds, only: IK
    use errors, only: NO_SUCH_ITERATION
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(in) :: convergence
    integer(IK), intent(in) :: index
    integer(IK) :: basis_dim

    if (index > convergence%get_num_iterations()) then
        basis_dim = NO_SUCH_ITERATION
        return
    end if

    basis_dim = convergence%iterations(index)%get_basis_dim()

end function krylov_convergence_get_iteration_basis_dim
