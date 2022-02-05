function krylov_get_space_real_option(index, key) result(value)

    use kinds, only: IK, RK
    use errors, only: NO_SUCH_OPTION
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=*), intent(in) :: key
    real(RK) :: value

    if (index > krylov_get_num_spaces()) then
        value = -huge(1.0_RK)
        return
    end if

    associate (config => spaces(index)%space_p%config)
        if (config%find_option(key) == NO_SUCH_OPTION) then
            value = -huge(1.0_RK)
            return
        end if

        value = config%get_real_option(key)
    end associate

end function krylov_get_space_real_option
