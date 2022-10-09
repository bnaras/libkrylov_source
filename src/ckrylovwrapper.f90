function ckrylov_initialize() bind(c) result(error)

    use kinds, only: IK
    use krylov, only: krylov_initialize
    implicit none

    integer(IK) :: error

    error = krylov_initialize()

end function ckrylov_initialize

function ckrylov_finalize() bind(c) result(error)

    use kinds, only: IK
    use krylov, only: krylov_finalize
    implicit none

    integer(IK) :: error

    error = krylov_finalize()

end function ckrylov_finalize

function ckrylov_get_version(version, version_len) bind(c) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use cutils, only: string_c2f, string_f2c
    use krylov, only: krylov_get_version
    implicit none

    integer(IK), value, intent(in) :: version_len
    character(len=1, kind=AK), intent(out) :: version(*)
    integer(IK) :: error

    character(len=:, kind=AK), allocatable :: version_tmp

    allocate (character(len=version_len, kind=AK) :: version_tmp)

    error = krylov_get_version(version_tmp)
    if (error /= OK) version_tmp = ''

    version(1_IK:version_len) = string_f2c(version_tmp, version_len)

    deallocate (version_tmp)

end function ckrylov_get_version

function ckrylov_get_compiled_datetime(compiled_dt, compiled_dt_len) bind(c) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use cutils, only: string_c2f, string_f2c
    use krylov, only: krylov_get_compiled_datetime
    implicit none

    integer(IK), value, intent(in) :: compiled_dt_len
    character(len=1, kind=AK), intent(out) :: compiled_dt(*)
    integer(IK) :: error

    character(len=:, kind=AK), allocatable :: compiled_dt_tmp

    allocate (character(len=compiled_dt_len, kind=AK) :: compiled_dt_tmp)

    error = krylov_get_compiled_datetime(compiled_dt_tmp)
    if (error /= OK) compiled_dt_tmp = ''

    compiled_dt(1_IK:compiled_dt_len) = string_f2c(compiled_dt_tmp, compiled_dt_len)

    deallocate (compiled_dt_tmp)

end function ckrylov_get_compiled_datetime

function ckrylov_get_current_datetime(current_dt, current_dt_len) bind(c) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use cutils, only: string_c2f, string_f2c
    use krylov, only: krylov_get_current_datetime
    implicit none

    integer(IK), value, intent(in) :: current_dt_len
    character(len=1, kind=AK), intent(out) :: current_dt(*)
    integer(IK) :: error

    character(len=:, kind=AK), allocatable :: current_dt_tmp

    allocate (character(len=current_dt_len, kind=AK) :: current_dt_tmp)

    error = krylov_get_current_datetime(current_dt_tmp)
    if (error /= OK) current_dt_tmp = ''

    current_dt(1_IK:current_dt_len) = string_f2c(current_dt_tmp, current_dt_len)

    deallocate (current_dt_tmp)

end function ckrylov_get_current_datetime

function ckrylov_header() bind(c) result(error)

    use kinds, only: IK
    use krylov, only: krylov_header
    implicit none

    integer(IK) :: error

    error = krylov_header()

end function ckrylov_header

function ckrylov_footer() bind(c) result(error)

    use kinds, only: IK
    use krylov, only: krylov_footer
    implicit none

    integer(IK) :: error

    error = krylov_footer()

end function ckrylov_footer

function ckrylov_set_defaults() bind(c) result(error)

    use kinds, only: IK
    use krylov, only: krylov_set_defaults
    implicit none

    integer(IK) :: error

    error = krylov_set_defaults()

end function ckrylov_set_defaults

function ckrylov_get_integer_option(key, key_len) bind(c) result(value)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_get_integer_option
    implicit none

    character(len=1, kind=AK), intent(in) :: key(*)
    integer(IK), value, intent(in) :: key_len
    integer(IK) :: value

    value = krylov_get_integer_option(string_c2f(key, key_len))

end function ckrylov_get_integer_option

function ckrylov_set_integer_option(key, key_len, value) bind(c) result(error)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_set_integer_option
    implicit none

    character(len=1, kind=AK), intent(in) :: key(*)
    integer(IK), value, intent(in) :: key_len, value
    integer(IK) :: error

    error = krylov_set_integer_option(string_c2f(key, key_len), value)

end function ckrylov_set_integer_option

function ckrylov_get_string_option(key, key_len, value, value_len) bind(c) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use cutils, only: string_c2f, string_f2c
    use krylov, only: krylov_get_string_option
    implicit none

    character(len=1, kind=AK), intent(in) :: key(*)
    integer(IK), value, intent(in) :: key_len, value_len
    character(len=1, kind=AK), intent(out) :: value(*)
    integer(IK) :: error

    character(len=:, kind=AK), allocatable :: value_tmp

    allocate (character(len=value_len, kind=AK) :: value_tmp)

    error = krylov_get_string_option(string_c2f(key, key_len), value_tmp)
    if (error /= OK) value_tmp = ''

    value(1_IK:value_len) = string_f2c(value_tmp, value_len)

    deallocate (value_tmp)

end function ckrylov_get_string_option

function ckrylov_set_string_option(key, key_len, value, value_len) bind(c) result(error)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_set_string_option
    implicit none

    character(len=1, kind=AK), intent(in) :: key(*), value(*)
    integer(IK), value, intent(in) :: key_len, value_len
    integer(IK) :: error

    error = krylov_set_string_option(string_c2f(key, key_len), string_c2f(value, value_len))

end function ckrylov_set_string_option

function ckrylov_length_string_option(key, key_len) bind(c) result(length)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_length_string_option
    implicit none

    character(len=1, kind=AK), intent(in) :: key(*)
    integer(IK), value, intent(in) :: key_len
    integer(IK) :: length

    length = krylov_length_string_option(string_c2f(key, key_len))

end function ckrylov_length_string_option

function ckrylov_get_real_option(key, key_len) bind(c) result(value)

    use kinds, only: IK, RK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_get_real_option
    implicit none

    character(len=1, kind=AK), intent(in) :: key(*)
    integer(IK), value, intent(in) :: key_len
    real(RK) :: value

    value = krylov_get_real_option(string_c2f(key, key_len))

end function ckrylov_get_real_option

function ckrylov_set_real_option(key, key_len, value) bind(c) result(error)

    use kinds, only: IK, RK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_set_real_option
    implicit none

    character(len=1, kind=AK), intent(in) :: key(*)
    integer(IK), value, intent(in) :: key_len
    real(RK), value, intent(in) :: value
    integer(IK) :: error

    error = krylov_set_real_option(string_c2f(key, key_len), value)

end function ckrylov_set_real_option

function ckrylov_get_logical_option(key, key_len) bind(c) result(value)

    use kinds, only: IK, AK, LK
    use cutils, only: string_c2f
    use krylov, only: krylov_get_logical_option
    implicit none

    character(len=1, kind=AK), intent(in) :: key(*)
    integer(IK), value, intent(in) :: key_len
    logical(LK) :: value

    value = krylov_get_logical_option(string_c2f(key, key_len))

end function ckrylov_get_logical_option

function ckrylov_set_logical_option(key, key_len, value) bind(c) result(error)

    use kinds, only: IK, AK, LK
    use cutils, only: string_c2f
    use krylov, only: krylov_set_logical_option
    implicit none

    character(len=1, kind=AK), intent(in) :: key(*)
    integer(IK), value, intent(in) :: key_len
    logical(LK), value, intent(in) :: value
    integer(IK) :: error

    error = krylov_set_logical_option(string_c2f(key, key_len), value)

end function ckrylov_set_logical_option

function ckrylov_get_enum_option(key, key_len, value, value_len) bind(c) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use cutils, only: string_c2f, string_f2c
    use krylov, only: krylov_get_enum_option
    implicit none

    character(len=1, kind=AK), intent(in) :: key(*)
    integer(IK), value, intent(in) :: key_len, value_len
    character(len=1, kind=AK), intent(out) :: value(*)
    integer(IK) :: error

    character(len=:, kind=AK), allocatable :: value_tmp

    allocate (character(len=value_len, kind=AK) :: value_tmp)

    error = krylov_get_enum_option(string_c2f(key, key_len), value_tmp)
    if (error /= OK) value_tmp = ''

    value(1_IK:value_len) = string_f2c(value_tmp, value_len)

    deallocate (value_tmp)

end function ckrylov_get_enum_option

function ckrylov_set_enum_option(key, key_len, value, value_len) bind(c) result(error)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_set_enum_option
    implicit none

    character(len=1, kind=AK), intent(in) :: key(*), value(*)
    integer(IK), value, intent(in) :: key_len, value_len
    integer(IK) :: error

    error = krylov_set_enum_option(string_c2f(key, key_len), string_c2f(value, value_len))

end function ckrylov_set_enum_option

function ckrylov_length_enum_option(key, key_len) bind(c) result(length)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_length_enum_option
    implicit none

    character(len=1, kind=AK), intent(in) :: key(*)
    integer(IK), value, intent(in) :: key_len
    integer(IK) :: length

    length = krylov_length_enum_option(string_c2f(key, key_len))

end function ckrylov_length_enum_option

function ckrylov_define_enum_option(key, key_len, values, values_len) bind(c) result(error)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_define_enum_option
    implicit none

    character(len=1, kind=AK), intent(in) :: key(*), values(*)
    integer(IK), value, intent(in) :: key_len, values_len
    integer(IK) :: error

    error = krylov_define_enum_option(string_c2f(key, key_len), string_c2f(values, values_len))

end function ckrylov_define_enum_option

function ckrylov_validate_enum_option(key, key_len, value, value_len) bind(c) result(error)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_validate_enum_option
    implicit none

    character(len=1, kind=AK), intent(in) :: key(*), value(*)
    integer(IK), value, intent(in) :: key_len, value_len
    integer(IK) :: error

    error = krylov_validate_enum_option(string_c2f(key, key_len), string_c2f(value, value_len))

end function ckrylov_validate_enum_option

function ckrylov_add_space(kind, kind_len, structure, structure_len, equation, equation_len, &
                           full_dim, solution_dim, basis_dim) bind(c) result(index)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_add_space
    implicit none

    character(len=1, kind=AK), intent(in) :: kind(*), structure(*), equation(*)
    integer(IK), value, intent(in) :: kind_len, structure_len, equation_len, &
                                      full_dim, solution_dim, basis_dim
    integer(IK) :: index

    index = krylov_add_space(string_c2f(kind, kind_len), string_c2f(structure, structure_len), &
                             string_c2f(equation, equation_len), full_dim, solution_dim, basis_dim)

end function ckrylov_add_space

function ckrylov_get_num_spaces() bind(c) result(num_spaces)

    use kinds, only: IK
    use krylov, only: krylov_get_num_spaces
    implicit none

    integer(IK) :: num_spaces

    num_spaces = krylov_get_num_spaces()

end function ckrylov_get_num_spaces

function ckrylov_get_space_integer_option(index, key, key_len) bind(c) result(value)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_get_space_integer_option
    implicit none

    integer(IK), value, intent(in) :: index, key_len
    character(len=1, kind=AK), intent(in) :: key(*)
    integer(IK) :: value

    value = krylov_get_space_integer_option(index, string_c2f(key, key_len))

end function ckrylov_get_space_integer_option

function ckrylov_set_space_integer_option(index, key, key_len, value) bind(c) result(error)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_set_space_integer_option
    implicit none

    integer(IK), value, intent(in) :: index, key_len, value
    character(len=1, kind=AK), intent(in) :: key(*)
    integer(IK) :: error

    error = krylov_set_space_integer_option(index, string_c2f(key, key_len), value)

end function ckrylov_set_space_integer_option

function ckrylov_get_space_string_option(index, key, key_len, value, value_len) bind(c) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use cutils, only: string_c2f, string_f2c
    use krylov, only: krylov_get_space_string_option
    implicit none

    integer(IK), value, intent(in) :: index, key_len, value_len
    character(len=1, kind=AK), intent(in) :: key(*)
    character(len=1, kind=AK), intent(out) :: value(*)
    integer(IK) :: error

    character(len=:, kind=AK), allocatable :: value_tmp

    allocate (character(len=value_len, kind=AK) :: value_tmp)

    error = krylov_get_space_string_option(index, string_c2f(key, key_len), value_tmp)
    if (error /= OK) value_tmp = ''

    value(1_IK:value_len) = string_f2c(value_tmp, value_len)

    deallocate (value_tmp)

end function ckrylov_get_space_string_option

function ckrylov_set_space_string_option(index, key, key_len, value, value_len) bind(c) result(error)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_set_space_string_option
    implicit none

    integer(IK), value, intent(in) :: index, key_len, value_len
    character(len=1, kind=AK), intent(in) :: key(*), value(*)
    integer(IK) :: error

    error = krylov_set_space_string_option(index, string_c2f(key, key_len), string_c2f(value, value_len))

end function ckrylov_set_space_string_option

function ckrylov_length_space_string_option(index, key, key_len) bind(c) result(length)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_length_space_string_option
    implicit none

    integer(IK), value, intent(in) :: index, key_len
    character(len=1, kind=AK), intent(in) :: key(*)
    integer(IK) :: length

    length = krylov_length_space_string_option(index, string_c2f(key, key_len))

end function ckrylov_length_space_string_option

function ckrylov_get_space_real_option(index, key, key_len) bind(c) result(value)

    use kinds, only: IK, RK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_get_space_real_option
    implicit none

    integer(IK), value, intent(in) :: index, key_len
    character(len=1, kind=AK), intent(in) :: key(*)
    real(RK) :: value

    value = krylov_get_space_real_option(index, string_c2f(key, key_len))

end function ckrylov_get_space_real_option

function ckrylov_set_space_real_option(index, key, key_len, value) bind(c) result(error)

    use kinds, only: IK, RK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_set_space_real_option
    implicit none

    integer(IK), value, intent(in) :: index, key_len
    character(len=1, kind=AK), intent(in) :: key(*)
    real(RK), value, intent(in) :: value
    integer(IK) :: error

    error = krylov_set_space_real_option(index, string_c2f(key, key_len), value)

end function ckrylov_set_space_real_option

function ckrylov_get_space_logical_option(index, key, key_len) bind(c) result(value)

    use kinds, only: IK, AK, LK
    use cutils, only: string_c2f
    use krylov, only: krylov_get_space_logical_option
    implicit none

    integer(IK), value, intent(in) :: index, key_len
    character(len=1, kind=AK), intent(in) :: key(*)
    logical(LK) :: value

    value = krylov_get_space_logical_option(index, string_c2f(key, key_len))

end function ckrylov_get_space_logical_option

function ckrylov_set_space_logical_option(index, key, key_len, value) bind(c) result(error)

    use kinds, only: IK, AK, LK
    use cutils, only: string_c2f
    use krylov, only: krylov_set_space_logical_option
    implicit none

    integer(IK), value, intent(in) :: index, key_len
    character(len=1, kind=AK), intent(in) :: key(*)
    logical(LK), value, intent(in) :: value
    integer(IK) :: error

    error = krylov_set_space_logical_option(index, string_c2f(key, key_len), value)

end function ckrylov_set_space_logical_option

function ckrylov_get_space_enum_option(index, key, key_len, value, value_len) bind(c) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use cutils, only: string_c2f, string_f2c
    use krylov, only: krylov_get_space_enum_option
    implicit none

    integer(IK), value, intent(in) :: index, key_len, value_len
    character(len=1, kind=AK), intent(in) :: key(*)
    character(len=1, kind=AK), intent(out) :: value(*)
    integer(IK) :: error

    character(len=:, kind=AK), allocatable :: value_tmp

    allocate (character(len=value_len, kind=AK) :: value_tmp)

    error = krylov_get_space_enum_option(index, string_c2f(key, key_len), value_tmp)
    if (error /= OK) value_tmp = ''

    value(1_IK:value_len) = string_f2c(value_tmp, value_len)

    deallocate (value_tmp)

end function ckrylov_get_space_enum_option

function ckrylov_set_space_enum_option(index, key, key_len, value, value_len) bind(c) result(error)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_set_space_enum_option
    implicit none

    integer(IK), value, intent(in) :: index, key_len, value_len
    character(len=1, kind=AK), intent(in) :: key(*), value(*)
    integer(IK) :: error

    error = krylov_set_space_enum_option(index, string_c2f(key, key_len), string_c2f(value, value_len))

end function ckrylov_set_space_enum_option

function ckrylov_length_space_enum_option(index, key, key_len) bind(c) result(length)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_length_space_enum_option
    implicit none

    integer(IK), value, intent(in) :: index, key_len
    character(len=1, kind=AK), intent(in) :: key(*)
    integer(IK) :: length

    length = krylov_length_space_enum_option(index, string_c2f(key, key_len))

end function ckrylov_length_space_enum_option

function ckrylov_define_space_enum_option(index, key, key_len, values, values_len) bind(c) result(error)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_define_space_enum_option
    implicit none

    integer(IK), value, intent(in) :: index, key_len, values_len
    character(len=1, kind=AK), intent(in) :: key(*), values(*)
    integer(IK) :: error

    error = krylov_define_space_enum_option(index, string_c2f(key, key_len), string_c2f(values, values_len))

end function ckrylov_define_space_enum_option

function ckrylov_validate_space_enum_option(index, key, key_len, value, value_len) bind(c) result(error)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_validate_space_enum_option
    implicit none

    integer(IK), value, intent(in) :: index, key_len, value_len
    character(len=1, kind=AK), intent(in) :: key(*), value(*)
    integer(IK) :: error

    error = krylov_validate_space_enum_option(index, string_c2f(key, key_len), string_c2f(value, value_len))

end function ckrylov_validate_space_enum_option

function ckrylov_get_space_kind(index, kind, kind_len) bind(c) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use cutils, only: string_f2c
    use krylov, only: krylov_get_space_kind
    implicit none

    integer(IK), value, intent(in) :: index, kind_len
    character(len=1, kind=AK), intent(out) :: kind(*)
    integer(IK) :: error

    character(len=:, kind=AK), allocatable :: kind_tmp

    allocate (character(len=kind_len, kind=AK) :: kind_tmp)

    error = krylov_get_space_kind(index, kind_tmp)
    if (error /= OK) kind_tmp = ''

    kind(1_IK:kind_len) = string_f2c(kind_tmp, kind_len)

    deallocate (kind_tmp)

end function ckrylov_get_space_kind

function ckrylov_get_space_structure(index, structure, structure_len) bind(c) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use cutils, only: string_f2c
    use krylov, only: krylov_get_space_structure
    implicit none

    integer(IK), value, intent(in) :: index, structure_len
    character(len=1, kind=AK), intent(out) :: structure(*)
    integer(IK) :: error

    character(len=:, kind=AK), allocatable :: structure_tmp

    allocate (character(len=structure_len, kind=AK) :: structure_tmp)

    error = krylov_get_space_structure(index, structure_tmp)
    if (error /= OK) structure_tmp = ''

    structure(1_IK:structure_len) = string_f2c(structure_tmp, structure_len)

    deallocate (structure_tmp)

end function ckrylov_get_space_structure

function ckrylov_get_space_equation(index, equation, equation_len) bind(c) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use cutils, only: string_f2c
    use krylov, only: krylov_get_space_equation
    implicit none

    integer(IK), value, intent(in) :: index, equation_len
    character(len=1, kind=AK), intent(out) :: equation(*)
    integer(IK) :: error

    character(len=:, kind=AK), allocatable :: equation_tmp

    allocate (character(len=equation_len, kind=AK) :: equation_tmp)

    error = krylov_get_space_equation(index, equation_tmp)
    if (error /= OK) equation_tmp = ''

    equation(1_IK:equation_len) = string_f2c(equation_tmp, equation_len)

    deallocate (equation_tmp)

end function ckrylov_get_space_equation

function ckrylov_get_space_preconditioner(index, preconditioner, preconditioner_len) bind(c) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use cutils, only: string_f2c
    use krylov, only: krylov_get_space_preconditioner
    implicit none

    integer(IK), value, intent(in) :: index, preconditioner_len
    character(len=1, kind=AK), intent(out) :: preconditioner(*)
    integer(IK) :: error

    character(len=:, kind=AK), allocatable :: preconditioner_tmp

    allocate (character(len=preconditioner_len, kind=AK) :: preconditioner_tmp)

    error = krylov_get_space_preconditioner(index, preconditioner_tmp)
    if (error /= OK) preconditioner_tmp = ''

    preconditioner(1_IK:preconditioner_len) = string_f2c(preconditioner_tmp, preconditioner_len)

    deallocate (preconditioner_tmp)

end function ckrylov_get_space_preconditioner

function ckrylov_set_space_preconditioner(index, preconditioner, preconditioner_len) bind(c) result(error)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_set_space_preconditioner
    implicit none

    integer(IK), value, intent(in) :: index, preconditioner_len
    character(len=1, kind=AK), intent(in) :: preconditioner(*)
    integer(IK) :: error

    error = krylov_set_space_preconditioner(index, string_c2f(preconditioner, preconditioner_len))

end function ckrylov_set_space_preconditioner

function ckrylov_get_space_orthonormalizer(index, orthonormalizer, orthonormalizer_len) bind(c) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use cutils, only: string_f2c
    use krylov, only: krylov_get_space_orthonormalizer
    implicit none

    integer(IK), value, intent(in) :: index, orthonormalizer_len
    character(len=1, kind=AK), intent(out) :: orthonormalizer(*)
    integer(IK) :: error

    character(len=:, kind=AK), allocatable :: orthonormalizer_tmp

    allocate (character(len=orthonormalizer_len, kind=AK) :: orthonormalizer_tmp)

    error = krylov_get_space_orthonormalizer(index, orthonormalizer_tmp)
    if (error /= OK) orthonormalizer_tmp = ''

    orthonormalizer(1_IK:orthonormalizer_len) = string_f2c(orthonormalizer_tmp, orthonormalizer_len)

    deallocate (orthonormalizer_tmp)

end function ckrylov_get_space_orthonormalizer

function ckrylov_set_space_orthonormalizer(index, orthonormalizer, orthonormalizer_len) bind(c) result(error)

    use kinds, only: IK, AK
    use cutils, only: string_c2f
    use krylov, only: krylov_set_space_orthonormalizer
    implicit none

    integer(IK), value, intent(in) :: index, orthonormalizer_len
    character(len=1, kind=AK), intent(in) :: orthonormalizer(*)
    integer(IK) :: error

    error = krylov_set_space_orthonormalizer(index, string_c2f(orthonormalizer, orthonormalizer_len))

end function ckrylov_set_space_orthonormalizer

function ckrylov_get_space_full_dim(index) bind(c) result(full_dim)

    use kinds, only: IK
    use krylov, only: krylov_get_space_full_dim
    implicit none

    integer(IK), value, intent(in) :: index
    integer(IK) :: full_dim

    full_dim = krylov_get_space_full_dim(index)

end function ckrylov_get_space_full_dim

function ckrylov_get_space_solution_dim(index) bind(c) result(solution_dim)

    use kinds, only: IK
    use krylov, only: krylov_get_space_solution_dim
    implicit none

    integer(IK), value, intent(in) :: index
    integer(IK) :: solution_dim

    solution_dim = krylov_get_space_solution_dim(index)

end function ckrylov_get_space_solution_dim

function ckrylov_get_space_basis_dim(index) bind(c) result(basis_dim)

    use kinds, only: IK
    use krylov, only: krylov_get_space_basis_dim
    implicit none

    integer(IK), value, intent(in) :: index
    integer(IK) :: basis_dim

    basis_dim = krylov_get_space_basis_dim(index)

end function ckrylov_get_space_basis_dim

function ckrylov_get_space_vector_size(index) bind(c) result(length)

    use kinds, only: IK
    use krylov, only: krylov_get_space_vector_size
    implicit none

    integer(IK), value, intent(in) :: index
    integer(IK) :: length

    length = krylov_get_space_vector_size(index)

end function ckrylov_get_space_vector_size

function ckrylov_get_space_solution_size(index) bind(c) result(length)

    use kinds, only: IK
    use krylov, only: krylov_get_space_solution_size
    implicit none

    integer(IK), value, intent(in) :: index
    integer(IK) :: length

    length = krylov_get_space_solution_size(index)

end function ckrylov_get_space_solution_size

function ckrylov_get_space_eigenvalue_size(index) bind(c) result(length)

    use kinds, only: IK
    use krylov, only: krylov_get_space_eigenvalue_size
    implicit none

    integer(IK), value, intent(in) :: index
    integer(IK) :: length

    length = krylov_get_space_eigenvalue_size(index)

end function ckrylov_get_space_eigenvalue_size

function ckrylov_get_space_rhs_size(index) bind(c) result(length)

    use kinds, only: IK
    use krylov, only: krylov_get_space_rhs_size
    implicit none

    integer(IK), value, intent(in) :: index
    integer(IK) :: length

    length = krylov_get_space_rhs_size(index)

end function ckrylov_get_space_rhs_size

function ckrylov_get_space_sylvester_b_size(index) bind(c) result(length)

    use kinds, only: IK
    use krylov, only: krylov_get_space_sylvester_b_size
    implicit none

    integer(IK), value, intent(in) :: index
    integer(IK) :: length

    length = krylov_get_space_sylvester_b_size(index)

end function ckrylov_get_space_sylvester_b_size

function ckrylov_get_space_num_iterations(index) bind(c) result(num_iterations)

    use kinds, only: IK
    use krylov, only: krylov_get_space_num_iterations
    implicit none

    integer(IK), value, intent(in) :: index
    integer(IK) :: num_iterations

    num_iterations = krylov_get_space_num_iterations(index)

end function ckrylov_get_space_num_iterations

function ckrylov_get_space_iteration_basis_dim(index, iter) bind(c) result(basis_dim)

    use kinds, only: IK
    use krylov, only: krylov_get_space_iteration_basis_dim
    implicit none

    integer(IK), value, intent(in) :: index, iter
    integer(IK) :: basis_dim

    basis_dim = krylov_get_space_iteration_basis_dim(index, iter)

end function ckrylov_get_space_iteration_basis_dim

function ckrylov_get_space_iteration_gram_rcond(index, iter) bind(c) result(gram_rcond)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_space_iteration_gram_rcond
    implicit none

    integer(IK), value, intent(in) :: index, iter
    real(RK) :: gram_rcond

    gram_rcond = krylov_get_space_iteration_gram_rcond(index, iter)

end function ckrylov_get_space_iteration_gram_rcond

function ckrylov_get_space_iteration_expectation_vals(index, iter, solution_dim, expectation_vals) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_space_iteration_expectation_vals
    implicit none

    integer(IK), value, intent(in) :: index, iter, solution_dim
    real(RK), intent(out) :: expectation_vals(*)
    integer(IK) :: error

    error = krylov_get_space_iteration_expectation_vals(index, iter, solution_dim, expectation_vals)

end function ckrylov_get_space_iteration_expectation_vals

function ckrylov_get_space_iteration_lagrangian(index, iter) bind(c) result(lagrangian)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_space_iteration_lagrangian
    implicit none

    integer(IK), value, intent(in) :: index, iter
    real(RK) :: lagrangian

    lagrangian = krylov_get_space_iteration_lagrangian(index, iter)

end function ckrylov_get_space_iteration_lagrangian

function ckrylov_get_space_iteration_residual_norms(index, iter, solution_dim, residual_norms) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_space_iteration_residual_norms
    implicit none

    integer(IK), value, intent(in) :: index, iter, solution_dim
    real(RK), intent(out) :: residual_norms(*)
    integer(IK) :: error

    error = krylov_get_space_iteration_residual_norms(index, iter, solution_dim, residual_norms)

end function ckrylov_get_space_iteration_residual_norms

function ckrylov_get_space_iteration_max_residual_norm(index, iter) bind(c) result(residual_norm)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_space_iteration_max_residual_norm
    implicit none

    integer(IK), value, intent(in) :: index, iter
    real(RK) :: residual_norm

    residual_norm = krylov_get_space_iteration_max_residual_norm(index, iter)

end function ckrylov_get_space_iteration_max_residual_norm

function ckrylov_get_space_last_basis_dim(index) bind(c) result(last_basis_dim)

    use kinds, only: IK
    use krylov, only: krylov_get_space_last_basis_dim
    implicit none

    integer(IK), value, intent(in) :: index
    integer(IK) :: last_basis_dim

    last_basis_dim = krylov_get_space_last_basis_dim(index)

end function ckrylov_get_space_last_basis_dim

function ckrylov_get_space_last_gram_rcond(index) bind(c) result(last_gram_rcond)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_space_last_gram_rcond
    implicit none

    integer(IK), value, intent(in) :: index
    real(RK) :: last_gram_rcond

    last_gram_rcond = krylov_get_space_last_gram_rcond(index)

end function ckrylov_get_space_last_gram_rcond

function ckrylov_get_space_last_expectation_vals(index, solution_dim, expectation_vals) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_space_last_expectation_vals
    implicit none

    integer(IK), value, intent(in) :: index, solution_dim
    real(RK), intent(out) :: expectation_vals(*)
    integer(IK) :: error

    error = krylov_get_space_last_expectation_vals(index, solution_dim, expectation_vals)

end function ckrylov_get_space_last_expectation_vals

function ckrylov_get_space_last_lagrangian(index) bind(c) result(last_lagrangian)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_space_last_lagrangian
    implicit none

    integer(IK), value, intent(in) :: index
    real(RK) :: last_lagrangian

    last_lagrangian = krylov_get_space_last_lagrangian(index)

end function ckrylov_get_space_last_lagrangian

function ckrylov_get_space_last_residual_norms(index, solution_dim, residual_norms) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_space_last_residual_norms
    implicit none

    integer(IK), value, intent(in) :: index, solution_dim
    real(RK), intent(out) :: residual_norms(*)
    integer(IK) :: error

    error = krylov_get_space_last_residual_norms(index, solution_dim, residual_norms)

end function ckrylov_get_space_last_residual_norms

function ckrylov_get_space_last_max_residual_norm(index) bind(c) result(last_residual_norm)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_space_last_max_residual_norm
    implicit none

    integer(IK), value, intent(in) :: index
    real(RK) :: last_residual_norm

    last_residual_norm = krylov_get_space_last_max_residual_norm(index)

end function ckrylov_get_space_last_max_residual_norm

function ckrylov_get_space_convergence(index) bind(c) result(status)

    use kinds, only: IK
    use krylov, only: krylov_get_space_convergence
    implicit none

    integer(IK), value, intent(in) :: index
    integer(IK) :: status

    status = krylov_get_space_convergence(index)

end function ckrylov_get_space_convergence

function ckrylov_get_space_eigenvalues(index, solution_dim, eigenvalues) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_space_eigenvalues
    implicit none

    integer(IK), value, intent(in) :: index, solution_dim
    real(RK), intent(out) :: eigenvalues(*)
    integer(IK) :: error

    error = krylov_get_space_eigenvalues(index, solution_dim, eigenvalues)

end function ckrylov_get_space_eigenvalues

function ckrylov_set_space_diagonal(index, full_dim, diagonal) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_set_space_diagonal
    implicit none

    integer(IK), value, intent(in) :: index, full_dim
    real(RK), intent(in) :: diagonal(*)
    integer(IK) :: error

    error = krylov_set_space_diagonal(index, full_dim, diagonal)

end function ckrylov_set_space_diagonal

function ckrylov_get_space_shifts(index, solution_dim, shifts) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_space_shifts
    implicit none

    integer(IK), value, intent(in) :: index, solution_dim
    real(RK), intent(out) :: shifts(*)
    integer(IK) :: error

    error = krylov_get_space_shifts(index, solution_dim, shifts)

end function ckrylov_get_space_shifts

function ckrylov_set_space_shifts(index, solution_dim, shifts) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_set_space_shifts
    implicit none

    integer(IK), value, intent(in) :: index, solution_dim
    real(RK), intent(in) :: shifts(*)
    integer(IK) :: error

    error = krylov_set_space_shifts(index, solution_dim, shifts)

end function ckrylov_set_space_shifts

function ckrylov_get_real_space_vectors(index, full_dim, basis_dim, vectors) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_real_space_vectors
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, basis_dim
    real(RK), intent(out) :: vectors(*)
    integer(IK) :: error

    error = krylov_get_real_space_vectors(index, full_dim, basis_dim, vectors)

end function ckrylov_get_real_space_vectors

function ckrylov_set_real_space_vectors(index, full_dim, basis_dim, vectors) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_set_real_space_vectors
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, basis_dim
    real(RK), intent(in) :: vectors(*)
    integer(IK) :: error

    error = krylov_set_real_space_vectors(index, full_dim, basis_dim, vectors)

end function ckrylov_set_real_space_vectors

function ckrylov_set_real_space_vectors_from_diagonal(index, full_dim, basis_dim, diagonal) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_set_real_space_vectors_from_diagonal
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, basis_dim
    real(RK), intent(in) :: diagonal(*)
    integer(IK) :: error

    error = krylov_set_real_space_vectors_from_diagonal(index, full_dim, basis_dim, diagonal)

end function ckrylov_set_real_space_vectors_from_diagonal

function ckrylov_resize_real_space_vectors(index, basis_dim) bind(c) result(error)

    use kinds, only: IK
    use krylov, only: krylov_resize_real_space_vectors
    implicit none

    integer(IK), value, intent(in) :: index, basis_dim
    integer(IK) :: error

    error = krylov_resize_real_space_vectors(index, basis_dim)

end function ckrylov_resize_real_space_vectors

function ckrylov_get_real_space_products(index, full_dim, basis_dim, products) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_real_space_products
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, basis_dim
    real(RK), intent(out) :: products(*)
    integer(IK) :: error

    error = krylov_get_real_space_products(index, full_dim, basis_dim, products)

end function ckrylov_get_real_space_products

function ckrylov_get_real_space_solutions(index, full_dim, solution_dim, solutions) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_real_space_solutions
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, solution_dim
    real(RK), intent(out) :: solutions(*)
    integer(IK) :: error

    error = krylov_get_real_space_solutions(index, full_dim, solution_dim, solutions)

end function ckrylov_get_real_space_solutions

function ckrylov_resize_real_space_solutions(index, solution_dim) bind(c) result(error)

    use kinds, only: IK
    use krylov, only: krylov_resize_real_space_solutions
    implicit none

    integer(IK), value, intent(in) :: index, solution_dim
    integer(IK) :: error

    error = krylov_resize_real_space_solutions(index, solution_dim)

end function ckrylov_resize_real_space_solutions

function ckrylov_get_real_space_rhs(index, full_dim, solution_dim, rhs) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_real_space_rhs
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, solution_dim
    real(RK), intent(out) :: rhs(*)
    integer(IK) :: error

    error = krylov_get_real_space_rhs(index, full_dim, solution_dim, rhs)

end function ckrylov_get_real_space_rhs

function ckrylov_set_real_space_rhs(index, full_dim, solution_dim, rhs) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_set_real_space_rhs
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, solution_dim
    real(RK), intent(in) :: rhs(*)
    integer(IK) :: error

    error = krylov_set_real_space_rhs(index, full_dim, solution_dim, rhs)

end function ckrylov_set_real_space_rhs

function ckrylov_get_real_space_sylvester_b(index, solution_dim, sylvester_b) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_real_space_sylvester_b
    implicit none

    integer(IK), value, intent(in) :: index, solution_dim
    real(RK), intent(out) :: sylvester_b(*)
    integer(IK) :: error

    error = krylov_get_real_space_sylvester_b(index, solution_dim, sylvester_b)

end function ckrylov_get_real_space_sylvester_b

function ckrylov_set_real_space_sylvester_b(index, solution_dim, sylvester_b) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_set_real_space_sylvester_b
    implicit none

    integer(IK), value, intent(in) :: index, solution_dim
    real(RK), intent(in) :: sylvester_b(*)
    integer(IK) :: error

    error = krylov_set_real_space_sylvester_b(index, solution_dim, sylvester_b)

end function ckrylov_set_real_space_sylvester_b

function ckrylov_get_real_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_real_space_subset_vectors
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, skip_dim, subset_dim
    real(RK), intent(out) :: vectors(*)
    integer(IK) :: error

    error = krylov_get_real_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors)

end function ckrylov_get_real_space_subset_vectors

function ckrylov_set_real_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_set_real_space_subset_vectors
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, skip_dim, subset_dim
    real(RK), intent(in) :: vectors(*)
    integer(IK) :: error

    error = krylov_set_real_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors)

end function ckrylov_set_real_space_subset_vectors

function ckrylov_get_real_space_subset_products(index, full_dim, skip_dim, subset_dim, products) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_real_space_subset_products
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, skip_dim, subset_dim
    real(RK), intent(out) :: products(*)
    integer(IK) :: error

    error = krylov_get_real_space_subset_products(index, full_dim, skip_dim, subset_dim, products)

end function ckrylov_get_real_space_subset_products

function ckrylov_set_real_space_subset_products(index, full_dim, skip_dim, subset_dim, products) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_set_real_space_subset_products
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, skip_dim, subset_dim
    real(RK), intent(in) :: products(*)
    integer(IK) :: error

    error = krylov_set_real_space_subset_products(index, full_dim, skip_dim, subset_dim, products)

end function ckrylov_set_real_space_subset_products

function ckrylov_get_complex_space_vectors(index, full_dim, basis_dim, vectors) bind(c) result(error)

    use kinds, only: IK, CK
    use krylov, only: krylov_get_complex_space_vectors
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, basis_dim
    complex(CK), intent(out) :: vectors(*)
    integer(IK) :: error

    error = krylov_get_complex_space_vectors(index, full_dim, basis_dim, vectors)

end function ckrylov_get_complex_space_vectors

function ckrylov_set_complex_space_vectors(index, full_dim, basis_dim, vectors) bind(c) result(error)

    use kinds, only: IK, CK
    use krylov, only: krylov_set_complex_space_vectors
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, basis_dim
    complex(CK), intent(in) :: vectors(*)
    integer(IK) :: error

    error = krylov_set_complex_space_vectors(index, full_dim, basis_dim, vectors)

end function ckrylov_set_complex_space_vectors

function ckrylov_set_complex_space_vectors_from_diagonal(index, full_dim, basis_dim, diagonal) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_set_complex_space_vectors_from_diagonal
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, basis_dim
    real(RK), intent(in) :: diagonal(*)
    integer(IK) :: error

    error = krylov_set_complex_space_vectors_from_diagonal(index, full_dim, basis_dim, diagonal)

end function ckrylov_set_complex_space_vectors_from_diagonal

function ckrylov_resize_complex_space_vectors(index, basis_dim) bind(c) result(error)

    use kinds, only: IK
    use krylov, only: krylov_resize_complex_space_vectors
    implicit none

    integer(IK), value, intent(in) :: index, basis_dim
    integer(IK) :: error

    error = krylov_resize_complex_space_vectors(index, basis_dim)

end function ckrylov_resize_complex_space_vectors

function ckrylov_get_complex_space_products(index, full_dim, basis_dim, products) bind(c) result(error)

    use kinds, only: IK, CK
    use krylov, only: krylov_get_complex_space_products
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, basis_dim
    complex(CK), intent(out) :: products(*)
    integer(IK) :: error

    error = krylov_get_complex_space_products(index, full_dim, basis_dim, products)

end function ckrylov_get_complex_space_products

function ckrylov_get_complex_space_solutions(index, full_dim, solution_dim, solutions) bind(c) result(error)

    use kinds, only: IK, CK
    use krylov, only: krylov_get_complex_space_solutions
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, solution_dim
    complex(CK), intent(out) :: solutions(*)
    integer(IK) :: error

    error = krylov_get_complex_space_solutions(index, full_dim, solution_dim, solutions)

end function ckrylov_get_complex_space_solutions

function ckrylov_resize_complex_space_solutions(index, solution_dim) bind(c) result(error)

    use kinds, only: IK
    use krylov, only: krylov_resize_complex_space_solutions
    implicit none

    integer(IK), value, intent(in) :: index, solution_dim
    integer(IK) :: error

    error = krylov_resize_complex_space_solutions(index, solution_dim)

end function ckrylov_resize_complex_space_solutions

function ckrylov_get_complex_space_rhs(index, full_dim, solution_dim, rhs) bind(c) result(error)

    use kinds, only: IK, CK
    use krylov, only: krylov_get_complex_space_rhs
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, solution_dim
    complex(CK), intent(out) :: rhs(*)
    integer(IK) :: error

    error = krylov_get_complex_space_rhs(index, full_dim, solution_dim, rhs)

end function ckrylov_get_complex_space_rhs

function ckrylov_set_complex_space_rhs(index, full_dim, solution_dim, rhs) bind(c) result(error)

    use kinds, only: IK, CK
    use krylov, only: krylov_set_complex_space_rhs
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, solution_dim
    complex(CK), intent(in) :: rhs(*)
    integer(IK) :: error

    error = krylov_set_complex_space_rhs(index, full_dim, solution_dim, rhs)

end function ckrylov_set_complex_space_rhs

function ckrylov_get_complex_space_sylvester_b(index, solution_dim, sylvester_b) bind(c) result(error)

    use kinds, only: IK, CK
    use krylov, only: krylov_get_complex_space_sylvester_b
    implicit none

    integer(IK), value, intent(in) :: index, solution_dim
    complex(CK), intent(out) :: sylvester_b(*)
    integer(IK) :: error

    error = krylov_get_complex_space_sylvester_b(index, solution_dim, sylvester_b)

end function ckrylov_get_complex_space_sylvester_b

function ckrylov_set_complex_space_sylvester_b(index, solution_dim, sylvester_b) bind(c) result(error)

    use kinds, only: IK, CK
    use krylov, only: krylov_set_complex_space_sylvester_b
    implicit none

    integer(IK), value, intent(in) :: index, solution_dim
    complex(CK), intent(in) :: sylvester_b(*)
    integer(IK) :: error

    error = krylov_set_complex_space_sylvester_b(index, solution_dim, sylvester_b)

end function ckrylov_set_complex_space_sylvester_b

function ckrylov_get_complex_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors) bind(c) result(error)

    use kinds, only: IK, CK
    use krylov, only: krylov_get_complex_space_subset_vectors
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, skip_dim, subset_dim
    complex(CK), intent(out) :: vectors(*)
    integer(IK) :: error

    error = krylov_get_complex_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors)

end function ckrylov_get_complex_space_subset_vectors

function ckrylov_set_complex_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors) bind(c) result(error)

    use kinds, only: IK, CK
    use krylov, only: krylov_set_complex_space_subset_vectors
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, skip_dim, subset_dim
    complex(CK), intent(in) :: vectors(*)
    integer(IK) :: error

    error = krylov_set_complex_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors)

end function ckrylov_set_complex_space_subset_vectors

function ckrylov_get_complex_space_subset_products(index, full_dim, skip_dim, subset_dim, products) bind(c) result(error)

    use kinds, only: IK, CK
    use krylov, only: krylov_get_complex_space_subset_products
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, skip_dim, subset_dim
    complex(CK), intent(out) :: products(*)
    integer(IK) :: error

    error = krylov_get_complex_space_subset_products(index, full_dim, skip_dim, subset_dim, products)

end function ckrylov_get_complex_space_subset_products

function ckrylov_set_complex_space_subset_products(index, full_dim, skip_dim, subset_dim, products) bind(c) result(error)

    use kinds, only: IK, CK
    use krylov, only: krylov_set_complex_space_subset_products
    implicit none

    integer(IK), value, intent(in) :: index, full_dim, skip_dim, subset_dim
    complex(CK), intent(in) :: products(*)
    integer(IK) :: error

    error = krylov_set_complex_space_subset_products(index, full_dim, skip_dim, subset_dim, products)

end function ckrylov_set_complex_space_subset_products

function ckrylov_get_real_block_total_size() bind(c) result(total_size)

    use kinds, only: IK
    use krylov, only: krylov_get_real_block_total_size
    implicit none

    integer(IK) :: total_size

    total_size = krylov_get_real_block_total_size()

end function ckrylov_get_real_block_total_size

function ckrylov_get_real_block_dims(num_spaces, full_dims, subset_dims, offsets) bind(c) result(error)

    use kinds, only: IK
    use krylov, only: krylov_get_real_block_dims
    implicit none

    integer(IK), value, intent(in) :: num_spaces
    integer(IK), intent(out) :: full_dims(*), subset_dims(*), offsets(*)
    integer(IK) :: error

    error = krylov_get_real_block_dims(num_spaces, full_dims, subset_dims, offsets)

end function ckrylov_get_real_block_dims

function ckrylov_get_real_block_vectors(num_spaces, total_size, full_dims, subset_dims, offsets, vectors) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_get_real_block_vectors
    implicit none

    integer(IK), value, intent(in) :: num_spaces, total_size
    integer(IK), intent(in) :: full_dims(*), subset_dims(*), offsets(*)
    real(RK), intent(out) :: vectors(*)
    integer(IK) :: error

    error = krylov_get_real_block_vectors(num_spaces, total_size, full_dims, subset_dims, offsets, vectors)

end function ckrylov_get_real_block_vectors

function ckrylov_set_real_block_products(num_spaces, total_size, full_dims, subset_dims, offsets, products) bind(c) result(error)

    use kinds, only: IK, RK
    use krylov, only: krylov_set_real_block_products
    implicit none

    integer(IK), value, intent(in) :: num_spaces, total_size
    integer(IK), intent(in) :: full_dims(*), subset_dims(*), offsets(*)
    real(RK), intent(in) :: products(*)
    integer(IK) :: error

    error = krylov_set_real_block_products(num_spaces, total_size, full_dims, subset_dims, offsets, products)

end function ckrylov_set_real_block_products

function ckrylov_get_real_block_convergence() bind(c) result(status)

    use kinds, only: IK
    use krylov, only: krylov_get_real_block_convergence
    implicit none

    integer(IK) :: status

    status = krylov_get_real_block_convergence()

end function ckrylov_get_real_block_convergence

function ckrylov_get_complex_block_total_size() bind(c) result(total_size)

    use kinds, only: IK
    use krylov, only: krylov_get_complex_block_total_size
    implicit none

    integer(IK) :: total_size

    total_size = krylov_get_complex_block_total_size()

end function ckrylov_get_complex_block_total_size

function ckrylov_get_complex_block_dims(num_spaces, full_dims, subset_dims, offsets) bind(c) result(error)

    use kinds, only: IK
    use krylov, only: krylov_get_complex_block_dims
    implicit none

    integer(IK), value, intent(in) :: num_spaces
    integer(IK), intent(out) :: full_dims(*), subset_dims(*), offsets(*)
    integer(IK) :: error

    error = krylov_get_complex_block_dims(num_spaces, full_dims, subset_dims, offsets)

end function ckrylov_get_complex_block_dims

function ckrylov_get_complex_block_vectors(num_spaces, total_size, full_dims, subset_dims, offsets, vectors) bind(c) result(error)

    use kinds, only: IK, CK
    use krylov, only: krylov_get_complex_block_vectors
    implicit none

    integer(IK), value, intent(in) :: num_spaces, total_size
    integer(IK), intent(in) :: full_dims(*), subset_dims(*), offsets(*)
    complex(CK), intent(out) :: vectors(*)
    integer(IK) :: error

    error = krylov_get_complex_block_vectors(num_spaces, total_size, full_dims, subset_dims, offsets, vectors)

end function ckrylov_get_complex_block_vectors

function ckrylov_set_complex_block_products(num_spaces, total_size, full_dims, subset_dims, offsets, products) bind(c) result(error)

    use kinds, only: IK, CK
    use krylov, only: krylov_set_complex_block_products
    implicit none

    integer(IK), value, intent(in) :: num_spaces, total_size
    integer(IK), intent(in) :: full_dims(*), subset_dims(*), offsets(*)
    complex(CK), intent(in) :: products(*)
    integer(IK) :: error

    error = krylov_set_complex_block_products(num_spaces, total_size, full_dims, subset_dims, offsets, products)

end function ckrylov_set_complex_block_products

function ckrylov_get_complex_block_convergence() bind(c) result(status)

    use kinds, only: IK
    use krylov, only: krylov_get_complex_block_convergence
    implicit none

    integer(IK) :: status

    status = krylov_get_complex_block_convergence()

end function ckrylov_get_complex_block_convergence

function ckrylov_solve_real_equation(index, real_multiply_c) bind(c) result(error)

    use iso_c_binding, only: c_funptr, c_f_procpointer
    use kinds, only: IK, RK
    use krylov, only: krylov_i_real_multiply, krylov_solve_real_equation
    implicit none

    integer(IK), value, intent(in) :: index
    type(c_funptr), value, intent(in) :: real_multiply_c
    integer(IK) :: error

    procedure(krylov_i_real_multiply), pointer :: real_multiply_f => null()

    call c_f_procpointer(real_multiply_c, real_multiply_f)
    error = krylov_solve_real_equation(index, real_multiply_f)

end function ckrylov_solve_real_equation

function ckrylov_solve_real_block_equation(real_block_multiply_c) bind(c) result(error)

    use iso_c_binding, only: c_funptr, c_f_procpointer
    use kinds, only: IK, RK
    use krylov, only: krylov_i_real_block_multiply, krylov_solve_real_block_equation
    implicit none

    type(c_funptr), value, intent(in) :: real_block_multiply_c
    integer(IK) :: error

    procedure(krylov_i_real_block_multiply), pointer :: real_block_multiply_f => null()

    call c_f_procpointer(real_block_multiply_c, real_block_multiply_f)
    error = krylov_solve_real_block_equation(real_block_multiply_f)

end function ckrylov_solve_real_block_equation

function ckrylov_solve_complex_equation(index, complex_multiply_c) bind(c) result(error)

    use iso_c_binding, only: c_funptr, c_f_procpointer
    use kinds, only: IK, CK
    use krylov, only: krylov_i_complex_multiply, krylov_solve_complex_equation
    implicit none

    integer(IK), value, intent(in) :: index
    type(c_funptr), value, intent(in) :: complex_multiply_c
    integer(IK) :: error

    procedure(krylov_i_complex_multiply), pointer :: complex_multiply_f => null()

    call c_f_procpointer(complex_multiply_c, complex_multiply_f)
    error = krylov_solve_complex_equation(index, complex_multiply_f)

end function ckrylov_solve_complex_equation

function ckrylov_solve_complex_block_equation(complex_block_multiply_c) bind(c) result(error)

    use iso_c_binding, only: c_funptr, c_f_procpointer
    use kinds, only: IK, CK
    use krylov, only: krylov_i_complex_block_multiply, krylov_solve_complex_block_equation
    implicit none

    type(c_funptr), value, intent(in) :: complex_block_multiply_c
    integer(IK) :: error

    procedure(krylov_i_complex_block_multiply), pointer :: complex_block_multiply_f => null()

    call c_f_procpointer(complex_block_multiply_c, complex_block_multiply_f)
    error = krylov_solve_complex_block_equation(complex_block_multiply_f)

end function ckrylov_solve_complex_block_equation
