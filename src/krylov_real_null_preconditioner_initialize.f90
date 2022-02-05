function krylov_real_null_preconditioner_initialize(preconditioner, full_dim, solution_dim, config) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION
    use options, only: config_t
    use krylov, only: real_null_preconditioner_t
    implicit none

    class(real_null_preconditioner_t), intent(inout) :: preconditioner
    integer(IK), intent(in) :: full_dim, solution_dim
    type(config_t), intent(in) :: config
    integer(IK) :: error

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

    error = OK

end function krylov_real_null_preconditioner_initialize
