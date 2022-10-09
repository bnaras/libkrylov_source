program test_get_enum_option

    use kinds, only: IK, AK
    use errors, only: OK, NO_SUCH_OPTION, INVALID_OPTION
    use krylov, only: krylov_initialize, krylov_finalize, krylov_validate_enum_option, &
                      krylov_get_enum_option, krylov_define_enum_option, krylov_set_enum_option, &
                      krylov_length_enum_option

    implicit none

    integer(IK) :: error
    character(len=1, kind=AK) :: value

    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_define_enum_option('enum', 'a;b')
    if (error /= OK) stop 1

    if (krylov_validate_enum_option('enum', 'a') /= OK) stop 1
    if (krylov_validate_enum_option('enum', 'b') /= OK) stop 1
    if (krylov_validate_enum_option('enum', 'c') /= INVALID_OPTION) stop 1

    if (krylov_validate_enum_option('missing', 'a') /= NO_SUCH_OPTION) stop 1

    error = krylov_set_enum_option('enum', 'a')
    if (error /= OK) stop 1

    error = krylov_set_enum_option('enum', 'c')
    if (error /= INVALID_OPTION) stop 1

    error = krylov_get_enum_option('enum', value)
    if (error /= OK) stop 1
    if (value /= 'a') stop 1

    if (krylov_length_enum_option('enum') /= 1_IK) stop 1

    error = krylov_get_enum_option('missing', value)
    if (error /= NO_SUCH_OPTION) stop 1

    if (krylov_length_enum_option('missing') /= NO_SUCH_OPTION) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_enum_option
