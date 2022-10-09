function krylov_get_space_last_lagrangian(index) result(last_lagrangian)

    use kinds, only: IK, RK
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    real(RK) :: last_lagrangian

    if (index > krylov_get_num_spaces()) then
        last_lagrangian = huge(1.0_RK)
        return
    end if

    last_lagrangian = spaces(index)%space_p%convergence%get_last_lagrangian()

end function krylov_get_space_last_lagrangian
