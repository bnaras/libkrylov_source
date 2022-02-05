function krylov_get_real_space_vectors(index, full_dim, basis_dim, vectors) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: krylov_get_real_space_subset_vectors
    implicit none

    integer(IK), intent(in) :: index, full_dim, basis_dim
    real(RK), intent(out) :: vectors(full_dim, basis_dim)
    integer(IK) :: error

    error = krylov_get_real_space_subset_vectors(index, full_dim, 0_IK, basis_dim, vectors)

end function krylov_get_real_space_vectors
