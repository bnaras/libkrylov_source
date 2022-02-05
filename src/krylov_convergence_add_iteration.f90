function krylov_convergence_add_iteration(convergence, iteration) result(index)

    use kinds, only: IK, RK
    use krylov, only: convergence_t, iteration_t
    implicit none

    class(convergence_t), intent(inout) :: convergence
    type(iteration_t), intent(in) :: iteration
    integer(IK) :: index

    type(iteration_t), allocatable :: iterations_tmp(:)

    index = convergence%get_num_iterations() + 1_IK

    allocate (iterations_tmp(index))
    iterations_tmp(1_IK:index - 1_IK) = convergence%iterations
    call move_alloc(iterations_tmp, convergence%iterations)

    convergence%iterations(index) = iteration

end function krylov_convergence_add_iteration
