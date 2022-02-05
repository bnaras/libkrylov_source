function krylov_complex_eigenvalue_equation_get_lagrangian(equation) result(lagrangian)

    use kinds, only: RK
    use krylov, only: complex_eigenvalue_equation_t
    implicit none

    class(complex_eigenvalue_equation_t), intent(inout) :: equation
    real(RK) :: lagrangian

    lagrangian = sum(equation%eigenvalues)

end function krylov_complex_eigenvalue_equation_get_lagrangian
