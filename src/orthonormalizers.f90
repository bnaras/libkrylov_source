module orthonormalizers

    use kinds, only: IK, RK, CK
    use options, only: config_t
    implicit none

    type, abstract :: real_orthonormalizer_t
        integer(IK) :: basis_dim
        type(config_t), allocatable :: config
    contains
        procedure(krylov_real_orthonormalizer_i_initialize), deferred, pass :: initialize
        procedure(krylov_real_orthonormalizer_i_prepare_vectors), deferred, pass :: prepare_vectors
        procedure(krylov_real_orthonormalizer_i_prepare_transform), deferred, pass :: prepare_transform
        procedure(krylov_real_orthonormalizer_i_transform_rayleigh), deferred, pass :: transform_rayleigh
        procedure(krylov_real_orthonormalizer_i_transform_basis_rhs), deferred, pass :: transform_basis_rhs
        procedure(krylov_real_orthonormalizer_i_restore_basis_solutions), deferred, pass :: restore_basis_solutions
        procedure(krylov_real_orthonormalizer_i_get_gram_rcond), deferred, pass :: get_gram_rcond
    end type real_orthonormalizer_t

    type, extends(real_orthonormalizer_t) :: real_ortho_orthonormalizer_t
    contains
        procedure, pass :: initialize => krylov_real_ortho_orthonormalizer_initialize
        procedure, pass :: prepare_vectors => krylov_real_ortho_orthonormalizer_prepare_vectors
        procedure, pass :: prepare_transform => krylov_real_ortho_orthonormalizer_prepare_transform
        procedure, pass :: transform_rayleigh => krylov_real_ortho_orthonormalizer_transform_rayleigh
        procedure, pass :: transform_basis_rhs => krylov_real_ortho_orthonormalizer_transform_basis_rhs
        procedure, pass :: restore_basis_solutions => krylov_real_ortho_orthonormalizer_restore_basis_solutions
        procedure, pass :: get_gram_rcond => krylov_real_ortho_orthonormalizer_get_gram_rcond
        final :: krylov_real_ortho_orthonormalizer_finalize
    end type real_ortho_orthonormalizer_t

    type, extends(real_orthonormalizer_t) :: real_nks_orthonormalizer_t
        real(RK), allocatable :: vector_norm_squared(:), gram_matrix(:, :), scaled_gram_matrix(:, :), &
                                 gram_matrix_decomposed(:, :)
    contains
        procedure, pass :: initialize => krylov_real_nks_orthonormalizer_initialize
        procedure, pass :: prepare_vectors => krylov_real_nks_orthonormalizer_prepare_vectors
        procedure, pass :: prepare_transform => krylov_real_nks_orthonormalizer_prepare_transform
        procedure, pass :: transform_rayleigh => krylov_real_nks_orthonormalizer_transform_rayleigh
        procedure, pass :: transform_basis_rhs => krylov_real_nks_orthonormalizer_transform_basis_rhs
        procedure, pass :: restore_basis_solutions => krylov_real_nks_orthonormalizer_restore_basis_solutions
        procedure, pass :: get_gram_rcond => krylov_real_nks_orthonormalizer_get_gram_rcond
        final :: krylov_real_nks_orthonormalizer_finalize
    end type real_nks_orthonormalizer_t

    type, extends(real_orthonormalizer_t) :: real_semi_orthonormalizer_t
        real(RK), allocatable :: vector_norm_squared(:), gram_matrix(:, :), scaled_gram_matrix(:, :), &
                                 gram_matrix_decomposed(:, :)
    contains
        procedure, pass :: initialize => krylov_real_semi_orthonormalizer_initialize
        procedure, pass :: prepare_vectors => krylov_real_semi_orthonormalizer_prepare_vectors
        procedure, pass :: prepare_transform => krylov_real_semi_orthonormalizer_prepare_transform
        procedure, pass :: transform_rayleigh => krylov_real_semi_orthonormalizer_transform_rayleigh
        procedure, pass :: transform_basis_rhs => krylov_real_semi_orthonormalizer_transform_basis_rhs
        procedure, pass :: restore_basis_solutions => krylov_real_semi_orthonormalizer_restore_basis_solutions
        procedure, pass :: get_gram_rcond => krylov_real_semi_orthonormalizer_get_gram_rcond
        final :: krylov_real_semi_orthonormalizer_finalize
    end type real_semi_orthonormalizer_t

    type, abstract :: complex_orthonormalizer_t
        integer(IK) :: basis_dim
        type(config_t), allocatable :: config
    contains
        procedure(krylov_complex_orthonormalizer_i_initialize), deferred, pass :: initialize
        procedure(krylov_complex_orthonormalizer_i_prepare_vectors), deferred, pass :: prepare_vectors
        procedure(krylov_complex_orthonormalizer_i_prepare_transform), deferred, pass :: prepare_transform
        procedure(krylov_complex_orthonormalizer_i_transform_rayleigh), deferred, pass :: transform_rayleigh
        procedure(krylov_complex_orthonormalizer_i_transform_basis_rhs), deferred, pass :: transform_basis_rhs
        procedure(krylov_complex_orthonormalizer_i_restore_basis_solutions), deferred, pass :: restore_basis_solutions
        procedure(krylov_complex_orthonormalizer_i_get_gram_rcond), deferred, pass :: get_gram_rcond
    end type complex_orthonormalizer_t

    type, extends(complex_orthonormalizer_t) :: complex_ortho_orthonormalizer_t
    contains
        procedure, pass :: initialize => krylov_complex_ortho_orthonormalizer_initialize
        procedure, pass :: prepare_vectors => krylov_complex_ortho_orthonormalizer_prepare_vectors
        procedure, pass :: prepare_transform => krylov_complex_ortho_orthonormalizer_prepare_transform
        procedure, pass :: transform_rayleigh => krylov_complex_ortho_orthonormalizer_transform_rayleigh
        procedure, pass :: transform_basis_rhs => krylov_complex_ortho_orthonormalizer_transform_basis_rhs
        procedure, pass :: restore_basis_solutions => krylov_complex_ortho_orthonormalizer_restore_basis_solutions
        procedure, pass :: get_gram_rcond => krylov_complex_ortho_orthonormalizer_get_gram_rcond
        final :: krylov_complex_ortho_orthonormalizer_finalize
    end type complex_ortho_orthonormalizer_t

    type, extends(complex_orthonormalizer_t) :: complex_nks_orthonormalizer_t
        real(RK), allocatable :: vector_norm_squared(:)
        complex(CK), allocatable :: gram_matrix(:, :), scaled_gram_matrix(:, :), gram_matrix_decomposed(:, :)
    contains
        procedure, pass :: initialize => krylov_complex_nks_orthonormalizer_initialize
        procedure, pass :: prepare_vectors => krylov_complex_nks_orthonormalizer_prepare_vectors
        procedure, pass :: prepare_transform => krylov_complex_nks_orthonormalizer_prepare_transform
        procedure, pass :: transform_rayleigh => krylov_complex_nks_orthonormalizer_transform_rayleigh
        procedure, pass :: transform_basis_rhs => krylov_complex_nks_orthonormalizer_transform_basis_rhs
        procedure, pass :: restore_basis_solutions => krylov_complex_nks_orthonormalizer_restore_basis_solutions
        procedure, pass :: get_gram_rcond => krylov_complex_nks_orthonormalizer_get_gram_rcond
        final :: krylov_complex_nks_orthonormalizer_finalize
    end type complex_nks_orthonormalizer_t

    type, extends(complex_orthonormalizer_t) :: complex_semi_orthonormalizer_t
        real(RK), allocatable :: vector_norm_squared(:)
        complex(CK), allocatable :: gram_matrix(:, :), scaled_gram_matrix(:, :), gram_matrix_decomposed(:, :)
    contains
        procedure, pass :: initialize => krylov_complex_semi_orthonormalizer_initialize
        procedure, pass :: prepare_vectors => krylov_complex_semi_orthonormalizer_prepare_vectors
        procedure, pass :: prepare_transform => krylov_complex_semi_orthonormalizer_prepare_transform
        procedure, pass :: transform_rayleigh => krylov_complex_semi_orthonormalizer_transform_rayleigh
        procedure, pass :: transform_basis_rhs => krylov_complex_semi_orthonormalizer_transform_basis_rhs
        procedure, pass :: restore_basis_solutions => krylov_complex_semi_orthonormalizer_restore_basis_solutions
        procedure, pass :: get_gram_rcond => krylov_complex_semi_orthonormalizer_get_gram_rcond
        final :: krylov_complex_semi_orthonormalizer_finalize
    end type complex_semi_orthonormalizer_t

    abstract interface

        function krylov_real_orthonormalizer_i_initialize(orthonormalizer, config) result(error)
            import real_orthonormalizer_t, config_t, IK
            class(real_orthonormalizer_t), intent(inout) :: orthonormalizer
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_orthonormalizer_i_initialize

        function krylov_real_orthonormalizer_i_prepare_vectors( &
            orthonormalizer, full_dim, basis_dim, solution_dim, vectors, residuals, new_vectors, new_dim) result(error)
            import real_orthonormalizer_t, IK, RK
            class(real_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim, solution_dim
            real(RK), intent(in) :: vectors(full_dim, basis_dim), residuals(full_dim, solution_dim)
            real(RK), intent(out) :: new_vectors(full_dim, solution_dim)
            integer(IK), intent(out) :: new_dim
            integer(IK) :: error
        end function krylov_real_orthonormalizer_i_prepare_vectors

        function krylov_real_orthonormalizer_i_prepare_transform(orthonormalizer, full_dim, basis_dim, vectors) result(error)
            import real_orthonormalizer_t, IK, RK
            class(real_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim
            real(RK), intent(in) :: vectors(full_dim, basis_dim)
            integer(IK) :: error
        end function krylov_real_orthonormalizer_i_prepare_transform

        function krylov_real_orthonormalizer_i_transform_rayleigh( &
            orthonormalizer, basis_dim, rayleigh, orthonormal_rayleigh) result(error)
            import real_orthonormalizer_t, IK, RK
            class(real_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim
            real(RK), intent(in) :: rayleigh(basis_dim, basis_dim)
            real(RK), intent(out) :: orthonormal_rayleigh(basis_dim, basis_dim)
            integer(IK) :: error
        end function krylov_real_orthonormalizer_i_transform_rayleigh

        function krylov_real_orthonormalizer_i_transform_basis_rhs( &
            orthonormalizer, basis_dim, rhs_dim, basis_rhs, orthonormal_basis_rhs) result(error)
            import real_orthonormalizer_t, IK, RK
            class(real_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, rhs_dim
            real(RK), intent(in) :: basis_rhs(basis_dim, rhs_dim)
            real(RK), intent(out) :: orthonormal_basis_rhs(basis_dim, rhs_dim)
            integer(IK) :: error
        end function krylov_real_orthonormalizer_i_transform_basis_rhs

        function krylov_real_orthonormalizer_i_restore_basis_solutions( &
            orthonormalizer, basis_dim, solution_dim, orthonormal_basis_solutions, basis_solutions) result(error)
            import real_orthonormalizer_t, IK, RK
            class(real_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, solution_dim
            real(RK), intent(in) :: orthonormal_basis_solutions(basis_dim, solution_dim)
            real(RK), intent(out) :: basis_solutions(basis_dim, solution_dim)
            integer(IK) :: error
        end function krylov_real_orthonormalizer_i_restore_basis_solutions

        function krylov_real_orthonormalizer_i_get_gram_rcond(orthonormalizer) result(gram_rcond)
            import real_orthonormalizer_t, RK
            class(real_orthonormalizer_t), intent(in) :: orthonormalizer
            real(RK) :: gram_rcond
        end function krylov_real_orthonormalizer_i_get_gram_rcond

        function krylov_complex_orthonormalizer_i_initialize(orthonormalizer, config) result(error)
            import complex_orthonormalizer_t, config_t, IK
            class(complex_orthonormalizer_t), intent(inout) :: orthonormalizer
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_orthonormalizer_i_initialize

        function krylov_complex_orthonormalizer_i_prepare_vectors( &
            orthonormalizer, full_dim, basis_dim, solution_dim, vectors, residuals, new_vectors, new_dim) result(error)
            import complex_orthonormalizer_t, IK, CK
            class(complex_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim, solution_dim
            complex(CK), intent(in) :: vectors(full_dim, basis_dim), residuals(full_dim, solution_dim)
            complex(CK), intent(out) :: new_vectors(full_dim, solution_dim)
            integer(IK), intent(out) :: new_dim
            integer(IK) :: error
        end function krylov_complex_orthonormalizer_i_prepare_vectors

        function krylov_complex_orthonormalizer_i_prepare_transform(orthonormalizer, full_dim, basis_dim, vectors) result(error)
            import complex_orthonormalizer_t, IK, CK
            class(complex_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim
            complex(CK), intent(in) :: vectors(full_dim, basis_dim)
            integer(IK) :: error
        end function krylov_complex_orthonormalizer_i_prepare_transform

        function krylov_complex_orthonormalizer_i_transform_rayleigh( &
            orthonormalizer, basis_dim, rayleigh, orthonormal_rayleigh) result(error)
            import complex_orthonormalizer_t, IK, CK
            class(complex_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim
            complex(CK), intent(in) :: rayleigh(basis_dim, basis_dim)
            complex(CK), intent(out) :: orthonormal_rayleigh(basis_dim, basis_dim)
            integer(IK) :: error
        end function krylov_complex_orthonormalizer_i_transform_rayleigh

        function krylov_complex_orthonormalizer_i_transform_basis_rhs( &
            orthonormalizer, basis_dim, rhs_dim, basis_rhs, orthonormal_basis_rhs) result(error)
            import complex_orthonormalizer_t, IK, CK
            class(complex_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, rhs_dim
            complex(CK), intent(in) :: basis_rhs(basis_dim, rhs_dim)
            complex(CK), intent(out) :: orthonormal_basis_rhs(basis_dim, rhs_dim)
            integer(IK) :: error
        end function krylov_complex_orthonormalizer_i_transform_basis_rhs

        function krylov_complex_orthonormalizer_i_restore_basis_solutions( &
            orthonormalizer, basis_dim, solution_dim, orthonormal_basis_solutions, basis_solutions) result(error)
            import complex_orthonormalizer_t, IK, CK
            class(complex_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, solution_dim
            complex(CK), intent(in) :: orthonormal_basis_solutions(basis_dim, solution_dim)
            complex(CK), intent(out) :: basis_solutions(basis_dim, solution_dim)
            integer(IK) :: error
        end function krylov_complex_orthonormalizer_i_restore_basis_solutions

        function krylov_complex_orthonormalizer_i_get_gram_rcond(orthonormalizer) result(gram_rcond)
            import complex_orthonormalizer_t, RK
            class(complex_orthonormalizer_t), intent(in) :: orthonormalizer
            real(RK) :: gram_rcond
        end function krylov_complex_orthonormalizer_i_get_gram_rcond

    end interface

    interface

        function krylov_real_ortho_orthonormalizer_initialize(orthonormalizer, config) result(error)
            import real_ortho_orthonormalizer_t, config_t, IK
            class(real_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_ortho_orthonormalizer_initialize

        function krylov_real_ortho_orthonormalizer_prepare_vectors( &
            orthonormalizer, full_dim, basis_dim, solution_dim, vectors, residuals, new_vectors, new_dim) result(error)
            import real_ortho_orthonormalizer_t, IK, RK
            class(real_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim, solution_dim
            real(RK), intent(in) :: vectors(full_dim, basis_dim), residuals(full_dim, solution_dim)
            real(RK), intent(out) :: new_vectors(full_dim, solution_dim)
            integer(IK), intent(out) :: new_dim
            integer(IK) :: error
        end function krylov_real_ortho_orthonormalizer_prepare_vectors

        function krylov_real_ortho_orthonormalizer_prepare_transform( &
            orthonormalizer, full_dim, basis_dim, vectors) result(error)
            import real_ortho_orthonormalizer_t, IK, RK
            class(real_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim
            real(RK), intent(in) :: vectors(full_dim, basis_dim)
            integer(IK) :: error
        end function krylov_real_ortho_orthonormalizer_prepare_transform

        function krylov_real_ortho_orthonormalizer_transform_rayleigh( &
            orthonormalizer, basis_dim, rayleigh, orthonormal_rayleigh) result(error)
            import real_ortho_orthonormalizer_t, IK, RK
            class(real_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim
            real(RK), intent(in) :: rayleigh(basis_dim, basis_dim)
            real(RK), intent(out) :: orthonormal_rayleigh(basis_dim, basis_dim)
            integer(IK) :: error
        end function krylov_real_ortho_orthonormalizer_transform_rayleigh

        function krylov_real_ortho_orthonormalizer_transform_basis_rhs( &
            orthonormalizer, basis_dim, rhs_dim, basis_rhs, orthonormal_basis_rhs) result(error)
            import real_ortho_orthonormalizer_t, IK, RK
            class(real_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, rhs_dim
            real(RK), intent(in) :: basis_rhs(basis_dim, rhs_dim)
            real(RK), intent(out) :: orthonormal_basis_rhs(basis_dim, rhs_dim)
            integer(IK) :: error
        end function krylov_real_ortho_orthonormalizer_transform_basis_rhs

        function krylov_real_ortho_orthonormalizer_restore_basis_solutions( &
            orthonormalizer, basis_dim, solution_dim, orthonormal_basis_solutions, basis_solutions) result(error)
            import real_ortho_orthonormalizer_t, IK, RK
            class(real_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, solution_dim
            real(RK), intent(in) :: orthonormal_basis_solutions(basis_dim, solution_dim)
            real(RK), intent(out) :: basis_solutions(basis_dim, solution_dim)
            integer(IK) :: error
        end function krylov_real_ortho_orthonormalizer_restore_basis_solutions

        function krylov_real_ortho_orthonormalizer_get_gram_rcond(orthonormalizer) result(gram_rcond)
            import real_ortho_orthonormalizer_t, RK
            class(real_ortho_orthonormalizer_t), intent(in) :: orthonormalizer
            real(RK) :: gram_rcond
        end function krylov_real_ortho_orthonormalizer_get_gram_rcond

        function krylov_real_nks_orthonormalizer_initialize(orthonormalizer, config) result(error)
            import real_nks_orthonormalizer_t, config_t, IK
            class(real_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_nks_orthonormalizer_initialize

        function krylov_real_nks_orthonormalizer_prepare_vectors( &
            orthonormalizer, full_dim, basis_dim, solution_dim, vectors, residuals, new_vectors, new_dim) result(error)
            import real_nks_orthonormalizer_t, IK, RK
            class(real_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim, solution_dim
            real(RK), intent(in) :: vectors(full_dim, basis_dim), residuals(full_dim, solution_dim)
            real(RK), intent(out) :: new_vectors(full_dim, solution_dim)
            integer(IK), intent(out) :: new_dim
            integer(IK) :: error
        end function krylov_real_nks_orthonormalizer_prepare_vectors

        function krylov_real_nks_orthonormalizer_prepare_transform( &
            orthonormalizer, full_dim, basis_dim, vectors) result(error)
            import real_nks_orthonormalizer_t, IK, RK
            class(real_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim
            real(RK), intent(in) :: vectors(full_dim, basis_dim)
            integer(IK) :: error
        end function krylov_real_nks_orthonormalizer_prepare_transform

        function krylov_real_nks_orthonormalizer_transform_rayleigh( &
            orthonormalizer, basis_dim, rayleigh, orthonormal_rayleigh) result(error)
            import real_nks_orthonormalizer_t, IK, RK
            class(real_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim
            real(RK), intent(in) :: rayleigh(basis_dim, basis_dim)
            real(RK), intent(out) :: orthonormal_rayleigh(basis_dim, basis_dim)
            integer(IK) :: error
        end function krylov_real_nks_orthonormalizer_transform_rayleigh

        function krylov_real_nks_orthonormalizer_transform_basis_rhs( &
            orthonormalizer, basis_dim, rhs_dim, basis_rhs, orthonormal_basis_rhs) result(error)
            import real_nks_orthonormalizer_t, IK, RK
            class(real_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, rhs_dim
            real(RK), intent(in) :: basis_rhs(basis_dim, rhs_dim)
            real(RK), intent(out) :: orthonormal_basis_rhs(basis_dim, rhs_dim)
            integer(IK) :: error
        end function krylov_real_nks_orthonormalizer_transform_basis_rhs

        function krylov_real_nks_orthonormalizer_restore_basis_solutions( &
            orthonormalizer, basis_dim, solution_dim, orthonormal_basis_solutions, basis_solutions) result(error)
            import real_nks_orthonormalizer_t, IK, RK
            class(real_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, solution_dim
            real(RK), intent(in) :: orthonormal_basis_solutions(basis_dim, solution_dim)
            real(RK), intent(out) :: basis_solutions(basis_dim, solution_dim)
            integer(IK) :: error
        end function krylov_real_nks_orthonormalizer_restore_basis_solutions

        function krylov_real_nks_orthonormalizer_get_gram_rcond(orthonormalizer) result(gram_rcond)
            import real_nks_orthonormalizer_t, RK
            class(real_nks_orthonormalizer_t), intent(in) :: orthonormalizer
            real(RK) :: gram_rcond
        end function krylov_real_nks_orthonormalizer_get_gram_rcond

        function krylov_real_semi_orthonormalizer_initialize(orthonormalizer, config) result(error)
            import real_semi_orthonormalizer_t, config_t, IK
            class(real_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_semi_orthonormalizer_initialize

        function krylov_real_semi_orthonormalizer_prepare_vectors( &
            orthonormalizer, full_dim, basis_dim, solution_dim, vectors, residuals, new_vectors, new_dim) result(error)
            import real_semi_orthonormalizer_t, IK, RK
            class(real_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim, solution_dim
            real(RK), intent(in) :: vectors(full_dim, basis_dim), residuals(full_dim, solution_dim)
            real(RK), intent(out) :: new_vectors(full_dim, solution_dim)
            integer(IK), intent(out) :: new_dim
            integer(IK) :: error
        end function krylov_real_semi_orthonormalizer_prepare_vectors

        function krylov_real_semi_orthonormalizer_prepare_transform( &
            orthonormalizer, full_dim, basis_dim, vectors) result(error)
            import real_semi_orthonormalizer_t, IK, RK
            class(real_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim
            real(RK), intent(in) :: vectors(full_dim, basis_dim)
            integer(IK) :: error
        end function krylov_real_semi_orthonormalizer_prepare_transform

        function krylov_real_semi_orthonormalizer_transform_rayleigh( &
            orthonormalizer, basis_dim, rayleigh, orthonormal_rayleigh) result(error)
            import real_semi_orthonormalizer_t, IK, RK
            class(real_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim
            real(RK), intent(in) :: rayleigh(basis_dim, basis_dim)
            real(RK), intent(out) :: orthonormal_rayleigh(basis_dim, basis_dim)
            integer(IK) :: error
        end function krylov_real_semi_orthonormalizer_transform_rayleigh

        function krylov_real_semi_orthonormalizer_transform_basis_rhs( &
            orthonormalizer, basis_dim, rhs_dim, basis_rhs, orthonormal_basis_rhs) result(error)
            import real_semi_orthonormalizer_t, IK, RK
            class(real_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, rhs_dim
            real(RK), intent(in) :: basis_rhs(basis_dim, rhs_dim)
            real(RK), intent(out) :: orthonormal_basis_rhs(basis_dim, rhs_dim)
            integer(IK) :: error
        end function krylov_real_semi_orthonormalizer_transform_basis_rhs

        function krylov_real_semi_orthonormalizer_restore_basis_solutions( &
            orthonormalizer, basis_dim, solution_dim, orthonormal_basis_solutions, basis_solutions) result(error)
            import real_semi_orthonormalizer_t, IK, RK
            class(real_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, solution_dim
            real(RK), intent(in) :: orthonormal_basis_solutions(basis_dim, solution_dim)
            real(RK), intent(out) :: basis_solutions(basis_dim, solution_dim)
            integer(IK) :: error
        end function krylov_real_semi_orthonormalizer_restore_basis_solutions

        function krylov_real_semi_orthonormalizer_get_gram_rcond(orthonormalizer) result(gram_rcond)
            import real_semi_orthonormalizer_t, RK
            class(real_semi_orthonormalizer_t), intent(in) :: orthonormalizer
            real(RK) :: gram_rcond
        end function krylov_real_semi_orthonormalizer_get_gram_rcond

        function krylov_complex_ortho_orthonormalizer_initialize(orthonormalizer, config) result(error)
            import complex_ortho_orthonormalizer_t, config_t, IK
            class(complex_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_ortho_orthonormalizer_initialize

        function krylov_complex_ortho_orthonormalizer_prepare_vectors( &
            orthonormalizer, full_dim, basis_dim, solution_dim, vectors, residuals, new_vectors, new_dim) result(error)
            import complex_ortho_orthonormalizer_t, IK, CK
            class(complex_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim, solution_dim
            complex(CK), intent(in) :: vectors(full_dim, basis_dim), residuals(full_dim, solution_dim)
            complex(CK), intent(out) :: new_vectors(full_dim, solution_dim)
            integer(IK), intent(out) :: new_dim
            integer(IK) :: error
        end function krylov_complex_ortho_orthonormalizer_prepare_vectors

        function krylov_complex_ortho_orthonormalizer_prepare_transform( &
            orthonormalizer, full_dim, basis_dim, vectors) result(error)
            import complex_ortho_orthonormalizer_t, IK, CK
            class(complex_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim
            complex(CK), intent(in) :: vectors(full_dim, basis_dim)
            integer(IK) :: error
        end function krylov_complex_ortho_orthonormalizer_prepare_transform

        function krylov_complex_ortho_orthonormalizer_transform_rayleigh( &
            orthonormalizer, basis_dim, rayleigh, orthonormal_rayleigh) result(error)
            import complex_ortho_orthonormalizer_t, IK, CK
            class(complex_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim
            complex(CK), intent(in) :: rayleigh(basis_dim, basis_dim)
            complex(CK), intent(out) :: orthonormal_rayleigh(basis_dim, basis_dim)
            integer(IK) :: error
        end function krylov_complex_ortho_orthonormalizer_transform_rayleigh

        function krylov_complex_ortho_orthonormalizer_transform_basis_rhs( &
            orthonormalizer, basis_dim, rhs_dim, basis_rhs, orthonormal_basis_rhs) result(error)
            import complex_ortho_orthonormalizer_t, IK, CK
            class(complex_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, rhs_dim
            complex(CK), intent(in) :: basis_rhs(basis_dim, rhs_dim)
            complex(CK), intent(out) :: orthonormal_basis_rhs(basis_dim, rhs_dim)
            integer(IK) :: error
        end function krylov_complex_ortho_orthonormalizer_transform_basis_rhs

        function krylov_complex_ortho_orthonormalizer_restore_basis_solutions( &
            orthonormalizer, basis_dim, solution_dim, orthonormal_basis_solutions, basis_solutions) result(error)
            import complex_ortho_orthonormalizer_t, IK, CK
            class(complex_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, solution_dim
            complex(CK), intent(in) :: orthonormal_basis_solutions(basis_dim, solution_dim)
            complex(CK), intent(out) :: basis_solutions(basis_dim, solution_dim)
            integer(IK) :: error
        end function krylov_complex_ortho_orthonormalizer_restore_basis_solutions

        function krylov_complex_ortho_orthonormalizer_get_gram_rcond(orthonormalizer) result(gram_rcond)
            import complex_ortho_orthonormalizer_t, RK
            class(complex_ortho_orthonormalizer_t), intent(in) :: orthonormalizer
            real(RK) :: gram_rcond
        end function krylov_complex_ortho_orthonormalizer_get_gram_rcond

        function krylov_complex_nks_orthonormalizer_initialize(orthonormalizer, config) result(error)
            import complex_nks_orthonormalizer_t, config_t, IK
            class(complex_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_nks_orthonormalizer_initialize

        function krylov_complex_nks_orthonormalizer_prepare_vectors( &
            orthonormalizer, full_dim, basis_dim, solution_dim, vectors, residuals, new_vectors, new_dim) result(error)
            import complex_nks_orthonormalizer_t, IK, CK
            class(complex_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim, solution_dim
            complex(CK), intent(in) :: vectors(full_dim, basis_dim), residuals(full_dim, solution_dim)
            complex(CK), intent(out) :: new_vectors(full_dim, solution_dim)
            integer(IK), intent(out) :: new_dim
            integer(IK) :: error
        end function krylov_complex_nks_orthonormalizer_prepare_vectors

        function krylov_complex_nks_orthonormalizer_prepare_transform( &
            orthonormalizer, full_dim, basis_dim, vectors) result(error)
            import complex_nks_orthonormalizer_t, IK, CK
            class(complex_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim
            complex(CK), intent(in) :: vectors(full_dim, basis_dim)
            integer(IK) :: error
        end function krylov_complex_nks_orthonormalizer_prepare_transform

        function krylov_complex_nks_orthonormalizer_transform_rayleigh( &
            orthonormalizer, basis_dim, rayleigh, orthonormal_rayleigh) result(error)
            import complex_nks_orthonormalizer_t, IK, CK
            class(complex_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim
            complex(CK), intent(in) :: rayleigh(basis_dim, basis_dim)
            complex(CK), intent(out) :: orthonormal_rayleigh(basis_dim, basis_dim)
            integer(IK) :: error
        end function krylov_complex_nks_orthonormalizer_transform_rayleigh

        function krylov_complex_nks_orthonormalizer_transform_basis_rhs( &
            orthonormalizer, basis_dim, rhs_dim, basis_rhs, orthonormal_basis_rhs) result(error)
            import complex_nks_orthonormalizer_t, IK, CK
            class(complex_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, rhs_dim
            complex(CK), intent(in) :: basis_rhs(basis_dim, rhs_dim)
            complex(CK), intent(out) :: orthonormal_basis_rhs(basis_dim, rhs_dim)
            integer(IK) :: error
        end function krylov_complex_nks_orthonormalizer_transform_basis_rhs

        function krylov_complex_nks_orthonormalizer_restore_basis_solutions( &
            orthonormalizer, basis_dim, solution_dim, orthonormal_basis_solutions, basis_solutions) result(error)
            import complex_nks_orthonormalizer_t, IK, CK
            class(complex_nks_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, solution_dim
            complex(CK), intent(in) :: orthonormal_basis_solutions(basis_dim, solution_dim)
            complex(CK), intent(out) :: basis_solutions(basis_dim, solution_dim)
            integer(IK) :: error
        end function krylov_complex_nks_orthonormalizer_restore_basis_solutions

        function krylov_complex_nks_orthonormalizer_get_gram_rcond(orthonormalizer) result(gram_rcond)
            import complex_nks_orthonormalizer_t, RK
            class(complex_nks_orthonormalizer_t), intent(in) :: orthonormalizer
            real(RK) :: gram_rcond
        end function krylov_complex_nks_orthonormalizer_get_gram_rcond

        function krylov_complex_semi_orthonormalizer_initialize(orthonormalizer, config) result(error)
            import complex_semi_orthonormalizer_t, config_t, IK
            class(complex_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_semi_orthonormalizer_initialize

        function krylov_complex_semi_orthonormalizer_prepare_vectors( &
            orthonormalizer, full_dim, basis_dim, solution_dim, vectors, residuals, new_vectors, new_dim) result(error)
            import complex_semi_orthonormalizer_t, IK, CK
            class(complex_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim, solution_dim
            complex(CK), intent(in) :: vectors(full_dim, basis_dim), residuals(full_dim, solution_dim)
            complex(CK), intent(out) :: new_vectors(full_dim, solution_dim)
            integer(IK), intent(out) :: new_dim
            integer(IK) :: error
        end function krylov_complex_semi_orthonormalizer_prepare_vectors

        function krylov_complex_semi_orthonormalizer_prepare_transform( &
            orthonormalizer, full_dim, basis_dim, vectors) result(error)
            import complex_semi_orthonormalizer_t, IK, CK
            class(complex_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: full_dim, basis_dim
            complex(CK), intent(in) :: vectors(full_dim, basis_dim)
            integer(IK) :: error
        end function krylov_complex_semi_orthonormalizer_prepare_transform

        function krylov_complex_semi_orthonormalizer_transform_rayleigh( &
            orthonormalizer, basis_dim, rayleigh, orthonormal_rayleigh) result(error)
            import complex_semi_orthonormalizer_t, IK, CK
            class(complex_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim
            complex(CK), intent(in) :: rayleigh(basis_dim, basis_dim)
            complex(CK), intent(out) :: orthonormal_rayleigh(basis_dim, basis_dim)
            integer(IK) :: error
        end function krylov_complex_semi_orthonormalizer_transform_rayleigh

        function krylov_complex_semi_orthonormalizer_transform_basis_rhs( &
            orthonormalizer, basis_dim, rhs_dim, basis_rhs, orthonormal_basis_rhs) result(error)
            import complex_semi_orthonormalizer_t, IK, CK
            class(complex_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, rhs_dim
            complex(CK), intent(in) :: basis_rhs(basis_dim, rhs_dim)
            complex(CK), intent(out) :: orthonormal_basis_rhs(basis_dim, rhs_dim)
            integer(IK) :: error
        end function krylov_complex_semi_orthonormalizer_transform_basis_rhs

        function krylov_complex_semi_orthonormalizer_restore_basis_solutions( &
            orthonormalizer, basis_dim, solution_dim, orthonormal_basis_solutions, basis_solutions) result(error)
            import complex_semi_orthonormalizer_t, IK, CK
            class(complex_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
            integer(IK), intent(in) :: basis_dim, solution_dim
            complex(CK), intent(in) :: orthonormal_basis_solutions(basis_dim, solution_dim)
            complex(CK), intent(out) :: basis_solutions(basis_dim, solution_dim)
            integer(IK) :: error
        end function krylov_complex_semi_orthonormalizer_restore_basis_solutions

        function krylov_complex_semi_orthonormalizer_get_gram_rcond(orthonormalizer) result(gram_rcond)
            import complex_semi_orthonormalizer_t, RK
            class(complex_semi_orthonormalizer_t), intent(in) :: orthonormalizer
            real(RK) :: gram_rcond
        end function krylov_complex_semi_orthonormalizer_get_gram_rcond

    end interface

contains

    subroutine krylov_real_ortho_orthonormalizer_finalize(orthonormalizer)
        implicit none
        type(real_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer

        if (allocated(orthonormalizer%config)) deallocate (orthonormalizer%config)
    end subroutine krylov_real_ortho_orthonormalizer_finalize

    subroutine krylov_real_nks_orthonormalizer_finalize(orthonormalizer)
        implicit none
        type(real_nks_orthonormalizer_t), intent(inout) :: orthonormalizer

        if (allocated(orthonormalizer%config)) deallocate (orthonormalizer%config)
        if (allocated(orthonormalizer%vector_norm_squared)) deallocate (orthonormalizer%vector_norm_squared)
        if (allocated(orthonormalizer%gram_matrix)) deallocate (orthonormalizer%gram_matrix)
        if (allocated(orthonormalizer%scaled_gram_matrix)) deallocate (orthonormalizer%scaled_gram_matrix)
        if (allocated(orthonormalizer%gram_matrix_decomposed)) deallocate (orthonormalizer%gram_matrix_decomposed)
    end subroutine krylov_real_nks_orthonormalizer_finalize

    subroutine krylov_real_semi_orthonormalizer_finalize(orthonormalizer)
        implicit none
        type(real_semi_orthonormalizer_t), intent(inout) :: orthonormalizer

        if (allocated(orthonormalizer%config)) deallocate (orthonormalizer%config)
        if (allocated(orthonormalizer%vector_norm_squared)) deallocate (orthonormalizer%vector_norm_squared)
        if (allocated(orthonormalizer%gram_matrix)) deallocate (orthonormalizer%gram_matrix)
        if (allocated(orthonormalizer%scaled_gram_matrix)) deallocate (orthonormalizer%scaled_gram_matrix)
        if (allocated(orthonormalizer%gram_matrix_decomposed)) deallocate (orthonormalizer%gram_matrix_decomposed)
    end subroutine krylov_real_semi_orthonormalizer_finalize

    subroutine krylov_complex_ortho_orthonormalizer_finalize(orthonormalizer)
        implicit none
        type(complex_ortho_orthonormalizer_t), intent(inout) :: orthonormalizer

        if (allocated(orthonormalizer%config)) deallocate (orthonormalizer%config)
    end subroutine krylov_complex_ortho_orthonormalizer_finalize

    subroutine krylov_complex_nks_orthonormalizer_finalize(orthonormalizer)
        implicit none
        type(complex_nks_orthonormalizer_t), intent(inout) :: orthonormalizer

        if (allocated(orthonormalizer%config)) deallocate (orthonormalizer%config)
        if (allocated(orthonormalizer%vector_norm_squared)) deallocate (orthonormalizer%vector_norm_squared)
        if (allocated(orthonormalizer%gram_matrix)) deallocate (orthonormalizer%gram_matrix)
        if (allocated(orthonormalizer%scaled_gram_matrix)) deallocate (orthonormalizer%scaled_gram_matrix)
        if (allocated(orthonormalizer%gram_matrix_decomposed)) deallocate (orthonormalizer%gram_matrix_decomposed)
    end subroutine krylov_complex_nks_orthonormalizer_finalize

    subroutine krylov_complex_semi_orthonormalizer_finalize(orthonormalizer)
        implicit none
        type(complex_semi_orthonormalizer_t), intent(inout) :: orthonormalizer

        if (allocated(orthonormalizer%config)) deallocate (orthonormalizer%config)
        if (allocated(orthonormalizer%vector_norm_squared)) deallocate (orthonormalizer%vector_norm_squared)
        if (allocated(orthonormalizer%gram_matrix)) deallocate (orthonormalizer%gram_matrix)
        if (allocated(orthonormalizer%scaled_gram_matrix)) deallocate (orthonormalizer%scaled_gram_matrix)
        if (allocated(orthonormalizer%gram_matrix_decomposed)) deallocate (orthonormalizer%gram_matrix_decomposed)
    end subroutine krylov_complex_semi_orthonormalizer_finalize

end module orthonormalizers
