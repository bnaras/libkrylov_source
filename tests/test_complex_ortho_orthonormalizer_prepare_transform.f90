program test_complex_ortho_orthonormalizer_prepare_transform

    use kinds, only: IK, CK
    use errors, only: OK
    use options, only: config_t
    use krylov, only: complex_ortho_orthonormalizer_t
    implicit none

    type(complex_ortho_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    complex(CK) :: vectors(4_IK, 2_IK)
    integer(IK) :: error

    vectors = reshape((/(0.5_CK, 0.1_CK), (0.5_CK, 0.1_CK), (-0.5_CK, -0.1_CK), (-0.5_CK, -0.1_CK), &
                        (0.5_CK, 0.1_CK), (0.5_CK, 0.1_CK), (0.5_CK, 0.1_CK), (0.5_CK, 0.1_CK)/), (/4_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = orthonormalizer%initialize(config)
    if (error /= OK) stop 1

    error = orthonormalizer%prepare_transform(4_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    if (orthonormalizer%basis_dim /= 2_IK) stop 1

end program test_complex_ortho_orthonormalizer_prepare_transform
