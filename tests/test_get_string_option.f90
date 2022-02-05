program test_get_string_option

    use kinds, only: IK
    use errors, only: OK, NO_SUCH_OPTION
    use krylov, only: krylov_initialize, krylov_finalize, krylov_get_string_option, krylov_set_string_option
    implicit none

    integer(IK) :: error

    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_string_option('string', 'a')
    if (error /= OK) stop 1

    if (krylov_get_string_option('string') /= 'a') stop 1

    if (krylov_get_string_option('missing') /= '') stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_string_option
