program test_get_space_solution_size

    use kinds, only: IK
    use errors, only: OK, NO_SUCH_SPACE
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, krylov_get_space_solution_size
    implicit none

    integer(IK) :: error, index, length

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with full dimension 100
    index = krylov_add_space('r', 's', 'e', 100_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    ! Get size of real space
    length = krylov_get_space_solution_size(index)
    if (length /= 200_IK) stop 1

    ! Add complex space with full dimension 100
    index = krylov_add_space('c', 'h', 'e', 100_IK, 2_IK, 3_IK)
    if (index /= 2_IK) stop 1

    ! Get size of real space
    length = krylov_get_space_solution_size(index)
    if (length /= 200_IK) stop 1

    ! Try get size of non-existent space
    length = krylov_get_space_solution_size(index + 1_IK)
    if (length /= NO_SUCH_SPACE) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_solution_size
