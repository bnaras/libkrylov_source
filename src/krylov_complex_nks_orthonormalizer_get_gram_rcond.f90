function krylov_complex_nks_orthonormalizer_get_gram_rcond(orthonormalizer) result(gram_rcond)

    use kinds, only: RK
    use krylov, only: complex_nks_orthonormalizer_t
    use linalg, only: complex_he_rcond_spectral_norm
    implicit none

    class(complex_nks_orthonormalizer_t), intent(in) :: orthonormalizer
    real(RK) :: gram_rcond

    gram_rcond = complex_he_rcond_spectral_norm(orthonormalizer%scaled_gram_matrix, orthonormalizer%basis_dim)

end function krylov_complex_nks_orthonormalizer_get_gram_rcond
