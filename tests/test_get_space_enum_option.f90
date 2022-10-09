program test_get_space_enum_option

    use kinds, only: IK, AK
    use errors, only: OK, NO_SUCH_OPTION, INVALID_OPTION, NO_SUCH_SPACE
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_validate_space_enum_option, krylov_get_space_enum_option, &
                      krylov_define_space_enum_option, krylov_set_space_enum_option, &
                      krylov_length_space_enum_option
    implicit none

    integer(IK) :: error, index
    character(len=1, kind=AK) :: value

    error = krylov_initialize()
    if (error /= OK) stop 1

    index = krylov_add_space('r', 's', 'e', 10_IK, 1_IK, 3_IK)
    if (index /= 1_IK) stop 1

    error = krylov_define_space_enum_option(1_IK, 'enum', 'a;b')
    if (error /= OK) stop 1

    if (krylov_validate_space_enum_option(index, 'enum', 'a') /= OK) stop 1
    if (krylov_validate_space_enum_option(index, 'enum', 'b') /= OK) stop 1
    if (krylov_validate_space_enum_option(index, 'enum', 'c') /= INVALID_OPTION) stop 1

    if (krylov_validate_space_enum_option(index, 'missing', 'a') /= NO_SUCH_OPTION) stop 1

    error = krylov_set_space_enum_option(index, 'enum', 'a')
    if (error /= OK) stop 1

    error = krylov_set_space_enum_option(index, 'enum', 'c')
    if (error /= INVALID_OPTION) stop 1

    error = krylov_get_space_enum_option(index, 'enum', value)
    if (error /= OK) stop 1
    if (value /= 'a') stop 1

    if (krylov_length_space_enum_option(index, 'enum') /= 1_IK) stop 1

    error = krylov_get_space_enum_option(index, 'missing', value)
    if (error /= NO_SUCH_OPTION) stop 1

    if (krylov_length_space_enum_option(index, 'missing') /= NO_SUCH_OPTION) stop 1

    index = 2_IK
    if (krylov_validate_space_enum_option(index, 'enum', 'a') /= NO_SUCH_SPACE) stop 1

    error = krylov_set_space_enum_option(index, 'enum', 'a')
    if (error /= NO_SUCH_SPACE) stop 1

    error = krylov_get_space_enum_option(index, 'enum', value)
    if (error /= NO_SUCH_SPACE) stop 1

    if (krylov_length_space_enum_option(index, 'enum') /= NO_SUCH_SPACE) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_enum_option
