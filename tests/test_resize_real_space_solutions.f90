program test_resize_real_space_solutions

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INVALID_DIMENSION
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_get_space_solution_size, krylov_resize_real_space_solutions, &
                      krylov_get_real_space_solutions
    implicit none

    integer(IK) :: error, index, length

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with full dimension 100, solution dimension 1
    index = krylov_add_space('r', 's', 'e', 100_IK, 1_IK, 3_IK)
    if (index /= 1_IK) stop 1

    ! Add second real space with full dimension 50, solution dimension 1
    index = krylov_add_space('r', 's', 'e', 50_IK, 1_IK, 2_IK)
    if (index /= 2_IK) stop 1

    ! Add complex space with full dimension 60, solution dimension 2
    index = krylov_add_space('c', 'h', 'e', 60_IK, 2_IK, 4_IK)
    if (index /= 3_IK) stop 1

    ! Resize first space to solution dimension 3
    error = krylov_resize_real_space_solutions(1_IK, 3_IK)
    if (error /= OK) stop 1
    length = krylov_get_space_solution_size(1_IK)
    if (length /= 300_IK) stop 1

    ! Resize second space to solution dimension 1
    error = krylov_resize_real_space_solutions(2_IK, 1_IK)
    if (error /= OK) stop 1
    length = krylov_get_space_solution_size(2_IK)
    if (length /= 50_IK) stop 1

    ! Resize to impossible space
    ! solution_dim > full_dim
    error = krylov_resize_real_space_solutions(1_IK, 200_IK)
    if (error /= INVALID_DIMENSION) stop 1
    length = krylov_get_space_solution_size(1_IK)
    if (length /= 300_IK) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_resize_real_space_solutions
