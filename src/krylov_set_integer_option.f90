function krylov_set_integer_option(key, value) result(error)

    use kinds, only: IK
    use krylov, only: config
    implicit none

    character(len=*), intent(in) :: key
    integer(IK), intent(in) :: value
    integer(IK) :: error

    error = config%set_integer_option(key, value)

end function krylov_set_integer_option
