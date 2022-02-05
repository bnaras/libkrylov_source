function krylov_complex_space_make_residuals(space) result(error)

    use kinds, only: IK
    use krylov, only: complex_space_t
    implicit none

    class(complex_space_t), intent(inout) :: space
    integer(IK) :: error

    error = space%equation%make_residuals()

end function krylov_complex_space_make_residuals
