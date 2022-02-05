program test_options

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_OPTION, INVALID_OPTION
    use options, only: config_t
    implicit none

    type(config_t) :: c1, c2, c3, c4
    integer(IK) :: error

    error = c1%initialize()
    if (error /= OK) stop 1
    if (c1%count_local() /= 0_IK) stop 1
    if (c1%count() /= 0_IK) stop 1
    if (c1%level /= 0_IK) stop 1
    if (associated(c1%parent)) stop 1

    error = c1%set_integer_option('integer', 1_IK)
    if (error /= OK) stop 1
    if (c1%find_option_local('integer') /= OK) stop 1
    if (c1%find_option('integer') /= OK) stop 1
    if (c1%count_local() /= 1_IK) stop 1
    if (c1%count() /= 1_IK) stop 1
    if (c1%get_integer_option('integer') /= 1_IK) stop 1
    if (c1%find_option_local('missing') /= NO_SUCH_OPTION) stop 1
    if (c1%find_option('missing') /= NO_SUCH_OPTION) stop 1

    error = c1%set_string_option('string', 'abc')
    if (error /= OK) stop 1
    if (c1%find_option_local('string') /= OK) stop 1
    if (c1%find_option('string') /= OK) stop 1
    if (c1%count_local() /= 2_IK) stop 1
    if (c1%count() /= 2_IK) stop 1
    if (c1%get_string_option('string') /= 'abc') stop 1

    error = c1%set_real_option('real', 1.0_RK)
    if (error /= OK) stop 1
    if (c1%find_option_local('real') /= OK) stop 1
    if (c1%find_option('real') /= OK) stop 1
    if (c1%count_local() /= 3_IK) stop 1
    if (c1%count() /= 3_IK) stop 1
    if (c1%get_real_option('real') /= 1.0_RK) stop 1

    error = c1%set_logical_option('logical', .true.)
    if (error /= OK) stop 1
    if (c1%find_option_local('logical') /= OK) stop 1
    if (c1%find_option('logical') /= OK) stop 1
    if (c1%count_local() /= 4_IK) stop 1
    if (c1%count() /= 4_IK) stop 1
    if (c1%get_logical_option('logical') .neqv. .true.) stop 1

    error = c1%define_enum_option('enum', 'a;b')
    if (error /= OK) stop 1
    if (c1%find_enum_local('enum') /= OK) stop 1
    if (c1%find_enum('enum') /= OK) stop 1
    if (c1%validate_enum_option('enum', 'a') /= OK) stop 1
    if (c1%validate_enum_option('enum', 'b') /= OK) stop 1
    if (c1%validate_enum_option('enum', 'c') /= INVALID_OPTION) stop 1
    error = c1%set_enum_option('enum', 'a')
    if (error /= OK) stop 1
    if (c1%count_local() /= 5_IK) stop 1
    if (c1%count() /= 5_IK) stop 1
    if (c1%get_enum_option('enum') /= 'a') stop 1
    error = c1%set_enum_option('enum', 'c')
    if (error /= INVALID_OPTION) stop 1
    if (c1%validate_enum_option('missing', 'a') /= NO_SUCH_OPTION) stop 1

    c2 = c1
    if (c2%count_local() /= 5_IK) stop 1
    if (c2%count() /= 5_IK) stop 1
    if (c2%level /= 0_IK) stop 1
    if (associated(c2%parent)) stop 1
    if (c2%find_option_local('integer') /= OK) stop 1
    if (c2%find_option('integer') /= OK) stop 1
    if (c2%get_integer_option('integer') /= 1_IK) stop 1
    if (c2%get_string_option('string') /= 'abc') stop 1
    if (c2%get_real_option('real') /= 1.0_RK) stop 1
    if (c2%get_logical_option('logical') .neqv. .true.) stop 1
    if (c2%validate_enum_option('enum', 'a') /= OK) stop 1
    if (c2%validate_enum_option('enum', 'b') /= OK) stop 1
    if (c2%validate_enum_option('enum', 'c') /= INVALID_OPTION) stop 1
    if (c2%get_enum_option('enum') /= 'a') stop 1
    error = c2%set_enum_option('enum', 'c')
    if (error /= INVALID_OPTION) stop 1
    if (c2%validate_enum_option('missing', 'a') /= NO_SUCH_OPTION) stop 1

    c3 = c1%link()
    if (c3%count_local() /= 0_IK) stop 1
    if (c3%count() /= 5_IK) stop 1
    if (c3%level /= 1_IK) stop 1
    if (.not. associated(c3%parent)) stop 1
    if (c3%find_option_local('integer') /= NO_SUCH_OPTION) stop 1
    if (c3%find_option('integer') /= OK) stop 1
    if (c3%get_integer_option('integer') /= 1_IK) stop 1
    if (c3%find_option_local('missing') /= NO_SUCH_OPTION) stop 1
    if (c3%find_option('missing') /= NO_SUCH_OPTION) stop 1
    error = c3%set_integer_option('integer_1', 2_IK)
    if (error /= OK) stop 1
    if (c3%count_local() /= 1_IK) stop 1
    if (c3%count() /= 6_IK) stop 1
    if (c3%find_option_local('integer_1') /= OK) stop 1
    if (c3%find_option('integer_1') /= OK) stop 1
    if (c3%get_integer_option('integer_1') /= 2_IK) stop 1
    error = c3%set_string_option('string', 'xyz')
    if (error /= OK) stop 1
    if (c3%count_local() /= 2_IK) stop 1
    if (c3%count() /= 7_IK) stop 1
    if (c3%find_option_local('string') /= OK) stop 1
    if (c3%find_option('string') /= OK) stop 1
    if (c3%get_string_option('string') /= 'xyz') stop 1
    if (c3%validate_enum_option('enum', 'a') /= OK) stop 1
    if (c3%validate_enum_option('enum', 'b') /= OK) stop 1
    if (c3%validate_enum_option('enum', 'c') /= INVALID_OPTION) stop 1
    error = c3%set_enum_option('enum', 'b')
    if (error /= OK) stop 1
    if (c3%count_local() /= 3_IK) stop 1
    if (c3%count() /= 8_IK) stop 1
    if (c3%get_enum_option('enum') /= 'b') stop 1
    error = c3%define_enum_option('enum', 'p')
    if (error /= OK) stop 1
    if (c3%validate_enum_option('enum', 'p') /= OK) stop 1
    if (c3%validate_enum_option('enum', 'q') /= INVALID_OPTION) stop 1
    error = c3%set_enum_option('enum', 'p')
    if (error /= OK) stop 1
    error = c3%set_enum_option('enum', 'a')
    if (error /= INVALID_OPTION) stop 1
    if (c3%get_enum_option('enum') /= 'p') stop 1

    if (c1%find_option_local('integer_1') /= NO_SUCH_OPTION) stop 1
    if (c1%find_option('integer_1') /= NO_SUCH_OPTION) stop 1
    if (c1%get_string_option('string') /= 'abc') stop 1
    if (c1%get_enum_option('enum') /= 'a') stop 1

    error = c1%set_integer_option('integer', 3_IK)
    if (error /= OK) stop 1
    if (c1%get_integer_option('integer') /= 3_IK) stop 1
    if (c3%get_integer_option('integer') /= 3_IK) stop 1

    c4 = c3
    if (c4%count_local() /= 3_IK) stop 1
    if (c4%count() /= 8_IK) stop 2
    if (c4%level /= 1_IK) stop 1
    if (.not. associated(c4%parent)) stop 1
    if (c4%get_integer_option('integer') /= 3_IK) stop 1
    if (c4%get_integer_option('integer_1') /= 2_IK) stop 1
    if (c4%find_option_local('string') /= OK) stop 1
    if (c4%find_option('string') /= OK) stop 1
    if (c4%get_string_option('string') /= 'xyz') stop 1
    if (c4%validate_enum_option('enum', 'p') /= OK) stop 1
    if (c4%validate_enum_option('enum', 'q') /= INVALID_OPTION) stop 1
    error = c4%set_enum_option('enum', 'p')
    if (error /= OK) stop 1
    error = c4%set_enum_option('enum', 'a')
    if (error /= INVALID_OPTION) stop 1
    if (c4%get_enum_option('enum') /= 'p') stop 1

end program test_options
