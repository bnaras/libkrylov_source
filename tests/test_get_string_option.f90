program test_get_string_option

    use kinds, only: IK, AK
    use errors, only: OK, NO_SUCH_OPTION
    use krylov, only: krylov_initialize, krylov_finalize, krylov_get_string_option, &
                      krylov_set_string_option, krylov_length_string_option
    implicit none

    integer(IK) :: error
    character(len=1, kind=AK) :: value

    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_string_option('string', 'a')
    if (error /= OK) stop 1

    error = krylov_get_string_option('string', value)
    if (error /= OK) stop 1
    if (value /= 'a') stop 1

    if (krylov_length_string_option('string') /= 1_IK) stop 1

    error = krylov_get_string_option('missing', value)
    if (error /= NO_SUCH_OPTION) stop 1

    if (krylov_length_string_option('missing') /= NO_SUCH_OPTION) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_string_option
