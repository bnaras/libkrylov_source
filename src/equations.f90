module equations

    use kinds, only: IK, RK, CK
    use options, only: config_t
    use orthonormalizers, only: real_orthonormalizer_t, complex_orthonormalizer_t
    implicit none

    type, abstract :: real_equation_t
        integer(IK) :: full_dim, solution_dim, basis_dim, new_dim
        type(config_t), allocatable :: config
        real(RK), allocatable :: vectors(:, :), products(:, :), solutions(:, :), residuals(:, :), &
                                 rayleigh(:, :), basis_solutions(:, :)
    contains
        procedure(krylov_real_equation_i_initialize), deferred, pass :: initialize
        procedure(krylov_real_equation_i_expand_equation), deferred, pass :: expand_equation
        procedure(krylov_real_equation_i_solve_projected), deferred, pass :: solve_projected
        procedure(krylov_real_equation_i_get_expectation_vals), deferred, pass :: get_expectation_vals
        procedure(krylov_real_equation_i_get_lagrangian), deferred, pass :: get_lagrangian
        procedure(krylov_real_equation_i_make_residuals), deferred, pass :: make_residuals
        procedure(krylov_real_equation_i_resize_vectors), deferred, pass :: resize_vectors
        procedure(krylov_real_equation_i_resize_solutions), deferred, pass :: resize_solutions
    end type real_equation_t

    type, extends(real_equation_t) :: real_eigenvalue_equation_t
        real(RK), allocatable :: eigenvalues(:)
    contains
        procedure, pass :: initialize => krylov_real_eigenvalue_equation_initialize
        procedure, pass :: expand_equation => krylov_real_eigenvalue_equation_expand_equation
        procedure, pass :: solve_projected => krylov_real_eigenvalue_equation_solve_projected
        procedure, pass :: get_expectation_vals => krylov_real_eigenvalue_equation_get_expectation_vals
        procedure, pass :: get_lagrangian => krylov_real_eigenvalue_equation_get_lagrangian
        procedure, pass :: make_residuals => krylov_real_eigenvalue_equation_make_residuals
        procedure, pass :: resize_vectors => krylov_real_eigenvalue_equation_resize_vectors
        procedure, pass :: resize_solutions => krylov_real_eigenvalue_equation_resize_solutions
        final :: krylov_real_eigenvalue_equation_finalize
    end type real_eigenvalue_equation_t

    type, extends(real_equation_t) :: real_linear_equation_t
        real(RK), allocatable :: rhs(:, :), basis_rhs(:, :)
    contains
        procedure, pass :: initialize => krylov_real_linear_equation_initialize
        procedure, pass :: expand_equation => krylov_real_linear_equation_expand_equation
        procedure, pass :: solve_projected => krylov_real_linear_equation_solve_projected
        procedure, pass :: get_expectation_vals => krylov_real_linear_equation_get_expectation_vals
        procedure, pass :: get_lagrangian => krylov_real_linear_equation_get_lagrangian
        procedure, pass :: make_residuals => krylov_real_linear_equation_make_residuals
        procedure, pass :: resize_vectors => krylov_real_linear_equation_resize_vectors
        procedure, pass :: resize_solutions => krylov_real_linear_equation_resize_solutions
        final :: krylov_real_linear_equation_finalize
    end type real_linear_equation_t

    type, extends(real_equation_t) :: real_shifted_linear_equation_t
        real(RK), allocatable :: rhs(:, :), shifts(:), basis_rhs(:, :)
    contains
        procedure, pass :: initialize => krylov_real_shifted_linear_equation_initialize
        procedure, pass :: expand_equation => krylov_real_shifted_linear_equation_expand_equation
        procedure, pass :: solve_projected => krylov_real_shifted_linear_equation_solve_projected
        procedure, pass :: get_expectation_vals => krylov_real_shifted_linear_equation_get_expectation_vals
        procedure, pass :: get_lagrangian => krylov_real_shifted_linear_equation_get_lagrangian
        procedure, pass :: make_residuals => krylov_real_shifted_linear_equation_make_residuals
        procedure, pass :: resize_vectors => krylov_real_shifted_linear_equation_resize_vectors
        procedure, pass :: resize_solutions => krylov_real_shifted_linear_equation_resize_solutions
        final :: krylov_real_shifted_linear_equation_finalize
    end type real_shifted_linear_equation_t

    type, extends(real_equation_t) :: real_sylvester_equation_t
        real(RK), allocatable :: rhs(:, :), sylvester_b(:, :), basis_rhs(:, :)
    contains
        procedure, pass :: initialize => krylov_real_sylvester_equation_initialize
        procedure, pass :: expand_equation => krylov_real_sylvester_equation_expand_equation
        procedure, pass :: solve_projected => krylov_real_sylvester_equation_solve_projected
        procedure, pass :: get_expectation_vals => krylov_real_sylvester_equation_get_expectation_vals
        procedure, pass :: get_lagrangian => krylov_real_sylvester_equation_get_lagrangian
        procedure, pass :: make_residuals => krylov_real_sylvester_equation_make_residuals
        procedure, pass :: resize_vectors => krylov_real_sylvester_equation_resize_vectors
        procedure, pass :: resize_solutions => krylov_real_sylvester_equation_resize_solutions
        final :: krylov_real_sylvester_equation_finalize
    end type real_sylvester_equation_t

    type, abstract :: complex_equation_t
        integer(IK) :: full_dim, solution_dim, basis_dim, new_dim
        type(config_t), allocatable :: config
        complex(CK), allocatable :: vectors(:, :), products(:, :), solutions(:, :), residuals(:, :), &
                                    rayleigh(:, :), basis_solutions(:, :)
    contains
        procedure(krylov_complex_equation_i_initialize), deferred, pass :: initialize
        procedure(krylov_complex_equation_i_expand_equation), deferred, pass :: expand_equation
        procedure(krylov_complex_equation_i_solve_projected), deferred, pass :: solve_projected
        procedure(krylov_complex_equation_i_get_expectation_vals), deferred, pass :: get_expectation_vals
        procedure(krylov_complex_equation_i_get_lagrangian), deferred, pass :: get_lagrangian
        procedure(krylov_complex_equation_i_make_residuals), deferred, pass :: make_residuals
        procedure(krylov_complex_equation_i_resize_vectors), deferred, pass :: resize_vectors
        procedure(krylov_complex_equation_i_resize_solutions), deferred, pass :: resize_solutions
    end type complex_equation_t

    type, extends(complex_equation_t) :: complex_eigenvalue_equation_t
        real(RK), allocatable :: eigenvalues(:)
    contains
        procedure, pass :: initialize => krylov_complex_eigenvalue_equation_initialize
        procedure, pass :: expand_equation => krylov_complex_eigenvalue_equation_expand_equation
        procedure, pass :: solve_projected => krylov_complex_eigenvalue_equation_solve_projected
        procedure, pass :: get_expectation_vals => krylov_complex_eigenvalue_equation_get_expectation_vals
        procedure, pass :: get_lagrangian => krylov_complex_eigenvalue_equation_get_lagrangian
        procedure, pass :: make_residuals => krylov_complex_eigenvalue_equation_make_residuals
        procedure, pass :: resize_vectors => krylov_complex_eigenvalue_equation_resize_vectors
        procedure, pass :: resize_solutions => krylov_complex_eigenvalue_equation_resize_solutions
        final :: krylov_complex_eigenvalue_equation_finalize
    end type complex_eigenvalue_equation_t

    type, extends(complex_equation_t) :: complex_linear_equation_t
        complex(CK), allocatable :: rhs(:, :), basis_rhs(:, :)
    contains
        procedure, pass :: initialize => krylov_complex_linear_equation_initialize
        procedure, pass :: expand_equation => krylov_complex_linear_equation_expand_equation
        procedure, pass :: solve_projected => krylov_complex_linear_equation_solve_projected
        procedure, pass :: get_expectation_vals => krylov_complex_linear_equation_get_expectation_vals
        procedure, pass :: get_lagrangian => krylov_complex_linear_equation_get_lagrangian
        procedure, pass :: make_residuals => krylov_complex_linear_equation_make_residuals
        procedure, pass :: resize_vectors => krylov_complex_linear_equation_resize_vectors
        procedure, pass :: resize_solutions => krylov_complex_linear_equation_resize_solutions
        final :: krylov_complex_linear_equation_finalize
    end type complex_linear_equation_t

    type, extends(complex_equation_t) :: complex_shifted_linear_equation_t
        complex(CK), allocatable :: rhs(:, :), basis_rhs(:, :)
        real(RK), allocatable :: shifts(:)
    contains
        procedure, pass :: initialize => krylov_complex_shifted_linear_equation_initialize
        procedure, pass :: expand_equation => krylov_complex_shifted_linear_equation_expand_equation
        procedure, pass :: solve_projected => krylov_complex_shifted_linear_equation_solve_projected
        procedure, pass :: get_expectation_vals => krylov_complex_shifted_linear_equation_get_expectation_vals
        procedure, pass :: get_lagrangian => krylov_complex_shifted_linear_equation_get_lagrangian
        procedure, pass :: make_residuals => krylov_complex_shifted_linear_equation_make_residuals
        procedure, pass :: resize_vectors => krylov_complex_shifted_linear_equation_resize_vectors
        procedure, pass :: resize_solutions => krylov_complex_shifted_linear_equation_resize_solutions
        final :: krylov_complex_shifted_linear_equation_finalize
    end type complex_shifted_linear_equation_t

    type, extends(complex_equation_t) :: complex_sylvester_equation_t
        complex(CK), allocatable :: rhs(:, :), basis_rhs(:, :), sylvester_b(:, :)
    contains
        procedure, pass :: initialize => krylov_complex_sylvester_equation_initialize
        procedure, pass :: expand_equation => krylov_complex_sylvester_equation_expand_equation
        procedure, pass :: solve_projected => krylov_complex_sylvester_equation_solve_projected
        procedure, pass :: get_expectation_vals => krylov_complex_sylvester_equation_get_expectation_vals
        procedure, pass :: get_lagrangian => krylov_complex_sylvester_equation_get_lagrangian
        procedure, pass :: make_residuals => krylov_complex_sylvester_equation_make_residuals
        procedure, pass :: resize_vectors => krylov_complex_sylvester_equation_resize_vectors
        procedure, pass :: resize_solutions => krylov_complex_sylvester_equation_resize_solutions
        final :: krylov_complex_sylvester_equation_finalize
    end type complex_sylvester_equation_t

    abstract interface

        function krylov_real_equation_i_initialize( &
            equation, full_dim, solution_dim, basis_dim, config) result(error)
            import real_equation_t, config_t, IK
            class(real_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_equation_i_initialize

        function krylov_real_equation_i_expand_equation(equation) result(error)
            import real_equation_t, IK
            class(real_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_real_equation_i_expand_equation

        function krylov_real_equation_i_solve_projected(equation, orthonormalizer) result(error)
            import real_equation_t, real_orthonormalizer_t, IK
            class(real_equation_t), intent(inout) :: equation
            class(real_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK) :: error
        end function krylov_real_equation_i_solve_projected

        function krylov_real_equation_i_get_expectation_vals(equation, solution_dim, expectation_vals) result(error)
            import real_equation_t, IK, RK
            class(real_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(out) :: expectation_vals(solution_dim)
            integer(IK) :: error
        end function krylov_real_equation_i_get_expectation_vals

        function krylov_real_equation_i_get_lagrangian(equation) result(lagrangian)
            import real_equation_t, RK
            class(real_equation_t), intent(inout) :: equation
            real(RK) :: lagrangian
        end function krylov_real_equation_i_get_lagrangian

        function krylov_real_equation_i_make_residuals(equation) result(error)
            import real_equation_t, IK
            class(real_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_real_equation_i_make_residuals

        function krylov_real_equation_i_resize_vectors(equation, basis_dim) result(error)
            import real_equation_t, IK
            class(real_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: basis_dim
            integer(IK) :: error
        end function krylov_real_equation_i_resize_vectors

        function krylov_real_equation_i_resize_solutions(equation, solution_dim) result(error)
            import real_equation_t, IK
            class(real_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            integer(IK) :: error
        end function krylov_real_equation_i_resize_solutions

        function krylov_complex_equation_i_initialize( &
            equation, full_dim, solution_dim, basis_dim, config) result(error)
            import complex_equation_t, config_t, IK
            class(complex_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_equation_i_initialize

        function krylov_complex_equation_i_expand_equation(equation) result(error)
            import complex_equation_t, IK
            class(complex_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_complex_equation_i_expand_equation

        function krylov_complex_equation_i_solve_projected(equation, orthonormalizer) result(error)
            import complex_equation_t, complex_orthonormalizer_t, IK
            class(complex_equation_t), intent(inout) :: equation
            class(complex_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK) :: error
        end function krylov_complex_equation_i_solve_projected

        function krylov_complex_equation_i_get_expectation_vals(equation, solution_dim, expectation_vals) result(error)
            import complex_equation_t, IK, RK
            class(complex_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(out) :: expectation_vals(solution_dim)
            integer(IK) :: error
        end function krylov_complex_equation_i_get_expectation_vals

        function krylov_complex_equation_i_get_lagrangian(equation) result(lagrangian)
            import complex_equation_t, RK
            class(complex_equation_t), intent(inout) :: equation
            real(RK) :: lagrangian
        end function krylov_complex_equation_i_get_lagrangian

        function krylov_complex_equation_i_make_residuals(equation) result(error)
            import complex_equation_t, IK
            class(complex_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_complex_equation_i_make_residuals

        function krylov_complex_equation_i_resize_vectors(equation, basis_dim) result(error)
            import complex_equation_t, IK
            class(complex_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: basis_dim
            integer(IK) :: error
        end function krylov_complex_equation_i_resize_vectors

        function krylov_complex_equation_i_resize_solutions(equation, solution_dim) result(error)
            import complex_equation_t, IK
            class(complex_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            integer(IK) :: error
        end function krylov_complex_equation_i_resize_solutions

    end interface

    interface

        function krylov_real_eigenvalue_equation_initialize( &
            equation, full_dim, solution_dim, basis_dim, config) result(error)
            import real_eigenvalue_equation_t, config_t, IK
            class(real_eigenvalue_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_eigenvalue_equation_initialize

        function krylov_real_eigenvalue_equation_expand_equation(equation) result(error)
            import real_eigenvalue_equation_t, IK
            class(real_eigenvalue_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_real_eigenvalue_equation_expand_equation

        function krylov_real_eigenvalue_equation_solve_projected(equation, orthonormalizer) result(error)
            import real_eigenvalue_equation_t, real_orthonormalizer_t, IK
            class(real_eigenvalue_equation_t), intent(inout) :: equation
            class(real_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK) :: error
        end function krylov_real_eigenvalue_equation_solve_projected

        function krylov_real_eigenvalue_equation_get_expectation_vals( &
            equation, solution_dim, expectation_vals) result(error)
            import real_eigenvalue_equation_t, IK, RK
            class(real_eigenvalue_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(out) :: expectation_vals(solution_dim)
            integer(IK) :: error
        end function krylov_real_eigenvalue_equation_get_expectation_vals

        function krylov_real_eigenvalue_equation_get_lagrangian(equation) result(lagrangian)
            import real_eigenvalue_equation_t, RK
            class(real_eigenvalue_equation_t), intent(inout) :: equation
            real(RK) :: lagrangian
        end function krylov_real_eigenvalue_equation_get_lagrangian

        function krylov_real_eigenvalue_equation_make_residuals(equation) result(error)
            import real_eigenvalue_equation_t, IK
            class(real_eigenvalue_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_real_eigenvalue_equation_make_residuals

        function krylov_real_eigenvalue_equation_resize_vectors(equation, basis_dim) result(error)
            import real_eigenvalue_equation_t, IK
            class(real_eigenvalue_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: basis_dim
            integer(IK) :: error
        end function krylov_real_eigenvalue_equation_resize_vectors

        function krylov_real_eigenvalue_equation_resize_solutions(equation, solution_dim) result(error)
            import real_eigenvalue_equation_t, IK
            class(real_eigenvalue_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            integer(IK) :: error
        end function krylov_real_eigenvalue_equation_resize_solutions

        function krylov_real_linear_equation_initialize( &
            equation, full_dim, solution_dim, basis_dim, config) result(error)
            import real_linear_equation_t, config_t, IK
            class(real_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_linear_equation_initialize

        function krylov_real_linear_equation_expand_equation(equation) result(error)
            import real_linear_equation_t, IK
            class(real_linear_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_real_linear_equation_expand_equation

        function krylov_real_linear_equation_solve_projected(equation, orthonormalizer) result(error)
            import real_linear_equation_t, real_orthonormalizer_t, IK
            class(real_linear_equation_t), intent(inout) :: equation
            class(real_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK) :: error
        end function krylov_real_linear_equation_solve_projected

        function krylov_real_linear_equation_get_expectation_vals( &
            equation, solution_dim, expectation_vals) result(error)
            import real_linear_equation_t, IK, RK
            class(real_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(out) :: expectation_vals(solution_dim)
            integer(IK) :: error
        end function krylov_real_linear_equation_get_expectation_vals

        function krylov_real_linear_equation_get_lagrangian(equation) result(lagrangian)
            import real_linear_equation_t, RK
            class(real_linear_equation_t), intent(inout) :: equation
            real(RK) :: lagrangian
        end function krylov_real_linear_equation_get_lagrangian

        function krylov_real_linear_equation_make_residuals(equation) result(error)
            import real_linear_equation_t, IK
            class(real_linear_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_real_linear_equation_make_residuals

        function krylov_real_linear_equation_resize_vectors(equation, basis_dim) result(error)
            import real_linear_equation_t, IK
            class(real_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: basis_dim
            integer(IK) :: error
        end function krylov_real_linear_equation_resize_vectors

        function krylov_real_linear_equation_resize_solutions(equation, solution_dim) result(error)
            import real_linear_equation_t, IK
            class(real_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            integer(IK) :: error
        end function krylov_real_linear_equation_resize_solutions

        function krylov_real_shifted_linear_equation_initialize( &
            equation, full_dim, solution_dim, basis_dim, config) result(error)
            import real_shifted_linear_equation_t, config_t, IK
            class(real_shifted_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_shifted_linear_equation_initialize

        function krylov_real_shifted_linear_equation_expand_equation(equation) result(error)
            import real_shifted_linear_equation_t, IK
            class(real_shifted_linear_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_real_shifted_linear_equation_expand_equation

        function krylov_real_shifted_linear_equation_solve_projected(equation, orthonormalizer) result(error)
            import real_shifted_linear_equation_t, real_orthonormalizer_t, IK
            class(real_shifted_linear_equation_t), intent(inout) :: equation
            class(real_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK) :: error
        end function krylov_real_shifted_linear_equation_solve_projected

        function krylov_real_shifted_linear_equation_get_expectation_vals( &
            equation, solution_dim, expectation_vals) result(error)
            import real_shifted_linear_equation_t, IK, RK
            class(real_shifted_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(out) :: expectation_vals(solution_dim)
            integer(IK) :: error
        end function krylov_real_shifted_linear_equation_get_expectation_vals

        function krylov_real_shifted_linear_equation_get_lagrangian(equation) result(lagrangian)
            import real_shifted_linear_equation_t, RK
            class(real_shifted_linear_equation_t), intent(inout) :: equation
            real(RK) :: lagrangian
        end function krylov_real_shifted_linear_equation_get_lagrangian

        function krylov_real_shifted_linear_equation_make_residuals(equation) result(error)
            import real_shifted_linear_equation_t, IK
            class(real_shifted_linear_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_real_shifted_linear_equation_make_residuals

        function krylov_real_shifted_linear_equation_resize_vectors(equation, basis_dim) result(error)
            import real_shifted_linear_equation_t, IK
            class(real_shifted_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: basis_dim
            integer(IK) :: error
        end function krylov_real_shifted_linear_equation_resize_vectors

        function krylov_real_shifted_linear_equation_resize_solutions(equation, solution_dim) result(error)
            import real_shifted_linear_equation_t, IK
            class(real_shifted_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            integer(IK) :: error
        end function krylov_real_shifted_linear_equation_resize_solutions

        function krylov_real_sylvester_equation_initialize( &
            equation, full_dim, solution_dim, basis_dim, config) result(error)
            import real_sylvester_equation_t, config_t, IK
            class(real_sylvester_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_sylvester_equation_initialize

        function krylov_real_sylvester_equation_expand_equation(equation) result(error)
            import real_sylvester_equation_t, IK
            class(real_sylvester_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_real_sylvester_equation_expand_equation

        function krylov_real_sylvester_equation_solve_projected(equation, orthonormalizer) result(error)
            import real_sylvester_equation_t, real_orthonormalizer_t, IK
            class(real_sylvester_equation_t), intent(inout) :: equation
            class(real_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK) :: error
        end function krylov_real_sylvester_equation_solve_projected

        function krylov_real_sylvester_equation_get_expectation_vals( &
            equation, solution_dim, expectation_vals) result(error)
            import real_sylvester_equation_t, IK, RK
            class(real_sylvester_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(out) :: expectation_vals(solution_dim)
            integer(IK) :: error
        end function krylov_real_sylvester_equation_get_expectation_vals

        function krylov_real_sylvester_equation_get_lagrangian(equation) result(lagrangian)
            import real_sylvester_equation_t, RK
            class(real_sylvester_equation_t), intent(inout) :: equation
            real(RK) :: lagrangian
        end function krylov_real_sylvester_equation_get_lagrangian

        function krylov_real_sylvester_equation_make_residuals(equation) result(error)
            import real_sylvester_equation_t, IK
            class(real_sylvester_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_real_sylvester_equation_make_residuals

        function krylov_real_sylvester_equation_resize_vectors(equation, basis_dim) result(error)
            import real_sylvester_equation_t, IK
            class(real_sylvester_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: basis_dim
            integer(IK) :: error
        end function krylov_real_sylvester_equation_resize_vectors

        function krylov_real_sylvester_equation_resize_solutions(equation, solution_dim) result(error)
            import real_sylvester_equation_t, IK
            class(real_sylvester_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            integer(IK) :: error
        end function krylov_real_sylvester_equation_resize_solutions

        function krylov_complex_eigenvalue_equation_initialize( &
            equation, full_dim, solution_dim, basis_dim, config) result(error)
            import complex_eigenvalue_equation_t, config_t, IK
            class(complex_eigenvalue_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_eigenvalue_equation_initialize

        function krylov_complex_eigenvalue_equation_expand_equation(equation) result(error)
            import complex_eigenvalue_equation_t, IK
            class(complex_eigenvalue_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_complex_eigenvalue_equation_expand_equation

        function krylov_complex_eigenvalue_equation_solve_projected(equation, orthonormalizer) result(error)
            import complex_eigenvalue_equation_t, complex_orthonormalizer_t, IK
            class(complex_eigenvalue_equation_t), intent(inout) :: equation
            class(complex_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK) :: error
        end function krylov_complex_eigenvalue_equation_solve_projected

        function krylov_complex_eigenvalue_equation_get_expectation_vals( &
            equation, solution_dim, expectation_vals) result(error)
            import complex_eigenvalue_equation_t, IK, RK
            class(complex_eigenvalue_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(out) :: expectation_vals(solution_dim)
            integer(IK) :: error
        end function krylov_complex_eigenvalue_equation_get_expectation_vals

        function krylov_complex_eigenvalue_equation_get_lagrangian(equation) result(lagrangian)
            import complex_eigenvalue_equation_t, RK
            class(complex_eigenvalue_equation_t), intent(inout) :: equation
            real(RK) :: lagrangian
        end function krylov_complex_eigenvalue_equation_get_lagrangian

        function krylov_complex_eigenvalue_equation_make_residuals(equation) result(error)
            import complex_eigenvalue_equation_t, IK
            class(complex_eigenvalue_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_complex_eigenvalue_equation_make_residuals

        function krylov_complex_eigenvalue_equation_resize_vectors(equation, basis_dim) result(error)
            import complex_eigenvalue_equation_t, IK
            class(complex_eigenvalue_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: basis_dim
            integer(IK) :: error
        end function krylov_complex_eigenvalue_equation_resize_vectors

        function krylov_complex_eigenvalue_equation_resize_solutions(equation, solution_dim) result(error)
            import complex_eigenvalue_equation_t, IK
            class(complex_eigenvalue_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            integer(IK) :: error
        end function krylov_complex_eigenvalue_equation_resize_solutions

        function krylov_complex_linear_equation_initialize( &
            equation, full_dim, solution_dim, basis_dim, config) result(error)
            import complex_linear_equation_t, config_t, IK
            class(complex_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_linear_equation_initialize

        function krylov_complex_linear_equation_expand_equation(equation) result(error)
            import complex_linear_equation_t, IK
            class(complex_linear_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_complex_linear_equation_expand_equation

        function krylov_complex_linear_equation_solve_projected(equation, orthonormalizer) result(error)
            import complex_linear_equation_t, complex_orthonormalizer_t, IK
            class(complex_linear_equation_t), intent(inout) :: equation
            class(complex_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK) :: error
        end function krylov_complex_linear_equation_solve_projected

        function krylov_complex_linear_equation_get_expectation_vals( &
            equation, solution_dim, expectation_vals) result(error)
            import complex_linear_equation_t, IK, RK
            class(complex_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(out) :: expectation_vals(solution_dim)
            integer(IK) :: error
        end function krylov_complex_linear_equation_get_expectation_vals

        function krylov_complex_linear_equation_get_lagrangian(equation) result(lagrangian)
            import complex_linear_equation_t, RK
            class(complex_linear_equation_t), intent(inout) :: equation
            real(RK) :: lagrangian
        end function krylov_complex_linear_equation_get_lagrangian

        function krylov_complex_linear_equation_make_residuals(equation) result(error)
            import complex_linear_equation_t, IK
            class(complex_linear_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_complex_linear_equation_make_residuals

        function krylov_complex_linear_equation_resize_vectors(equation, basis_dim) result(error)
            import complex_linear_equation_t, IK
            class(complex_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: basis_dim
            integer(IK) :: error
        end function krylov_complex_linear_equation_resize_vectors

        function krylov_complex_linear_equation_resize_solutions(equation, solution_dim) result(error)
            import complex_linear_equation_t, IK
            class(complex_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            integer(IK) :: error
        end function krylov_complex_linear_equation_resize_solutions

        function krylov_complex_shifted_linear_equation_initialize( &
            equation, full_dim, solution_dim, basis_dim, config) result(error)
            import complex_shifted_linear_equation_t, config_t, IK
            class(complex_shifted_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_shifted_linear_equation_initialize

        function krylov_complex_shifted_linear_equation_expand_equation(equation) result(error)
            import complex_shifted_linear_equation_t, IK
            class(complex_shifted_linear_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_complex_shifted_linear_equation_expand_equation

        function krylov_complex_shifted_linear_equation_solve_projected(equation, orthonormalizer) result(error)
            import complex_shifted_linear_equation_t, complex_orthonormalizer_t, IK
            class(complex_shifted_linear_equation_t), intent(inout) :: equation
            class(complex_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK) :: error
        end function krylov_complex_shifted_linear_equation_solve_projected

        function krylov_complex_shifted_linear_equation_get_expectation_vals( &
            equation, solution_dim, expectation_vals) result(error)
            import complex_shifted_linear_equation_t, IK, RK
            class(complex_shifted_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(out) :: expectation_vals(solution_dim)
            integer(IK) :: error
        end function krylov_complex_shifted_linear_equation_get_expectation_vals

        function krylov_complex_shifted_linear_equation_get_lagrangian(equation) result(lagrangian)
            import complex_shifted_linear_equation_t, RK
            class(complex_shifted_linear_equation_t), intent(inout) :: equation
            real(RK) :: lagrangian
        end function krylov_complex_shifted_linear_equation_get_lagrangian

        function krylov_complex_shifted_linear_equation_make_residuals(equation) result(error)
            import complex_shifted_linear_equation_t, IK
            class(complex_shifted_linear_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_complex_shifted_linear_equation_make_residuals

        function krylov_complex_shifted_linear_equation_resize_vectors(equation, basis_dim) result(error)
            import complex_shifted_linear_equation_t, IK
            class(complex_shifted_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: basis_dim
            integer(IK) :: error
        end function krylov_complex_shifted_linear_equation_resize_vectors

        function krylov_complex_shifted_linear_equation_resize_solutions(equation, solution_dim) result(error)
            import complex_shifted_linear_equation_t, IK
            class(complex_shifted_linear_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            integer(IK) :: error
        end function krylov_complex_shifted_linear_equation_resize_solutions

        function krylov_complex_sylvester_equation_initialize( &
            equation, full_dim, solution_dim, basis_dim, config) result(error)
            import complex_sylvester_equation_t, config_t, IK
            class(complex_sylvester_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_sylvester_equation_initialize

        function krylov_complex_sylvester_equation_expand_equation(equation) result(error)
            import complex_sylvester_equation_t, IK
            class(complex_sylvester_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_complex_sylvester_equation_expand_equation

        function krylov_complex_sylvester_equation_solve_projected(equation, orthonormalizer) result(error)
            import complex_sylvester_equation_t, complex_orthonormalizer_t, IK
            class(complex_sylvester_equation_t), intent(inout) :: equation
            class(complex_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK) :: error
        end function krylov_complex_sylvester_equation_solve_projected

        function krylov_complex_sylvester_equation_get_expectation_vals( &
            equation, solution_dim, expectation_vals) result(error)
            import complex_sylvester_equation_t, IK, RK
            class(complex_sylvester_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(out) :: expectation_vals(solution_dim)
            integer(IK) :: error
        end function krylov_complex_sylvester_equation_get_expectation_vals

        function krylov_complex_sylvester_equation_get_lagrangian(equation) result(lagrangian)
            import complex_sylvester_equation_t, RK
            class(complex_sylvester_equation_t), intent(inout) :: equation
            real(RK) :: lagrangian
        end function krylov_complex_sylvester_equation_get_lagrangian

        function krylov_complex_sylvester_equation_make_residuals(equation) result(error)
            import complex_sylvester_equation_t, IK
            class(complex_sylvester_equation_t), intent(inout) :: equation
            integer(IK) :: error
        end function krylov_complex_sylvester_equation_make_residuals

        function krylov_complex_sylvester_equation_resize_vectors(equation, basis_dim) result(error)
            import complex_sylvester_equation_t, IK
            class(complex_sylvester_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: basis_dim
            integer(IK) :: error
        end function krylov_complex_sylvester_equation_resize_vectors

        function krylov_complex_sylvester_equation_resize_solutions(equation, solution_dim) result(error)
            import complex_sylvester_equation_t, IK
            class(complex_sylvester_equation_t), intent(inout) :: equation
            integer(IK), intent(in) :: solution_dim
            integer(IK) :: error
        end function krylov_complex_sylvester_equation_resize_solutions

    end interface

contains

    subroutine krylov_real_eigenvalue_equation_finalize(equation)
        implicit none
        type(real_eigenvalue_equation_t), intent(inout) :: equation

        if (allocated(equation%config)) deallocate (equation%config)
        if (allocated(equation%vectors)) deallocate (equation%vectors)
        if (allocated(equation%products)) deallocate (equation%products)
        if (allocated(equation%solutions)) deallocate (equation%solutions)
        if (allocated(equation%residuals)) deallocate (equation%residuals)
        if (allocated(equation%eigenvalues)) deallocate (equation%eigenvalues)
        if (allocated(equation%rayleigh)) deallocate (equation%rayleigh)
        if (allocated(equation%basis_solutions)) deallocate (equation%basis_solutions)
    end subroutine krylov_real_eigenvalue_equation_finalize

    subroutine krylov_real_linear_equation_finalize(equation)
        implicit none
        type(real_linear_equation_t), intent(inout) :: equation

        if (allocated(equation%config)) deallocate (equation%config)
        if (allocated(equation%vectors)) deallocate (equation%vectors)
        if (allocated(equation%products)) deallocate (equation%products)
        if (allocated(equation%solutions)) deallocate (equation%solutions)
        if (allocated(equation%residuals)) deallocate (equation%residuals)
        if (allocated(equation%rhs)) deallocate (equation%rhs)
        if (allocated(equation%rayleigh)) deallocate (equation%rayleigh)
        if (allocated(equation%basis_solutions)) deallocate (equation%basis_solutions)
        if (allocated(equation%basis_rhs)) deallocate (equation%basis_rhs)
    end subroutine krylov_real_linear_equation_finalize

    subroutine krylov_real_shifted_linear_equation_finalize(equation)
        implicit none
        type(real_shifted_linear_equation_t), intent(inout) :: equation

        if (allocated(equation%config)) deallocate (equation%config)
        if (allocated(equation%vectors)) deallocate (equation%vectors)
        if (allocated(equation%products)) deallocate (equation%products)
        if (allocated(equation%solutions)) deallocate (equation%solutions)
        if (allocated(equation%residuals)) deallocate (equation%residuals)
        if (allocated(equation%rhs)) deallocate (equation%rhs)
        if (allocated(equation%shifts)) deallocate (equation%shifts)
        if (allocated(equation%rayleigh)) deallocate (equation%rayleigh)
        if (allocated(equation%basis_solutions)) deallocate (equation%basis_solutions)
        if (allocated(equation%basis_rhs)) deallocate (equation%basis_rhs)
    end subroutine krylov_real_shifted_linear_equation_finalize

    subroutine krylov_real_sylvester_equation_finalize(equation)
        implicit none
        type(real_sylvester_equation_t), intent(inout) :: equation

        if (allocated(equation%config)) deallocate (equation%config)
        if (allocated(equation%vectors)) deallocate (equation%vectors)
        if (allocated(equation%products)) deallocate (equation%products)
        if (allocated(equation%solutions)) deallocate (equation%solutions)
        if (allocated(equation%residuals)) deallocate (equation%residuals)
        if (allocated(equation%rhs)) deallocate (equation%rhs)
        if (allocated(equation%sylvester_b)) deallocate (equation%sylvester_b)
        if (allocated(equation%rayleigh)) deallocate (equation%rayleigh)
        if (allocated(equation%basis_solutions)) deallocate (equation%basis_solutions)
        if (allocated(equation%basis_rhs)) deallocate (equation%basis_rhs)
    end subroutine krylov_real_sylvester_equation_finalize

    subroutine krylov_complex_eigenvalue_equation_finalize(equation)
        implicit none
        type(complex_eigenvalue_equation_t), intent(inout) :: equation

        if (allocated(equation%config)) deallocate (equation%config)
        if (allocated(equation%vectors)) deallocate (equation%vectors)
        if (allocated(equation%products)) deallocate (equation%products)
        if (allocated(equation%solutions)) deallocate (equation%solutions)
        if (allocated(equation%residuals)) deallocate (equation%residuals)
        if (allocated(equation%eigenvalues)) deallocate (equation%eigenvalues)
        if (allocated(equation%rayleigh)) deallocate (equation%rayleigh)
        if (allocated(equation%basis_solutions)) deallocate (equation%basis_solutions)
    end subroutine krylov_complex_eigenvalue_equation_finalize

    subroutine krylov_complex_linear_equation_finalize(equation)
        implicit none
        type(complex_linear_equation_t), intent(inout) :: equation

        if (allocated(equation%config)) deallocate (equation%config)
        if (allocated(equation%vectors)) deallocate (equation%vectors)
        if (allocated(equation%products)) deallocate (equation%products)
        if (allocated(equation%solutions)) deallocate (equation%solutions)
        if (allocated(equation%residuals)) deallocate (equation%residuals)
        if (allocated(equation%rhs)) deallocate (equation%rhs)
        if (allocated(equation%rayleigh)) deallocate (equation%rayleigh)
        if (allocated(equation%basis_solutions)) deallocate (equation%basis_solutions)
        if (allocated(equation%basis_rhs)) deallocate (equation%basis_rhs)
    end subroutine krylov_complex_linear_equation_finalize

    subroutine krylov_complex_shifted_linear_equation_finalize(equation)
        implicit none
        type(complex_shifted_linear_equation_t), intent(inout) :: equation

        if (allocated(equation%config)) deallocate (equation%config)
        if (allocated(equation%vectors)) deallocate (equation%vectors)
        if (allocated(equation%products)) deallocate (equation%products)
        if (allocated(equation%solutions)) deallocate (equation%solutions)
        if (allocated(equation%residuals)) deallocate (equation%residuals)
        if (allocated(equation%rhs)) deallocate (equation%rhs)
        if (allocated(equation%shifts)) deallocate (equation%shifts)
        if (allocated(equation%rayleigh)) deallocate (equation%rayleigh)
        if (allocated(equation%basis_solutions)) deallocate (equation%basis_solutions)
        if (allocated(equation%basis_rhs)) deallocate (equation%basis_rhs)
    end subroutine krylov_complex_shifted_linear_equation_finalize

    subroutine krylov_complex_sylvester_equation_finalize(equation)
        implicit none
        type(complex_sylvester_equation_t), intent(inout) :: equation

        if (allocated(equation%config)) deallocate (equation%config)
        if (allocated(equation%vectors)) deallocate (equation%vectors)
        if (allocated(equation%products)) deallocate (equation%products)
        if (allocated(equation%solutions)) deallocate (equation%solutions)
        if (allocated(equation%residuals)) deallocate (equation%residuals)
        if (allocated(equation%rhs)) deallocate (equation%rhs)
        if (allocated(equation%sylvester_b)) deallocate (equation%sylvester_b)
        if (allocated(equation%rayleigh)) deallocate (equation%rayleigh)
        if (allocated(equation%basis_solutions)) deallocate (equation%basis_solutions)
        if (allocated(equation%basis_rhs)) deallocate (equation%basis_rhs)
    end subroutine krylov_complex_sylvester_equation_finalize

end module equations
