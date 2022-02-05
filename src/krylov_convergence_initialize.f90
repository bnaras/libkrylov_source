function krylov_convergence_initialize(convergence, solution_dim, config) result(error)

    use kinds, only: IK
    use errors, only: OK
    use options, only: config_t
    use krylov, only: convergence_t, iteration_t
    implicit none

    class(convergence_t), intent(inout) :: convergence
    integer(IK), intent(in) :: solution_dim
    type(config_t), intent(in) :: config
    integer(IK) :: error

    convergence%solution_dim = solution_dim

    if (allocated(convergence%config)) deallocate (convergence%config)
    allocate(convergence%config)
    convergence%config = config

    if (allocated(convergence%iterations)) deallocate (convergence%iterations)
    allocate (convergence%iterations(0_IK))

    error = OK

end function krylov_convergence_initialize

