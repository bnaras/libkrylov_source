program test_get_real_block_vectors

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, spaces, &
                      real_space_t, krylov_set_real_space_vectors, &
                      krylov_get_real_block_vectors
    implicit none

    integer(IK) :: error, index, full_dims(2_IK), subset_dims(2_IK), offsets(2_IK)
    real(RK) :: vectors_1(3_IK), vectors_2(2_IK), vectors(5_IK)

    vectors_1 = (/-1.0_RK, 1.0_RK, -2.0_RK/)
    vectors_2 = (/3.0_RK, -1.0_RK/)

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with full dimension 3, current dimension 1
    index = krylov_add_space('r', 's', 'e', 3_IK, 1_IK, 1_IK)
    if (index /= 1_IK) stop 1
    spaces(index)%space_p%new_dim = 1_IK
    error = krylov_set_real_space_vectors(index, 3_IK, 1_IK, vectors_1)
    if (error /= OK) stop 1
    full_dims(index) = 3_IK
    subset_dims(index) = 1_IK
    offsets(index) = 0_IK

    ! Add second real space with full dimension 2, current dimension 1
    index = krylov_add_space('r', 's', 'e', 2_IK, 1_IK, 1_IK)
    if (index /= 2_IK) stop 1
    spaces(index)%space_p%new_dim = 1_IK
    error = krylov_set_real_space_vectors(index, 2_IK, 1_IK, vectors_2)
    if (error /= OK) stop 1
    full_dims(index) = 2_IK
    subset_dims(index) = 1_IK
    offsets(index) = 3_IK

    error = krylov_get_real_block_vectors(2_IK, 5_IK, full_dims, subset_dims, &
                                          offsets, vectors)
    if (error /= OK) stop 1

    if (vectors(1_IK) /= -1.0_RK) stop 1
    if (vectors(4_IK) /= 3.0_RK) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_real_block_vectors
