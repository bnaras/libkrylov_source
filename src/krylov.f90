module krylov

    use kinds, only: IK, RK, CK
    use options, only: config_t
    use control, only: iteration_t, convergence_t
    use solvers, only: space_t, real_space_t, complex_space_t
    use equations, only: real_equation_t, real_eigenvalue_equation_t, real_linear_equation_t, &
                         real_shifted_linear_equation_t, real_sylvester_equation_t, complex_equation_t, &
                         complex_eigenvalue_equation_t, complex_linear_equation_t, complex_shifted_linear_equation_t, &
                         complex_sylvester_equation_t
    use preconditioners, only: real_preconditioner_t, real_null_preconditioner_t, real_cg_preconditioner_t, &
                               real_davidson_preconditioner_t, real_jd_preconditioner_t, real_jdall_preconditioner_t, &
                               complex_preconditioner_t, complex_null_preconditioner_t, complex_cg_preconditioner_t, &
                               complex_davidson_preconditioner_t, complex_jd_preconditioner_t, complex_jdall_preconditioner_t
    use orthonormalizers, only: real_orthonormalizer_t, real_nks_orthonormalizer_t, real_semi_orthonormalizer_t, &
                                real_ortho_orthonormalizer_t, complex_orthonormalizer_t, complex_nks_orthonormalizer_t, &
                                complex_semi_orthonormalizer_t, complex_ortho_orthonormalizer_t
    implicit none

    type space_pointer_t
        class(space_t), pointer :: space_p
    end type space_pointer_t

    type(config_t), allocatable :: config
    type(space_pointer_t), allocatable :: spaces(:)

    abstract interface

        function krylov_i_real_multiply(full_dim, subset_dim, vectors, products) result(error)
            import IK, RK
            integer(IK), intent(in) :: full_dim, subset_dim
            real(RK), intent(in) :: vectors(full_dim, subset_dim)
            real(RK), intent(out) :: products(full_dim, subset_dim)
            integer(IK) :: error
        end function krylov_i_real_multiply

        function krylov_i_complex_multiply(full_dim, subset_dim, vectors, products) result(error)
            import IK, CK
            integer(IK), intent(in) :: full_dim, subset_dim
            complex(CK), intent(in) :: vectors(full_dim, subset_dim)
            complex(CK), intent(out) :: products(full_dim, subset_dim)
            integer(IK) :: error
        end function krylov_i_complex_multiply

        function krylov_i_real_block_multiply( &
            num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products) result(error)
            import IK, RK
            integer(IK), intent(in) :: num_spaces, total_size, full_dims(num_spaces), &
                                       subset_dims(num_spaces), offsets(num_spaces)
            real(RK), intent(in) :: vectors(total_size)
            real(RK), intent(out) :: products(total_size)
            integer(IK) :: error
        end function krylov_i_real_block_multiply

        function krylov_i_complex_block_multiply( &
            num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products) result(error)
            import IK, CK
            integer(IK), intent(in) :: num_spaces, total_size, full_dims(num_spaces), &
                                       subset_dims(num_spaces), offsets(num_spaces)
            complex(CK), intent(in) :: vectors(total_size)
            complex(CK), intent(out) :: products(total_size)
            integer(IK) :: error
        end function krylov_i_complex_block_multiply

    end interface

    interface

        function krylov_initialize() result(error)
            import IK
            integer(IK) :: error
        end function krylov_initialize

        function krylov_finalize() result(error)
            import IK
            integer(IK) :: error
        end function krylov_finalize

        function krylov_set_defaults() result(error)
            import IK
            integer(IK) :: error
        end function krylov_set_defaults

        function krylov_get_integer_option(key) result(value)
            import IK
            character(len=*), intent(in) :: key
            integer(IK) :: value
        end function krylov_get_integer_option

        function krylov_set_integer_option(key, value) result(error)
            import IK
            character(len=*), intent(in) :: key
            integer(IK), intent(in) :: value
            integer(IK) :: error
        end function krylov_set_integer_option

        function krylov_get_string_option(key) result(value)
            character(len=*), intent(in) :: key
            character(len=:), allocatable :: value
        end function krylov_get_string_option

        function krylov_set_string_option(key, value) result(error)
            import IK
            character(len=*), intent(in) :: key, value
            integer(IK) :: error
        end function krylov_set_string_option

        function krylov_get_real_option(key) result(value)
            import RK
            character(len=*), intent(in) :: key
            real(RK) :: value
        end function krylov_get_real_option

        function krylov_set_real_option(key, value) result(error)
            import IK, RK
            character(len=*), intent(in) :: key
            real(RK), intent(in) :: value
            integer(IK) :: error
        end function krylov_set_real_option

        function krylov_get_logical_option(key) result(value)
            character(len=*), intent(in) :: key
            logical :: value
        end function krylov_get_logical_option

        function krylov_set_logical_option(key, value) result(error)
            import IK
            character(len=*), intent(in) :: key
            logical, intent(in) :: value
            integer(IK) :: error
        end function krylov_set_logical_option

        function krylov_validate_enum_option(key, value) result(error)
            import IK
            character(len=*), intent(in) :: key, value
            integer(IK) :: error
        end function krylov_validate_enum_option

        function krylov_get_enum_option(key) result(value)
            character(len=*), intent(in) :: key
            character(len=:), allocatable :: value
        end function krylov_get_enum_option

        function krylov_define_enum_option(key, values) result(error)
            import IK
            character(len=*), intent(in) :: key, values
            integer(IK) :: error
        end function krylov_define_enum_option

        function krylov_set_enum_option(key, value) result(error)
            import IK
            character(len=*), intent(in) :: key, value
            integer(IK) :: error
        end function krylov_set_enum_option

        function krylov_add_space(kind, structure, equation, full_dim, solution_dim, basis_dim) result(index)
            import IK
            character(len=1), intent(in) :: kind, structure, equation
            integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
            integer(IK) :: index
        end function krylov_add_space

        function krylov_get_num_spaces() result(num_spaces)
            import IK
            integer(IK) :: num_spaces
        end function krylov_get_num_spaces

        function krylov_get_space_integer_option(index, key) result(value)
            import IK
            integer(IK), intent(in) :: index
            character(len=*), intent(in) :: key
            integer(IK) :: value
        end function krylov_get_space_integer_option

        function krylov_set_space_integer_option(index, key, value) result(error)
            import IK
            integer(IK), intent(in) :: index, value
            character(len=*), intent(in) :: key
            integer(IK) :: error
        end function krylov_set_space_integer_option

        function krylov_get_space_string_option(index, key) result(value)
            import IK
            integer(IK), intent(in) :: index
            character(len=*), intent(in) :: key
            character(len=:), allocatable :: value
        end function krylov_get_space_string_option

        function krylov_set_space_string_option(index, key, value) result(error)
            import IK
            integer(IK), intent(in) :: index
            character(len=*), intent(in) :: key, value
            integer(IK) :: error
        end function krylov_set_space_string_option

        function krylov_get_space_real_option(index, key) result(value)
            import IK, RK
            integer(IK), intent(in) :: index
            character(len=*), intent(in) :: key
            real(RK) :: value
        end function krylov_get_space_real_option

        function krylov_set_space_real_option(index, key, value) result(error)
            import IK, RK
            integer(IK), intent(in) :: index
            character(len=*), intent(in) :: key
            real(RK), intent(in) :: value
            integer(IK) :: error
        end function krylov_set_space_real_option

        function krylov_get_space_logical_option(index, key) result(value)
            import IK
            integer(IK), intent(in) :: index
            character(len=*), intent(in) :: key
            logical :: value
        end function krylov_get_space_logical_option

        function krylov_set_space_logical_option(index, key, value) result(error)
            import IK
            integer(IK), intent(in) :: index
            character(len=*), intent(in) :: key
            logical, intent(in) :: value
            integer(IK) :: error
        end function krylov_set_space_logical_option

        function krylov_validate_space_enum_option(index, key, value) result(error)
            import IK
            integer(IK), intent(in) :: index
            character(len=*), intent(in) :: key, value
            integer(IK) :: error
        end function krylov_validate_space_enum_option

        function krylov_get_space_enum_option(index, key) result(value)
            import IK
            integer(IK), intent(in) :: index
            character(len=*), intent(in) :: key
            character(len=:), allocatable :: value
        end function krylov_get_space_enum_option

        function krylov_define_space_enum_option(index, key, values) result(error)
            import IK
            integer(IK), intent(in) :: index
            character(len=*), intent(in) :: key, values
            integer(IK) :: error
        end function krylov_define_space_enum_option

        function krylov_set_space_enum_option(index, key, value) result(error)
            import IK
            integer(IK), intent(in) :: index
            character(len=*), intent(in) :: key, value
            integer(IK) :: error
        end function krylov_set_space_enum_option

        function krylov_get_space_kind(index) result(kind)
            import IK
            integer(IK), intent(in) :: index
            character(len=1) :: kind
        end function krylov_get_space_kind

        function krylov_get_space_structure(index) result(structure)
            import IK
            integer(IK), intent(in) :: index
            character(len=1) :: structure
        end function krylov_get_space_structure

        function krylov_get_space_equation(index) result(equation)
            import IK
            integer(IK), intent(in) :: index
            character(len=1) :: equation
        end function krylov_get_space_equation

        function krylov_get_space_preconditioner(index) result(preconditioner)
            import IK
            integer(IK), intent(in) :: index
            character(len=1) :: preconditioner
        end function krylov_get_space_preconditioner

        function krylov_set_space_preconditioner(index, preconditioner) result(error)
            import IK
            integer(IK), intent(in) :: index
            character(len=1), intent(in) :: preconditioner
            integer(IK) :: error
        end function krylov_set_space_preconditioner

        function krylov_get_space_orthonormalizer(index) result(orthonormalizer)
            import IK
            integer(IK), intent(in) :: index
            character(len=1) :: orthonormalizer
        end function krylov_get_space_orthonormalizer

        function krylov_set_space_orthonormalizer(index, orthonormalizer) result(error)
            import IK
            integer(IK), intent(in) :: index
            character(len=1), intent(in) :: orthonormalizer
            integer(IK) :: error
        end function krylov_set_space_orthonormalizer

        function krylov_get_space_full_dim(index) result(full_dim)
            import IK
            integer(IK), intent(in) :: index
            integer(IK) :: full_dim
        end function krylov_get_space_full_dim

        function krylov_get_space_solution_dim(index) result(solution_dim)
            import IK
            integer(IK), intent(in) :: index
            integer(IK) :: solution_dim
        end function krylov_get_space_solution_dim

        function krylov_get_space_basis_dim(index) result(basis_dim)
            import IK
            integer(IK), intent(in) :: index
            integer(IK) :: basis_dim
        end function krylov_get_space_basis_dim

        function krylov_get_space_vector_size(index) result(length)
            import IK
            integer(IK), intent(in) :: index
            integer(IK) :: length
        end function krylov_get_space_vector_size

        function krylov_get_space_solution_size(index) result(length)
            import IK
            integer(IK), intent(in) :: index
            integer(IK) :: length
        end function krylov_get_space_solution_size

        function krylov_get_space_eigenvalue_size(index) result(length)
            import IK
            integer(IK), intent(in) :: index
            integer(IK) :: length
        end function krylov_get_space_eigenvalue_size

        function krylov_get_space_rhs_size(index) result(length)
            import IK
            integer(IK), intent(in) :: index
            integer(IK) :: length
        end function krylov_get_space_rhs_size

        function krylov_get_space_sylvester_b_size(index) result(length)
            import IK
            integer(IK), intent(in) :: index
            integer(IK) :: length
        end function krylov_get_space_sylvester_b_size

        function krylov_get_space_last_basis_dim(index) result(last_basis_dim)
            import IK
            integer(IK), intent(in) :: index
            integer(IK) :: last_basis_dim
        end function krylov_get_space_last_basis_dim

        function krylov_get_space_last_residual_norm(index) result(last_residual_norm)
            import IK, RK
            integer(IK), intent(in) :: index
            real(RK) :: last_residual_norm
        end function krylov_get_space_last_residual_norm

        function krylov_get_space_last_gram_rcond(index) &
            result(last_gram_rcond)
            import IK, RK
            integer(IK), intent(in) :: index
            real(RK) :: last_gram_rcond
        end function krylov_get_space_last_gram_rcond

        function krylov_get_space_last_lagrangian(index) result(last_lagrangian)
            import IK, RK
            integer(IK), intent(in) :: index
            real(RK) :: last_lagrangian
        end function krylov_get_space_last_lagrangian

        function krylov_get_space_convergence(index) result(status)
            import IK
            integer(IK), intent(in) :: index
            integer(IK) :: status
        end function krylov_get_space_convergence

        function krylov_get_space_eigenvalues(index, solution_dim, eigenvalues) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, solution_dim
            real(RK), intent(out) :: eigenvalues(solution_dim)
            integer(IK) :: error
        end function krylov_get_space_eigenvalues

        function krylov_get_real_space_vectors(index, full_dim, basis_dim, vectors) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, full_dim, basis_dim
            real(RK), intent(out) :: vectors(full_dim, basis_dim)
            integer(IK) :: error
        end function krylov_get_real_space_vectors

        function krylov_set_real_space_vectors(index, full_dim, basis_dim, vectors) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, full_dim, basis_dim
            real(RK), intent(in) :: vectors(full_dim, basis_dim)
            integer(IK) :: error
        end function krylov_set_real_space_vectors

        function krylov_set_real_space_vectors_from_diagonal(index, full_dim, basis_dim, diagonal) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, full_dim, basis_dim
            real(RK), intent(in) :: diagonal(full_dim)
            integer(IK) :: error
        end function krylov_set_real_space_vectors_from_diagonal

        function krylov_resize_real_space_vectors(index, basis_dim) result(error)
            import IK
            integer(IK), intent(in) :: index, basis_dim
            integer(IK) :: error
        end function krylov_resize_real_space_vectors

        function krylov_get_real_space_products(index, full_dim, basis_dim, products) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, full_dim, basis_dim
            real(RK), intent(out) :: products(full_dim, basis_dim)
            integer(IK) :: error
        end function krylov_get_real_space_products

        function krylov_get_real_space_solutions(index, full_dim, solution_dim, solutions) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, full_dim, solution_dim
            real(RK), intent(out) :: solutions(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_get_real_space_solutions

        function krylov_resize_real_space_solutions(index, solution_dim) result(error)
            import IK
            integer(IK), intent(in) :: index, solution_dim
            integer(IK) :: error
        end function krylov_resize_real_space_solutions

        function krylov_get_real_space_rhs(index, full_dim, solution_dim, rhs) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, full_dim, solution_dim
            real(RK), intent(out) :: rhs(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_get_real_space_rhs

        function krylov_set_real_space_rhs(index, full_dim, solution_dim, rhs) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, full_dim, solution_dim
            real(RK), intent(in) :: rhs(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_set_real_space_rhs

        function krylov_get_real_space_shifts(index, solution_dim, shifts) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, solution_dim
            real(RK), intent(out) :: shifts(solution_dim)
            integer(IK) :: error
        end function krylov_get_real_space_shifts

        function krylov_set_real_space_shifts(index, solution_dim, shifts) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, solution_dim
            real(RK), intent(in) :: shifts(solution_dim)
            integer(IK) :: error
        end function krylov_set_real_space_shifts

        function krylov_get_real_space_sylvester_b(index, solution_dim, sylvester_b) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, solution_dim
            real(RK), intent(out) :: sylvester_b(solution_dim, solution_dim)
            integer(IK) :: error
        end function krylov_get_real_space_sylvester_b

        function krylov_set_real_space_sylvester_b(index, solution_dim, sylvester_b) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, solution_dim
            real(RK), intent(in) :: sylvester_b(solution_dim, solution_dim)
            integer(IK) :: error
        end function krylov_set_real_space_sylvester_b

        function krylov_get_real_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, full_dim, skip_dim, subset_dim
            real(RK), intent(out) :: vectors(full_dim, subset_dim)
            integer(IK) :: error
        end function krylov_get_real_space_subset_vectors

        function krylov_set_real_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, full_dim, skip_dim, subset_dim
            real(RK), intent(in) :: vectors(full_dim, subset_dim)
            integer(IK) :: error
        end function krylov_set_real_space_subset_vectors

        function krylov_get_real_space_subset_products(index, full_dim, skip_dim, subset_dim, products) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, full_dim, skip_dim, subset_dim
            real(RK), intent(out) :: products(full_dim, subset_dim)
            integer(IK) :: error
        end function krylov_get_real_space_subset_products

        function krylov_set_real_space_subset_products(index, full_dim, skip_dim, subset_dim, products) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, full_dim, skip_dim, subset_dim
            real(RK), intent(in) :: products(full_dim, subset_dim)
            integer(IK) :: error
        end function krylov_set_real_space_subset_products

        function krylov_get_complex_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors) result(error)
            import IK, CK
            integer(IK), intent(in) :: index, full_dim, skip_dim, subset_dim
            complex(CK), intent(out) :: vectors(full_dim, subset_dim)
            integer(IK) :: error
        end function krylov_get_complex_space_subset_vectors

        function krylov_set_complex_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors) result(error)
            import IK, CK
            integer(IK), intent(in) :: index, full_dim, skip_dim, subset_dim
            complex(CK), intent(in) :: vectors(full_dim, subset_dim)
            integer(IK) :: error
        end function krylov_set_complex_space_subset_vectors

        function krylov_get_complex_space_subset_products(index, full_dim, skip_dim, subset_dim, products) result(error)
            import IK, CK
            integer(IK), intent(in) :: index, full_dim, skip_dim, subset_dim
            complex(CK), intent(out) :: products(full_dim, subset_dim)
            integer(IK) :: error
        end function krylov_get_complex_space_subset_products

        function krylov_set_complex_space_subset_products(index, full_dim, skip_dim, subset_dim, products) result(error)
            import IK, CK
            integer(IK), intent(in) :: index, full_dim, skip_dim, subset_dim
            complex(CK), intent(in) :: products(full_dim, subset_dim)
            integer(IK) :: error
        end function krylov_set_complex_space_subset_products

        function krylov_get_complex_space_vectors(index, full_dim, basis_dim, vectors) result(error)
            import IK, CK
            integer(IK), intent(in) :: index, full_dim, basis_dim
            complex(CK), intent(out) :: vectors(full_dim, basis_dim)
            integer(IK) :: error
        end function krylov_get_complex_space_vectors

        function krylov_set_complex_space_vectors(index, full_dim, basis_dim, vectors) result(error)
            import IK, CK
            integer(IK), intent(in) :: index, full_dim, basis_dim
            complex(CK), intent(in) :: vectors(full_dim, basis_dim)
            integer(IK) :: error
        end function krylov_set_complex_space_vectors

        function krylov_set_complex_space_vectors_from_diagonal(index, full_dim, basis_dim, diagonal) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, full_dim, basis_dim
            real(RK), intent(in) :: diagonal(full_dim)
            integer(IK) :: error
        end function krylov_set_complex_space_vectors_from_diagonal

        function krylov_resize_complex_space_vectors(index, basis_dim) result(error)
            import IK
            integer(IK), intent(in) :: index, basis_dim
            integer(IK) :: error
        end function krylov_resize_complex_space_vectors

        function krylov_get_complex_space_products(index, full_dim, basis_dim, products) result(error)
            import IK, CK
            integer(IK), intent(in) :: index, full_dim, basis_dim
            complex(CK), intent(out) :: products(full_dim, basis_dim)
            integer(IK) :: error
        end function krylov_get_complex_space_products

        function krylov_get_complex_space_solutions(index, full_dim, solution_dim, solutions) result(error)
            import IK, CK
            integer(IK), intent(in) :: index, full_dim, solution_dim
            complex(CK), intent(out) :: solutions(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_get_complex_space_solutions

        function krylov_resize_complex_space_solutions(index, solution_dim) result(error)
            import IK
            integer(IK), intent(in) :: index, solution_dim
            integer(IK) :: error
        end function krylov_resize_complex_space_solutions

        function krylov_get_complex_space_rhs(index, full_dim, solution_dim, rhs) result(error)
            import IK, CK
            integer(IK), intent(in) :: index, full_dim, solution_dim
            complex(CK), intent(out) :: rhs(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_get_complex_space_rhs

        function krylov_set_complex_space_rhs(index, full_dim, solution_dim, rhs) result(error)
            import IK, CK
            integer(IK), intent(in) :: index, full_dim, solution_dim
            complex(CK), intent(in) :: rhs(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_set_complex_space_rhs

        function krylov_get_complex_space_shifts(index, solution_dim, shifts) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, solution_dim
            real(RK), intent(out) :: shifts(solution_dim)
            integer(IK) :: error
        end function krylov_get_complex_space_shifts

        function krylov_set_complex_space_shifts(index, solution_dim, shifts) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, solution_dim
            real(RK), intent(in) :: shifts(solution_dim)
            integer(IK) :: error
        end function krylov_set_complex_space_shifts

        function krylov_get_complex_space_sylvester_b(index, solution_dim, sylvester_b) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, solution_dim
            complex(RK), intent(out) :: sylvester_b(solution_dim, solution_dim)
            integer(IK) :: error
        end function krylov_get_complex_space_sylvester_b

        function krylov_set_complex_space_sylvester_b(index, solution_dim, sylvester_b) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, solution_dim
            complex(RK), intent(in) :: sylvester_b(solution_dim, solution_dim)
            integer(IK) :: error
        end function krylov_set_complex_space_sylvester_b

        function krylov_set_space_diagonal(index, full_dim, diagonal) result(error)
            import IK, RK
            integer(IK), intent(in) :: index, full_dim
            real(RK), intent(in) :: diagonal(full_dim)
            integer(IK) :: error
        end function krylov_set_space_diagonal

        function krylov_get_real_block_dims(num_spaces, full_dims, subset_dims, offsets, total_size) result(error)
            import IK
            integer(IK), intent(in) :: num_spaces
            integer(IK), intent(out) :: full_dims(num_spaces), subset_dims(num_spaces), offsets(num_spaces), total_size
            integer(IK) :: error
        end function krylov_get_real_block_dims

        function krylov_get_real_block_vectors(num_spaces, total_size, full_dims, subset_dims, offsets, vectors) result(error)
            import IK, RK
            integer(IK), intent(in) :: num_spaces, total_size, full_dims(num_spaces), subset_dims(num_spaces), &
                                       offsets(num_spaces)
            real(RK), intent(out) :: vectors(total_size)
            integer(IK) :: error
        end function krylov_get_real_block_vectors

        function krylov_set_real_block_products(num_spaces, total_size, full_dims, subset_dims, offsets, products) result(error)
            import IK, RK
            integer(IK), intent(in) :: num_spaces, total_size, full_dims(num_spaces), subset_dims(num_spaces), &
                                       offsets(num_spaces)
            real(RK), intent(in) :: products(total_size)
            integer(IK) :: error
        end function krylov_set_real_block_products

        function krylov_get_real_block_convergence() result(status)
            import IK
            integer(IK) :: status
        end function krylov_get_real_block_convergence

        function krylov_get_complex_block_dims(num_spaces, full_dims, subset_dims, offsets, total_size) result(error)
            import IK
            integer(IK), intent(in) :: num_spaces
            integer(IK), intent(out) :: full_dims(num_spaces), subset_dims(num_spaces), offsets(num_spaces), total_size
            integer(IK) :: error
        end function krylov_get_complex_block_dims

        function krylov_get_complex_block_vectors(num_spaces, total_size, full_dims, subset_dims, offsets, vectors) result(error)
            import IK, CK
            integer(IK), intent(in) :: num_spaces, total_size, full_dims(num_spaces), subset_dims(num_spaces), &
                                       offsets(num_spaces)
            complex(CK), intent(out) :: vectors(total_size)
            integer(IK) :: error
        end function krylov_get_complex_block_vectors

        function krylov_set_complex_block_products(num_spaces, total_size, full_dims, subset_dims, offsets, products) result(error)
            import IK, CK
            integer(IK), intent(in) :: num_spaces, total_size, full_dims(num_spaces), subset_dims(num_spaces), &
                                       offsets(num_spaces)
            complex(CK), intent(in) :: products(total_size)
            integer(IK) :: error
        end function krylov_set_complex_block_products

        function krylov_get_complex_block_convergence() result(status)
            import IK
            integer(IK) :: status
        end function krylov_get_complex_block_convergence

        function krylov_solve_real_equation(index, multiply) result(error)
            import IK, krylov_i_real_multiply
            integer(IK), intent(in) :: index
            procedure(krylov_i_real_multiply) :: multiply
            integer(IK) :: error
        end function krylov_solve_real_equation

        function krylov_solve_real_block_equation(block_multiply) result(error)
            import IK, krylov_i_real_block_multiply
            procedure(krylov_i_real_block_multiply) :: block_multiply
            integer(IK) :: error
        end function krylov_solve_real_block_equation

        function krylov_solve_complex_equation(index, multiply) result(error)
            import IK, krylov_i_complex_multiply
            integer(IK), intent(in) :: index
            procedure(krylov_i_complex_multiply) :: multiply
            integer(IK) :: error
        end function krylov_solve_complex_equation

        function krylov_solve_complex_block_equation(block_multiply) result(error)
            import IK, krylov_i_complex_block_multiply
            procedure(krylov_i_complex_block_multiply) :: block_multiply
            integer(IK) :: error
        end function krylov_solve_complex_block_equation

    end interface

end module krylov
