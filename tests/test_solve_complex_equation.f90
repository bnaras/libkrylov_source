program test_solve_complex_equation

    use kinds, only: IK, RK, CK, LK
    use errors, only: OK
    use testing, only: near_real_vec, near_complex_mat
    use krylov, only: krylov_initialize, krylov_finalize, krylov_set_enum_option, &
                      krylov_add_space, krylov_set_complex_space_vectors, &
                      krylov_solve_complex_equation, krylov_get_complex_space_solutions, &
                      krylov_get_space_eigenvalues, krylov_set_complex_space_rhs, &
                      krylov_set_space_shifts
    implicit none

    integer(IK) :: index, error
    complex(CK) :: vectors(4_IK, 1_IK), rhs(4_IK, 1_IK), solutions(4_IK, 1_IK), &
                   solutions_ref1(4_IK, 1_IK), solutions_ref2(4_IK, 1_IK), solutions_ref3(4_IK, 1_IK)
    real(RK) :: eigenvalues(1_IK), eigenvalues_ref(1_IK), shifts(1_IK)

    vectors = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                        (0.0_CK, 0.0_CK)/), (/4_IK, 1_IK/))
    rhs = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                    (0.0_CK, 0.0_CK)/), (/4_IK, 1_IK/))
    shifts = (/-1.0_RK/)
    eigenvalues_ref = (/0.960073820952024_RK/)
    solutions_ref1 = reshape((/(0.693582188120881_CK, 0.0_CK), (-0.694782745452518_CK, -0.019183995235172_CK), &
                              (0.005107696365343_CK, -0.129933915457505_CK), (0.000677699556451_CK, 0.137634621533832_CK)/), &
                            (/4_IK, 1_IK/))
    solutions_ref2 = reshape((/(0.57050764852474867_CK, 0.0_CK), (-0.45076137564027469_CK, -0.0122609548410319777_CK), &
                               (-0.0184067712375792572_CK, -0.0480518989141027961_CK), &
                               (-0.0198384090005020650_CK, 0.0521627444904955023_CK)/), (/4_IK, 1_IK/))
    solutions_ref3 = reshape((/(0.304771521880259_CK, 0.0_CK), (-0.198752971433269_CK, -0.005341645160543_CK), &
                               (-0.014709246797494_CK, -0.015521054708982_CK), &
                               (-0.015116423179432_CK, 0.017053055846022_CK)/), (/4_IK, 1_IK/))

    ! Eigenvalue equation
    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_enum_option('preconditioner', 'n')
    if (error /= OK) stop 1

    error = krylov_set_enum_option('orthonormalizer', 'o')
    if (error /= OK) stop 1

    ! Add complex space for eigenvalue equation with full dimension 4
    index = krylov_add_space('c', 'h', 'e', 4_IK, 1_IK, 1_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_complex_space_vectors(index, 4_IK, 1_IK, vectors)
    if (error /= OK) stop 1

    error = krylov_solve_complex_equation(index, complex_multiply)
    if (error /= OK) stop 1

    error = krylov_get_space_eigenvalues(index, 1_IK, eigenvalues)
    if (error /= OK) stop 1

    error = krylov_get_complex_space_solutions(index, 4_IK, 1_IK, solutions)
    if (error /= OK) stop 1

    if (eigenvalues /= near_real_vec(eigenvalues_ref)) stop 1
    if (solutions /= near_complex_mat(solutions_ref1, fix_phase=.true._LK)) stop 1

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
    index = krylov_add_space('c', 'h', 'l', 4_IK, 1_IK, 1_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_complex_space_rhs(index, 4_IK, 1_IK, rhs)
    if (error /= OK) stop 1

    error = krylov_set_complex_space_vectors(index, 4_IK, 1_IK, vectors)
    if (error /= OK) stop 1

    error = krylov_solve_complex_equation(index, complex_multiply)
    if (error /= OK) stop 1

    error = krylov_get_complex_space_solutions(index, 4_IK, 1_IK, solutions)
    if (error /= OK) stop 1

    if (solutions /= near_complex_mat(solutions_ref2, fix_phase=.true._LK)) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

    ! Shifted-linear equation
    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_enum_option('preconditioner', 'n')
    if (error /= OK) stop 1

    error = krylov_set_enum_option('orthonormalizer', 'o')
    if (error /= OK) stop 1

    ! Add real space for eigenvalue equation with full dimension 4
    index = krylov_add_space('c', 'h', 'h', 4_IK, 1_IK, 1_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_complex_space_rhs(index, 4_IK, 1_IK, rhs)
    if (error /= OK) stop 1

    error = krylov_set_space_shifts(index, 1_IK, shifts)
    if (error /= OK) stop 1

    error = krylov_set_complex_space_vectors(index, 4_IK, 1_IK, vectors)
    if (error /= OK) stop 1

    error = krylov_solve_complex_equation(index, complex_multiply)
    if (error /= OK) stop 1

    error = krylov_get_complex_space_solutions(index, 4_IK, 1_IK, solutions)
    if (error /= OK) stop 1

    if (solutions /= near_complex_mat(solutions_ref3, fix_phase=.true._LK)) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

contains

    function complex_multiply(full_dim, subset_dim, vectors, products) result(error)

        use kinds, only: IK, CK
        use errors, only: OK, INVALID_DIMENSION
        implicit none

        integer(IK), intent(in) :: full_dim, subset_dim
        complex(CK), intent(in) :: vectors(full_dim, subset_dim)
        complex(CK), intent(out) :: products(full_dim, subset_dim)
        integer(IK) :: error

        complex(CK) :: matrix(4_IK, 4_IK)

        if (full_dim /= 4_IK) then
            error = INVALID_DIMENSION
            return
        end if

        matrix = reshape((/(5.0_CK, 0.0_CK), (4.0_CK, 0.1_CK), (1.0_CK, 0.1_CK), (1.0_CK, -0.1_CK), &
                           (4.0_CK, -0.1_CK), (5.0_CK, 0.0_CK), (1.0_CK, -0.1_CK), (1.0_CK, 0.1_CK), &
                           (1.0_CK, -0.1_CK), (1.0_CK, 0.1_CK), (4.0_CK, 0.0_CK), (2.0_CK, -0.1_CK), &
                           (1.0_CK, 0.1_CK), (1.0_CK, -0.1_CK), (2.0_CK, 0.1_CK), (4.0_CK, 0.0_CK)/), &
                         (/4_IK, 4_IK/))

        products = matmul(matrix, vectors)

        error = OK

    end function complex_multiply

end program test_solve_complex_equation
