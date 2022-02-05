program test_get_space_solution_dim

    use kinds, only: IK
    use errors, only: OK, NO_SUCH_SPACE
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, krylov_get_space_solution_dim
    implicit none

    integer(IK) :: error, index, solution_dim

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with dimension 100
    index = krylov_add_space('r', 's', 'e', 100_IK, 2_IK, 3_IK)
    solution_dim = krylov_get_space_solution_dim(index)
    if (solution_dim /= 2_IK) stop 1

    ! Check solution dimension
    solution_dim = krylov_get_space_solution_dim(index)
    if (solution_dim /= 2_IK) stop 1

    ! Nonexistent space
    solution_dim = krylov_get_space_solution_dim(index + 1_IK)
    if (solution_dim /= NO_SUCH_SPACE) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_solution_dim
