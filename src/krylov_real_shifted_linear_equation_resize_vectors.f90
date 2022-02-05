function krylov_real_shifted_linear_equation_resize_vectors(equation, basis_dim) result(error)
    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: real_shifted_linear_equation_t
    implicit none

    class(real_shifted_linear_equation_t), intent(inout) :: equation
    integer(IK), intent(in) :: basis_dim
    integer(IK) :: error

    real(RK), allocatable :: vectors_tmp(:, :), products_tmp(:, :), rayleigh_tmp(:, :), &
                             basis_solutions_tmp(:, :), basis_rhs_tmp(:, :)

    ! Nothing to do
    if (basis_dim == equation%basis_dim) then
        error = OK
        return
    end if

    if (basis_dim > equation%full_dim) then
        error = INVALID_DIMENSION
        return
    end if

    if (basis_dim > equation%basis_dim) then

        allocate (vectors_tmp(equation%full_dim, basis_dim), &
                  products_tmp(equation%full_dim, basis_dim), &
                  rayleigh_tmp(basis_dim, basis_dim), &
                  basis_solutions_tmp(basis_dim, equation%solution_dim), &
                  basis_rhs_tmp(basis_dim, equation%solution_dim))

        vectors_tmp = 0.0_RK
        products_tmp = 0.0_RK
        rayleigh_tmp = 0.0_RK
        basis_solutions_tmp = 0.0_RK
        basis_rhs_tmp = 0.0_RK

        vectors_tmp(:, 1_IK:equation%basis_dim) = equation%vectors
        products_tmp(:, 1_IK:equation%basis_dim) = equation%products
        rayleigh_tmp(1_IK:equation%basis_dim, 1_IK:equation%basis_dim) = equation%rayleigh
        basis_solutions_tmp(1_IK:equation%basis_dim, :) = equation%basis_solutions
        basis_rhs_tmp(1_IK:equation%basis_dim, :) = equation%basis_rhs

        call move_alloc(vectors_tmp, equation%vectors)
        call move_alloc(products_tmp, equation%products)
        call move_alloc(rayleigh_tmp, equation%rayleigh)
        call move_alloc(basis_solutions_tmp, equation%basis_solutions)
        call move_alloc(basis_rhs_tmp, equation%basis_rhs)

    else

        deallocate (equation%vectors, equation%products, equation%rayleigh, &
                    equation%basis_solutions, equation%basis_rhs)

        allocate (equation%vectors(equation%full_dim, basis_dim), &
                  equation%products(equation%full_dim, basis_dim), &
                  equation%rayleigh(basis_dim, basis_dim), &
                  equation%basis_solutions(basis_dim, equation%solution_dim), &
                  equation%basis_rhs(basis_dim, equation%solution_dim))

        equation%vectors = 0.0_RK
        equation%products = 0.0_RK
        equation%rayleigh = 0.0_RK
        equation%basis_solutions = 0.0_RK
        equation%basis_rhs = 0.0_RK

    end if

    equation%basis_dim = basis_dim

    error = OK

end function krylov_real_shifted_linear_equation_resize_vectors
