function krylov_complex_ortho_orthonormalizer_transform_basis_rhs( &
    orthonormalizer, basis_dim, rhs_dim, basis_rhs, orthonormal_basis_rhs) result(error)

    use kinds, only: IK, CK
    use errors, only: OK
    use krylov, only: complex_ortho_orthonormalizer_t
    implicit none

    class(complex_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: basis_dim, rhs_dim
    complex(CK), intent(in) :: basis_rhs(basis_dim, rhs_dim)
    complex(CK), intent(out) :: orthonormal_basis_rhs(basis_dim, rhs_dim)
    integer(IK) :: error

    orthonormal_basis_rhs = basis_rhs

    error = OK

end function krylov_complex_ortho_orthonormalizer_transform_basis_rhs
