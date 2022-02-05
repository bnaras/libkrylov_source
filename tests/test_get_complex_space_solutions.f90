program test_get_complex_space_solutions

    use kinds, only: IK, CK
    use errors, only: OK, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INVALID_DIMENSION
    use testing, only: near_complex_mat
    use krylov, only: spaces, complex_space_t, krylov_initialize, krylov_finalize, &
                      krylov_add_space, krylov_get_complex_space_solutions
    implicit none

    integer(IK) :: error, index
    complex(CK) :: solutions_1(10_IK, 2_IK), solutions_2(10_IK, 2_IK), solutions_3(5_IK, 1_IK), &
                   solutions_4(1_IK, 1_IK)

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add complex space with full dimension 10, solution dimension 2
    index = krylov_add_space('c', 'h', 'e', 10_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    ! Add second complex space with full dimension 5, solution dimension 1
    index = krylov_add_space('c', 'h', 'e', 5_IK, 1_IK, 2_IK)
    if (index /= 2_IK) stop 1

    ! Add real space with full dimension 4, solution dimension 1
    index = krylov_add_space('r', 's', 'e', 4_IK, 1_IK, 2_IK)
    if (index /= 3_IK) stop 1

    ! Get solutions on first space (1.0 - 1.0i)
    solutions_1 = (1.0_CK, -1.0_CK)
    select type (space => spaces(1_IK)%space_p)
    type is (complex_space_t)
        space%equation%solutions = solutions_1
    end select
    solutions_2 = (0.0_CK, 0.0_CK)
    error = krylov_get_complex_space_solutions(1_IK, 10_IK, 2_IK, solutions_2)
    if (error /= OK) stop 1
    if (solutions_2 /= near_complex_mat(solutions_1)) stop 1

    ! Try to get solutions from first space with wrong dimensions
    error = krylov_get_complex_space_solutions(1_IK, 8_IK, 2_IK, solutions_3)
    if (error /= INVALID_DIMENSION) stop 1

    ! Try to get solutions from real space
    error = krylov_get_complex_space_solutions(3_IK, 4_IK, 1_IK, solutions_4)
    if (error /= INCOMPATIBLE_SPACE) stop 1

    ! Try to get solutions from non-existent space
    error = krylov_get_complex_space_solutions(4_IK, 5_IK, 1_IK, solutions_4)
    if (error /= NO_SUCH_SPACE) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_complex_space_solutions
