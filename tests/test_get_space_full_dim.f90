program test_get_space_full_dim

    use kinds, only: IK
    use errors, only: OK, NO_SUCH_SPACE
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_get_space_full_dim
    implicit none

    integer(IK) :: error, index, full_dim

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with dimension 100
    index = krylov_add_space('r', 's', 'e', 100_IK, 2_IK, 3_IK)
    full_dim = krylov_get_space_full_dim(index)
    if (full_dim /= 100_IK) stop 1

    ! Nonexistent space
    full_dim = krylov_get_space_full_dim(index + 1_IK)
    if (full_dim /= NO_SUCH_SPACE) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_full_dim
