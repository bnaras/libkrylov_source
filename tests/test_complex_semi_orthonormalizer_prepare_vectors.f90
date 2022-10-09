program test_complex_semi_orthonormalizer_prepare_vectors

    use kinds, only: IK, RK, CK, LK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_complex_mat
    use krylov, only: complex_semi_orthonormalizer_t
    implicit none

    type(complex_semi_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    complex(CK) :: vectors(4_IK, 2_IK), residuals(4_IK, 2_IK), new_vectors(4_IK, 2_IK), new_vectors_ref(4_IK, 2_IK)
    integer(IK) :: error, new_dim

    vectors = reshape((/(0.4_CK, 0.3_CK), (0.4_CK, 0.3_CK), (-0.4_CK, -0.3_CK), (-0.4_CK, -0.3_CK), &
                        (0.2_CK, 0.2_CK), (0.2_CK, 0.2_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), (/4_IK, 2_IK/))
    residuals = reshape((/(0.1_CK, 0.1_CK), (0.1_CK, -0.1_CK), (-0.3_CK, -0.1_CK), (-0.3_CK, 0.1_CK), &
                          (0.1_CK, 0.1_CK), (0.1_CK, -0.3_CK), (0.1_CK, 0.1_CK), (0.1_CK, -0.3_CK)/), (/4_IK, 2_IK/))
    new_vectors_ref = reshape((/(-0.0707106781186549_CK, 0.0292893218813451_CK), &
                                (0.12928932188134501_CK, -0.0292893218813451_CK), &
                                (0.21213203435596437_CK, 0.17071067811865470_CK), &
                                (0.41213203435596424_CK, -0.17071067811865465_CK), &
                                (0.0707106781186549_CK, 0.17071067811865473_CK), &
                                (0.27071067811865474_CK, -0.17071067811865465_CK), &
                                (-0.21213203435596414_CK, 0.0292893218813451_CK), &
                                (-0.01213203435596408_CK, -0.0292893218813451_CK)/), (/4_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = config%set_real_option('min_basis_vector_singular_value', 1.0E-12_RK)
    if (error /= OK) stop 1

    error = config%set_real_option('min_basis_vector_norm', 1.0E-7_RK)
    if (error /= OK) stop 1

    error = orthonormalizer%initialize(config)
    if (error /= OK) stop 1

    error = orthonormalizer%prepare_transform(4_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    error = orthonormalizer%prepare_vectors(4_IK, 2_IK, 2_IK, vectors, residuals, new_vectors, new_dim)
    if (error /= OK) stop 1
    if (new_dim /= 2_IK) stop 1

    if (new_vectors /= near_complex_mat(new_vectors_ref, fix_phase=.true._LK)) stop 1

end program test_complex_semi_orthonormalizer_prepare_vectors
