function krylov_complex_sylvester_equation_make_residuals(equation) result(error)

    use kinds, only: IK, CK
    use errors, only: OK
    use krylov, only: complex_sylvester_equation_t
    implicit none

    class(complex_sylvester_equation_t), intent(inout) :: equation
    integer(IK) :: error

    ! TODO
    error = OK

end function krylov_complex_sylvester_equation_make_residuals
