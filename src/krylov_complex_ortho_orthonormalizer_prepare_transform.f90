function krylov_complex_ortho_orthonormalizer_prepare_transform(orthonormalizer, full_dim, basis_dim, vectors) result(error)

    use kinds, only: IK, CK
    use errors, only: OK
    use krylov, only: complex_ortho_orthonormalizer_t
    implicit none

    class(complex_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: full_dim, basis_dim
    complex(CK), intent(in) :: vectors(full_dim, basis_dim)
    integer(IK) :: error

    orthonormalizer%basis_dim = basis_dim

    error = OK

end function krylov_complex_ortho_orthonormalizer_prepare_transform
