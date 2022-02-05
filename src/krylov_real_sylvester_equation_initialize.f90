function krylov_real_sylvester_equation_initialize(equation, full_dim, solution_dim, basis_dim, config) result(error)

    use kinds, only: IK
    use errors, only: OK
    use options, only: config_t
    use krylov, only: real_sylvester_equation_t
    implicit none

    class(real_sylvester_equation_t), intent(inout) :: equation
    integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
    type(config_t), intent(in) :: config
    integer(IK) :: error

    equation%full_dim = full_dim
    equation%solution_dim = solution_dim
    equation%basis_dim = basis_dim
    equation%new_dim = basis_dim

    if (allocated(equation%config)) deallocate (equation%config)
    allocate (equation%config)
    equation%config = config

    if (allocated(equation%vectors)) deallocate (equation%vectors)
    if (allocated(equation%products)) deallocate (equation%products)
    if (allocated(equation%solutions)) deallocate (equation%solutions)
    if (allocated(equation%residuals)) deallocate (equation%residuals)
    if (allocated(equation%rhs)) deallocate (equation%rhs)
    if (allocated(equation%sylvester_b)) deallocate (equation%sylvester_b)
    if (allocated(equation%rayleigh)) deallocate (equation%rayleigh)
    if (allocated(equation%basis_solutions)) deallocate (equation%basis_solutions)
    if (allocated(equation%basis_rhs)) deallocate (equation%basis_rhs)

    allocate (equation%vectors(full_dim, basis_dim), &
              equation%products(full_dim, basis_dim), &
              equation%solutions(full_dim, solution_dim), &
              equation%residuals(full_dim, solution_dim), &
              equation%rhs(full_dim, solution_dim), &
              equation%sylvester_b(solution_dim, solution_dim), &
              equation%rayleigh(basis_dim, basis_dim), &
              equation%basis_solutions(basis_dim, solution_dim), &
              equation%basis_rhs(basis_dim, solution_dim))

    error = OK

end function krylov_real_sylvester_equation_initialize
