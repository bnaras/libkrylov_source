program test_complex_semi_orthonormalizer_transform_rayleigh

    use kinds, only: IK, RK, CK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_complex_mat
    use krylov, only: complex_semi_orthonormalizer_t
    implicit none

    type(complex_semi_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    complex(CK) :: vectors(4_IK, 2_IK), rayleigh(2_IK, 2_IK), orthonormalized(2_IK, 2_IK), &
                   orthonormalized_ref(2_IK, 2_IK)
    integer(IK) :: error

    vectors = reshape((/(0.4_CK, 0.3_CK), (0.4_CK, 0.3_CK), (-0.4_CK, -0.3_CK), (-0.4_CK, -0.3_CK), &
                        (0.2_CK, 0.2_CK), (0.2_CK, 0.2_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), (/4_IK, 2_IK/))
    rayleigh = reshape((/(1.0_CK, 0.0_CK), (2.0_CK, -1.0_CK), (2.0_CK, 1.0_CK), (3.0_CK, 0.0_CK)/), (/2_IK, 2_IK/))
    orthonormalized_ref = reshape((/(1.0_CK, 0.0_CK), (6.0811183182043083_CK, -3.3941125496954276_CK), &
                                    (6.0811183182043083_CK, 3.3941125496954276_CK), (23.5_CK, 0.0_CK)/), (/2_IK, 2_IK/))

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

    if (orthonormalized /= near_complex_mat(orthonormalized_ref, thr=1.0E-12_RK)) stop 1

end program test_complex_semi_orthonormalizer_transform_rayleigh
