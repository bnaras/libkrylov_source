function krylov_convergence_get_last_max_residual_norm(convergence) result(last_max_residual_norm)

    use kinds, only: IK, RK
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(in) :: convergence
    real(RK) :: last_max_residual_norm

    integer(IK) :: index

    index = convergence%get_num_iterations()

    if (index == 0_IK) then
        last_max_residual_norm = -1.0_RK
        return
    end if

    last_max_residual_norm = convergence%iterations(index)%get_max_residual_norm()

end function krylov_convergence_get_last_max_residual_norm
