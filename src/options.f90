module options

    use kinds, only: IK, RK, AK, LK
    use dict, only: entry_t, dict_t, make_entry
    implicit none

    character(len=*, kind=AK), parameter :: delim = ';'
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
        procedure, pass :: length_string_option => config_length_string_option
        procedure, pass :: get_string_option => config_get_string_option
        procedure, pass :: set_string_option => config_set_string_option
        procedure, pass :: get_real_option => config_get_real_option
        procedure, pass :: set_real_option => config_set_real_option
        procedure, pass :: get_logical_option => config_get_logical_option
        procedure, pass :: set_logical_option => config_set_logical_option
        procedure, pass :: get_enum_option => config_get_enum_option
        procedure, pass :: set_enum_option => config_set_enum_option
        procedure, pass :: length_enum_option => config_length_enum_option
        procedure, pass :: define_enum_option => config_define_enum_option
        procedure, pass :: validate_enum_option => config_validate_enum_option
        procedure, pass :: count_enum_option => config_count_enum_option
        procedure, pass :: longest_enum_option => config_longest_enum_option
        procedure, pass :: index_enum_option => config_index_enum_option
        procedure, pass :: search_enum_option => config_search_enum_option
        final :: config_finalize
    end type config_t

contains

    function config_initialize(config) result(error)

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

        implicit none

        class(config_t), intent(in) :: config
        integer(IK) :: count

        count = config%options%count()

    end function config_count_local

    recursive function config_count(config) result(count)

        implicit none

        class(config_t), intent(in) :: config
        integer(IK) :: count

        count = config%options%count()
        if (associated(config%parent)) count = count + config%parent%count()

    end function config_count

    function config_find_option_local(config, key) result(error)

        use errors, only: OK, KEY_NOT_FOUND, NO_SUCH_OPTION
        implicit none

        class(config_t), intent(in) :: config
        character(len=*, kind=AK), intent(in) :: key
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

        use errors, only: OK, KEY_NOT_FOUND, NO_SUCH_OPTION
        implicit none

        class(config_t), intent(in) :: config
        character(len=*, kind=AK), intent(in) :: key
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

        use errors, only: OK, KEY_NOT_FOUND, NO_SUCH_OPTION
        implicit none

        class(config_t), intent(in) :: config
        character(len=*, kind=AK), intent(in) :: key
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

        use errors, only: OK, KEY_NOT_FOUND, NO_SUCH_OPTION
        implicit none

        class(config_t), intent(in) :: config
        character(len=*, kind=AK), intent(in) :: key
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

        use errors, only: KEY_NOT_FOUND
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        type(entry_t) :: entry

        integer(IK) :: pos

        pos = config%options%find_key(key)
        if (pos == KEY_NOT_FOUND) then
            if (associated(config%parent)) then
                entry = config%parent%get_option_entry(key)
            else
                entry = make_entry(key, '')
            end if
        else
            entry = config%options%retrieve_entry(pos)
        end if

    end function config_get_option_entry

    recursive function config_get_enum_entry(config, key) result(entry)

        use errors, only: KEY_NOT_FOUND
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        type(entry_t) :: entry

        integer(IK) :: pos

        pos = config%enums%find_key(key)
        if (pos == KEY_NOT_FOUND) then
            if (associated(config%parent)) then
                entry = config%parent%get_enum_entry(key)
            else
                entry = make_entry(key, '')
            end if
        else
            entry = config%enums%retrieve_entry(pos)
        end if

    end function config_get_enum_entry

    function config_get_integer_option(config, key) result(val)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        integer(IK) :: val

        type(entry_t) :: entry

        entry = config%get_option_entry(key)
        val = entry%as_integer()

    end function config_get_integer_option

    function config_set_integer_option(config, key, val) result(error)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        integer(IK), intent(in) :: val
        integer(IK) :: error

        error = config%options%put(key, val)

    end function config_set_integer_option

    function config_get_string_option(config, key) result(val)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        character(len=:, kind=AK), allocatable :: val

        type(entry_t) :: entry

        entry = config%get_option_entry(key)
        val = entry%as_string()

    end function config_get_string_option

    function config_set_string_option(config, key, val) result(error)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key, val
        integer(IK) :: error

        error = config%options%put(key, val)

    end function config_set_string_option

    function config_length_string_option(config, key) result(length)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        integer(IK) :: length

        type(entry_t) :: entry

        entry = config%get_option_entry(key)
        length = entry%get_length()

    end function config_length_string_option

    function config_get_real_option(config, key) result(val)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        real(RK) :: val

        type(entry_t) :: entry

        entry = config%get_option_entry(key)
        val = entry%as_real()

    end function config_get_real_option

    function config_set_real_option(config, key, val) result(error)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        real(RK), intent(in) :: val
        integer(IK) :: error

        error = config%options%put(key, val)

    end function config_set_real_option

    function config_get_logical_option(config, key) result(val)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        logical(LK) :: val

        type(entry_t) :: entry

        entry = config%get_option_entry(key)
        val = entry%as_logical()

    end function config_get_logical_option

    function config_set_logical_option(config, key, val) result(error)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        logical(LK), intent(in) :: val
        integer(IK) :: error

        error = config%options%put(key, val)

    end function config_set_logical_option

    function config_get_enum_option(config, key) result(val)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        character(len=:, kind=AK), allocatable :: val

        type(entry_t) :: entry

        entry = config%get_option_entry(key)
        val = entry%as_string()

    end function config_get_enum_option

    function config_set_enum_option(config, key, val) result(error)

        use errors, only: OK
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key, val
        integer(IK) :: error

        integer(IK) :: err

        err = config%validate_enum_option(key, val)
        if (err /= OK) then
            error = err
            return
        end if

        error = config%options%put(key, val)

    end function config_set_enum_option

    function config_length_enum_option(config, key) result(length)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        integer(IK) :: length

        type(entry_t) :: entry

        entry = config%get_option_entry(key)
        length = entry%get_length()

    end function config_length_enum_option

    function config_define_enum_option(config, key, vals) result(error)

        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key, vals
        integer(IK) :: error

        error = config%enums%put(key, vals)

    end function config_define_enum_option

    function config_validate_enum_option(config, key, val) result(error)

        use errors, only: OK, INVALID_OPTION
        use utils, only: contains
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key, val
        integer(IK) :: error

        integer(IK) :: err
        type(entry_t) :: entry
        character(len=:, kind=AK), allocatable :: vals

        err = config%find_enum(key)
        if (err /= OK) then
            error = err
            return
        end if

        entry = config%get_enum_entry(key)
        vals = entry%as_string()
        if (contains(vals, val, delim)) then
            error = OK
        else
            error = INVALID_OPTION
        end if

        deallocate (vals)

    end function config_validate_enum_option

    function config_count_enum_option(config, key) result(count1)

        use utils, only: count
        use errors, only: OK
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        integer(IK) :: count1

        integer(IK) :: err
        type(entry_t) :: entry
        character(len=:, kind=AK), allocatable :: vals

        err = config%find_enum(key)
        if (err /= OK) then
            count1 = err
            return
        end if

        entry = config%get_enum_entry(key)
        vals = entry%as_string()

        if (vals == '') then
            count1 = 0_IK
        else
            count1 = count(vals, delim) + 1_IK
        end if

        deallocate (vals)

    end function config_count_enum_option

    function config_longest_enum_option(config, key) result(length)

        use utils, only: longest
        use errors, only: OK
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        integer(IK) :: length

        integer(IK) :: err
        type(entry_t) :: entry
        character(len=:, kind=AK), allocatable :: vals

        err = config%find_enum(key)
        if (err /= OK) then
            length = err
            return
        end if

        entry = config%get_enum_entry(key)
        vals = entry%as_string()

        length = longest(vals, delim)

        deallocate (vals)

    end function config_longest_enum_option

    function config_index_enum_option(config, key, index) result(val)

        use errors, only: OK
        use utils, only: substring
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key
        integer(IK), intent(in) :: index
        character(len=:, kind=AK), allocatable :: val

        integer(IK) :: err
        type(entry_t) :: entry
        character(len=:, kind=AK), allocatable :: vals

        err = config%find_enum(key)
        if (err /= OK) then
            val = ''
            return
        end if

        entry = config%get_enum_entry(key)
        vals = entry%as_string()
        val = substring(vals, index, delim)

        deallocate (vals)

    end function config_index_enum_option

    function config_search_enum_option(config, key, val) result(index)

        use errors, only: OK, NO_SUCH_OPTION, INVALID_OPTION
        use utils, only: contains, find
        implicit none

        class(config_t), intent(inout) :: config
        character(len=*, kind=AK), intent(in) :: key, val
        integer(IK) :: index

        integer(IK) :: err
        type(entry_t) :: entry
        character(len=:, kind=AK), allocatable :: vals

        err = config%find_enum(key)
        if (err /= OK) then
            index = NO_SUCH_OPTION
            return
        end if

        entry = config%get_enum_entry(key)
        vals = entry%as_string()

        if (.not. contains(vals, val, delim)) then
            index = INVALID_OPTION
            return
        end if

        index = find(vals, val, delim)

        deallocate (vals)

    end function config_search_enum_option

    subroutine config_finalize(config)
        implicit none
        type(config_t), intent(inout) :: config

        if (allocated(config%options)) deallocate (config%options)
        if (allocated(config%enums)) deallocate (config%enums)
        if (associated(config%parent)) nullify (config%parent)
    end subroutine config_finalize

end module options
