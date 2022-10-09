module control

    use kinds, only: IK, RK
    use options, only: config_t
    implicit none

    type iteration_t
        integer(IK) :: basis_dim, solution_dim
        real(RK) :: gram_rcond, lagrangian
        real(RK), allocatable :: expectation_vals(:), residual_norms(:)
    contains
        procedure, pass :: initialize => krylov_iteration_initialize
        procedure, pass :: get_basis_dim => krylov_iteration_get_basis_dim
        procedure, pass :: get_solution_dim => krylov_iteration_get_solution_dim
        procedure, pass :: get_gram_rcond => krylov_iteration_get_gram_rcond
        procedure, pass :: get_expectation_vals => krylov_iteration_get_expectation_vals
        procedure, pass :: set_expectation_vals => krylov_iteration_set_expectation_vals
        procedure, pass :: get_lagrangian => krylov_iteration_get_lagrangian
        procedure, pass :: get_residual_norms => krylov_iteration_get_residual_norms
        procedure, pass :: set_residual_norms => krylov_iteration_set_residual_norms
        procedure, pass :: get_max_residual_norm => krylov_iteration_get_max_residual_norm
        final :: krylov_iteration_finalize
    end type iteration_t

    type convergence_t
        integer(IK) :: solution_dim
        type(config_t), allocatable :: config
        type(iteration_t), allocatable :: iterations(:)
    contains
        procedure, pass :: initialize => krylov_convergence_initialize
        procedure, pass :: add_iteration => krylov_convergence_add_iteration
        procedure, pass :: get_num_iterations => krylov_convergence_get_num_iterations
        procedure, pass :: get_iteration_basis_dim => krylov_convergence_get_iteration_basis_dim
        procedure, pass :: get_iteration_gram_rcond => krylov_convergence_get_iteration_gram_rcond
        procedure, pass :: get_iteration_expectation_vals => krylov_convergence_get_iteration_expectation_vals
        procedure, pass :: get_iteration_lagrangian => krylov_convergence_get_iteration_lagrangian
        procedure, pass :: get_iteration_residual_norms => krylov_convergence_get_iteration_residual_norms
        procedure, pass :: get_iteration_max_residual_norm => krylov_convergence_get_iteration_max_residual_norm
        procedure, pass :: get_last_basis_dim => krylov_convergence_get_last_basis_dim
        procedure, pass :: get_last_gram_rcond => krylov_convergence_get_last_gram_rcond
        procedure, pass :: get_last_expectation_vals => krylov_convergence_get_last_expectation_vals
        procedure, pass :: get_last_lagrangian => krylov_convergence_get_last_lagrangian
        procedure, pass :: get_last_residual_norms => krylov_convergence_get_last_residual_norms
        procedure, pass :: get_last_max_residual_norm => krylov_convergence_get_last_max_residual_norm
        procedure, pass :: get_solution_convergence => krylov_convergence_get_solution_convergence
        procedure, pass :: get_convergence => krylov_convergence_get_convergence
        procedure, pass :: get_active_dim => krylov_convergence_get_active_dim
        procedure, pass :: get_active => krylov_convergence_get_active
        final :: krylov_convergence_finalize
    end type convergence_t

    interface

        function krylov_iteration_initialize(iteration, basis_dim, solution_dim, gram_rcond, lagrangian) result(error)
            import iteration_t, IK, RK
            class(iteration_t), intent(inout) :: iteration
            integer(IK), intent(in) :: basis_dim, solution_dim
            real(RK), intent(in) :: gram_rcond, lagrangian
            integer(IK) :: error
        end function krylov_iteration_initialize

        function krylov_iteration_get_basis_dim(iteration) result(basis_dim)
            import iteration_t, IK
            class(iteration_t), intent(in) :: iteration
            integer(IK) :: basis_dim
        end function krylov_iteration_get_basis_dim

        function krylov_iteration_get_solution_dim(iteration) result(solution_dim)
            import iteration_t, IK
            class(iteration_t), intent(in) :: iteration
            integer(IK) :: solution_dim
        end function krylov_iteration_get_solution_dim

        function krylov_iteration_get_gram_rcond(iteration) result(gram_rcond)
            import iteration_t, RK
            class(iteration_t), intent(in) :: iteration
            real(RK) :: gram_rcond
        end function krylov_iteration_get_gram_rcond

        function krylov_iteration_get_expectation_vals(iteration, solution_dim, expectation_vals) result(error)
            import iteration_t, IK, RK
            class(iteration_t), intent(in) :: iteration
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(out) :: expectation_vals(solution_dim)
            integer(IK) :: error
        end function krylov_iteration_get_expectation_vals

        function krylov_iteration_set_expectation_vals(iteration, solution_dim, expectation_vals) result(error)
            import iteration_t, IK, RK
            class(iteration_t), intent(inout) :: iteration
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(in) :: expectation_vals(solution_dim)
            integer(IK) :: error
        end function krylov_iteration_set_expectation_vals

        function krylov_iteration_get_lagrangian(iteration) result(lagrangian)
            import iteration_t, RK
            class(iteration_t), intent(in) :: iteration
            real(RK) :: lagrangian
        end function krylov_iteration_get_lagrangian

        function krylov_iteration_get_residual_norms(iteration, solution_dim, residual_norms) result(error)
            import iteration_t, IK, RK
            class(iteration_t), intent(in) :: iteration
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(out) :: residual_norms(solution_dim)
            integer(IK) :: error
        end function krylov_iteration_get_residual_norms

        function krylov_iteration_set_residual_norms(iteration, solution_dim, residual_norms) result(error)
            import iteration_t, IK, RK
            class(iteration_t), intent(inout) :: iteration
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(in) :: residual_norms(solution_dim)
            integer(IK) :: error
        end function krylov_iteration_set_residual_norms

        function krylov_iteration_get_max_residual_norm(iteration) result(max_residual_norm)
            import iteration_t, RK
            class(iteration_t), intent(in) :: iteration
            real(RK) :: max_residual_norm
        end function krylov_iteration_get_max_residual_norm

        function krylov_convergence_initialize(convergence, solution_dim, config) result(error)
            import convergence_t, config_t, IK
            class(convergence_t), intent(inout) :: convergence
            integer(IK), intent(in) :: solution_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_convergence_initialize

        function krylov_convergence_add_iteration(convergence, iteration) result(index)
            import convergence_t, iteration_t, IK, RK
            class(convergence_t), intent(inout) :: convergence
            type(iteration_t), intent(in) :: iteration
            integer(IK) :: index
        end function krylov_convergence_add_iteration

        function krylov_convergence_get_num_iterations(convergence) result(num_iterations)
            import convergence_t, IK
            class(convergence_t), intent(in) :: convergence
            integer(IK) :: num_iterations
        end function krylov_convergence_get_num_iterations

        function krylov_convergence_get_iteration_basis_dim(convergence, index) result(basis_dim)
            import convergence_t, IK
            class(convergence_t), intent(in) :: convergence
            integer(IK), intent(in) :: index
            integer(IK) :: basis_dim
        end function krylov_convergence_get_iteration_basis_dim

        function krylov_convergence_get_iteration_gram_rcond(convergence, index) result(gram_rcond)
            import convergence_t, IK, RK
            class(convergence_t), intent(in) :: convergence
            integer(IK), intent(in) :: index
            real(RK) :: gram_rcond
        end function krylov_convergence_get_iteration_gram_rcond

        function krylov_convergence_get_iteration_expectation_vals( &
            convergence, index, solution_dim, expectation_vals) result(error)
            import convergence_t, IK, RK
            class(convergence_t), intent(in) :: convergence
            integer(IK), intent(in) :: index, solution_dim
            real(RK), intent(out) :: expectation_vals(solution_dim)
            integer(IK) :: error
        end function krylov_convergence_get_iteration_expectation_vals

        function krylov_convergence_get_iteration_lagrangian(convergence, index) result(lagrangian)
            import convergence_t, IK, RK
            class(convergence_t), intent(in) :: convergence
            integer(IK), intent(in) :: index
            real(RK) :: lagrangian
        end function krylov_convergence_get_iteration_lagrangian

        function krylov_convergence_get_iteration_residual_norms( &
            convergence, index, solution_dim, residual_norms) result(error)
            import convergence_t, IK, RK
            class(convergence_t), intent(in) :: convergence
            integer(IK), intent(in) :: index, solution_dim
            real(RK), intent(out) :: residual_norms(solution_dim)
            integer(IK) :: error
        end function krylov_convergence_get_iteration_residual_norms

        function krylov_convergence_get_iteration_max_residual_norm(convergence, index) result(max_residual_norm)
            import convergence_t, IK, RK
            class(convergence_t), intent(in) :: convergence
            integer(IK), intent(in) :: index
            real(RK) :: max_residual_norm
        end function krylov_convergence_get_iteration_max_residual_norm

        function krylov_convergence_get_last_basis_dim(convergence) result(last_basis_dim)
            import convergence_t, IK
            class(convergence_t), intent(in) :: convergence
            integer(IK) :: last_basis_dim
        end function krylov_convergence_get_last_basis_dim

        function krylov_convergence_get_last_gram_rcond(convergence) result(last_gram_rcond)
            import convergence_t, RK
            class(convergence_t), intent(in) :: convergence
            real(RK) :: last_gram_rcond
        end function krylov_convergence_get_last_gram_rcond

        function krylov_convergence_get_last_expectation_vals(convergence, solution_dim, last_expectation_vals) result(error)
            import convergence_t, IK, RK
            class(convergence_t), intent(in) :: convergence
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(out) :: last_expectation_vals(solution_dim)
            integer(IK) :: error
        end function krylov_convergence_get_last_expectation_vals

        function krylov_convergence_get_last_lagrangian(convergence) result(last_lagrangian)
            import convergence_t, RK
            class(convergence_t), intent(in) :: convergence
            real(RK) :: last_lagrangian
        end function krylov_convergence_get_last_lagrangian

        function krylov_convergence_get_last_residual_norms(convergence, solution_dim, last_residual_norms) result(error)
            import convergence_t, IK, RK
            class(convergence_t), intent(in) :: convergence
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(out) :: last_residual_norms(solution_dim)
            integer(IK) :: error
        end function krylov_convergence_get_last_residual_norms

        function krylov_convergence_get_last_max_residual_norm(convergence) result(last_max_residual_norm)
            import convergence_t, RK
            class(convergence_t), intent(in) :: convergence
            real(RK) :: last_max_residual_norm
        end function krylov_convergence_get_last_max_residual_norm

        function krylov_convergence_get_solution_convergence(convergence, index) result(status)
            import convergence_t, IK
            class(convergence_t), intent(inout) :: convergence
            integer(IK), intent(in) :: index
            integer(IK) :: status
        end function krylov_convergence_get_solution_convergence

        function krylov_convergence_get_convergence(convergence) result(status)
            import convergence_t, IK
            class(convergence_t), intent(inout) :: convergence
            integer(IK) :: status
        end function krylov_convergence_get_convergence

        function krylov_convergence_get_active_dim(convergence) result(active_dim)
            import convergence_t, IK
            class(convergence_t), intent(inout) :: convergence
            integer(IK) :: active_dim
        end function krylov_convergence_get_active_dim

        function krylov_convergence_get_active(convergence, active_dim, active) result(error)
            import convergence_t, IK
            class(convergence_t), intent(inout) :: convergence
            integer(IK), intent(in) :: active_dim
            integer(IK), intent(out) :: active(active_dim)
            integer(IK) :: error
        end function krylov_convergence_get_active

    end interface

contains

    subroutine krylov_iteration_finalize(iteration)
        implicit none
        type(iteration_t), intent(inout) :: iteration

        if (allocated(iteration%expectation_vals)) deallocate (iteration%expectation_vals)
        if (allocated(iteration%residual_norms)) deallocate (iteration%residual_norms)
    end subroutine krylov_iteration_finalize

    subroutine krylov_convergence_finalize(convergence)
        implicit none
        type(convergence_t), intent(inout) :: convergence

        if (allocated(convergence%iterations)) deallocate (convergence%iterations)
    end subroutine krylov_convergence_finalize

end module control
