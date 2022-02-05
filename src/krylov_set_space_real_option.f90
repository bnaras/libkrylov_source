function krylov_set_space_real_option(index, key, value) result(error)

    use kinds, only: IK, RK
    use errors, only: NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=*), intent(in) :: key
    real(RK), intent(in) :: value
    integer(IK) :: error

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        return
    end if

    error = spaces(index)%space_p%config%set_real_option(key, value)

end function krylov_set_space_real_option
