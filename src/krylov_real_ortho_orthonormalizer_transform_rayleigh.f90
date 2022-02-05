function krylov_real_ortho_orthonormalizer_transform_rayleigh( &
    orthonormalizer, basis_dim, rayleigh, orthonormal_rayleigh) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: real_ortho_orthonormalizer_t
    implicit none

    class(real_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK), intent(in) :: basis_dim
    real(RK), intent(in) :: rayleigh(basis_dim, basis_dim)
    real(RK), intent(out) :: orthonormal_rayleigh(basis_dim, basis_dim)
    integer(IK) :: error

    orthonormal_rayleigh = rayleigh

    error = OK

end function krylov_real_ortho_orthonormalizer_transform_rayleigh
