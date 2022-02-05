program test_get_real_space_rhs

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, &
                      INCOMPATIBLE_EQUATION
    use testing, only: near_real_mat
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_set_real_space_rhs, krylov_get_real_space_rhs
    implicit none

    integer(IK) :: error, index
    real(RK) :: rhs_1(10_IK, 2_IK), rhs_2(10_IK, 2_IK), rhs_3(5_IK, 1_IK), rhs_4(50_IK, 3_IK)

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space for linear equation
    index = krylov_add_space('r', 's', 'l', 10_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    ! Add real space for eigenvalue equation
    index = krylov_add_space('r', 's', 'e', 5_IK, 1_IK, 2_IK)
    if (index /= 2_IK) stop 1

    ! Add complex space for linear equation
    index = krylov_add_space('c', 'h', 'l', 50_IK, 3_IK, 4_IK)
    if (index /= 3_IK) stop 1

    ! Set rhs on first space
    rhs_1 = 1.0_RK
    error = krylov_set_real_space_rhs(1_IK, 10_IK, 2_IK, rhs_1)
    if (error /= OK) stop 1

    ! Get rhs from first space
    rhs_2 = 0.0_RK
    error = krylov_get_real_space_rhs(1_IK, 10_IK, 2_IK, rhs_2)
    if (error /= OK) stop 1
    if (rhs_2 /= near_real_mat(rhs_1)) stop 1

    ! Try to set rhs on eigenvalue equation
    rhs_3 = 2.0_RK
    error = krylov_set_real_space_rhs(2_IK, 5_IK, 1_IK, rhs_3)
    if (error /= INCOMPATIBLE_EQUATION) stop 1

    ! Try to get rhs from eigenvalue equation
    error = krylov_get_real_space_rhs(2_IK, 5_IK, 1_IK, rhs_3)
    if (error /= INCOMPATIBLE_EQUATION) stop 1

    ! Try to get rhs from non-existent space
    error = krylov_get_real_space_rhs(4_IK, 10_IK, 1_IK, rhs_4)
    if (error /= NO_SUCH_SPACE) stop 1

    ! Try to get rhs from complex space
    error = krylov_get_real_space_rhs(3_IK, 50_IK, 3_IK, rhs_4)
    if (error /= INCOMPATIBLE_SPACE) stop 1

    ! Try to get rhs with wrong dimension
    error = krylov_get_real_space_rhs(1_IK, 20_IK, 4_IK, rhs_3)
    if (error /= INVALID_DIMENSION) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_real_space_rhs
