program test_get_space_kind

    use kinds, only: IK
    use errors, only: OK
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_get_space_kind
    implicit none

    integer(IK) :: error, index
    character(len=1) :: kind

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space
    index = krylov_add_space('r', 's', 'e', 10_IK, 2_IK, 3_IK)
    kind = krylov_get_space_kind(index)
    if (kind /= 'r') stop 1

    ! Add complex space
    index = krylov_add_space('c', 'h', 'e', 6_IK, 2_IK, 3_IK)
    kind = krylov_get_space_kind(index)
    if (kind /= 'c') stop 1

    ! Nonexistent space
    kind = krylov_get_space_kind(index + 1_IK)
    if (kind /= '') stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_kind
