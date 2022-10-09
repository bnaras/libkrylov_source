function krylov_convergence_get_iteration_lagrangian(convergence, index) result(lagrangian)

    use kinds, only: IK, RK
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(in) :: convergence
    integer(IK), intent(in) :: index
    real(RK) :: lagrangian

    if (index > convergence%get_num_iterations()) then
        lagrangian = huge(1.0_RK)
        return
    end if

    lagrangian = convergence%iterations(index)%get_lagrangian()

end function krylov_convergence_get_iteration_lagrangian
