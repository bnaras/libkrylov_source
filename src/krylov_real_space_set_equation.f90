function krylov_real_space_set_equation(space, value) result(error)

    use kinds, only: IK, AK
    use errors, only: OK, INVALID_EQUATION
    use krylov, only: real_space_t, real_eigenvalue_equation_t, real_linear_equation_t, &
                      real_sylvester_equation_t, real_shifted_linear_equation_t
    implicit none

    class(real_space_t), intent(inout) :: space
    character(len=*, kind=AK), intent(in) :: value
    integer(IK) :: error

    if (space%config%validate_enum_option('equation', value) /= OK) then
        error = INVALID_EQUATION
        return
    end if

    if (value == 'e') then
        allocate (real_eigenvalue_equation_t :: space%equation)
    else if (value == 'l') then
        allocate (real_linear_equation_t :: space%equation)
    else if (value == 's') then
        allocate (real_sylvester_equation_t :: space%equation)
    else if (value == 'h') then
        allocate (real_shifted_linear_equation_t :: space%equation)
    end if

    error = OK

end function krylov_real_space_set_equation
