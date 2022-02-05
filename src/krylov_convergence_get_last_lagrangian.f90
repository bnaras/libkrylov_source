function krylov_convergence_get_last_lagrangian(convergence) result(last_lagrangian)

    use kinds, only: IK, RK
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(in) :: convergence
    real(RK) :: last_lagrangian

    integer(IK) :: index

    index = convergence%get_num_iterations()

    if (index == 0_IK) then
        last_lagrangian = huge(0.0_RK)
        return
    end if

    last_lagrangian = convergence%iterations(index)%lagrangian

end function krylov_convergence_get_last_lagrangian
