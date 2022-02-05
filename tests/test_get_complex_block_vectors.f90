program test_get_complex_block_vectors

    use kinds, only: IK, CK
    use errors, only: OK
    use testing, only: near_complex_vec
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, spaces, &
                      complex_space_t, krylov_set_complex_space_vectors, &
                      krylov_get_complex_block_vectors
    implicit none

    integer(IK) :: error, index, full_dims(2_IK), subset_dims(2_IK), offsets(2_IK)
    complex(CK) :: vectors_1(3_IK), vectors_2(2_IK), vectors(5_IK), vectors_ref(5_IK)

    vectors_1 = (/(-1.0_CK, 0.0_CK), (1.0_CK, 0.0_CK), (-2.0_CK, 0.0_CK)/)
    vectors_2 = (/(3.0_CK, 0.0_CK), (-1.0_CK, 0.0_CK)/)
    vectors_ref = (/(-1.0_CK, 0.0_CK), (1.0_CK, 0.0_CK), (-2.0_CK, 0.0_CK), &
                    (3.0_CK, 0.0_CK), (-1.0_CK, 0.0_CK)/)

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add complex space with full dimension 3, current dimension 1
    index = krylov_add_space('c', 'h', 'e', 3_IK, 1_IK, 1_IK)
    if (index /= 1_IK) stop 1
    spaces(index)%space_p%new_dim = 1_IK
    error = krylov_set_complex_space_vectors(index, 3_IK, 1_IK, vectors_1)
    if (error /= OK) stop 1
    full_dims(index) = 3_IK
    subset_dims(index) = 1_IK
    offsets(index) = 0_IK

    ! Add second complex space with full dimension 2, current dimension 1
    index = krylov_add_space('c', 'h', 'e', 2_IK, 1_IK, 1_IK)
    if (index /= 2_IK) stop 1
    spaces(index)%space_p%new_dim = 1_IK
    error = krylov_set_complex_space_vectors(index, 2_IK, 1_IK, vectors_2)
    if (error /= OK) stop 1
    full_dims(index) = 2_IK
    subset_dims(index) = 1_IK
    offsets(index) = 3_IK

    error = krylov_get_complex_block_vectors(2_IK, 5_IK, full_dims, subset_dims, &
                                          offsets, vectors)
    if (error /= OK) stop 1

    if (vectors /= near_complex_vec(vectors_ref)) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_complex_block_vectors
