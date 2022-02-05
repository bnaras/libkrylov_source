program test_set_real_space_vectors_from_diagonal

    use kinds, only: IK, RK
    use errors, only: OK
    use testing, only: near_real_mat
    use krylov, only: krylov_initialize, krylov_add_space, krylov_set_real_space_vectors_from_diagonal, &
                      krylov_finalize, krylov_get_real_space_vectors
    implicit none

    real(RK) :: diagonal(5_IK), vectors(5_IK, 1_IK), vectors_ref1(5_IK, 1_IK)
    integer(IK) :: error, index

    diagonal = (/5.0_RK, 2.0_RK, -8.0_RK, 3.0_RK, 7.0_RK/)
    vectors_ref1 = reshape((/0.0_RK, 0.0_RK, 1.0_RK, 0.0_RK, 0.0_RK/), (/5_IK, 1_IK/))

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space for eigenvalue equation with full dimension 5
    index = krylov_add_space('r', 's', 'e', 5_IK, 1_IK, 1_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_real_space_vectors_from_diagonal(index, 5_IK, 1_IK, diagonal)
    if (error /= OK) stop 1

    error = krylov_get_real_space_vectors(index, 5_IK, 1_IK, vectors)
    if (error /= OK) stop 1

    if (vectors /= near_real_mat(vectors_ref1)) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_set_real_space_vectors_from_diagonal