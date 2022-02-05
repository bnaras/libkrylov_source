function krylov_get_enum_option(key) result(value)

    use krylov, only: config
    implicit none

    character(len=*), intent(in) :: key
    character(len=:), allocatable :: value

    value = config%get_enum_option(key)

end function krylov_get_enum_option
