function krylov_real_ortho_orthonormalizer_get_gram_rcond(orthonormalizer) result(gram_rcond)

    use kinds, only: RK
    use krylov, only: real_ortho_orthonormalizer_t
    implicit none

    class(real_ortho_orthonormalizer_t), intent(in) :: orthonormalizer
    real(RK) :: gram_rcond

    gram_rcond = 1.0_RK

end function krylov_real_ortho_orthonormalizer_get_gram_rcond
