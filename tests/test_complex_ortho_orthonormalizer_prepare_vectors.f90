program test_complex_ortho_orthonormalizer_prepare_vectors

    use kinds, only: IK, RK, CK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_complex_mat
    use krylov, only: complex_ortho_orthonormalizer_t
    implicit none

    type(complex_ortho_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    complex(CK) :: vectors(4_IK, 2_IK), residuals(4_IK, 2_IK), new_vectors(4_IK, 2_IK), ref(4_IK, 2_IK)
    integer(IK) :: error, new_dim

    vectors = reshape((/(0.5_CK, 0.1_CK), (0.5_CK, 0.1_CK), (-0.5_CK, -0.1_CK), (-0.5_CK, -0.1_CK), &
                        (0.5_CK, 0.1_CK), (0.5_CK, 0.1_CK), (0.5_CK, 0.1_CK), (0.5_CK, 0.1_CK)/), (/4_IK, 2_IK/))
    residuals = reshape((/(1.0_CK, 0.1_CK), (-1.0_CK, -0.1_CK), (-3.0_CK, -0.1_CK), (3.0_CK, 0.1_CK), &
                          (1.5_CK, 0.1_CK), (-1.5_CK, -0.1_CK), (0.5_CK, 0.1_CK), (-0.5_CK, -0.1_CK)/), (/4_IK, 2_IK/))
    ref = reshape((/(0.223438723324904_CK, 0.002234387233249_CK), (-0.223438723324904_CK, -0.022343872332490_CK), &
                    (-0.670316169974712_CK, -0.022343872332490_CK), (0.670316169974712_CK, 0.022343872332490_CK), &
                    (0.668966912755992_CK, 0.054945248252818_CK), (-0.668035241170813_CK, -0.054963280606080_CK), &
                    (0.223390802988257_CK, 0.013515582701985_CK), (-0.223390802988257_CK, -0.013515582701985_CK)/), (/4_IK, 2_IK/))

    error = config%initialize()
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

    if (new_vectors /= near_complex_mat(ref, thr=1.0E-01_RK)) stop 1

end program test_complex_ortho_orthonormalizer_prepare_vectors
