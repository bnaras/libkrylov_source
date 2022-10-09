function krylov_real_jdall_preconditioner_initialize(preconditioner, full_dim, solution_dim, config) result(error)

    use kinds, only: IK, RK, LK
    use errors, only: OK, INVALID_DIMENSION
    use options, only: config_t
    use krylov, only: real_jdall_preconditioner_t
    implicit none

    class(real_jdall_preconditioner_t), intent(inout) :: preconditioner
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
    if (allocated(preconditioner%eigenvalues)) deallocate (preconditioner%eigenvalues)
    if (allocated(preconditioner%shifts)) deallocate (preconditioner%shifts)
    if (allocated(preconditioner%solutions)) deallocate (preconditioner%solutions)

    allocate (preconditioner%diagonal(full_dim), &
              preconditioner%eigenvalues(solution_dim), &
              preconditioner%shifts(solution_dim), &
              preconditioner%solutions(full_dim, solution_dim))

    preconditioner%diagonal = 0.0_RK
    preconditioner%eigenvalues = 0.0_RK
    preconditioner%shifts = 0.0_RK
    preconditioner%solutions = 0.0_RK

    err = preconditioner%config%set_logical_option('has_diagonal', .false._LK)
    if (err /= OK) then
        error = err
        return
    end if

    err = preconditioner%config%set_logical_option('has_eigenvalues', .false._LK)
    if (err /= OK) then
        error = err
        return
    end if

    err = preconditioner%config%set_logical_option('has_shifts', .false._LK)
    if (err /= OK) then
        error = err
        return
    end if

    err = preconditioner%config%set_logical_option('has_solutions', .false._LK)
    if (err /= OK) then
        error = err
        return
    end if

    error = OK

end function krylov_real_jdall_preconditioner_initialize
