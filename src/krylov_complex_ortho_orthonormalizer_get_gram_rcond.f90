function krylov_complex_ortho_orthonormalizer_get_gram_rcond(orthonormalizer) result(gram_rcond)

    use kinds, only: RK
    use krylov, only: complex_ortho_orthonormalizer_t
    implicit none

    class(complex_ortho_orthonormalizer_t), intent(in) :: orthonormalizer
    real(RK) :: gram_rcond

    gram_rcond = 1.0_RK

end function krylov_complex_ortho_orthonormalizer_get_gram_rcond
