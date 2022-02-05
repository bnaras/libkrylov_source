function krylov_complex_sylvester_equation_get_lagrangian(equation) result(lagrangian)

    use kinds, only: IK, RK
    use krylov, only: complex_sylvester_equation_t
    implicit none

    class(complex_sylvester_equation_t), intent(inout) :: equation
    real(RK) :: lagrangian

    ! TODO
    lagrangian = 0.0_RK

end function krylov_complex_sylvester_equation_get_lagrangian
