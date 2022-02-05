function krylov_real_ortho_orthonormalizer_initialize(orthonormalizer, config) result(error)

    use kinds, only: IK
    use errors, only: OK
    use options, only: config_t
    use krylov, only: real_ortho_orthonormalizer_t
    implicit none

    class(real_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
    type(config_t), intent(in) :: config
    integer(IK) :: error

    orthonormalizer%basis_dim = 0_IK

    if (allocated(orthonormalizer%config)) deallocate (orthonormalizer%config)
    allocate (orthonormalizer%config)
    orthonormalizer%config = config

    error = OK

end function krylov_real_ortho_orthonormalizer_initialize
