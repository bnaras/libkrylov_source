function krylov_complex_semi_orthonormalizer_prepare_transform( &
    orthonormalizer, full_dim, basis_dim, vectors) result(error)

    use kinds, only: IK, RK, CK
    use errors, only: OK, LINEAR_ALGEBRA_ERROR, ILL_CONDITIONED, INVALID_DIMENSION, LINEARLY_DEPENDENT_BASIS, &
                      INCOMPLETE_CONFIGURATION
    use krylov, only: complex_semi_orthonormalizer_t
    use linalg, only: uplo
    use blaswrapper, only: complex_gemm
    use lapackwrapper, only: complex_potrf
    use linalg, only: complex_he_diag_scale
    implicit none

    class(complex_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: full_dim
    integer(IK), intent(in) :: basis_dim
    complex(CK), intent(in) :: vectors(full_dim, basis_dim)
    integer(IK) :: error

    integer(IK) :: err, info, vec
    real(RK) :: thr_zero

    if (basis_dim < 0_IK) then
        error = INVALID_DIMENSION
        return
    end if

    if (orthonormalizer%config%find_option('min_basis_vector_norm') /= OK) then
        error = INCOMPLETE_CONFIGURATION
        return
    end if

    thr_zero = orthonormalizer%config%get_real_option('min_basis_vector_norm')

    deallocate (orthonormalizer%vector_norm_squared, &
                orthonormalizer%gram_matrix, &
                orthonormalizer%scaled_gram_matrix, &
                orthonormalizer%gram_matrix_decomposed)
    allocate (orthonormalizer%vector_norm_squared(basis_dim), &
              orthonormalizer%gram_matrix(basis_dim, basis_dim), &
              orthonormalizer%scaled_gram_matrix(basis_dim, basis_dim), &
              orthonormalizer%gram_matrix_decomposed(basis_dim, basis_dim))

    orthonormalizer%vector_norm_squared = (0.0_CK, 0.0_CK)
    orthonormalizer%gram_matrix = (0.0_CK, 0.0_CK)
    orthonormalizer%scaled_gram_matrix = (0.0_CK, 0.0_CK)
    orthonormalizer%gram_matrix_decomposed = (0.0_CK, 0.0_CK)

    orthonormalizer%basis_dim = basis_dim

    ! Compute Gram matrix
    call complex_gemm('c', 'n', basis_dim, basis_dim, full_dim, (1.0_CK, 0.0_CK), vectors, full_dim, &
                      vectors, full_dim, (0.0_CK, 0.0_CK), orthonormalizer%gram_matrix, basis_dim)

    do vec = 1_IK, basis_dim
        orthonormalizer%vector_norm_squared(vec) = real(orthonormalizer%gram_matrix(vec, vec), RK)
        if (real(orthonormalizer%vector_norm_squared(vec), RK) < thr_zero**2) then
            error = LINEARLY_DEPENDENT_BASIS
            return
        end if
    end do

    ! Rescale Gram matrix to have unit diagonal
    orthonormalizer%scaled_gram_matrix = orthonormalizer%gram_matrix
    err = complex_he_diag_scale(orthonormalizer%scaled_gram_matrix, orthonormalizer%vector_norm_squared, basis_dim)
    if (err /= OK) then
        error = err
        return
    end if

    orthonormalizer%gram_matrix_decomposed = orthonormalizer%scaled_gram_matrix

    ! Cholesky decomposition in place
    info = 0_IK
    call complex_potrf(uplo, basis_dim, orthonormalizer%gram_matrix_decomposed, basis_dim, info)
    if (info /= 0_IK) then
        error = LINEAR_ALGEBRA_ERROR
        return
    end if

    error = OK

end function krylov_complex_semi_orthonormalizer_prepare_transform
