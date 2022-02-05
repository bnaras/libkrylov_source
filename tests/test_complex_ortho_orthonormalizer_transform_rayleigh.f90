program test_complex_ortho_orthonormalizer_transform_rayleigh

    use kinds, only: IK, RK, CK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_complex_mat
    use krylov, only: complex_ortho_orthonormalizer_t
    implicit none

    type(complex_ortho_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    complex(CK) :: vectors(4_IK, 2_IK), rayleigh(2_IK, 2_IK), orthonormalized(2_IK, 2_IK), &
                   orthonormalized_ref(2_IK, 2_IK)
    integer(IK) :: error

    vectors = reshape((/(0.5_CK, 0.001_CK), (0.5_CK, 0.001_CK), (-0.5_CK, -0.001_CK), (-0.5_CK, -0.001_CK), &
                        (0.5_CK, 0.001_CK), (0.5_CK, 0.001_CK), (0.5_CK, 0.001_CK), (0.5_CK, 0.001_CK)/), &
                      (/4_IK, 2_IK/))
    rayleigh = reshape((/(1.0_CK, 0.1_CK), (2.0_CK, -0.1_CK), (2.0_CK, 0.1_CK), (3.0_CK, 0.1_CK)/), &
                       (/2_IK, 2_IK/))
    orthonormalized_ref = reshape((/(1.0_CK, 0.1_CK), (2.0_CK, -0.1_CK), (2.0_CK, 0.1_CK), (3.0_CK, 0.1_CK)/), &
                                  (/2_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = orthonormalizer%initialize(config)
    if (error /= OK) stop 1

    error = orthonormalizer%prepare_transform(4_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    error = orthonormalizer%transform_rayleigh(2_IK, rayleigh, orthonormalized)
    if (error /= OK) stop 1

    if (orthonormalized /= near_complex_mat(orthonormalized_ref, thr=1.0E-04_RK)) stop 1

end program test_complex_ortho_orthonormalizer_transform_rayleigh
