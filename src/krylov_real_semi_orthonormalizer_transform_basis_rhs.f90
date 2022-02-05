function krylov_real_semi_orthonormalizer_transform_basis_rhs( &
    orthonormalizer, basis_dim, rhs_dim, basis_rhs, orthonormal_basis_rhs) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: real_semi_orthonormalizer_t
    use linalg, only: uplo
    use lapackwrapper, only: real_trsm
    implicit none

    class(real_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: basis_dim, rhs_dim
    real(RK), intent(in) :: basis_rhs(basis_dim, rhs_dim)
    real(RK), intent(out) :: orthonormal_basis_rhs(basis_dim, rhs_dim)
    integer(IK) :: error

    integer(IK) :: vec

    ! Rescale basis_rhs
    do vec = 1_IK, basis_dim
        orthonormal_basis_rhs(vec, :) = basis_rhs(vec, :) / sqrt(orthonormalizer%vector_norm_squared(vec))
    end do

    ! Transform to orthogonal basis in place
    call real_trsm('l', uplo, 'n', 'n', basis_dim, rhs_dim, 1.0_RK, orthonormalizer%gram_matrix_decomposed, &
                   basis_dim, orthonormal_basis_rhs, basis_dim)

    error = OK

end function krylov_real_semi_orthonormalizer_transform_basis_rhs
