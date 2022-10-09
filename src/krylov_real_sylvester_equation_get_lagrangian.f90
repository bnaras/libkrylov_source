function krylov_real_sylvester_equation_get_lagrangian(equation) result(lagrangian)

    use kinds, only: IK, RK
    use krylov, only: real_sylvester_equation_t
    implicit none

    class(real_sylvester_equation_t), intent(inout) :: equation
    real(RK) :: lagrangian

    ! TODO
    lagrangian = 0.0_RK

end function krylov_real_sylvester_equation_get_lagrangian
