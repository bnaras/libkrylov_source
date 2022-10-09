program test_get_real_space_vectors

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INVALID_DIMENSION
    use testing, only: near_real_mat
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_set_real_space_vectors, krylov_get_real_space_vectors
    implicit none

    integer(IK) :: error, index
    real(RK) :: vectors_1(10_IK, 3_IK), vectors_2(10_IK, 3_IK), vectors_3(8_IK, 4_IK)

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with full dimension 10, current dimension 3
    index = krylov_add_space('r', 's', 'e', 10_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    ! Add second real space with full dimension 8, current dimension 4
    index = krylov_add_space('r', 's', 'e', 8_IK, 2_IK, 4_IK)
    if (index /= 2_IK) stop 1

    ! Add complex space with full dimension 10, current dimension 4
    index = krylov_add_space('c', 'h', 'e', 10_IK, 2_IK, 4_IK)
    if (index /= 3_IK) stop 1

    ! Set vectors on first space
    vectors_1 = -1.0_RK
    error = krylov_set_real_space_vectors(1_IK, 10_IK, 3_IK, vectors_1)
    if (error /= OK) stop 1

    ! Get vectors from first space
    vectors_2 = 0.0_RK
    error = krylov_get_real_space_vectors(1_IK, 10_IK, 3_IK, vectors_2)
    if (error /= OK) stop 1
    if (vectors_2 /= near_real_mat(vectors_1)) stop 1

    ! Try to get vectors from non-existent space
    error = krylov_get_real_space_vectors(4_IK, 10_IK, 1_IK, vectors_3)
    if (error /= NO_SUCH_SPACE) stop 1

    ! Try to get vectors from complex space
    error = krylov_get_real_space_vectors(3_IK, 10_IK, 4_IK, vectors_3)
    if (error /= INCOMPATIBLE_SPACE) stop 1

    ! Try to get vectors with wrong dimension
    error = krylov_get_real_space_vectors(2_IK, 10_IK, 4_IK, vectors_1)
    if (error /= INVALID_DIMENSION) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_real_space_vectors
