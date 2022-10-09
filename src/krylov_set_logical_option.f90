function krylov_set_logical_option(key, value) result(error)

    use kinds, only: IK, AK, LK
    use krylov, only: config
    implicit none

    character(len=*, kind=AK), intent(in) :: key
    logical(LK), intent(in) :: value
    integer(IK) :: error

    error = config%set_logical_option(key, value)

end function krylov_set_logical_option
