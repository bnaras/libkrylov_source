function krylov_set_enum_option(key, value) result(error)

    use kinds, only: IK, AK
    use krylov, only: config
    implicit none

    character(len=*, kind=AK), intent(in) :: key, value
    integer(IK) :: error

    error = config%set_enum_option(key, value)

end function krylov_set_enum_option
