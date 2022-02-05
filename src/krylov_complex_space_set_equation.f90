function krylov_complex_space_set_equation(space, value) result(error)

    use kinds, only: IK
    use errors, only: OK, INVALID_EQUATION
    use krylov, only: complex_space_t, complex_eigenvalue_equation_t, complex_linear_equation_t, &
                      complex_sylvester_equation_t, complex_shifted_linear_equation_t
    implicit none

    class(complex_space_t), intent(inout) :: space
    character(len=*), intent(in) :: value
    integer(IK) :: error

    if (space%config%validate_enum_option('equation', value) /= OK) then
        error = INVALID_EQUATION
        return
    end if

    if (value == 'e') then
        allocate (complex_eigenvalue_equation_t :: space%equation)
    else if (value == 'l') then
        allocate (complex_linear_equation_t :: space%equation)
    else if (value == 's') then
        allocate (complex_sylvester_equation_t :: space%equation)
    else if (value == 'h') then
        allocate (complex_shifted_linear_equation_t :: space%equation)
    end if

    error = OK

end function krylov_complex_space_set_equation
