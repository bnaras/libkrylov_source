program test_get_space_vector_size

    use kinds, only: IK
    use errors, only: OK, NO_SUCH_SPACE
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, krylov_get_space_vector_size
    implicit none

    integer(IK) :: error, index, length

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with dimension 100
    index = krylov_add_space('r', 's', 'e', 100_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    length = krylov_get_space_vector_size(index)
    if (length /= 300_IK) stop 1

    ! Nonexistent space
    length = krylov_get_space_vector_size(index + 1_IK)
    if (length /= NO_SUCH_SPACE) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_vector_size
