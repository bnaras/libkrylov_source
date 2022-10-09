program test_complex_nks_orthonormalizer_prepare_transform

    use kinds, only: IK, RK, CK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_complex_mat
    use krylov, only: complex_nks_orthonormalizer_t
    implicit none

    type(complex_nks_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    complex(CK) :: vectors(4_IK, 2_IK), gram_factor(2_IK, 2_IK)
    integer(IK) :: error

    vectors = reshape((/(0.4_CK, 0.3_CK), (0.4_CK, 0.3_CK), (-0.4_CK, -0.3_CK), (-0.4_CK, -0.3_CK), &
                        (0.2_CK, 0.2_CK), (0.2_CK, 0.2_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), (/4_IK, 2_IK/))
    gram_factor = reshape((/(1.0_CK, 0.0_CK), (0.7_CK, -0.1_CK), (0.7_CK, 0.1_CK), (0.70710678118654757_CK, 0.0_CK)/), &
                          (/2_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = config%set_real_option('min_basis_vector_norm', 1.0E-7_RK)
    if (error /= OK) stop 1

    error = orthonormalizer%initialize(config)
    if (error /= OK) stop 1

    error = orthonormalizer%prepare_transform(4_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    if (orthonormalizer%gram_matrix_decomposed /= near_complex_mat(gram_factor)) stop 1

end program test_complex_nks_orthonormalizer_prepare_transform
