function krylov_real_linear_equation_get_lagrangian(equation) result(lagrangian)

    use kinds, only: IK, RK
    use blaswrapper, only: real_dot
    use krylov, only: real_linear_equation_t
    implicit none

    class(real_linear_equation_t), intent(inout) :: equation
    real(RK) :: lagrangian

    lagrangian = -real_dot(equation%basis_dim * equation%solution_dim, equation%basis_rhs, 1_IK, &
                           equation%basis_solutions, 1_IK)

end function krylov_real_linear_equation_get_lagrangian
