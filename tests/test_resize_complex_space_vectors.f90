program test_resize_complex_space_vectors

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_SPACE, INVALID_DIMENSION, INVALID_DIMENSION
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_get_space_vector_size, krylov_resize_complex_space_vectors, &
                      krylov_get_complex_space_vectors
    implicit none

    integer(IK) :: error, index, length

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with full dimension 100, current dimension 2
    index = krylov_add_space('r', 's', 'e', 100_IK, 1_IK, 2_IK)
    if (index /= 1_IK) stop 1

    ! Add complex space with full dimension 50, current dimension 4
    index = krylov_add_space('c', 'h', 'e', 50_IK, 1_IK, 4_IK)
    if (index /= 2_IK) stop 1

    ! Add complex space with full dimension 10, current dimension 2
    index = krylov_add_space('c', 'h', 'e', 10_IK, 1_IK, 2_IK)
    if (index /= 3_IK) stop 1

    ! Resize first complex space (index 2) to current dimension 5
    error = krylov_resize_complex_space_vectors(2_IK, 5_IK)
    if (error /= OK) stop 1
    length = krylov_get_space_vector_size(2_IK)
    if (length /= 250_IK) stop 1

    ! Resize second complex space (index 3) to current dimension 1
    error = krylov_resize_complex_space_vectors(3_IK, 1_IK)
    if (error /= OK) stop 1
    length = krylov_get_space_vector_size(3_IK)
    if (length /= 10_IK) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_resize_complex_space_vectors
