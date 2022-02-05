function krylov_real_ortho_orthonormalizer_prepare_transform(orthonormalizer, full_dim, basis_dim, vectors) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: real_ortho_orthonormalizer_t
    implicit none

    class(real_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: full_dim, basis_dim
    real(RK), intent(in) :: vectors(full_dim, basis_dim)
    integer(IK) :: error

    orthonormalizer%basis_dim = basis_dim

    error = OK

end function krylov_real_ortho_orthonormalizer_prepare_transform
