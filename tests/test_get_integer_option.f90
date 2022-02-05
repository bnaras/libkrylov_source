program test_get_integer_option

    use kinds, only: IK
    use errors, only: OK, NO_SUCH_OPTION
    use krylov, only: krylov_initialize, krylov_finalize, krylov_get_integer_option, krylov_set_integer_option
    implicit none

    integer(IK) :: error

    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_integer_option('integer', 1_IK)
    if (error /= OK) stop 1

    if (krylov_get_integer_option('integer') /= 1_IK) stop 1

    if (krylov_get_integer_option('missing') /= NO_SUCH_OPTION) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_integer_option
