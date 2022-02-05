module options

    use kinds, only: IK, RK
    use dict, only: entry_t, dict_t
    implicit none

    character(len=*), parameter :: delim = ';'
    integer(IK), parameter :: max_depth = 10_IK

    type config_t
        type(dict_t), allocatable :: options, enums
        integer(IK) :: level = 0_IK
        type(config_t), pointer :: parent => null()
    contains
        procedure, pass :: initialize => config_initialize
        procedure, pass :: link => config_link
        procedure, pass :: count_local => config_count_local
        procedure, pass :: count => config_count
        procedure, pass :: find_option_local => config_find_option_local
        procedure, pass :: find_option => config_find_option
        procedure, pass :: find_enum_local => config_find_enum_local
        procedure, pass :: find_enum => config_find_enum
        procedure, pass :: get_option_entry => config_get_option_entry
        procedure, pass :: get_enum_entry => config_get_enum_entry
        procedure, pass :: get_integer_option => config_get_integer_option
        procedure, pass :: set_integer_option => config_set_integer_option
        procedure, pass :: get_string_option => config_get_string_option
        procedure, pass :: set_string_option => config_set_string_option
        procedure, pass :: get_real_option => config_get_real_option
        procedure, pass :: set_real_option => config_set_real_option
        procedure, pass :: get_logical_option => config_get_logical_option
        procedure, pass :: set_logical_option => config_set_logical_option
        procedure, pass :: validate_enum_option => config_validate_enum_option
        procedure, pass :: get_enum_option => config_get_enum_option
        procedure, pass :: define_enum_option => config_define_enum_option
        procedure, pass :: set_enum_option => config_set_enum_option
        final :: config_finalize
    end type config_t

contains

    function config_initialize(config) result(error)

        use kinds, only: IK
        use errors, only: OK
        implicit none

        class(config_t), intent(inout) :: config
        integer(IK) :: error

        integer(IK) :: err

        if (allocated(config%options)) deallocate (config%options)
        if (allocated(config%enums)) deallocate (config%enums)
        if (associated(config%parent)) nullify (config%parent)
        allocate (config%options, config%enums)

        err = config%options%initialize()
        if (err /= OK) then
            error = err
            return
        end if

        err = config%enums%initialize()
        if (err /= OK) then
            error = err
            return
        end if

        error = OK

    end function config_initialize

    function config_link(config) result(child)

        use kinds, only: IK
        use errors, only: OK
        implicit none

        class(config_t), target, intent(in) :: config
        type(config_t), allocatable :: child

        integer(IK) :: err

        allocate (child)
        err = child%initialize()
        if (err /= OK) return
        if (config%level >= max_depth) return

        child%level = config%level + 1_IK
        child%parent => config

    end function config_link

    function config_count_local(config) result(count)

        use kinds, only: IK
        implicit none

        class(config_t), intent(in) :: config
        integer(IK) :: count

        count = config%options%count()

    end function config_count_local

    recursive function config_count(config) result(count)

        use kinds, only: IK
        implicit none

        class(config_t), intent(in) :: config
        integer(IK) :: count

        count = config%options%count()
        if (associated(config%parent)) count = count + config%parent%count()

    end function config_count

    function config_find_option_local(config, key) result(error)

        use kinds, only: IK
        use errors, only: OK, KEY_NOT_FOUND, NO_SUCH_OPTION
        implicit none

        class(config_t), intent(in) :: config
        character(len=*), intent(in) :: key
        integer(IK) :: error

        integer(IK) :: pos

        pos = config%options%find_key(key)
        if (pos == KEY_NOT_FOUND) then
            error = NO_SUCH_OPTION
        else
            error = OK
        end if

    end function config_find_option_local

    recursive function config_find_option(config, key) result(error)

        use kinds, only: IK
        use errors, only: OK, KEY_NOT_FOUND, NO_SUCH_OPTION
        implicit none

        class(config_t), intent(in) :: config
        character(len=*), intent(in) :: key
        integer(IK) :: error

        integer(IK) :: pos

        pos = config%options%find_key(key)
        if (pos == KEY_NOT_FOUND) then
            if (associated(config%parent)) then
                error = config%parent%find_option(key)
            else
                error = NO_SUCH_OPTION
            end if
        else
            error = OK
        end if

    end function config_find_option

    function config_find_enum_local(config, key) result(error)

        use kinds, only: IK
        use errors, only: OK, KEY_NOT_FOUND, NO_SUCH_OPTION
        implicit none

        class(config_t), intent(in) :: config
        character(len=*), intent(in) :: key
        integer(IK) :: error

        integer(IK) :: pos

        pos = config%enums%find_key(key)
        if (pos == KEY_NOT_FOUND) then
            error = NO_SUCH_OPTION
        else
            error = OK
        end if

    end function config_find_enum_local

    recursive function config_find_enum(config, key) result(error)

        use kinds, only: IK
        use errors, only: OK, KEY_NOT_FOUND, NO_SUCH_OPTION
        implicit none

        class(config_t), intent(in) :: config
        character(len=*), intent(in) :: key
        integer(IK) :: error

        integer(IK) :: pos

        pos = config%enums%find_key(key)
        if (pos == KEY_NOT_FOUND) then
            if (associated(config%parent)) then
                error = config%parent%find_enum(key)
            else
                error = NO_SUCH_OPTION
            end if
        else
            error = OK
        end if

    end function config_find_enum

    recursive function config_get_option_entry(config, key) result(entry)

        use kinds, only: IK
        use errors, only: KEY_NOT_FOUND
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*), intent(in) :: key
        type(entry_t), allocatable :: entry

        integer(IK) :: pos

        pos = config%options%find_key(key)
        if (pos == KEY_NOT_FOUND) then
            if (associated(config%parent)) then
                entry = config%parent%get_option_entry(key)
            else
                entry = entry_t(key, '')
            end if
        else
            entry = config%options%retrieve_entry(pos)
        end if

    end function config_get_option_entry

    recursive function config_get_enum_entry(config, key) result(entry)

        use kinds, only: IK
        use errors, only: KEY_NOT_FOUND
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*), intent(in) :: key
        type(entry_t), allocatable :: entry

        integer(IK) :: pos

        pos = config%enums%find_key(key)
        if (pos == KEY_NOT_FOUND) then
            if (associated(config%parent)) then
                entry = config%parent%get_enum_entry(key)
            else
                entry = entry_t(key, '')
            end if
        else
            entry = config%enums%retrieve_entry(pos)
        end if

    end function config_get_enum_entry

    function config_get_integer_option(config, key) result(value)

        use kinds, only: IK
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*), intent(in) :: key
        integer(IK) :: value

        type(entry_t) :: entry

        entry = config%get_option_entry(key)
        value = entry%as_integer()

    end function config_get_integer_option

    function config_set_integer_option(config, key, value) result(error)

        use kinds, only: IK
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*), intent(in) :: key
        integer(IK), intent(in) :: value
        integer(IK) :: error

        error = config%options%put(key, value)

    end function config_set_integer_option

    function config_get_string_option(config, key) result(value)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*), intent(in) :: key
        character(len=:), allocatable :: value

        type(entry_t) :: entry

        entry = config%get_option_entry(key)
        value = entry%as_string()

    end function config_get_string_option

    function config_set_string_option(config, key, value) result(error)

        use kinds, only: IK
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*), intent(in) :: key, value
        integer(IK) :: error

        error = config%options%put(key, value)

    end function config_set_string_option

    function config_get_real_option(config, key) result(value)

        use kinds, only: RK
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*), intent(in) :: key
        real(RK) :: value

        type(entry_t) :: entry

        entry = config%get_option_entry(key)
        value = entry%as_real()

    end function config_get_real_option

    function config_set_real_option(config, key, value) result(error)

        use kinds, only: IK, RK
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*), intent(in) :: key
        real(RK), intent(in) :: value
        integer(IK) :: error

        error = config%options%put(key, value)

    end function config_set_real_option

    function config_get_logical_option(config, key) result(value)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*), intent(in) :: key
        logical :: value

        type(entry_t) :: entry

        entry = config%get_option_entry(key)
        value = entry%as_logical()

    end function config_get_logical_option

    function config_set_logical_option(config, key, value) result(error)

        use kinds, only: IK
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*), intent(in) :: key
        logical, intent(in) :: value
        integer(IK) :: error

        error = config%options%put(key, value)

    end function config_set_logical_option

    function config_validate_enum_option(config, key, value) result(error)

        use kinds, only: IK
        use errors, only: OK, KEY_NOT_FOUND, NO_SUCH_OPTION, INVALID_OPTION
        use utils, only: contains
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*), intent(in) :: key, value
        integer(IK) :: error

        integer(IK) :: err
        type(entry_t) :: entry
        character(len=:), allocatable :: values

        err = config%find_enum(key)
        if (err /= OK) then
            error = err
            return
        end if

        entry = config%get_enum_entry(key)
        values = entry%as_string()
        if (contains(values, value, delim)) then
            error = OK
        else
            error = INVALID_OPTION
        end if

    end function config_validate_enum_option

    function config_get_enum_option(config, key) result(value)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*), intent(in) :: key
        character(len=:), allocatable :: value

        type(entry_t) :: entry

        entry = config%get_option_entry(key)
        value = entry%as_string()

    end function config_get_enum_option

    function config_define_enum_option(config, key, values) result(error)

        use kinds, only: IK
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*), intent(in) :: key, values
        integer(IK) :: error

        error = config%enums%put(key, values)

    end function config_define_enum_option

    function config_set_enum_option(config, key, value) result(error)

        use kinds, only: IK
        use utils, only: contains
        use errors, only: OK
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*), intent(in) :: key, value
        integer(IK) :: error

        integer(IK) :: err

        err = config%validate_enum_option(key, value)
        if (err /= OK) then
            error = err
            return
        end if

        error = config%options%put(key, value)

    end function config_set_enum_option

    subroutine config_finalize(config)
        implicit none
        type(config_t), intent(inout) :: config

        if (allocated(config%options)) deallocate (config%options)
        if (allocated(config%enums)) deallocate (config%enums)
        if (associated(config%parent)) nullify (config%parent)
    end subroutine config_finalize

end module options
