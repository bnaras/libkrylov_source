function krylov_complex_nks_orthonormalizer_prepare_vectors( &
    orthonormalizer, full_dim, basis_dim, solution_dim, vectors, residuals, new_vectors, new_dim) result(error)

    use kinds, only: IK, CK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: complex_nks_orthonormalizer_t
    implicit none

    class(complex_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: full_dim, basis_dim, solution_dim
    complex(CK), intent(in) :: vectors(full_dim, basis_dim), residuals(full_dim, solution_dim)
    complex(CK), intent(out) :: new_vectors(full_dim, solution_dim)
    integer(IK), intent(out) :: new_dim
    integer(IK) :: error

    if (solution_dim <= 0_IK) then
        error = INVALID_DIMENSION
        return
    end if

    new_dim = solution_dim
    new_vectors = residuals

    error = OK

end function krylov_complex_nks_orthonormalizer_prepare_vectors
