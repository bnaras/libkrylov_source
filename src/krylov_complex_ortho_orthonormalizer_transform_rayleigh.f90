function krylov_complex_ortho_orthonormalizer_transform_rayleigh( &
    orthonormalizer, basis_dim,rayleigh,orthonormal_rayleigh) result(error)

    use kinds, only: IK, CK
    use errors, only: OK
    use krylov, only: complex_ortho_orthonormalizer_t
    implicit none

    class(complex_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: basis_dim 
    complex(CK), intent(in) :: rayleigh(basis_dim, basis_dim)
    complex(CK), intent(out) :: orthonormal_rayleigh(basis_dim, basis_dim)
    integer(IK) :: error

    orthonormal_rayleigh = rayleigh

    error = OK

end function krylov_complex_ortho_orthonormalizer_transform_rayleigh
