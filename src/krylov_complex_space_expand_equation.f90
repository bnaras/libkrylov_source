function krylov_complex_space_expand_equation(space) result(error)

    use kinds, only: IK
    use krylov, only: complex_space_t
    implicit none

    class(complex_space_t), intent(inout) :: space
    integer(IK) :: error

    error = space%equation%expand_equation()

end function krylov_complex_space_expand_equation
