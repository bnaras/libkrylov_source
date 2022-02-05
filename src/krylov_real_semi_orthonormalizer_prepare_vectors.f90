function krylov_real_semi_orthonormalizer_prepare_vectors( &
    orthonormalizer, full_dim, basis_dim, solution_dim, vectors, residuals, new_vectors, new_dim) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION, INCOMPLETE_CONFIGURATION
    use krylov, only: real_semi_orthonormalizer_t
    use linalg, only: real_ge_orthogonalize
    implicit none

    class(real_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: full_dim, basis_dim, solution_dim
    real(RK), intent(in) :: vectors(full_dim, basis_dim), residuals(full_dim, solution_dim)
    real(RK), intent(out) :: new_vectors(full_dim, solution_dim)
    integer(IK), intent(out) :: new_dim
    integer(IK) :: error

    integer(IK) :: err
    real(RK) :: thr_zero

    if (solution_dim <= 0_IK) then
        error = INVALID_DIMENSION
        return
    end if

    if (orthonormalizer%config%find_option('min_basis_vector_singular_value') /= OK) then
        error = INCOMPLETE_CONFIGURATION
        return
    end if

    thr_zero = orthonormalizer%config%get_real_option('min_basis_vector_singular_value')

    new_vectors = residuals

    err = real_ge_orthogonalize(new_vectors, full_dim, solution_dim, thr_zero, new_dim)
    if (err /= OK) then
        error = err
        return
    end if

    error = OK

end function krylov_real_semi_orthonormalizer_prepare_vectors
