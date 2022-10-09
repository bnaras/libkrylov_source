program test_get_space_string_option

    use kinds, only: IK, AK
    use errors, only: OK, NO_SUCH_OPTION, NO_SUCH_SPACE
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_get_space_string_option, krylov_set_space_string_option, &
                      krylov_length_space_string_option
    implicit none

    integer(IK) :: error, index
    character(len=1, kind=AK) :: value

    error = krylov_initialize()
    if (error /= OK) stop 1

    index = krylov_add_space('r', 's', 'e', 10_IK, 1_IK, 3_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_space_string_option(index, 'string', 'a')
    if (error /= OK) stop 1

    error = krylov_get_space_string_option(index, 'string', value)
    if (error /= OK) stop 1
    if (value /= 'a') stop 1

    if (krylov_length_space_string_option(index, 'string') /= 1_IK) stop 1

    error = krylov_get_space_string_option(index, 'missing', value)
    if (error /= NO_SUCH_OPTION) stop 1

    if (krylov_length_space_string_option(index, 'missing') /= NO_SUCH_OPTION) stop 1

    index = 2_IK
    error = krylov_get_space_string_option(index, 'string', value)
    if (error /= NO_SUCH_SPACE) stop 1

    if (krylov_length_space_string_option(index, 'string') /= NO_SUCH_SPACE) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_string_option
