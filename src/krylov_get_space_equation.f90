function krylov_get_space_equation(index) result(equation)

    use kinds, only: IK
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=1) :: equation

    if (index > krylov_get_num_spaces()) then
        equation = ''
        return
    end if

    equation = spaces(index)%space_p%config%get_enum_option('equation')

end function krylov_get_space_equation
