function krylov_real_semi_orthonormalizer_transform_rayleigh( &
    orthonormalizer, basis_dim, rayleigh, orthonormal_rayleigh) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: real_semi_orthonormalizer_t
    use linalg, only: uplo
    use lapackwrapper, only: real_trsm
    use linalg, only: real_sy_diag_scale
    implicit none

    class(real_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: basis_dim
    real(RK), intent(in) :: rayleigh(basis_dim, basis_dim)
    real(RK), intent(out) :: orthonormal_rayleigh(basis_dim, basis_dim)
    integer(IK) :: error

    integer(IK) :: err

    orthonormal_rayleigh = rayleigh

    ! Rescale Rayleigh matrix
    err = real_sy_diag_scale(orthonormal_rayleigh, orthonormalizer%vector_norm_squared, basis_dim)
    if (err /= OK) then
        error = err
        return
    end if

    ! Transform to orthogonal basis in place
    call real_trsm('r', uplo, 'n', 'n', basis_dim, basis_dim, 1.0_RK, orthonormalizer%gram_matrix_decomposed, &
                   basis_dim, orthonormal_rayleigh, basis_dim)
    call real_trsm('l', uplo, 'c', 'n', basis_dim, basis_dim, 1.0_RK, orthonormalizer%gram_matrix_decomposed, &
                   basis_dim, orthonormal_rayleigh, basis_dim)

    error = OK

end function krylov_real_semi_orthonormalizer_transform_rayleigh
