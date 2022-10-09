program test_set_complex_space_vectors_from_diagonal

    use kinds, only: IK, RK, CK
    use errors, only: OK
    use testing, only: near_complex_mat
    use krylov, only: krylov_initialize, krylov_add_space, krylov_set_complex_space_vectors_from_diagonal, &
                      krylov_finalize, krylov_get_complex_space_vectors, krylov_set_complex_space_rhs, &
                      krylov_set_space_shifts
    implicit none

    real(RK) :: diagonal(5_IK), shifts(1_IK)
    complex(CK) :: rhs(5_IK, 1_IK), vectors(5_IK, 1_IK), vectors_ref1(5_IK, 1_IK), vectors_ref2(5_IK, 1_IK), &
                   vectors_ref3(5_IK, 1_IK)
    integer(IK) :: error, index

    diagonal = (/5.0_RK, 2.0_RK, -8.0_RK, 3.0_RK, 7.0_RK/)
    shifts = (/1.0_RK/)
    rhs = reshape((/(0.265833374057532_CK, 0.000001666666667_CK), (0.000000079750012_CK, 0.999999999980346_CK), &
                    (-0.031900004886904_CK, -0.0000002_CK), (0.957000146607114_CK, 0.000006_CK), &
                    (-0.111650017104163_CK, -0.0000007_CK)/), (/5_IK, 1_IK/))
    vectors_ref1 = reshape((/(0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                             (0.0_CK, 0.0_CK)/), (/5_IK, 1_IK/))
    vectors_ref2 = reshape((/(0.089250813042720_CK, 0.000000559566140_CK), (0.000000066938110_CK, 0.839349210359593_CK), &
                             (0.006693810978204_CK, 0.000000041967461_CK), (0.535504878256322_CK, 0.000003357396842_CK), &
                             (-0.026775243912816_CK, -0.000000167869842_CK)/), (/5_IK, 1_IK/))
    vectors_ref3 = reshape((/(0.059832626164763_CK, 0.000000375126126_CK), (0.000000071799151_CK, 0.900302700903730_CK), &
                             (0.003191073395454_CK, 0.000000020006726_CK), (0.430794908386292_CK, 0.000002700908103_CK), &
                             (-0.016753135326133_CK, -0.000000105035315_CK)/), (/5_IK, 1_IK/))

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add complex space for eigenvalue equation with full dimension 5
    index = krylov_add_space('c', 'h', 'e', 5_IK, 1_IK, 1_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_complex_space_vectors_from_diagonal(index, 5_IK, 1_IK, diagonal)
    if (error /= OK) stop 1

    error = krylov_get_complex_space_vectors(index, 5_IK, 1_IK, vectors)
    if (error /= OK) stop 1

    if (vectors /= near_complex_mat(vectors_ref1)) stop 1

    ! Add complex space for linear equation with full dimension 5
    index = krylov_add_space('c', 'h', 'l', 5_IK, 1_IK, 1_IK)
    if (index /= 2_IK) stop 1

    error = krylov_set_complex_space_rhs(index, 5_IK, 1_IK, rhs)
    if (error /= OK) stop 1

    error = krylov_set_complex_space_vectors_from_diagonal(index, 5_IK, 1_IK, diagonal)
    if (error /= OK) stop 1

    error = krylov_get_complex_space_vectors(index, 5_IK, 1_IK, vectors)
    if (error /= OK) stop 1

    if (vectors /= near_complex_mat(vectors_ref2)) stop 1

    ! Add complex space for shifted-linear equation with full dimension 5
    index = krylov_add_space('c', 'h', 'h', 5_IK, 1_IK, 1_IK)
    if (index /= 3_IK) stop 1

    error = krylov_set_complex_space_rhs(index, 5_IK, 1_IK, rhs)
    if (error /= OK) stop 1

    error = krylov_set_space_shifts(index, 1_IK, shifts)
    if (error /= OK) stop 1

    error = krylov_set_complex_space_vectors_from_diagonal(index, 5_IK, 1_IK, diagonal)
    if (error /= OK) stop 1

    error = krylov_get_complex_space_vectors(index, 5_IK, 1_IK, vectors)
    if (error /= OK) stop 1

    if (vectors /= near_complex_mat(vectors_ref3)) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_set_complex_space_vectors_from_diagonal
