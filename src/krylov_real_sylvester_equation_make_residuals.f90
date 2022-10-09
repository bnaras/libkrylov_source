function krylov_real_sylvester_equation_make_residuals(equation) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: real_sylvester_equation_t
    implicit none

    class(real_sylvester_equation_t), intent(inout) :: equation
    integer(IK) :: error
    
    ! TODO
    error = OK

end function krylov_real_sylvester_equation_make_residuals
