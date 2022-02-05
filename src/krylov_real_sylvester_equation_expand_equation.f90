function krylov_real_sylvester_equation_expand_equation(equation) result(error)

    use kinds, only: IK
    use errors, only: OK
    use krylov, only: real_sylvester_equation_t
    implicit none

    class(real_sylvester_equation_t), intent(inout) :: equation
    integer(IK) :: error

    ! TODO
    error = OK

end function krylov_real_sylvester_equation_expand_equation
