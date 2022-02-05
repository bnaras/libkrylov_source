function krylov_define_enum_option(key, values) result(error)

    use kinds, only: IK
    use krylov, only: config
    implicit none

    character(len=*), intent(in) :: key, values
    integer(IK) :: error

    error = config%define_enum_option(key, values)

end function krylov_define_enum_option
