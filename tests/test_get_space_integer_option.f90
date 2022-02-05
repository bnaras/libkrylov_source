program test_get_space_integer_option

    use kinds, only: IK
    use errors, only: OK, NO_SUCH_OPTION, NO_SUCH_SPACE
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, krylov_get_space_integer_option, &
                      krylov_set_space_integer_option
    implicit none

    integer(IK) :: error, index

    error = krylov_initialize()
    if (error /= OK) stop 1

    index = krylov_add_space('r', 's', 'e', 10_IK, 1_IK, 3_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_space_integer_option(1_IK, 'integer', 1_IK)
    if (error /= OK) stop 1

    if (krylov_get_space_integer_option(1_IK, 'integer') /= 1_IK) stop 1

    if (krylov_get_space_integer_option(1_IK, 'missing') /= NO_SUCH_OPTION) stop 1

    if (krylov_get_space_integer_option(2_IK, 'integer') /= NO_SUCH_SPACE) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_integer_option
