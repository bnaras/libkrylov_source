function krylov_real_cg_preconditioner_initialize(preconditioner, full_dim, solution_dim, config) result(error)

    use kinds, only: IK, RK, LK
    use errors, only: OK, INVALID_DIMENSION
    use options, only: config_t
    use krylov, only: real_cg_preconditioner_t
    implicit none

    class(real_cg_preconditioner_t), intent(inout) :: preconditioner
    integer(IK), intent(in) :: full_dim, solution_dim
    type(config_t), intent(in) :: config
    integer(IK) :: error

    integer(IK) :: err

    if (full_dim <= 0_IK) then
        error = INVALID_DIMENSION
        return
    end if

    if (solution_dim <= 0_IK) then
        error = INVALID_DIMENSION
        return
    end if

    preconditioner%full_dim = full_dim
    preconditioner%solution_dim = solution_dim

    if (allocated(preconditioner%config)) deallocate (preconditioner%config)
    allocate (preconditioner%config)
    preconditioner%config = config

    if (allocated(preconditioner%diagonal)) deallocate (preconditioner%diagonal)
    allocate (preconditioner%diagonal(full_dim))

    preconditioner%diagonal = 0.0_RK

    err = preconditioner%config%set_logical_option('has_diagonal', .false._LK)
    if (err /= OK) then
        error = err
        return
    end if

    error = OK

end function krylov_real_cg_preconditioner_initialize
