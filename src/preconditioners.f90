module preconditioners

    use kinds, only: IK, RK, CK
    use options, only: config_t
    implicit none

    type, abstract :: real_preconditioner_t
        integer(IK) :: full_dim, solution_dim
        type(config_t), allocatable :: config
    contains
        procedure(krylov_real_preconditioner_i_initialize), deferred, pass :: initialize
        procedure(krylov_real_preconditioner_i_get_status), deferred, pass :: get_status
        procedure(krylov_real_preconditioner_i_transform_residuals), deferred, pass :: transform_residuals
    end type real_preconditioner_t

    type, extends(real_preconditioner_t) :: real_null_preconditioner_t
    contains
        procedure, pass :: initialize => krylov_real_null_preconditioner_initialize
        procedure, pass :: get_status => krylov_real_null_preconditioner_get_status
        procedure, pass :: transform_residuals => krylov_real_null_preconditioner_transform_residuals
        final :: krylov_real_null_preconditioner_finalize
    end type real_null_preconditioner_t

    type, extends(real_preconditioner_t) :: real_cg_preconditioner_t
        real(RK), allocatable :: diagonal(:)
    contains
        procedure, pass :: initialize => krylov_real_cg_preconditioner_initialize
        procedure, pass :: set_diagonal => krylov_real_cg_preconditioner_set_diagonal
        procedure, pass :: get_status => krylov_real_cg_preconditioner_get_status
        procedure, pass :: transform_residuals => krylov_real_cg_preconditioner_transform_residuals
        final :: krylov_real_cg_preconditioner_finalize
    end type real_cg_preconditioner_t

    type, extends(real_preconditioner_t) :: real_davidson_preconditioner_t
        real(RK), allocatable :: diagonal(:), eigenvalues(:)
    contains
        procedure, pass :: initialize => krylov_real_davidson_preconditioner_initialize
        procedure, pass :: set_diagonal => krylov_real_davidson_preconditioner_set_diagonal
        procedure, pass :: set_eigenvalues => krylov_real_davidson_preconditioner_set_eigenvalues
        procedure, pass :: get_status => krylov_real_davidson_preconditioner_get_status
        procedure, pass :: transform_residuals => krylov_real_davidson_preconditioner_transform_residuals
        final :: krylov_real_davidson_preconditioner_finalize
    end type real_davidson_preconditioner_t

    type, extends(real_preconditioner_t) :: real_jd_preconditioner_t
        real(RK), allocatable :: solutions(:, :), diagonal(:), eigenvalues(:)
    contains
        procedure, pass :: initialize => krylov_real_jd_preconditioner_initialize
        procedure, pass :: set_diagonal => krylov_real_jd_preconditioner_set_diagonal
        procedure, pass :: set_eigenvalues => krylov_real_jd_preconditioner_set_eigenvalues
        procedure, pass :: set_solutions => krylov_real_jd_preconditioner_set_solutions
        procedure, pass :: get_status => krylov_real_jd_preconditioner_get_status
        procedure, pass :: transform_residuals => krylov_real_jd_preconditioner_transform_residuals
        final :: krylov_real_jd_preconditioner_finalize
    end type real_jd_preconditioner_t

    type, extends(real_preconditioner_t) :: real_jdall_preconditioner_t
        real(RK), allocatable :: solutions(:, :), diagonal(:), eigenvalues(:)
    contains
        procedure, pass :: initialize => krylov_real_jdall_preconditioner_initialize
        procedure, pass :: set_diagonal => krylov_real_jdall_preconditioner_set_diagonal
        procedure, pass :: set_eigenvalues => krylov_real_jdall_preconditioner_set_eigenvalues
        procedure, pass :: set_solutions => krylov_real_jdall_preconditioner_set_solutions
        procedure, pass :: get_status => krylov_real_jdall_preconditioner_get_status
        procedure, pass :: transform_residuals => krylov_real_jdall_preconditioner_transform_residuals
        final :: krylov_real_jdall_preconditioner_finalize
    end type real_jdall_preconditioner_t

    type, abstract :: complex_preconditioner_t
        integer(IK) :: full_dim, solution_dim
        type(config_t), allocatable :: config
    contains
        procedure(krylov_complex_preconditioner_i_initialize), deferred, pass :: initialize
        procedure(krylov_complex_preconditioner_i_get_status), deferred, pass :: get_status
        procedure(krylov_complex_preconditioner_i_transform_residuals), deferred, pass :: transform_residuals
    end type complex_preconditioner_t

    type, extends(complex_preconditioner_t) :: complex_null_preconditioner_t
    contains
        procedure, pass :: initialize => krylov_complex_null_preconditioner_initialize
        procedure, pass :: get_status => krylov_complex_null_preconditioner_get_status
        procedure, pass :: transform_residuals => krylov_complex_null_preconditioner_transform_residuals
        final :: krylov_complex_null_preconditioner_finalize
    end type complex_null_preconditioner_t

    type, extends(complex_preconditioner_t) :: complex_cg_preconditioner_t
        real(RK), allocatable :: diagonal(:)
    contains
        procedure, pass :: initialize => krylov_complex_cg_preconditioner_initialize
        procedure, pass :: set_diagonal => krylov_complex_cg_preconditioner_set_diagonal
        procedure, pass :: get_status => krylov_complex_cg_preconditioner_get_status
        procedure, pass :: transform_residuals => krylov_complex_cg_preconditioner_transform_residuals
        final :: krylov_complex_cg_preconditioner_finalize
    end type complex_cg_preconditioner_t

    type, extends(complex_preconditioner_t) :: complex_davidson_preconditioner_t
        real(RK), allocatable :: diagonal(:), eigenvalues(:)
    contains
        procedure, pass :: initialize => krylov_complex_davidson_preconditioner_initialize
        procedure, pass :: set_diagonal => krylov_complex_davidson_preconditioner_set_diagonal
        procedure, pass :: set_eigenvalues => krylov_complex_davidson_preconditioner_set_eigenvalues
        procedure, pass :: get_status => krylov_complex_davidson_preconditioner_get_status
        procedure, pass :: transform_residuals => krylov_complex_davidson_preconditioner_transform_residuals
        final :: krylov_complex_davidson_preconditioner_finalize
    end type complex_davidson_preconditioner_t

    type, extends(complex_preconditioner_t) :: complex_jd_preconditioner_t
        real(RK), allocatable :: diagonal(:), eigenvalues(:)
        complex(CK), allocatable :: solutions(:, :)
    contains
        procedure, pass :: initialize => krylov_complex_jd_preconditioner_initialize
        procedure, pass :: set_diagonal => krylov_complex_jd_preconditioner_set_diagonal
        procedure, pass :: set_eigenvalues => krylov_complex_jd_preconditioner_set_eigenvalues
        procedure, pass :: set_solutions => krylov_complex_jd_preconditioner_set_solutions
        procedure, pass :: get_status => krylov_complex_jd_preconditioner_get_status
        procedure, pass :: transform_residuals => krylov_complex_jd_preconditioner_transform_residuals
        final :: krylov_complex_jd_preconditioner_finalize
    end type complex_jd_preconditioner_t

    type, extends(complex_preconditioner_t) :: complex_jdall_preconditioner_t
        real(RK), allocatable :: diagonal(:), eigenvalues(:)
        complex(CK), allocatable :: solutions(:, :)
    contains
        procedure, pass :: initialize => krylov_complex_jdall_preconditioner_initialize
        procedure, pass :: set_diagonal => krylov_complex_jdall_preconditioner_set_diagonal
        procedure, pass :: set_eigenvalues => krylov_complex_jdall_preconditioner_set_eigenvalues
        procedure, pass :: set_solutions => krylov_complex_jdall_preconditioner_set_solutions
        procedure, pass :: get_status => krylov_complex_jdall_preconditioner_get_status
        procedure, pass :: transform_residuals => krylov_complex_jdall_preconditioner_transform_residuals
        final :: krylov_complex_jdall_preconditioner_finalize
    end type complex_jdall_preconditioner_t

    abstract interface

        function krylov_real_preconditioner_i_initialize( &
            preconditioner, full_dim, solution_dim, config) result(error)
            import real_preconditioner_t, config_t, IK
            class(real_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_preconditioner_i_initialize

        function krylov_real_preconditioner_i_get_status(preconditioner) result(status)
            import real_preconditioner_t, IK
            class(real_preconditioner_t), intent(inout) :: preconditioner
            integer(IK) :: status
        end function krylov_real_preconditioner_i_get_status

        function krylov_real_preconditioner_i_transform_residuals( &
            preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)
            import real_preconditioner_t, IK, RK
            class(real_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            real(RK), intent(in) :: residuals(full_dim, solution_dim)
            real(RK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_real_preconditioner_i_transform_residuals

        function krylov_complex_preconditioner_i_initialize( &
            preconditioner, full_dim, solution_dim, config) result(error)
            import complex_preconditioner_t, config_t, IK
            class(complex_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_preconditioner_i_initialize

        function krylov_complex_preconditioner_i_get_status(preconditioner) result(status)
            import complex_preconditioner_t, IK
            class(complex_preconditioner_t), intent(inout) :: preconditioner
            integer(IK) :: status
        end function krylov_complex_preconditioner_i_get_status

        function krylov_complex_preconditioner_i_transform_residuals( &
            preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)
            import complex_preconditioner_t, IK, CK
            class(complex_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            complex(CK), intent(in) :: residuals(full_dim, solution_dim)
            complex(CK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_complex_preconditioner_i_transform_residuals

    end interface

    interface

        function krylov_real_null_preconditioner_initialize( &
            preconditioner, full_dim, solution_dim, config) result(error)
            import real_null_preconditioner_t, config_t, IK
            class(real_null_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_null_preconditioner_initialize

        function krylov_real_null_preconditioner_get_status(preconditioner) result(status)
            import real_null_preconditioner_t, IK
            class(real_null_preconditioner_t), intent(inout) :: preconditioner
            integer(IK) :: status
        end function krylov_real_null_preconditioner_get_status

        function krylov_real_null_preconditioner_transform_residuals( &
            preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)
            import real_null_preconditioner_t, IK, RK
            class(real_null_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            real(RK), intent(in) :: residuals(full_dim, solution_dim)
            real(RK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_real_null_preconditioner_transform_residuals

        function krylov_real_cg_preconditioner_initialize( &
            preconditioner, full_dim, solution_dim, config) result(error)
            import real_cg_preconditioner_t, config_t, IK
            class(real_cg_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_cg_preconditioner_initialize

        function krylov_real_cg_preconditioner_set_diagonal(preconditioner, full_dim, diagonal) result(error)
            import real_cg_preconditioner_t, IK, RK
            class(real_cg_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim
            real(RK), intent(in) :: diagonal(full_dim)
            integer(IK) :: error
        end function krylov_real_cg_preconditioner_set_diagonal

        function krylov_real_cg_preconditioner_get_status(preconditioner) result(status)
            import real_cg_preconditioner_t, IK
            class(real_cg_preconditioner_t), intent(inout) :: preconditioner
            integer(IK) :: status
        end function krylov_real_cg_preconditioner_get_status

        function krylov_real_cg_preconditioner_transform_residuals( &
            preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)
            import real_cg_preconditioner_t, IK, RK
            class(real_cg_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            real(RK), intent(in) :: residuals(full_dim, solution_dim)
            real(RK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_real_cg_preconditioner_transform_residuals

        function krylov_real_davidson_preconditioner_initialize( &
            preconditioner, full_dim, solution_dim, config) result(error)
            import real_davidson_preconditioner_t, config_t, IK
            class(real_davidson_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_davidson_preconditioner_initialize

        function krylov_real_davidson_preconditioner_set_diagonal(preconditioner, full_dim, diagonal) result(error)
            import real_davidson_preconditioner_t, IK, RK
            class(real_davidson_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim
            real(RK), intent(in) :: diagonal(full_dim)
            integer(IK) :: error
        end function krylov_real_davidson_preconditioner_set_diagonal

        function krylov_real_davidson_preconditioner_set_eigenvalues(preconditioner, solution_dim, eigenvalues) result(error)
            import real_davidson_preconditioner_t, IK, RK
            class(real_davidson_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(in) :: eigenvalues(solution_dim)
            integer(IK) :: error
        end function krylov_real_davidson_preconditioner_set_eigenvalues

        function krylov_real_davidson_preconditioner_get_status(preconditioner) result(status)
            import real_davidson_preconditioner_t, IK
            class(real_davidson_preconditioner_t), intent(inout) :: preconditioner
            integer(IK) :: status
        end function krylov_real_davidson_preconditioner_get_status

        function krylov_real_davidson_preconditioner_transform_residuals( &
            preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)
            import real_davidson_preconditioner_t, IK, RK
            class(real_davidson_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            real(RK), intent(in) :: residuals(full_dim, solution_dim)
            real(RK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_real_davidson_preconditioner_transform_residuals

        function krylov_real_jd_preconditioner_initialize( &
            preconditioner, full_dim, solution_dim, config) result(error)
            import real_jd_preconditioner_t, config_t, IK
            class(real_jd_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_jd_preconditioner_initialize

        function krylov_real_jd_preconditioner_set_diagonal(preconditioner, full_dim, diagonal) result(error)
            import real_jd_preconditioner_t, IK, RK
            class(real_jd_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim
            real(RK), intent(in) :: diagonal(full_dim)
            integer(IK) :: error
        end function krylov_real_jd_preconditioner_set_diagonal

        function krylov_real_jd_preconditioner_set_eigenvalues(preconditioner, solution_dim, eigenvalues) result(error)
            import real_jd_preconditioner_t, IK, RK
            class(real_jd_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(in) :: eigenvalues(solution_dim)
            integer(IK) :: error
        end function krylov_real_jd_preconditioner_set_eigenvalues

        function krylov_real_jd_preconditioner_set_solutions(preconditioner, full_dim, solution_dim, solutions) result(error)
            import real_jd_preconditioner_t, IK, RK
            class(real_jd_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            real(RK), intent(in) :: solutions(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_real_jd_preconditioner_set_solutions

        function krylov_real_jd_preconditioner_get_status(preconditioner) result(status)
            import real_jd_preconditioner_t, IK
            class(real_jd_preconditioner_t), intent(inout) :: preconditioner
            integer(IK) :: status
        end function krylov_real_jd_preconditioner_get_status

        function krylov_real_jd_preconditioner_transform_residuals( &
            preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)
            import real_jd_preconditioner_t, IK, RK
            class(real_jd_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            real(RK), intent(in) :: residuals(full_dim, solution_dim)
            real(RK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_real_jd_preconditioner_transform_residuals

        function krylov_real_jdall_preconditioner_initialize( &
            preconditioner, full_dim, solution_dim, config) result(error)
            import real_jdall_preconditioner_t, config_t, IK
            class(real_jdall_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_jdall_preconditioner_initialize

        function krylov_real_jdall_preconditioner_set_diagonal(preconditioner, full_dim, diagonal) result(error)
            import real_jdall_preconditioner_t, IK, RK
            class(real_jdall_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim
            real(RK), intent(in) :: diagonal(full_dim)
            integer(IK) :: error
        end function krylov_real_jdall_preconditioner_set_diagonal

        function krylov_real_jdall_preconditioner_set_eigenvalues(preconditioner, solution_dim, eigenvalues) result(error)
            import real_jdall_preconditioner_t, IK, RK
            class(real_jdall_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(in) :: eigenvalues(solution_dim)
            integer(IK) :: error
        end function krylov_real_jdall_preconditioner_set_eigenvalues

        function krylov_real_jdall_preconditioner_set_solutions(preconditioner, full_dim, solution_dim, solutions) result(error)
            import real_jdall_preconditioner_t, IK, RK
            class(real_jdall_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            real(RK), intent(in) :: solutions(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_real_jdall_preconditioner_set_solutions

        function krylov_real_jdall_preconditioner_get_status(preconditioner) result(status)
            import real_jdall_preconditioner_t, IK
            class(real_jdall_preconditioner_t), intent(inout) :: preconditioner
            integer(IK) :: status
        end function krylov_real_jdall_preconditioner_get_status

        function krylov_real_jdall_preconditioner_transform_residuals( &
            preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)
            import real_jdall_preconditioner_t, IK, RK
            class(real_jdall_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            real(RK), intent(in) :: residuals(full_dim, solution_dim)
            real(RK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_real_jdall_preconditioner_transform_residuals

        function krylov_complex_null_preconditioner_initialize( &
            preconditioner, full_dim, solution_dim, config) result(error)
            import complex_null_preconditioner_t, config_t, IK
            class(complex_null_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_null_preconditioner_initialize

        function krylov_complex_null_preconditioner_get_status(preconditioner) result(status)
            import complex_null_preconditioner_t, IK
            class(complex_null_preconditioner_t), intent(inout) :: preconditioner
            integer(IK) :: status
        end function krylov_complex_null_preconditioner_get_status

        function krylov_complex_null_preconditioner_transform_residuals( &
            preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)
            import complex_null_preconditioner_t, IK, CK
            class(complex_null_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            complex(CK), intent(in) :: residuals(full_dim, solution_dim)
            complex(CK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_complex_null_preconditioner_transform_residuals

        function krylov_complex_cg_preconditioner_initialize( &
            preconditioner, full_dim, solution_dim, config) result(error)
            import complex_cg_preconditioner_t, config_t, IK
            class(complex_cg_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_cg_preconditioner_initialize

        function krylov_complex_cg_preconditioner_set_diagonal(preconditioner, full_dim, diagonal) result(error)
            import complex_cg_preconditioner_t, IK, RK
            class(complex_cg_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim
            real(RK), intent(in) :: diagonal(full_dim)
            integer(IK) :: error
        end function krylov_complex_cg_preconditioner_set_diagonal

        function krylov_complex_cg_preconditioner_get_status(preconditioner) result(status)
            import complex_cg_preconditioner_t, IK
            class(complex_cg_preconditioner_t), intent(inout) :: preconditioner
            integer(IK) :: status
        end function krylov_complex_cg_preconditioner_get_status

        function krylov_complex_cg_preconditioner_transform_residuals( &
            preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)
            import complex_cg_preconditioner_t, IK, CK
            class(complex_cg_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            complex(CK), intent(in) :: residuals(full_dim, solution_dim)
            complex(CK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_complex_cg_preconditioner_transform_residuals

        function krylov_complex_davidson_preconditioner_initialize( &
            preconditioner, full_dim, solution_dim, config) result(error)
            import complex_davidson_preconditioner_t, config_t, IK
            class(complex_davidson_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_davidson_preconditioner_initialize

        function krylov_complex_davidson_preconditioner_set_diagonal(preconditioner, full_dim, diagonal) result(error)
            import complex_davidson_preconditioner_t, IK, RK
            class(complex_davidson_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim
            real(RK), intent(in) :: diagonal(full_dim)
            integer(IK) :: error
        end function krylov_complex_davidson_preconditioner_set_diagonal

        function krylov_complex_davidson_preconditioner_set_eigenvalues(preconditioner, solution_dim, eigenvalues) result(error)
            import complex_davidson_preconditioner_t, IK, RK
            class(complex_davidson_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(in) :: eigenvalues(solution_dim)
            integer(IK) :: error
        end function krylov_complex_davidson_preconditioner_set_eigenvalues

        function krylov_complex_davidson_preconditioner_get_status(preconditioner) result(status)
            import complex_davidson_preconditioner_t, IK
            class(complex_davidson_preconditioner_t), intent(inout) :: preconditioner
            integer(IK) :: status
        end function krylov_complex_davidson_preconditioner_get_status

        function krylov_complex_davidson_preconditioner_transform_residuals( &
            preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)
            import complex_davidson_preconditioner_t, IK, CK
            class(complex_davidson_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            complex(CK), intent(in) :: residuals(full_dim, solution_dim)
            complex(CK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_complex_davidson_preconditioner_transform_residuals

        function krylov_complex_jd_preconditioner_initialize( &
            preconditioner, full_dim, solution_dim, config) result(error)
            import complex_jd_preconditioner_t, config_t, IK
            class(complex_jd_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_jd_preconditioner_initialize

        function krylov_complex_jd_preconditioner_set_diagonal(preconditioner, full_dim, diagonal) result(error)
            import complex_jd_preconditioner_t, IK, RK
            class(complex_jd_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim
            real(RK), intent(in) :: diagonal(full_dim)
            integer(IK) :: error
        end function krylov_complex_jd_preconditioner_set_diagonal

        function krylov_complex_jd_preconditioner_set_eigenvalues(preconditioner, solution_dim, eigenvalues) result(error)
            import complex_jd_preconditioner_t, IK, RK
            class(complex_jd_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(in) :: eigenvalues(solution_dim)
            integer(IK) :: error
        end function krylov_complex_jd_preconditioner_set_eigenvalues

        function krylov_complex_jd_preconditioner_set_solutions(preconditioner, full_dim, solution_dim, solutions) result(error)
            import complex_jd_preconditioner_t, IK, CK
            class(complex_jd_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            complex(CK), intent(in) :: solutions(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_complex_jd_preconditioner_set_solutions

        function krylov_complex_jd_preconditioner_get_status(preconditioner) result(status)
            import complex_jd_preconditioner_t, IK
            class(complex_jd_preconditioner_t), intent(inout) :: preconditioner
            integer(IK) :: status
        end function krylov_complex_jd_preconditioner_get_status

        function krylov_complex_jd_preconditioner_transform_residuals( &
            preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)
            import complex_jd_preconditioner_t, IK, CK
            class(complex_jd_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            complex(CK), intent(in) :: residuals(full_dim, solution_dim)
            complex(CK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_complex_jd_preconditioner_transform_residuals

        function krylov_complex_jdall_preconditioner_initialize( &
            preconditioner, full_dim, solution_dim, config) result(error)
            import complex_jdall_preconditioner_t, config_t, IK
            class(complex_jdall_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_jdall_preconditioner_initialize

        function krylov_complex_jdall_preconditioner_set_diagonal(preconditioner, full_dim, diagonal) result(error)
            import complex_jdall_preconditioner_t, IK, RK
            class(complex_jdall_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim
            real(RK), intent(in) :: diagonal(full_dim)
            integer(IK) :: error
        end function krylov_complex_jdall_preconditioner_set_diagonal

        function krylov_complex_jdall_preconditioner_set_eigenvalues(preconditioner, solution_dim, eigenvalues) result(error)
            import complex_jdall_preconditioner_t, IK, RK
            class(complex_jdall_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: solution_dim
            real(RK), intent(in) :: eigenvalues(solution_dim)
            integer(IK) :: error
        end function krylov_complex_jdall_preconditioner_set_eigenvalues

        function krylov_complex_jdall_preconditioner_set_solutions(preconditioner, full_dim, solution_dim, solutions) result(error)
            import complex_jdall_preconditioner_t, IK, CK
            class(complex_jdall_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            complex(CK), intent(in) :: solutions(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_complex_jdall_preconditioner_set_solutions

        function krylov_complex_jdall_preconditioner_get_status(preconditioner) result(status)
            import complex_jdall_preconditioner_t, IK
            class(complex_jdall_preconditioner_t), intent(inout) :: preconditioner
            integer(IK) :: status
        end function krylov_complex_jdall_preconditioner_get_status

        function krylov_complex_jdall_preconditioner_transform_residuals( &
            preconditioner, full_dim, solution_dim, residuals, preconditioned_residuals) result(error)
            import complex_jdall_preconditioner_t, IK, CK
            class(complex_jdall_preconditioner_t), intent(inout) :: preconditioner
            integer(IK), intent(in) :: full_dim, solution_dim
            complex(CK), intent(in) :: residuals(full_dim, solution_dim)
            complex(CK), intent(out) :: preconditioned_residuals(full_dim, solution_dim)
            integer(IK) :: error
        end function krylov_complex_jdall_preconditioner_transform_residuals

    end interface

contains

    subroutine krylov_real_null_preconditioner_finalize(preconditioner)
        implicit none
        type(real_null_preconditioner_t), intent(inout) :: preconditioner

        if (allocated(preconditioner%config)) deallocate (preconditioner%config)
    end subroutine krylov_real_null_preconditioner_finalize

    subroutine krylov_real_cg_preconditioner_finalize(preconditioner)
        implicit none
        type(real_cg_preconditioner_t), intent(inout) :: preconditioner

        if (allocated(preconditioner%config)) deallocate (preconditioner%config)
        if (allocated(preconditioner%diagonal)) deallocate (preconditioner%diagonal)
    end subroutine krylov_real_cg_preconditioner_finalize

    subroutine krylov_real_davidson_preconditioner_finalize(preconditioner)
        implicit none
        type(real_davidson_preconditioner_t), intent(inout) :: preconditioner

        if (allocated(preconditioner%config)) deallocate (preconditioner%config)
        if (allocated(preconditioner%diagonal)) deallocate (preconditioner%diagonal)
        if (allocated(preconditioner%eigenvalues)) deallocate (preconditioner%eigenvalues)
    end subroutine krylov_real_davidson_preconditioner_finalize

    subroutine krylov_real_jd_preconditioner_finalize(preconditioner)
        implicit none
        type(real_jd_preconditioner_t), intent(inout) :: preconditioner

        if (allocated(preconditioner%config)) deallocate (preconditioner%config)
        if (allocated(preconditioner%diagonal)) deallocate (preconditioner%diagonal)
        if (allocated(preconditioner%eigenvalues)) deallocate (preconditioner%eigenvalues)
        if (allocated(preconditioner%solutions)) deallocate (preconditioner%solutions)
    end subroutine krylov_real_jd_preconditioner_finalize

    subroutine krylov_real_jdall_preconditioner_finalize(preconditioner)
        implicit none
        type(real_jdall_preconditioner_t), intent(inout) :: preconditioner

        if (allocated(preconditioner%config)) deallocate (preconditioner%config)
        if (allocated(preconditioner%diagonal)) deallocate (preconditioner%diagonal)
        if (allocated(preconditioner%eigenvalues)) deallocate (preconditioner%eigenvalues)
        if (allocated(preconditioner%solutions)) deallocate (preconditioner%solutions)
    end subroutine krylov_real_jdall_preconditioner_finalize

    subroutine krylov_complex_null_preconditioner_finalize(preconditioner)
        implicit none
        type(complex_null_preconditioner_t), intent(inout) :: preconditioner

        if (allocated(preconditioner%config)) deallocate (preconditioner%config)
    end subroutine krylov_complex_null_preconditioner_finalize

    subroutine krylov_complex_cg_preconditioner_finalize(preconditioner)
        implicit none
        type(complex_cg_preconditioner_t), intent(inout) :: preconditioner

        if (allocated(preconditioner%config)) deallocate (preconditioner%config)
        if (allocated(preconditioner%diagonal)) deallocate (preconditioner%diagonal)
    end subroutine krylov_complex_cg_preconditioner_finalize

    subroutine krylov_complex_davidson_preconditioner_finalize(preconditioner)
        implicit none
        type(complex_davidson_preconditioner_t), intent(inout) :: preconditioner

        if (allocated(preconditioner%config)) deallocate (preconditioner%config)
        if (allocated(preconditioner%diagonal)) deallocate (preconditioner%diagonal)
        if (allocated(preconditioner%eigenvalues)) deallocate (preconditioner%eigenvalues)
    end subroutine krylov_complex_davidson_preconditioner_finalize

    subroutine krylov_complex_jd_preconditioner_finalize(preconditioner)
        implicit none
        type(complex_jd_preconditioner_t), intent(inout) :: preconditioner

        if (allocated(preconditioner%config)) deallocate (preconditioner%config)
        if (allocated(preconditioner%diagonal)) deallocate (preconditioner%diagonal)
        if (allocated(preconditioner%eigenvalues)) deallocate (preconditioner%eigenvalues)
        if (allocated(preconditioner%solutions)) deallocate (preconditioner%solutions)
    end subroutine krylov_complex_jd_preconditioner_finalize

    subroutine krylov_complex_jdall_preconditioner_finalize(preconditioner)
        implicit none
        type(complex_jdall_preconditioner_t), intent(inout) :: preconditioner

        if (allocated(preconditioner%config)) deallocate (preconditioner%config)
        if (allocated(preconditioner%diagonal)) deallocate (preconditioner%diagonal)
        if (allocated(preconditioner%eigenvalues)) deallocate (preconditioner%eigenvalues)
        if (allocated(preconditioner%solutions)) deallocate (preconditioner%solutions)
    end subroutine krylov_complex_jdall_preconditioner_finalize

end module preconditioners
