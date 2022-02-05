function krylov_get_space_solution_dim(index) result(solution_dim)

    use kinds, only: IK
    use errors, only: NO_SUCH_SPACE
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    integer(IK) :: solution_dim

    if (index > krylov_get_num_spaces()) then
        solution_dim = NO_SUCH_SPACE
        return
    end if

    solution_dim = spaces(index)%space_p%solution_dim

end function krylov_get_space_solution_dim
