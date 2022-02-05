program test_solve_real_block_equation

    use kinds, only: IK, RK
    use errors, only: OK
    use testing, only: near_real_vec, near_real_mat
    use krylov, only: krylov_initialize, krylov_finalize, krylov_set_enum_option, &
                      krylov_add_space, krylov_set_real_space_vectors, &
                      krylov_solve_real_block_equation, krylov_get_real_space_solutions, &
                      krylov_get_space_eigenvalues
    implicit none

    integer(IK) :: index, error
    real(RK) :: vectors_1(2_IK), vectors_2(2_IK), eigenvalues_1(1_IK), eigenvalues_2(1_IK), &
                solutions_1(2_IK, 1_IK), solutions_2(2_IK, 1_IK), eigenvalues_ref_1(1_IK), &
                eigenvalues_ref_2(1_IK), solutions_ref_1(2_IK, 1_IK), solutions_ref_2(2_IK, 1_IK)

    vectors_1 = (/1.0_RK, 0.0_RK/)
    vectors_2 = (/1.0_RK, 0.0_RK/)
    eigenvalues_ref_1 = (/-1.0_RK/)
    eigenvalues_ref_2 = (/0.0_RK/)
    solutions_ref_1 = reshape((/sqrt(0.5_RK), -sqrt(0.5_RK)/), (/2_IK, 1_IK/))
    solutions_ref_2 = reshape((/sqrt(0.5_RK), -sqrt(0.5_RK)/), (/2_IK, 1_IK/))

    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_enum_option('preconditioner', 'n')
    if (error /= OK) stop 1

    error = krylov_set_enum_option('orthonormalizer', 'o')
    if (error /= OK) stop 1

    ! Add real space for eigenvalue equation with full dimension 2
    index = krylov_add_space('r', 's', 'e', 2_IK, 1_IK, 1_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_real_space_vectors(index, 2_IK, 1_IK, vectors_1)
    if (error /= OK) stop 1

    ! Add second real space for eigenvalue equation with full dimension 2
    index = krylov_add_space('r', 's', 'e', 2_IK, 1_IK, 1_IK)
    if (index /= 2_IK) stop 1

    error = krylov_set_real_space_vectors(index, 2_IK, 1_IK, vectors_2)
    if (error /= OK) stop 1

    error = krylov_solve_real_block_equation(block_multiply)
    if (error /= OK) stop 1

    error = krylov_get_space_eigenvalues(1_IK, 1_IK, eigenvalues_1)
    if (error /= OK) stop 1

    error = krylov_get_real_space_solutions(1_IK, 2_IK, 1_IK, solutions_1)
    if (error /= OK) stop 1

    if (eigenvalues_1 /= near_real_vec(eigenvalues_ref_1)) stop 1
    if (solutions_1 /= near_real_mat(solutions_ref_1, fix_phase=.true.)) stop 1

    error = krylov_get_space_eigenvalues(2_IK, 1_IK, eigenvalues_2)
    if (error /= OK) stop 1

    error = krylov_get_real_space_solutions(2_IK, 2_IK, 1_IK, solutions_2)
    if (error /= OK) stop 1

    if (eigenvalues_2 /= near_real_vec(eigenvalues_ref_2)) stop 1
    if (solutions_2 /= near_real_mat(solutions_ref_2, fix_phase=.true.)) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

contains

    function block_multiply(num_spaces, total_size, full_dims, subset_dims, offsets, &
                            vectors, products) result(error)

        use kinds, only: IK, RK
        use errors, only: OK, INVALID_DIMENSION
        implicit none

        integer(IK), intent(in) :: num_spaces, total_size, full_dims(num_spaces), &
                                   subset_dims(num_spaces), offsets(num_spaces)
        real(RK), intent(in) :: vectors(total_size)
        real(RK), intent(out) :: products(total_size)
        integer(IK) :: error

        integer(IK) :: offset, length
        real(RK) :: matrix_1(2_IK, 2_IK), matrix_2(2_IK, 2_IK)

        if (num_spaces /= 2_IK) then
            error = INVALID_DIMENSION
            return
        end if

        if (total_size /= 4_IK) then
            error = INVALID_DIMENSION
            return
        end if

        matrix_1 = reshape((/0.0_RK, 1.0_RK, 1.0_RK, 0.0_RK/), (/2_IK, 2_IK/))
        matrix_2 = reshape((/1.0_RK, 1.0_RK, 1.0_RK, 1.0_RK/), (/2_IK, 2_IK/))

        offset = offsets(1_IK)
        length = full_dims(1_IK) * subset_dims(1_IK)
        products(offset + 1_IK:offset + length) = matmul(matrix_1, vectors(offset + 1_IK:offset + length))
        offset = offsets(2_IK)
        length = full_dims(2_IK) * subset_dims(2_IK)
        products(offset + 1_IK:offset + length) = matmul(matrix_2, vectors(offset + 1_IK:offset + length))

        error = OK

    end function block_multiply

end program test_solve_real_block_equation
