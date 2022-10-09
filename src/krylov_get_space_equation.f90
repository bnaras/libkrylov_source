function krylov_get_space_equation(index, equation) result(error)

    use kinds, only: IK, AK
    use errors, only: OK, NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=*, kind=AK), intent(out) :: equation
    integer(IK) :: error

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        equation = ''
        return
    end if

    equation = spaces(index)%space_p%config%get_enum_option('equation')

    error = OK

end function krylov_get_space_equation
