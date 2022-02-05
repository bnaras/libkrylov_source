function krylov_iteration_get_max_residual_norm(iteration) result(max_residual_norm)

    use kinds, only: IK, RK
    use krylov, only: iteration_t
    implicit none

    class(iteration_t), intent(in) :: iteration
    real(RK) :: max_residual_norm

    integer(IK) :: index

    max_residual_norm = 0.0_RK
    do index = 1_IK, iteration%get_solution_dim()
        max_residual_norm = max(max_residual_norm, iteration%residual_norms(index))
    end do

end function krylov_iteration_get_max_residual_norm
