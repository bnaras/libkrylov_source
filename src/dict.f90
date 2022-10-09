module dict

    use kinds, only: IK, RK, AK, LK

    type entry_t
        character(len=:, kind=AK), allocatable :: key, val
    contains
        procedure, pass :: get_key => entry_get_key
        procedure, pass :: get_length => entry_get_length
        procedure, pass :: as_integer => entry_as_integer
        procedure, pass :: as_string => entry_as_string
        procedure, pass :: as_real => entry_as_real
        procedure, pass :: as_logical => entry_as_logical
        final :: entry_finalize
    end type entry_t

    type dict_t
        type(entry_t), allocatable :: data(:)
    contains
        procedure, pass :: initialize => dict_initialize
        procedure, pass :: count => dict_count
        procedure, pass :: clear => dict_clear
        procedure, pass :: find_key => dict_find_key
        procedure, pass :: retrieve_entry => dict_retrieve_entry
        procedure, pass :: get_entry => dict_get_entry
        procedure, pass :: put_entry => dict_put_entry
        procedure, pass :: delete => dict_delete
        procedure, pass :: put => dict_put
        procedure, pass :: get_length => dict_get_length
        procedure, pass :: get_integer => dict_get_integer
        procedure, pass :: get_string => dict_get_string
        procedure, pass :: get_real => dict_get_real
        procedure, pass :: get_logical => dict_get_logical
        final :: dict_finalize
    end type dict_t

contains

    function get_length(val) result(length)

        implicit none

        class(*), intent(in) :: val
        integer(IK) :: length

        integer(IK) :: sv, sa

        select type (val)
        type is (character(len=*, kind=AK))
            length = len(val, kind=IK)
        class default
            sv = storage_size(val, kind=IK)
            sa = storage_size('a', kind=IK)
            length = sv / sa
            if (length * sa > sv) length = length + 1_IK
        end select

    end function get_length

    function make_entry(key, val) result(entry)

        implicit none

        character(len=*, kind=AK), intent(in) :: key
        class(*), intent(in) :: val
        type(entry_t) :: entry

        entry%key = key

        allocate (character(len=get_length(val), kind=AK) :: entry%val)
        select type (val)
        type is (character(len=*, kind=AK))
            entry%val = val
        class default
            entry%val = transfer(val, entry%val)
        end select

    end function make_entry

    function entry_get_key(entry) result(key)

        implicit none
        class(entry_t), intent(in) :: entry
        character(len=:, kind=AK), allocatable :: key

        key = entry%key

    end function entry_get_key

    function entry_get_length(entry) result(length)

        implicit none

        class(entry_t) :: entry
        integer(IK) :: length

        length = get_length(entry%val)

    end function entry_get_length

    function entry_as_integer(entry) result(val)

        implicit none

        class(entry_t), intent(in) :: entry
        integer(IK) :: val

        val = transfer(entry%val, val)

    end function entry_as_integer

    function entry_as_string(entry) result(val)

        implicit none

        class(entry_t), intent(in) :: entry
        character(len=:, kind=AK), allocatable :: val

        val = entry%val

    end function entry_as_string

    function entry_as_real(entry) result(val)

        implicit none

        class(entry_t), intent(in) :: entry
        real(RK) :: val

        val = transfer(entry%val, val)

    end function entry_as_real

    function entry_as_logical(entry) result(val)

        implicit none

        class(entry_t), intent(in) :: entry
        logical(LK) :: val

        val = transfer(entry%val, val)

    end function entry_as_logical

    subroutine entry_finalize(entry)

        implicit none
        type(entry_t), intent(inout) :: entry

        if (allocated(entry%key)) deallocate (entry%key)
        if (allocated(entry%val)) deallocate (entry%val)

    end subroutine entry_finalize

    function dict_initialize(dict) result(error)

        use kinds, only: IK
        use errors, only: OK
        implicit none

        class(dict_t), intent(inout) :: dict
        integer(IK) :: error

        if (allocated(dict%data)) deallocate (dict%data)
        allocate (dict%data(0_IK))
        error = OK

    end function dict_initialize

    function dict_count(dict) result(count)

        implicit none

        class(dict_t), intent(in) :: dict
        integer(IK) :: count

        if (.not. allocated(dict%data)) then
            count = 0_IK
        else
            count = size(dict%data, kind=IK)
        end if

    end function dict_count

    function dict_clear(dict) result(error)

        use errors, only: OK
        implicit none

        class(dict_t), intent(inout) :: dict
        integer(IK) :: error

        deallocate (dict%data)
        allocate (dict%data(0_IK))

        error = OK

    end function dict_clear

    function dict_find_key(dict, key) result(pos)

        use errors, only: KEY_NOT_FOUND
        implicit none

        class(dict_t), intent(in) :: dict
        character(len=*, kind=AK), intent(in) :: key
        integer(IK) :: pos

        logical(LK) :: found

        found = .false._LK
        do pos = 1_IK, dict%count()
            if (dict%data(pos)%key == key) then
                found = .true._LK
                exit
            end if
        end do

        if (.not.found) pos = KEY_NOT_FOUND

    end function dict_find_key

    function dict_retrieve_entry(dict, pos) result(entry)

        use errors, only: KEY_NOT_FOUND
        implicit none

        class(dict_t), intent(in) :: dict
        integer(IK), intent(in) :: pos
        type(entry_t) :: entry

        if (pos > dict%count()) then
            entry = make_entry('', '')
        else
            entry = dict%data(pos)
        end if

    end function dict_retrieve_entry

    function dict_get_entry(dict, key) result(entry)

        use errors, only: KEY_NOT_FOUND
        implicit none

        class(dict_t), intent(in) :: dict
        character(len=*, kind=AK), intent(in) :: key
        type(entry_t) :: entry

        integer(IK) :: pos

        pos = dict%find_key(key)
        if (pos == KEY_NOT_FOUND) then
            entry = make_entry(key, '')
        else
            entry = dict%retrieve_entry(pos)
        end if

    end function dict_get_entry

    function dict_put_entry(dict, entry) result(error)

        use errors, only: OK, KEY_NOT_FOUND
        implicit none

        class(dict_t), intent(inout) :: dict
        class(entry_t), intent(in) :: entry
        integer(IK) :: error

        integer(IK) :: pos, length
        type(entry_t), allocatable :: data_tmp(:)

        pos = dict%find_key(entry%key)
        if (pos /= KEY_NOT_FOUND) then
            dict%data(pos) = entry
            error = OK
            return
        end if

        length = dict%count()

        do pos = 1_IK, length
            if (dict%data(pos)%key > entry%key) exit
        end do
        pos = pos - 1_IK

        allocate (data_tmp(length + 1_IK))
        if (pos > 0_IK) data_tmp(1_IK:pos) = dict%data(1_IK:pos)
        data_tmp(pos + 1_IK) = entry
        if (pos < length) data_tmp(pos + 2_IK:length + 1_IK) = dict%data(pos + 1_IK:length)
        call move_alloc(data_tmp, dict%data)

        error = OK

    end function dict_put_entry

    function dict_delete(dict, key) result(error)

        use errors, only: OK, KEY_NOT_FOUND
        implicit none

        class(dict_t), intent(inout) :: dict
        character(len=*, kind=AK), intent(in) :: key
        integer(IK) :: error

        integer(IK) :: pos, length
        type(entry_t), allocatable :: data_tmp(:)

        pos = dict%find_key(key)
        if (pos == KEY_NOT_FOUND) then
            error = KEY_NOT_FOUND
            return
        end if

        length = dict%count()

        allocate (data_tmp(length - 1_IK))
        if (pos > 1_IK) data_tmp(1_IK:pos - 1_IK) = dict%data(1_IK:pos - 1_IK)
        if (pos < length) data_tmp(pos:length - 1_IK) = dict%data(pos + 1_IK:length)
        call move_alloc(data_tmp, dict%data)

        error = OK

    end function dict_delete

    function dict_put(dict, key, val) result(error)

        implicit none

        class(dict_t), intent(inout) :: dict
        character(len=*, kind=AK), intent(in) :: key
        class(*), intent(in) :: val
        integer(IK) :: error

        error = dict%put_entry(make_entry(key, val))

    end function dict_put

    function dict_get_integer(dict, key) result(val)

        implicit none

        class(dict_t), intent(in) :: dict
        character(len=*, kind=AK), intent(in) :: key
        integer(IK) :: val

        type(entry_t) :: entry

        entry = dict%get_entry(key)
        val = entry%as_integer()

    end function dict_get_integer

    function dict_get_length(dict, key) result(length)

        implicit none

        class(dict_t), intent(in) :: dict
        character(len=*, kind=AK), intent(in) :: key
        integer(IK) :: length

        type(entry_t) :: entry

        entry = dict%get_entry(key)
        length = entry%get_length()

    end function dict_get_length

    function dict_get_string(dict, key) result(val)

        implicit none

        class(dict_t), intent(in) :: dict
        character(len=*, kind=AK), intent(in) :: key
        character(len=:, kind=AK), allocatable :: val

        type(entry_t) :: entry

        entry = dict%get_entry(key)
        val = entry%as_string()

    end function dict_get_string

    function dict_get_real(dict, key) result(val)

        implicit none

        class(dict_t), intent(in) :: dict
        character(len=*, kind=AK), intent(in) :: key
        real(RK) :: val

        type(entry_t) :: entry

        entry = dict%get_entry(key)
        val = entry%as_real()

    end function dict_get_real

    function dict_get_logical(dict, key) result(val)

        implicit none

        class(dict_t), intent(in) :: dict
        character(len=*, kind=AK), intent(in) :: key
        logical(LK) :: val

        type(entry_t) :: entry

        entry = dict%get_entry(key)
        val = entry%as_logical()

    end function dict_get_logical

    subroutine dict_finalize(dict)

        implicit none
        type(dict_t), intent(inout) :: dict

        if (allocated(dict%data)) deallocate (dict%data)

    end subroutine dict_finalize

end module dict
