function krylov_complex_nks_orthonormalizer_transform_rayleigh( &
    orthonormalizer, basis_dim, rayleigh, orthonormal_rayleigh) result(error)

    use kinds, only: IK, CK
    use errors, only: OK
    use krylov, only: complex_nks_orthonormalizer_t
    use linalg, only: uplo
    use lapackwrapper, only: complex_trsm
    use linalg, only: complex_he_diag_scale
    implicit none

    class(complex_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: basis_dim
    complex(CK), intent(in) :: rayleigh(basis_dim, basis_dim)
    complex(CK), intent(out) :: orthonormal_rayleigh(basis_dim, basis_dim)
    integer(IK) :: error

    integer(IK) :: err

    ! Rescale Rayleigh matrix
    orthonormal_rayleigh = rayleigh
    err = complex_he_diag_scale(orthonormal_rayleigh, orthonormalizer%vector_norm_squared, basis_dim)
    if (err /= OK) then
        error = err
        return
    end if

    ! Transform to orthogonal basis in place
    call complex_trsm('r', uplo, 'n', 'n', basis_dim, basis_dim, (1.0_CK, 0.0_CK), &
                      orthonormalizer%gram_matrix_decomposed, basis_dim, orthonormal_rayleigh, basis_dim)
    call complex_trsm('l', uplo, 'c', 'n', basis_dim, basis_dim, (1.0_CK, 0.0_CK), &
                      orthonormalizer%gram_matrix_decomposed, basis_dim, orthonormal_rayleigh, basis_dim)

    error = OK

end function krylov_complex_nks_orthonormalizer_transform_rayleigh
