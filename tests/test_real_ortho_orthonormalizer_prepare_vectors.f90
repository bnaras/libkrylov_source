program test_real_ortho_orthonormalizer_prepare_vectors

    use kinds, only: IK, RK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_mat
    use krylov, only: real_ortho_orthonormalizer_t
    implicit none

    type(real_ortho_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    real(RK) :: vectors(4_IK, 2_IK), residuals(4_IK, 2_IK), new_vectors(4_IK, 2_IK), &
                new_vectors_ref(4_IK, 2_IK)
    integer(IK) :: error, new_dim

    vectors = reshape((/0.5_RK, 0.5_RK, -0.5_RK, -0.5_RK, 0.5_RK, 0.5_RK, 0.5_RK, 0.5_RK/), (/4_IK, 2_IK/))
    residuals = reshape((/1.0_RK, -1.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 1.0_RK, -1.0_RK/), (/4_IK, 2_IK/))
    new_vectors_ref = reshape((/0.70710678118654746_RK, -0.70710678118654746_RK, 0.0_RK, 0.0_RK, &
                                0.0_RK, 0.0_RK, 0.70710678118654746_RK, -0.70710678118654746_RK/), (/4_IK, 2_IK/))

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

    if (new_vectors /= near_real_mat(new_vectors_ref)) stop 1

end program test_real_ortho_orthonormalizer_prepare_vectors
