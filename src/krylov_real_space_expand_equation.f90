function krylov_real_space_expand_equation(space) result(error)

    use kinds, only: IK
    use krylov, only: real_space_t
    implicit none

    class(real_space_t), intent(inout) :: space
    integer(IK) :: error

    error = space%equation%expand_equation()

end function krylov_real_space_expand_equation
