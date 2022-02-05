program test_get_real_space_subset_vectors

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INVALID_DIMENSION
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_set_real_space_subset_vectors, krylov_get_real_space_subset_vectors
    implicit none

    integer(IK) :: error, index
    real(RK) :: vectors_1(20_IK), vectors_2(16_IK), vectors_3(1_IK)

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with full dimension 100, current dimension 3
    index = krylov_add_space('r', 's', 'e', 10_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    ! Add second real space with full dimension 40, current dimension 4
    index = krylov_add_space('r', 's', 'e', 8_IK, 2_IK, 4_IK)
    if (index /= 2_IK) stop 1

    ! Add complex space with full dimension 50, current dimension 4
    index = krylov_add_space('c', 'h', 'e', 10_IK, 2_IK, 4_IK)
    if (index /= 3_IK) stop 1

    ! Set vectors on first space
    vectors_1 = -1.0_RK
    error = krylov_set_real_space_subset_vectors(1_IK, 10_IK, 1_IK, 2_IK, vectors_1)
    if (error /= OK) stop 1

    ! Get vectors from first space
    vectors_1 = 0.0_RK
    error = krylov_get_real_space_subset_vectors(1_IK, 10_IK, 1_IK, 2_IK, vectors_1)
    if (error /= OK) stop 1
    if (vectors_1(1_IK) /= -1.0_RK) stop 1

    ! Set vectors on second space
    vectors_2 = 2.0_RK
    error = krylov_set_real_space_subset_vectors(2_IK, 8_IK, 2_IK, 2_IK, vectors_2)
    if (error /= OK) stop 1

    ! Get vectors from second space
    vectors_2 = 0.0_RK
    error = krylov_get_real_space_subset_vectors(2_IK, 8_IK, 2_IK, 2_IK, vectors_2)
    if (error /= OK) stop 1
    if (vectors_2(1_IK) /= 2.0_RK) stop 1

    ! Try to get vectors from non-existent space
    error = krylov_get_real_space_subset_vectors(4_IK, 1_IK, 1_IK, 1_IK, vectors_3)
    if (error /= NO_SUCH_SPACE) stop 1

    ! Try to get vectors from complex space
    error = krylov_get_real_space_subset_vectors(3_IK, 1_IK, 1_IK, 1_IK, vectors_3)
    if (error /= INCOMPATIBLE_SPACE) stop 1

    ! Try to get vectors with wrong full dimensions
    error = krylov_get_real_space_subset_vectors(2_IK, 10_IK, 2_IK, 2_IK, vectors_1)
    if (error /= INVALID_DIMENSION) stop 1

    ! Try to get vectors with wrong skip dimensions
    error = krylov_get_real_space_subset_vectors(2_IK, 8_IK, 3_IK, 2_IK, vectors_2)
    if (error /= INVALID_DIMENSION) stop 1

    ! Try to set vectors on non-existent space
    error = krylov_set_real_space_subset_vectors(4_IK, 1_IK, 1_IK, 1_IK, vectors_3)
    if (error /= NO_SUCH_SPACE) stop 1

    ! Try to set vectors on complex space
    error = krylov_get_real_space_subset_vectors(3_IK, 1_IK, 1_IK, 1_IK, vectors_3)
    if (error /= INCOMPATIBLE_SPACE) stop 1

    ! Try to set vectors with wrong full dimensions
    error = krylov_set_real_space_subset_vectors(2_IK, 10_IK, 2_IK, 2_IK, vectors_1)
    if (error /= INVALID_DIMENSION) stop 1

    ! Try to set vectors with wrong skip dimensions
    error = krylov_set_real_space_subset_vectors(2_IK, 8_IK, 3_IK, 2_IK, vectors_2)
    if (error /= INVALID_DIMENSION) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_real_space_subset_vectors
