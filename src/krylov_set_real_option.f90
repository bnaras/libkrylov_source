function krylov_set_real_option(key, value) result(error)

    use kinds, only: IK, RK, AK
    use krylov, only: config
    implicit none

    character(len=*, kind=AK), intent(in) :: key
    real(RK), intent(in) :: value
    integer(IK) :: error

    error = config%set_real_option(key, value)

end function krylov_set_real_option
