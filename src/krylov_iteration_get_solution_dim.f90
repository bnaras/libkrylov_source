function krylov_iteration_get_solution_dim(iteration) result(solution_dim)

    use kinds, only: IK
    use krylov, only: iteration_t
    implicit none

    class(iteration_t), intent(in) :: iteration
    integer(IK) :: solution_dim

    solution_dim = iteration%solution_dim

end function krylov_iteration_get_solution_dim
