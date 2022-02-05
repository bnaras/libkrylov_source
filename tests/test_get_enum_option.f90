program test_get_enum_option

    use kinds, only: IK
    use errors, only: OK, NO_SUCH_OPTION, INVALID_OPTION
    use krylov, only: krylov_initialize, krylov_finalize, krylov_validate_enum_option, krylov_get_enum_option, &
                      krylov_define_enum_option, krylov_set_enum_option
    implicit none

    integer(IK) :: error

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

    if (krylov_get_enum_option('enum') /= 'a') stop 1
    if (krylov_get_enum_option('missing') /= '') stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_enum_option
