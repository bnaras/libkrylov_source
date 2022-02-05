function krylov_complex_linear_equation_get_lagrangian(equation) result(lagrangian)

    use kinds, only: IK, RK
    use blaswrapper, only: complex_dotc
    use krylov, only: complex_linear_equation_t
    implicit none

    class(complex_linear_equation_t), intent(inout) :: equation
    real(RK) :: lagrangian

    lagrangian = -real(complex_dotc(equation%basis_dim * equation%solution_dim, equation%basis_rhs, 1_IK, &
                                    equation%basis_solutions, 1_IK), RK)

end function krylov_complex_linear_equation_get_lagrangian
