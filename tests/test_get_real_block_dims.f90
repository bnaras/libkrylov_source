program test_get_real_block_dims

    use kinds, only: IK
    use errors, only: OK
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_get_real_block_dims, krylov_get_real_block_total_size
    implicit none

    integer(IK) :: error, index, full_dims(2_IK), subset_dims(2_IK), offsets(2_IK), total_size

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with full dimension 10, basis dimension 3
    index = krylov_add_space('r', 's', 'e', 10_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    ! Add second real space with full dimension 10, basis dimension 3
    index = krylov_add_space('r', 's', 'e', 10_IK, 2_IK, 3_IK)
    if (index /= 2_IK) stop 1

    total_size = krylov_get_real_block_total_size()
    if (total_size /= 60_IK) stop 1

    error = krylov_get_real_block_dims(2_IK, full_dims, subset_dims, offsets)
    if (error /= OK) stop 1

    if (offsets(1_IK) /= 0_IK) stop 1
    if (offsets(2_IK) /= 30_IK) stop 1
    if (full_dims(1_IK) /= 10_IK) stop 1
    if (full_dims(2_IK) /= 10_IK) stop 1
    if (subset_dims(1_IK) /= 3_IK) stop 1
    if (subset_dims(2_IK) /= 3_IK) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_real_block_dims
