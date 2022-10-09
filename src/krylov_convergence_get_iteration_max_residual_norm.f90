function krylov_convergence_get_iteration_max_residual_norm(convergence, index) result(max_residual_norm)

    use kinds, only: IK, RK
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(in) :: convergence
    integer(IK), intent(in) :: index
    real(RK) :: max_residual_norm

    if (index > convergence%get_num_iterations()) then
        max_residual_norm = -1.0_RK
        return
    end if

    max_residual_norm = convergence%iterations(index)%get_max_residual_norm()

end function krylov_convergence_get_iteration_max_residual_norm
