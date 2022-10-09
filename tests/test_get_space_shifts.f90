program test_get_space_shifts

    use kinds, only: IK, RK, CK
    use errors, only: OK, NO_SUCH_SPACE, INVALID_DIMENSION, INCOMPATIBLE_EQUATION
    use testing, only: near_real_vec
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_get_space_shifts, krylov_set_space_shifts
    implicit none

    integer(IK) :: error, index
    real(RK) :: shifts_1(2_IK), shifts_2(2_IK), shifts_3(2_IK), shifts_4(2_IK)

    shifts_1 = (/1.0_RK, 1.0_RK/)
    shifts_3 = (/1.0_RK, 1.0_RK/)

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real shifted eigenvalue with full dimension 10, solution dimension 2
    index = krylov_add_space('r', 's', 'h', 10_IK, 2_IK, 2_IK)
    if (index /= 1_IK) stop 1

    ! Add real eigenvalue space with full dimension 10, solution dimension 2
    index = krylov_add_space('r', 's', 'e', 10_IK, 2_IK, 2_IK)
    if (index /= 2_IK) stop 1

    ! Add complex shifted eigenvalue with full dimension 10, solution dimension 2
    index = krylov_add_space('c', 'h', 'h', 10_IK, 2_IK, 2_IK)
    if (index /= 3_IK) stop 1

    error = krylov_set_space_shifts(1_IK, 2_IK, shifts_1)
    if (error /= OK) stop 1

    error = krylov_get_space_shifts(1_IK, 2_IK, shifts_2)
    if (error /= OK) stop 1
    if (shifts_2 /= near_real_vec(shifts_1)) stop 1

    error = krylov_set_space_shifts(2_IK, 3_IK, shifts_1)
    if (error /= INVALID_DIMENSION) stop 1

    error = krylov_set_space_shifts(2_IK, 2_IK, shifts_1)
    if (error /= INCOMPATIBLE_EQUATION) stop 1

    error = krylov_get_space_shifts(2_IK, 2_IK, shifts_2)
    if (error /= INCOMPATIBLE_EQUATION) stop 1

    error = krylov_set_space_shifts(3_IK, 2_IK, shifts_3)
    if (error /= OK) stop 1

    error = krylov_get_space_shifts(3_IK, 2_IK, shifts_4)
    if (error /= OK) stop 1
    if (shifts_4 /= near_real_vec(shifts_3)) stop 1

    error = krylov_set_space_shifts(4_IK, 2_IK, shifts_1)
    if (error /= NO_SUCH_SPACE) stop 1

    error = krylov_get_space_shifts(4_IK, 2_IK, shifts_2)
    if (error /= NO_SUCH_SPACE) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_shifts
