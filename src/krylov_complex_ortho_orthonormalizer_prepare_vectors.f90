function krylov_complex_ortho_orthonormalizer_prepare_vectors( &
    orthonormalizer, full_dim, basis_dim, solution_dim, vectors, residuals, new_vectors, new_dim) result(error)

    use kinds, only: IK, RK, CK
    use errors, only: OK, INVALID_DIMENSION, INCOMPLETE_CONFIGURATION
    use krylov, only: complex_ortho_orthonormalizer_t
    use linalg, only: complex_ge_block_orthonormalize
    implicit none

    class(complex_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: full_dim, basis_dim, solution_dim
    complex(CK), intent(in) :: vectors(full_dim, basis_dim), residuals(full_dim, solution_dim)
    complex(CK), intent(out) :: new_vectors(full_dim, solution_dim)
    integer(IK), intent(out) :: new_dim
    integer(IK) :: error

    real(RK) :: thr_zero
    integer(IK) :: err

    if (solution_dim <= 0_IK) then
        error = INVALID_DIMENSION
        return
    end if

    if (orthonormalizer%config%find_option('min_basis_vector_norm') /= OK) then
        error = INCOMPLETE_CONFIGURATION
        return
    end if

    thr_zero = orthonormalizer%config%get_real_option('min_basis_vector_norm')

    new_vectors = residuals

    err = complex_ge_block_orthonormalize(new_vectors, vectors, full_dim, solution_dim, basis_dim, thr_zero, new_dim)
    if (err /= OK) then
        error = err
        return
    end if

    error = OK

end function krylov_complex_ortho_orthonormalizer_prepare_vectors
