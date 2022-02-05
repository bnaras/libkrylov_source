program test_real_space_restart

    use kinds, only: IK, RK
    use errors, only: OK
    use testing, only: near_real_mat
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, spaces, &
                      real_space_t, krylov_set_enum_option, krylov_set_real_space_vectors
    implicit none

    integer(IK) :: index, error
    real(RK) :: vectors(3_IK, 2_IK), solutions(3_IK, 1_IK), next_vectors(3_IK, 1_IK)

    vectors = reshape((/1.0_RK, 2.0_RK, 3.0_RK, -1.0_RK, 0.0_RK, 2.0_RK/), (/3_IK, 2_IK/))
    solutions = reshape((/-1.0_RK, 2.0_RK, -3.0_RK/), (/3_IK, 1_IK/))
    next_vectors = reshape((/-1.0_RK, 2.0_RK, -3.0_RK/), (/3_IK, 1_IK/))

    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_enum_option('orthonormalizer', 'n')
    if (error /= OK) stop 1

    error = krylov_set_enum_option('preconditioner', 'n')
    if (error /= OK) stop 1

    ! Add real space with full dimension 3, current dimension 2, solution dimension 1
    index = krylov_add_space('r', 's', 'e', 3_IK, 1_IK, 2_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_real_space_vectors(index, 3_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    select type (space => spaces(index)%space_p)
    type is (real_space_t)
        space%equation%solutions = solutions

        error = space%restart()
        if (error /= OK) stop 1

        if (space%equation%vectors /= near_real_mat(next_vectors)) stop 1
    end select

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_real_space_restart
