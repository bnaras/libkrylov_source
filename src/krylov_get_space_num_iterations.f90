function krylov_get_space_num_iterations(index) result(num_iterations)

    use kinds, only: IK
    use errors, only: NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    integer(IK) :: num_iterations

    if (index > krylov_get_num_spaces()) then
        num_iterations = NO_SUCH_SPACE
        return
    end if

    num_iterations = spaces(index)%space_p%convergence%get_num_iterations()

end function krylov_get_space_num_iterations
