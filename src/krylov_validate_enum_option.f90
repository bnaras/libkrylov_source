function krylov_validate_enum_option(key, value) result(error)

    use kinds, only: IK
    use krylov, only: config
    implicit none

    character(len=*), intent(in) :: key, value
    integer(IK) :: error

    error = config%validate_enum_option(key, value)
    
end function krylov_validate_enum_option
