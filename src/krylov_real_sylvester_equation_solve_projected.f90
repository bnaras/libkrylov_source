function krylov_real_sylvester_equation_solve_projected(equation, orthonormalizer) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: real_sylvester_equation_t, real_orthonormalizer_t
    implicit none

    class(real_sylvester_equation_t), intent(inout) :: equation
    class(real_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK) :: error

    ! TODO
    error = OK

end function krylov_real_sylvester_equation_solve_projected
