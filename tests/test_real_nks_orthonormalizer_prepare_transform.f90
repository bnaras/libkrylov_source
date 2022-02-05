program test_real_nks_orthonormalizer_prepare_transform

    use kinds, only: IK, RK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_mat
    use krylov, only: real_nks_orthonormalizer_t
    implicit none

    type(real_nks_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    real(RK) :: vectors(4_IK, 2_IK), gram_factor(2_IK, 2_IK)
    integer(IK) :: error

    vectors = reshape((/0.5_RK, 0.5_RK, -0.5_RK, -0.5_RK, 0.5_RK, 0.5_RK, 0.5_RK, 0.5_RK/), (/4_IK, 2_IK/))
    gram_factor = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 1.0_RK/), (/2_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = config%set_real_option('min_basis_vector_norm', 1.0E-7_RK)
    if (error /= OK) stop 1

    error = orthonormalizer%initialize(config)
    if (error /= OK) stop 1

    error = orthonormalizer%prepare_transform(4_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    if (orthonormalizer%gram_matrix_decomposed /= near_real_mat(gram_factor)) stop 1

end program test_real_nks_orthonormalizer_prepare_transform
