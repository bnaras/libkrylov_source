program test_complex_semi_orthonormalizer_get_gram_rcond

    use kinds, only: IK, RK, CK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_num
    use krylov, only: complex_semi_orthonormalizer_t
    implicit none

    type(complex_semi_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    complex(CK) :: vectors(4_IK, 2_IK)
    real(RK) :: gram_rcond
    integer(IK) :: error

    vectors = reshape((/(0.4_CK, 0.3_CK), (0.4_CK, 0.3_CK), (-0.4_CK, -0.3_CK), (-0.4_CK, -0.3_CK), &
                        (0.2_CK, 0.2_CK), (0.2_CK, 0.2_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), (/4_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = config%set_real_option('min_basis_vector_norm', 1.0E-7_RK)
    if (error /= OK) stop 1

    error = orthonormalizer%initialize(config)
    if (error /= OK) stop 1

    error = orthonormalizer%prepare_transform(4_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    gram_rcond = orthonormalizer%get_gram_rcond()

    if (gram_rcond /= near_real_num(0.17157287525380979_RK)) stop 1

end program test_complex_semi_orthonormalizer_get_gram_rcond
