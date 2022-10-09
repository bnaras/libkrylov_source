program test_real_nks_orthonormalizer_transform_rayleigh

    use kinds, only: IK, RK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_mat
    use krylov, only: real_nks_orthonormalizer_t
    implicit none

    type(real_nks_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    real(RK) :: vectors(4_IK, 2_IK), rayleigh(2_IK, 2_IK), orthonormalized(2_IK, 2_IK), &
                orthonormalized_ref(2_IK, 2_IK)
    integer(IK) :: error

    vectors = reshape((/0.5_RK, 0.5_RK, -0.5_RK, -0.5_RK, 0.2_RK, 0.2_RK, 0.0_RK, 0.0_RK/), (/4_IK, 2_IK/))
    rayleigh = reshape((/1.0_RK, 2.0_RK, 2.0_RK, 3.0_RK/), (/2_IK, 2_IK/))
    orthonormalized_ref = reshape((/1.0_RK, 9.0_RK, 9.0_RK, 56.0_RK/), (/2_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = config%set_real_option('min_basis_vector_norm', 1.0E-7_RK)
    if (error /= OK) stop 1

    error = orthonormalizer%initialize(config)
    if (error /= OK) stop 1

    error = orthonormalizer%prepare_transform(4_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    error = orthonormalizer%transform_rayleigh(2_IK, rayleigh, orthonormalized)
    if (error /= OK) stop 1

    if (orthonormalized /= near_real_mat(orthonormalized_ref, thr=1.0E-12_RK)) stop 1

end program test_real_nks_orthonormalizer_transform_rayleigh
