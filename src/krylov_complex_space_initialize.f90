function krylov_complex_space_initialize(space, equation, full_dim, solution_dim, basis_dim, config) result(error)

    use kinds, only: IK, AK
    use errors, only: OK, INVALID_CONFIGURATION
    use krylov, only: complex_space_t, config_t
    implicit none

    class(complex_space_t), intent(inout) :: space
    character(len=*, kind=AK), intent(in) :: equation
    integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
    type(config_t), intent(in) :: config
    integer(IK) :: error

    integer(IK) :: err, max_dim
    character(len=:, kind=AK), allocatable :: preconditioner, orthonormalizer

    space%full_dim = full_dim
    space%solution_dim = solution_dim
    space%basis_dim = basis_dim
    space%new_dim = basis_dim

    if (allocated(space%config)) deallocate (space%config)
    if (allocated(space%convergence)) deallocate (space%convergence)
    if (associated(space%equation)) deallocate (space%equation)
    if (associated(space%preconditioner)) deallocate (space%preconditioner)
    if (associated(space%orthonormalizer)) deallocate (space%orthonormalizer)

    allocate (space%config)
    space%config = config

    err = space%config%set_enum_option('kind', 'c')
    if (err /= OK) then
        error = INVALID_CONFIGURATION
        return
    end if

    err = space%config%set_enum_option('structure', 'h')
    if (err /= OK) then
        error = INVALID_CONFIGURATION
        return
    end if

    err = space%config%set_enum_option('equation', equation)
    if (err /= OK) then
        error = INVALID_CONFIGURATION
        return
    end if

    max_dim = min(full_dim, basis_dim + solution_dim * space%config%get_integer_option('max_iterations'))
    err = space%config%set_integer_option('max_dim', max_dim)
    if (err /= OK) then
        error = err
        return
    end if

    allocate (space%convergence)
    err = space%convergence%initialize(solution_dim, space%config%link())
    if (err /= OK) then
        error = err
        return
    end if

    err = space%set_equation(equation)
    if (err /= OK) then
        error = err
        return
    end if
    err = space%equation%initialize(full_dim, solution_dim, basis_dim, space%config%link())
    if (err /= OK) then
        error = err
        return
    end if

    preconditioner = space%config%get_enum_option('preconditioner')
    err = space%set_preconditioner(preconditioner)
    if (err /= OK) then
        error = err
        return
    end if
    err = space%preconditioner%initialize(full_dim, solution_dim, space%config%link())
    if (err /= OK) then
        error = err
        return
    end if

    orthonormalizer = space%config%get_enum_option('orthonormalizer')
    err = space%set_orthonormalizer(orthonormalizer)
    if (err /= OK) then
        error = err
        return
    end if
    err = space%orthonormalizer%initialize(space%config%link())
    if (err /= OK) then
        error = err
        return
    end if

    error = OK

end function krylov_complex_space_initialize
