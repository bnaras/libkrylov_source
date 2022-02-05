function krylov_complex_ortho_orthonormalizer_restore_basis_solutions( &
    orthonormalizer, basis_dim, solution_dim, orthonormal_basis_solutions, basis_solutions) result(error)

    use kinds, only: IK, CK
    use errors, only: OK
    use krylov, only: complex_ortho_orthonormalizer_t
    implicit none

    class(complex_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: basis_dim, solution_dim 
    complex(CK), intent(in) :: orthonormal_basis_solutions(basis_dim, solution_dim)
    complex(CK), intent(out) :: basis_solutions(basis_dim, solution_dim)
    integer(IK) :: error

    basis_solutions = orthonormal_basis_solutions

    error = OK

end function krylov_complex_ortho_orthonormalizer_restore_basis_solutions
