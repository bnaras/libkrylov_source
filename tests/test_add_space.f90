program test_add_space

    use kinds, only: IK
    use errors, only: OK, NO_SPACES, INVALID_KIND, INVALID_EQUATION, INVALID_DIMENSION
    use krylov, only: krylov_initialize, krylov_finalize, krylov_get_num_spaces, krylov_add_space
    implicit none

    integer(IK) :: error, num_spaces, index

    index = krylov_add_space('r', 's', 'e', 100_IK, 2_IK, 3_IK)
    if (index /= NO_SPACES) stop 1

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Empty list
    num_spaces = krylov_get_num_spaces()
    if (num_spaces /= 0_IK) stop 1

    ! Add real space
    index = krylov_add_space('r', 's', 'e', 100_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    ! Get num_spaces again
    num_spaces = krylov_get_num_spaces()
    if (num_spaces /= 1_IK) stop 1

    ! Add complex space
    index = krylov_add_space('c', 'h', 'e', 60_IK, 2_IK, 3_IK)
    if (index /= 2_IK) stop 1

    ! Get num_spaces again
    num_spaces = krylov_get_num_spaces()
    if (num_spaces /= 2_IK) stop 1

    ! Try to add space of unknown kind
    index = krylov_add_space('q', 's', 'e', 20_IK, 2_IK, 3_IK)
    if (index /= INVALID_KIND) stop 1

    ! Try to add space for unknown equation
    index = krylov_add_space('r', 's', 'q', 20_IK, 2_IK, 3_IK)
    if (index /= INVALID_EQUATION) stop 1

    ! Try to add problem spaces with invalid dimensions
    index = krylov_add_space('r', 's', 'e', 20_IK, 30_IK, 3_IK)
    if (index /= INVALID_DIMENSION) stop 1

    index = krylov_add_space('r', 's', 'e', 20_IK, 4_IK, 3_IK)
    if (index /= INVALID_DIMENSION) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_add_space
