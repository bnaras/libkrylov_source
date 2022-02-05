function krylov_get_space_last_lagrangian(index) result(last_lagrangian)

    use kinds, only: IK, RK
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    real(RK) :: last_lagrangian

    if (index > krylov_get_num_spaces()) then
        last_lagrangian = huge(1.0_RK)
    end if

    associate (space => spaces(index)%space_p)
        last_lagrangian = space%convergence%get_last_lagrangian()
    end associate

end function krylov_get_space_last_lagrangian
