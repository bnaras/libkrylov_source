program test_solve_real_equation

    use kinds, only: IK, RK
    use errors, only: OK
    use testing, only: near_real_vec, near_real_mat
    use krylov, only: krylov_initialize, krylov_finalize, krylov_set_enum_option, &
                      krylov_add_space, krylov_set_real_space_vectors, &
                      krylov_solve_real_equation, krylov_get_real_space_solutions, &
                      krylov_get_space_eigenvalues, krylov_set_real_space_rhs
    implicit none

    integer(IK) :: index, error
    real(RK) :: vectors(4_IK, 1_IK), rhs(4_IK, 1_IK), eigenvalues(1_IK), &
                solutions(4_IK, 1_IK), eigenvalues_ref(1_IK), solutions_ref(4_IK, 1_IK), &
                solutions1_ref(4_IK, 1_IK)

    vectors = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 0.0_RK/), (/4_IK, 1_IK/))
    rhs = reshape((/1.0_IK, 0.0_RK, 0.0_RK, 0.0_RK/), (/4_IK, 1_IK/))
    eigenvalues_ref = (/1.0_RK/)
    solutions_ref = reshape((/sqrt(0.5_RK), -sqrt(0.5_RK), 0.0_RK, 0.0_RK/), &
                            (/4_IK, 1_IK/))
    solutions1_ref = reshape((/0.56_RK, -0.44_RK, -0.02_RK, -0.02_RK/), (/4_IK, 1_IK/))

    ! Eigenvalue equation
    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_enum_option('preconditioner', 'n')
    if (error /= OK) stop 1

    error = krylov_set_enum_option('orthonormalizer', 'o')
    if (error /= OK) stop 1

    ! Add real space for eigenvalue equation with full dimension 4
    index = krylov_add_space('r', 's', 'e', 4_IK, 1_IK, 1_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_real_space_vectors(index, 4_IK, 1_IK, vectors)
    if (error /= OK) stop 1

    error = krylov_solve_real_equation(index, multiply)
    if (error /= OK) stop 1

    error = krylov_get_space_eigenvalues(index, 1_IK, eigenvalues)
    if (error /= OK) stop 1

    error = krylov_get_real_space_solutions(index, 4_IK, 1_IK, solutions)
    if (error /= OK) stop 1

    if (eigenvalues /= near_real_vec(eigenvalues_ref)) stop 1
    if (solutions /= near_real_mat(solutions_ref, fix_phase=.true.)) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

    ! Linear equation
    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_enum_option('preconditioner', 'n')
    if (error /= OK) stop 1

    error = krylov_set_enum_option('orthonormalizer', 'o')
    if (error /= OK) stop 1

    ! Add real space for eigenvalue equation with full dimension 4
    index = krylov_add_space('r', 's', 'l', 4_IK, 1_IK, 1_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_real_space_rhs(index, 4_IK, 1_IK, rhs)
    if (error /= OK) stop 1

    error = krylov_set_real_space_vectors(index, 4_IK, 1_IK, vectors)
    if (error /= OK) stop 1

    error = krylov_solve_real_equation(index, multiply)
    if (error /= OK) stop 1

    error = krylov_get_real_space_solutions(index, 4_IK, 1_IK, solutions)
    if (error /= OK) stop 1

    if (solutions /= near_real_mat(solutions1_ref, fix_phase=.true.)) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

contains

    function multiply(full_dim, subset_dim, vectors, products) result(error)

        use kinds, only: IK, RK
        use errors, only: OK, INVALID_DIMENSION
        implicit none

        integer(IK), intent(in) :: full_dim, subset_dim
        real(RK), intent(in) :: vectors(full_dim, subset_dim)
        real(RK), intent(out) :: products(full_dim, subset_dim)
        integer(IK) :: error

        real(RK) :: matrix(4_IK, 4_IK)

        if (full_dim /= 4_IK) then
            error = INVALID_DIMENSION
            return
        end if

        ! Example 4.1 from Gregory, Karney,
        ! "A collection of matrices for testing computational algorithms", Wiley, NY, 1969.
        matrix = reshape((/5.0_RK, 4.0_RK, 1.0_RK, 1.0_RK, 4.0_RK, 5.0_RK, 1.0_RK, 1.0_RK, &
                           1.0_RK, 1.0_RK, 4.0_RK, 2.0_RK, 1.0_RK, 1.0_RK, 2.0_RK, 4.0_RK/), &
                         (/4_IK, 4_IK/))

        products = matmul(matrix, vectors)

        error = OK

    end function multiply

end program test_solve_real_equation
