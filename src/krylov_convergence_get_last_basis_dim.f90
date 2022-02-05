function krylov_convergence_get_last_basis_dim(convergence) result(last_basis_dim)

    use kinds, only: IK
    use errors, only: NO_ITERATIONS
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(in) :: convergence
    integer(IK) :: last_basis_dim

    integer(IK) :: index

    index = convergence%get_num_iterations()

    if (index == 0_IK) then
        last_basis_dim = NO_ITERATIONS
        return
    end if

    last_basis_dim = convergence%iterations(index)%basis_dim

end function krylov_convergence_get_last_basis_dim
