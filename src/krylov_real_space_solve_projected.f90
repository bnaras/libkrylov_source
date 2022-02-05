function krylov_real_space_solve_projected(space) result(error)

    use kinds, only: IK
    use krylov, only: real_space_t
    implicit none

    class(real_space_t), intent(inout) :: space
    integer(IK) :: error

    error = space%equation%solve_projected(space%orthonormalizer)

end function krylov_real_space_solve_projected
