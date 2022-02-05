function krylov_real_space_make_residuals(space) result(error)

    use kinds, only: IK
    use errors, only: OK
    use krylov, only: real_space_t
    implicit none

    class(real_space_t), intent(inout) :: space
    integer(IK) :: error

    error = space%equation%make_residuals()

end function krylov_real_space_make_residuals
