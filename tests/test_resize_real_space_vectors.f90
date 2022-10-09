program test_resize_real_space_vectors

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INVALID_DIMENSION
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_get_space_vector_size, krylov_resize_real_space_vectors, &
                      krylov_get_real_space_vectors
    implicit none

    integer(IK) :: error, index, length

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with full dimension 100, current dimension 2
    index = krylov_add_space('r', 's', 'e', 100_IK, 1_IK, 2_IK)
    if (index /= 1_IK) stop 1

    ! Add second real space with full dimension 50, current dimension 3
    index = krylov_add_space('r', 's', 'e', 50_IK, 2_IK, 3_IK)
    if (index /= 2_IK) stop 1

    ! Add complex space with full dimension 6, current dimension 2
    index = krylov_add_space('c', 'h', 'e', 6_IK, 1_IK, 2_IK)
    if (index /= 3_IK) stop 1

    ! Resize first space to current dimension 4
    error = krylov_resize_real_space_vectors(1_IK, 4_IK)
    if (error /= OK) stop 1
    length = krylov_get_space_vector_size(1_IK)
    if (length /= 400_IK) stop 1

    ! Resize second space to current dimension 2
    error = krylov_resize_real_space_vectors(2_IK, 2_IK)
    if (error /= OK) stop 1
    length = krylov_get_space_vector_size(2_IK)
    if (length /= 100_IK) stop 1

    ! Impossible resizes
    ! basis_dim > full_dim
    error = krylov_resize_real_space_vectors(1_IK, 200_IK)
    if (error /= INVALID_DIMENSION) stop 1
    length = krylov_get_space_vector_size(1_IK)
    if (length /= 400_IK) stop 1

    error = krylov_resize_real_space_vectors(4_IK, 100_IK)
    if (error /= NO_SUCH_SPACE) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_resize_real_space_vectors
