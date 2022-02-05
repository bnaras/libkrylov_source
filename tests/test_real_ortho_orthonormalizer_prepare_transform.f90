program test_real_ortho_orthonormalizer_prepare_transform

    use kinds, only: IK, RK
    use errors, only: OK
    use options, only: config_t
    use krylov, only: real_ortho_orthonormalizer_t
    implicit none

    type(real_ortho_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    real(RK) :: vectors(4_IK, 2_IK)
    integer(IK) :: error

    vectors = reshape((/0.5_RK, 0.5_RK, -0.5_RK, -0.5_RK, 0.5_RK, 0.5_RK, 0.5_RK, 0.5_RK/), (/4_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = orthonormalizer%initialize(config)
    if (error /= OK) stop 1

    error = orthonormalizer%prepare_transform(4_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    if (orthonormalizer%basis_dim /= 2_IK) stop 1

end program test_real_ortho_orthonormalizer_prepare_transform
