module logging

    use iso_fortran_env, only: error_unit
    implicit none

    integer, parameter :: ERROR_LEVEL_TRACE = 0, &
                          ERROR_LEVEL_DEBUG = 10, &
                          ERROR_LEVEL_INFO = 20, &
                          ERROR_LEVEL_WARNING = 30, &
                          ERROR_LEVEL_ERROR = 40, &
                          ERROR_LEVEL_CRITICAL = 50, &
                          ERROR_LEVEL_SILENT = 60

#ifdef LOG_LEVEL_TRACE
    integer, parameter :: ERROR_LEVEL = ERROR_LEVEL_TRACE
#elif defined LOG_LEVEL_DEBUG
    integer, parameter :: ERROR_LEVEL = ERROR_LEVEL_DEBUG
#elif defined LOG_LEVEL_WARNING
    integer, parameter :: ERROR_LEVEL = ERROR_LEVEL_WARNING
#elif defined LOG_LEVEL_INFO
    integer, parameter :: ERROR_LEVEL = ERROR_LEVEL_INFO
#elif defined LOG_LEVEL_ERROR
    integer, parameter :: ERROR_LEVEL = ERROR_LEVEL_ERROR
#elif defined LOG_LEVEL_CRITICAL
    integer, parameter :: ERROR_LEVEL = ERROR_LEVEL_CRITICAL
#elif defined LOG_LEVEL_SILENT
    integer, parameter :: ERROR_LEVEL = ERROR_LEVEL_SILENT
#else
    integer, parameter :: ERROR_LEVEL = ERROR_LEVEL_ERROR
#endif

contains

    function fmt(val) result(string)

        use kinds, only: IK, RK, CK, AK, LK

        class(*), intent(in) :: val
        character(kind=AK, len=:), allocatable :: string

        character(kind=AK, len=:), allocatable :: re, im

        select type (val)
        type is (integer(IK))
            allocate (character(len=8) :: string)
            write (string, '(i8)') val
        type is (real(RK))
            allocate (character(len=20) :: string)
            write (string, '(g20.12)') val
        type is (complex(CK))
            allocate (character(len=20) :: re, im)
            allocate (character(len=43) :: string)
            write (re, '(g20.12)') real(val)
            write (im, '(g20.12)') aimag(val)
            write (string, '(a)') '('//trim(adjustl(re))//','//trim(adjustl(im))//')'
            deallocate (re, im)
        type is (character(kind=AK, len=*))
            string = val
        type is (logical(kind=LK))
            allocate (character(kind=AK, len=1) :: string)
            write (string, '(l1)') val
        end select

        string = trim(adjustl(string))

    end function fmt

    function fmt_vec(val) result(string)

        use kinds, only: IK, RK, CK
        implicit none

        class(*), intent(in) :: val(:)
        character(len=:), allocatable :: string

        string = ''

        select type (val)
        type is (integer(IK))
            string = fmt_aux(val, 8_IK, 65_IK, 'i8')
        type is (real(RK))
            string = fmt_aux(val, 4_IK, 81_IK, 'g20.12')
        type is (complex(CK))
            string = fmt_aux(val, 2_IK, 87_IK, '(a,g20.12,a,g20.12,a)')
        end select

    end function fmt_vec

    function fmt_mat(val) result(string)

        use kinds, only: IK, RK, CK
        implicit none

        class(*), intent(in) :: val(:, :)
        character(len=:), allocatable :: string

        string = ''

        select type (val)
        type is (integer(IK))
            string = fmt_aux(reshape(val, (/size(val)/)), 8_IK, 65_IK, 'i8')
        type is (real(RK))
            string = fmt_aux(reshape(val, (/size(val)/)), 4_IK, 81_IK, 'g20.12')
        type is (complex(CK))
            string = fmt_aux(reshape(val, (/size(val)/)), 2_IK, 87_IK, '(a,g20.12,a,g20.12,a)')
        end select

    end function fmt_mat

    function fmt_aux(val, max_length, line_length, fmt) result(string)

        use kinds, only: IK, RK, CK
        implicit none

        class(*), intent(in) :: val(:)
        integer(IK), intent(in) :: max_length, line_length
        character(len=*), intent(in) :: fmt
        character(len=:), allocatable :: string

        integer(IK) :: dim, lines, line, length, offset, pos, i
        character(len=80) :: line_fmt

        dim = size(val)
        lines = (dim - 1_IK)/max_length + 1_IK

        allocate (character(len=lines*line_length) :: string)

        do line = 1_IK, lines
            offset = (line - 1_IK)*max_length
            length = min(max_length, dim - offset)
            pos = (line - 1_IK)*line_length
            line_fmt = ''
            write (line_fmt, '(a, i4, a, a)') '(', length, fmt, ')'

            select type (val)
            type is (integer(IK))
                write (string(pos + 1_IK:pos + line_length), line_fmt) val(offset + 1_IK:offset + length)
            type is (real(RK))
                write (string(pos + 1_IK:pos + line_length), line_fmt) val(offset + 1_IK:offset + length)
            type is (complex(CK))
                write (string(pos + 1_IK:pos + line_length), line_fmt) &
                    ('(', real(val(offset + i)), ',', aimag(val(offset + i)), ')', i=1_IK, length)
            end select

            if (line /= lines) string(pos + line_length:pos + line_length) = new_line('a')

        end do

        string = trim(adjustl(string))

    end function fmt_aux

    subroutine log_trace(message)

        use kinds, only: AK

        character(kind=AK, len=*), intent(in) :: message

        call log(ERROR_LEVEL_TRACE, "TRACE", message)

    end subroutine log_trace

    subroutine log_debug(message)

        use kinds, only: AK

        character(kind=AK, len=*), intent(in) :: message

        call log(ERROR_LEVEL_DEBUG, "DEBUG", message)

    end subroutine log_debug

    subroutine log_warning(message)

        use kinds, only: AK

        character(kind=AK, len=*), intent(in) :: message

        call log(ERROR_LEVEL_WARNING, "WARNING", message)

    end subroutine log_warning

    subroutine log_error(message)

        use kinds, only: AK

        character(kind=AK, len=*), intent(in) :: message

        call log(ERROR_LEVEL_ERROR, "ERROR", message)

    end subroutine log_error

    subroutine log_critical(message)

        use kinds, only: AK

        character(kind=AK, len=*), intent(in) :: message

        call log(ERROR_LEVEL_CRITICAL, "CRITICAL", message)

    end subroutine log_critical

    subroutine log(level, prefix, message)

        use kinds, only: AK

        integer, intent(in) :: level
        character(kind=AK, len=*), intent(in) :: prefix, message

        if (level >= ERROR_LEVEL) write (error_unit, '(a1, a, a2, a)') "[", prefix, "] ", message

    end subroutine log

end module logging
