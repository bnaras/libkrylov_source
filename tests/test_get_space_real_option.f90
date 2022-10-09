program test_get_space_real_option

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_OPTION, NO_SUCH_SPACE
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, krylov_get_space_real_option, &
                      krylov_set_space_real_option
    implicit none

    integer(IK) :: error, index

    error = krylov_initialize()
    if (error /= OK) stop 1

    index = krylov_add_space('r', 's', 'e', 10_IK, 1_IK, 3_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_space_real_option(index, 'real', 1.0_RK)
    if (error /= OK) stop 1

    if (krylov_get_space_real_option(index, 'real') /= 1.0_RK) stop 1

    if (krylov_get_space_real_option(index, 'missing') /= -huge(1.0_RK)) stop 1

    index = 2_IK
    if (krylov_get_space_real_option(index, 'real') /= -huge(1.0_RK)) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_real_option
