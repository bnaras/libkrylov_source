function krylov_complex_space_solve_projected(space) result(error)

    use kinds, only: IK
    use krylov, only: complex_space_t
    implicit none

    class(complex_space_t), intent(inout) :: space
    integer(IK) :: error

    error = space%equation%solve_projected(space%orthonormalizer)

end function krylov_complex_space_solve_projected
