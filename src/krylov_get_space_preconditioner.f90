function krylov_get_space_preconditioner(index, preconditioner) result(error)

    use kinds, only: IK, AK
    use errors, only: OK, NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=*, kind=AK), intent(out) :: preconditioner
    integer(IK) :: error

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        preconditioner = ''
        return
    end if

    preconditioner = spaces(index)%space_p%config%get_enum_option('preconditioner')

    error = OK

end function krylov_get_space_preconditioner
