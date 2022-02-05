function krylov_complex_sylvester_equation_solve_projected(equation, orthonormalizer) result(error)

    use kinds, only: IK, CK
    use errors, only: OK
    use krylov, only: complex_sylvester_equation_t, complex_orthonormalizer_t
    implicit none

    class(complex_sylvester_equation_t), intent(inout) :: equation
    class(complex_orthonormalizer_t), intent(inout) :: orthonormalizer
    integer(IK) :: error

    ! TODO
    error = OK

end function krylov_complex_sylvester_equation_solve_projected
