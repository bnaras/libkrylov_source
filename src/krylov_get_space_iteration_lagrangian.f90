function krylov_get_space_iteration_lagrangian(index, iter) result(lagrangian)

    use kinds, only: IK, RK
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index, iter
    real(RK) :: lagrangian

    if (index > krylov_get_num_spaces()) then
        lagrangian = huge(1.0_RK)
        return
    end if

    lagrangian = spaces(index)%space_p%convergence%get_iteration_lagrangian(iter)

end function krylov_get_space_iteration_lagrangian
