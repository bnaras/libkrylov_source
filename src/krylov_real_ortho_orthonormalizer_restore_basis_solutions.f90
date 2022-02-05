function krylov_real_ortho_orthonormalizer_restore_basis_solutions( &
    orthonormalizer, basis_dim, solution_dim, orthonormal_basis_solutions, basis_solutions) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: real_ortho_orthonormalizer_t
    implicit none

    class(real_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: basis_dim, solution_dim
    real(RK), intent(in) :: orthonormal_basis_solutions(basis_dim, solution_dim)
    real(RK), intent(out) :: basis_solutions(basis_dim, solution_dim)
    integer(IK) :: error

    basis_solutions = orthonormal_basis_solutions

    error = OK

end function krylov_real_ortho_orthonormalizer_restore_basis_solutions
