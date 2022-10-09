function krylov_real_nks_orthonormalizer_restore_basis_solutions( &
    orthonormalizer, basis_dim, solution_dim, orthonormal_basis_solutions, basis_solutions) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: real_nks_orthonormalizer_t
    use linalg, only: uplo
    use lapackwrapper, only: real_trsm
    implicit none

    class(real_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: basis_dim, solution_dim
    real(RK), intent(in) :: orthonormal_basis_solutions(basis_dim, solution_dim)
    real(RK), intent(out) :: basis_solutions(basis_dim, solution_dim)
    integer(IK) :: error

    integer(IK) :: vec

    basis_solutions = orthonormal_basis_solutions

    ! Transform out of orthogonal basis in place
    call real_trsm('l', uplo, 'n', 'n', basis_dim, solution_dim, 1.0_RK, orthonormalizer%gram_matrix_decomposed, &
                   basis_dim, basis_solutions, basis_dim)

    ! Rescale basis_solutions
    do vec = 1_IK, basis_dim
        basis_solutions(vec, :) = basis_solutions(vec, :) / sqrt(orthonormalizer%vector_norm_squared(vec))
    end do

    error = OK

end function krylov_real_nks_orthonormalizer_restore_basis_solutions
