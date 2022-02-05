function krylov_get_space_preconditioner(index) result(preconditioner)

    use kinds, only: IK
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=1) :: preconditioner

    if (index > krylov_get_num_spaces()) then
        preconditioner = ''
        return
    end if

    preconditioner = spaces(index)%space_p%config%get_enum_option('preconditioner')

end function krylov_get_space_preconditioner
