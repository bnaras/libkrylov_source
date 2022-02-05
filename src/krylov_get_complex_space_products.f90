function krylov_get_complex_space_products(index, full_dim, basis_dim, products) result(error)

    use kinds, only: IK, CK
    use errors, only: OK
    use krylov, only: krylov_get_complex_space_subset_products
    implicit none

    integer(IK), intent(in) :: index, full_dim, basis_dim
    complex(CK), intent(out) :: products(full_dim, basis_dim)
    integer(IK) :: error

    error = krylov_get_complex_space_subset_products(index, full_dim, 0_IK, basis_dim, products)

end function krylov_get_complex_space_products
