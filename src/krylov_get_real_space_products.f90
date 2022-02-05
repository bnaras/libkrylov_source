function krylov_get_real_space_products(index, full_dim, basis_dim, products) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INVALID_DIMENSION
    use krylov, only: krylov_get_real_space_subset_products
    implicit none

    integer(IK), intent(in) :: index, full_dim, basis_dim
    real(RK), intent(out) :: products(full_dim, basis_dim)
    integer(IK) :: error

    error = krylov_get_real_space_subset_products(index, full_dim, 0_IK, basis_dim, products)

end function krylov_get_real_space_products
