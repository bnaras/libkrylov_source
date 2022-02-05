program test_get_real_space_sylvester_b

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, &
                      INCOMPATIBLE_EQUATION
    use testing, only: near_real_mat
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_set_real_space_sylvester_b, krylov_get_real_space_sylvester_b
    implicit none

    integer(IK) :: error, index
    real(RK) :: sylvester_b_1(5_IK, 5_IK), sylvester_b_2(5_IK, 5_IK), sylvester_b_3(1_IK, 1_IK), &
                sylvester_b_4(3_IK, 3_IK)

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space for Sylvester equation
    index = krylov_add_space('r', 's', 's', 10_IK, 5_IK, 6_IK)
    if (index /= 1_IK) stop 1

    ! Add real space for eigenvalue equation
    index = krylov_add_space('r', 's', 'e', 5_IK, 1_IK, 2_IK)
    if (index /= 2_IK) stop 1

    ! Add complex space for Sylvester equation
    index = krylov_add_space('c', 'h', 's', 40_IK, 3_IK, 4_IK)
    if (index /= 3_IK) stop 1

    ! Set sylvester_b on first space
    sylvester_b_1 = 1.0_RK
    error = krylov_set_real_space_sylvester_b(1_IK, 5_IK, sylvester_b_1)
    if (error /= OK) stop 1

    ! Get sylvester_b from first space
    sylvester_b_2 = 0.0_RK
    error = krylov_get_real_space_sylvester_b(1_IK, 5_IK, sylvester_b_2)
    if (error /= OK) stop 1
    if (sylvester_b_2 /= near_real_mat(sylvester_b_1)) stop 1

    ! Try to get sylvester_b on eigenvalue equation
    sylvester_b_3 = 2.0_RK
    error = krylov_set_real_space_sylvester_b(2_IK, 1_IK, sylvester_b_3)
    if (error /= INCOMPATIBLE_EQUATION) stop 1

    ! Try to get sylvester_b from eigenvalue equation
    error = krylov_get_real_space_sylvester_b(2_IK, 1_IK, sylvester_b_3)
    if (error /= INCOMPATIBLE_EQUATION) stop 1

    ! Try to get sylvester_b from non-existent space
    error = krylov_get_real_space_sylvester_b(4_IK, 1_IK, sylvester_b_4)
    if (error /= NO_SUCH_SPACE) stop 1

    ! Try to get sylvester_b from complex space
    error = krylov_get_real_space_sylvester_b(3_IK, 3_IK, sylvester_b_4)
    if (error /= INCOMPATIBLE_SPACE) stop 1

    ! Try to get sylvester_b with wrong dimension
    error = krylov_get_real_space_sylvester_b(1_IK, 4_IK, sylvester_b_1)
    if (error /= INVALID_DIMENSION) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_real_space_sylvester_b
