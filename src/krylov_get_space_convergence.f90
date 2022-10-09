function krylov_get_space_convergence(index) result(status)

    use kinds, only: IK
    use errors, only: NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    integer(IK) :: status

    if (index > krylov_get_num_spaces()) then
        status = NO_SUCH_SPACE
        return
    end if

    status = spaces(index)%space_p%convergence%get_convergence()

end function krylov_get_space_convergence
