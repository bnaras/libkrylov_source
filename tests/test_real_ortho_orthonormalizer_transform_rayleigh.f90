program test_real_ortho_orthonormalizer_transform_rayleigh

    use kinds, only: IK, RK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_mat
    use krylov, only: real_ortho_orthonormalizer_t
    implicit none

    type(real_ortho_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    real(RK) :: vectors(4_IK, 2_IK), rayleigh(2_IK, 2_IK), orthonormalized(2_IK, 2_IK), &
                orthonormalized_ref(2_IK, 2_IK)
    integer(IK) :: error

    vectors = reshape((/0.5_RK, 0.5_RK, -0.5_RK, -0.5_RK, 0.5_RK, 0.5_RK, 0.5_RK, 0.5_RK/), &
                      (/4_IK, 2_IK/))
    rayleigh = reshape((/1.0_RK, 2.0_RK, 2.0_RK, 3.0_RK/), (/2_IK, 2_IK/))
    orthonormalized_ref = reshape((/1.0_RK, 2.0_RK, 2.0_RK, 3.0_RK/), (/2_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = orthonormalizer%initialize(config)
    if (error /= OK) stop 1

    error = orthonormalizer%prepare_transform(4_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    error = orthonormalizer%transform_rayleigh(2_IK, rayleigh, orthonormalized)
    if (error /= OK) stop 1

    if (orthonormalized /= near_real_mat(orthonormalized_ref)) stop 1

end program test_real_ortho_orthonormalizer_transform_rayleigh
