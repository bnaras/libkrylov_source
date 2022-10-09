module solvers

    use kinds, only: IK, RK, CK, AK
    use options, only: config_t
    use control, only: convergence_t
    use equations, only: real_equation_t, complex_equation_t
    use preconditioners, only: real_preconditioner_t, complex_preconditioner_t
    use orthonormalizers, only: real_orthonormalizer_t, complex_orthonormalizer_t
    implicit none

    type, abstract :: space_t
        integer(IK) :: full_dim, solution_dim, basis_dim, new_dim
        type(config_t), allocatable :: config
        type(convergence_t), allocatable :: convergence
    contains
        procedure(krylov_space_i_initialize), deferred, pass :: initialize
        procedure(krylov_space_i_set_option), deferred, pass :: set_equation
        procedure(krylov_space_i_set_option), deferred, pass :: set_preconditioner
        procedure(krylov_space_i_set_option), deferred, pass :: set_orthonormalizer
        procedure(krylov_space_i_noargs), deferred, pass :: prepare_orthonormalizer
        procedure(krylov_space_i_noargs), deferred, pass :: expand_equation
        procedure(krylov_space_i_noargs), deferred, pass :: solve_projected
        procedure(krylov_space_i_noargs), deferred, pass :: transform_solutions
        procedure(krylov_space_i_noargs), deferred, pass :: make_residuals
        procedure(krylov_space_i_noargs), deferred, pass :: update_convergence
        procedure(krylov_space_i_noargs), deferred, pass :: prepare_preconditioner
        procedure(krylov_space_i_noargs), deferred, pass :: expand_basis
        procedure(krylov_space_i_noargs), deferred, pass :: restart
    end type space_t

    type, extends(space_t) :: real_space_t
        class(real_equation_t), pointer :: equation => null()
        class(real_preconditioner_t), pointer :: preconditioner => null()
        class(real_orthonormalizer_t), pointer :: orthonormalizer => null()
    contains
        procedure, pass :: initialize => krylov_real_space_initialize
        procedure, pass :: set_equation => krylov_real_space_set_equation
        procedure, pass :: set_preconditioner => krylov_real_space_set_preconditioner
        procedure, pass :: set_orthonormalizer => krylov_real_space_set_orthonormalizer
        procedure, pass :: prepare_orthonormalizer => krylov_real_space_prepare_orthonormalizer
        procedure, pass :: expand_equation => krylov_real_space_expand_equation
        procedure, pass :: solve_projected => krylov_real_space_solve_projected
        procedure, pass :: transform_solutions => krylov_real_space_transform_solutions
        procedure, pass :: make_residuals => krylov_real_space_make_residuals
        procedure, pass :: update_convergence => krylov_real_space_update_convergence
        procedure, pass :: prepare_preconditioner => krylov_real_space_prepare_preconditioner
        procedure, pass :: expand_basis => krylov_real_space_expand_basis
        procedure, pass :: restart => krylov_real_space_restart
        final :: krylov_real_space_finalize
    end type real_space_t

    type, extends(space_t) :: complex_space_t
        class(complex_equation_t), pointer :: equation => null()
        class(complex_preconditioner_t), pointer :: preconditioner => null()
        class(complex_orthonormalizer_t), pointer :: orthonormalizer => null()
    contains
        procedure, pass :: initialize => krylov_complex_space_initialize
        procedure, pass :: set_equation => krylov_complex_space_set_equation
        procedure, pass :: set_preconditioner => krylov_complex_space_set_preconditioner
        procedure, pass :: set_orthonormalizer => krylov_complex_space_set_orthonormalizer
        procedure, pass :: prepare_orthonormalizer => krylov_complex_space_prepare_orthonormalizer
        procedure, pass :: expand_equation => krylov_complex_space_expand_equation
        procedure, pass :: solve_projected => krylov_complex_space_solve_projected
        procedure, pass :: transform_solutions => krylov_complex_space_transform_solutions
        procedure, pass :: make_residuals => krylov_complex_space_make_residuals
        procedure, pass :: update_convergence => krylov_complex_space_update_convergence
        procedure, pass :: prepare_preconditioner => krylov_complex_space_prepare_preconditioner
        procedure, pass :: expand_basis => krylov_complex_space_expand_basis
        procedure, pass :: restart => krylov_complex_space_restart
        final :: krylov_complex_space_finalize
    end type complex_space_t

    abstract interface

        function krylov_space_i_initialize( &
            space, equation, full_dim, solution_dim, basis_dim, config) result(error)
            import space_t, config_t, IK, AK
            class(space_t), intent(inout) :: space
            character(len=*, kind=AK), intent(in) :: equation
            integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_space_i_initialize

        function krylov_space_i_set_option(space, value) result(error)
            import space_t, IK, AK
            class(space_t), intent(inout) :: space
            character(len=*, kind=AK), intent(in) :: value
            integer(IK) :: error
        end function krylov_space_i_set_option

        function krylov_space_i_noargs(space) result(error)
            import space_t, IK
            class(space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_space_i_noargs

    end interface

    interface

        function krylov_real_space_initialize( &
            space, equation, full_dim, solution_dim, basis_dim, config) result(error)
            import real_space_t, config_t, IK, AK
            class(real_space_t), intent(inout) :: space
            character(len=*, kind=AK), intent(in) :: equation
            integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_real_space_initialize

        function krylov_real_space_set_equation(space, value) result(error)
            import real_space_t, IK, AK
            class(real_space_t), intent(inout) :: space
            character(len=*, kind=AK), intent(in) :: value
            integer(IK) :: error
        end function krylov_real_space_set_equation

        function krylov_real_space_set_preconditioner(space, value) result(error)
            import real_space_t, IK, AK
            class(real_space_t), intent(inout) :: space
            character(len=*, kind=AK), intent(in) :: value
            integer(IK) :: error
        end function krylov_real_space_set_preconditioner

        function krylov_real_space_set_orthonormalizer(space, value) result(error)
            import real_space_t, IK, AK
            class(real_space_t), intent(inout) :: space
            character(len=*, kind=AK), intent(in) :: value
            integer(IK) :: error
        end function krylov_real_space_set_orthonormalizer

        function krylov_real_space_prepare_orthonormalizer(space) result(error)
            import real_space_t, IK
            class(real_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_real_space_prepare_orthonormalizer

        function krylov_real_space_expand_equation(space) result(error)
            import real_space_t, IK
            class(real_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_real_space_expand_equation

        function krylov_real_space_solve_projected(space) result(error)
            import real_space_t, IK
            class(real_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_real_space_solve_projected

        function krylov_real_space_make_residuals(space) result(error)
            import real_space_t, IK
            class(real_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_real_space_make_residuals

        function krylov_real_space_transform_solutions(space) result(error)
            import real_space_t, IK
            class(real_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_real_space_transform_solutions

        function krylov_real_space_update_convergence(space) result(error)
            import real_space_t, IK
            class(real_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_real_space_update_convergence

        function krylov_real_space_prepare_preconditioner(space) result(error)
            import real_space_t, IK
            class(real_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_real_space_prepare_preconditioner

        function krylov_real_space_expand_basis(space) result(error)
            import real_space_t, IK
            class(real_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_real_space_expand_basis

        function krylov_real_space_restart(space) result(error)
            import real_space_t, IK
            class(real_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_real_space_restart

        function krylov_complex_space_initialize( &
            space, equation, full_dim, solution_dim, basis_dim, config) result(error)
            import complex_space_t, config_t, IK, AK
            class(complex_space_t), intent(inout) :: space
            character(len=*, kind=AK), intent(in) :: equation
            integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
            type(config_t), intent(in) :: config
            integer(IK) :: error
        end function krylov_complex_space_initialize

        function krylov_complex_space_set_equation(space, value) result(error)
            import complex_space_t, IK, AK
            class(complex_space_t), intent(inout) :: space
            character(len=*, kind=AK), intent(in) :: value
            integer(IK) :: error
        end function krylov_complex_space_set_equation

        function krylov_complex_space_set_preconditioner(space, value) result(error)
            import complex_space_t, IK, AK
            class(complex_space_t), intent(inout) :: space
            character(len=*, kind=AK), intent(in) :: value
            integer(IK) :: error
        end function krylov_complex_space_set_preconditioner

        function krylov_complex_space_set_orthonormalizer(space, value) result(error)
            import complex_space_t, IK, AK
            class(complex_space_t), intent(inout) :: space
            character(len=*, kind=AK), intent(in) :: value
            integer(IK) :: error
        end function krylov_complex_space_set_orthonormalizer

        function krylov_complex_space_prepare_orthonormalizer(space) result(error)
            import complex_space_t, IK
            class(complex_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_complex_space_prepare_orthonormalizer

        function krylov_complex_space_expand_equation(space) result(error)
            import complex_space_t, IK
            class(complex_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_complex_space_expand_equation

        function krylov_complex_space_solve_projected(space) result(error)
            import complex_space_t, IK
            class(complex_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_complex_space_solve_projected

        function krylov_complex_space_make_residuals(space) result(error)
            import complex_space_t, IK
            class(complex_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_complex_space_make_residuals

        function krylov_complex_space_transform_solutions(space) result(error)
            import complex_space_t, IK
            class(complex_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_complex_space_transform_solutions

        function krylov_complex_space_update_convergence(space) result(error)
            import complex_space_t, IK
            class(complex_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_complex_space_update_convergence

        function krylov_complex_space_prepare_preconditioner(space) result(error)
            import complex_space_t, IK
            class(complex_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_complex_space_prepare_preconditioner

        function krylov_complex_space_expand_basis(space) result(error)
            import complex_space_t, IK
            class(complex_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_complex_space_expand_basis

        function krylov_complex_space_restart(space) result(error)
            import complex_space_t, IK
            class(complex_space_t), intent(inout) :: space
            integer(IK) :: error
        end function krylov_complex_space_restart

    end interface

contains

    subroutine krylov_real_space_finalize(space)
        implicit none
        type(real_space_t), intent(inout) :: space

        if (allocated(space%config)) deallocate (space%config)
        if (allocated(space%convergence)) deallocate (space%convergence)
        if (associated(space%equation)) deallocate (space%equation)
        if (associated(space%preconditioner)) deallocate (space%preconditioner)
        if (associated(space%orthonormalizer)) deallocate (space%orthonormalizer)
    end subroutine krylov_real_space_finalize

    subroutine krylov_complex_space_finalize(space)
        implicit none
        type(complex_space_t), intent(inout) :: space

        if (allocated(space%config)) deallocate (space%config)
        if (allocated(space%convergence)) deallocate (space%convergence)
        if (associated(space%equation)) deallocate (space%equation)
        if (associated(space%preconditioner)) deallocate (space%preconditioner)
        if (associated(space%orthonormalizer)) deallocate (space%orthonormalizer)
    end subroutine krylov_complex_space_finalize

end module solvers
