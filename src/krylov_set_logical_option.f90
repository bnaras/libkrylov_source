function krylov_set_logical_option(key, value) result(error)

    use kinds, only: IK
    use krylov, only: config
    implicit none

    character(len=*), intent(in) :: key
    logical, intent(in) :: value
    integer(IK) :: error

    error = config%set_logical_option(key, value)

end function krylov_set_logical_option
