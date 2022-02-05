function krylov_real_ortho_orthonormalizer_transform_basis_rhs( &
    orthonormalizer, basis_dim, rhs_dim, basis_rhs, orthonormal_basis_rhs) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: real_ortho_orthonormalizer_t
    implicit none

    class(real_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: basis_dim, rhs_dim
    real(RK), intent(in) :: basis_rhs(basis_dim, rhs_dim)
    real(RK), intent(out) :: orthonormal_basis_rhs(basis_dim, rhs_dim)
    integer(IK) :: error

    orthonormal_basis_rhs = basis_rhs

    error = OK

end function krylov_real_ortho_orthonormalizer_transform_basis_rhs
