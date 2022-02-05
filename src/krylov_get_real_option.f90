function krylov_get_real_option(key) result(value)

    use kinds, only: RK
    use errors, only: NO_SUCH_OPTION
    use krylov, only: config
    implicit none

    character(len=*), intent(in) :: key
    real(RK) :: value

    if (config%find_option(key) == NO_SUCH_OPTION) then
        value = -huge(1.0_RK)
        return
    end if

    value = config%get_real_option(key)

end function krylov_get_real_option
