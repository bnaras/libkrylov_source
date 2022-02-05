function krylov_real_semi_orthonormalizer_get_gram_rcond(orthonormalizer) result(gram_rcond)

    use kinds, only: RK
    use krylov, only: real_semi_orthonormalizer_t
    use linalg, only: real_sy_rcond_spectral_norm
    implicit none

    class(real_semi_orthonormalizer_t), intent(in) :: orthonormalizer
    real(RK) :: gram_rcond

    gram_rcond = real_sy_rcond_spectral_norm(orthonormalizer%scaled_gram_matrix, orthonormalizer%basis_dim)

end function krylov_real_semi_orthonormalizer_get_gram_rcond
