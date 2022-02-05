program test_real_space_expand_basis

    use kinds, only: IK, RK
    use errors, only: OK
    use testing, only: near_real_mat
    use krylov, only: real_space_t, iteration_t, krylov_initialize, krylov_finalize, krylov_add_space, &
                      spaces, krylov_set_enum_option, krylov_set_real_space_vectors
    implicit none

    integer(IK) :: index, error
    real(RK) :: vectors(3_IK, 1_IK), residuals(3_IK, 1_IK), residual_norms(1_IK), next_vectors(3_IK, 2_IK)
    type(iteration_t) :: iteration

    vectors = reshape((/1.0_RK, 2.0_RK, 3.0_RK/), (/3_IK, 1_IK/))
    residuals = reshape((/-1.0_RK, 2.0_RK, -3.0_RK/), (/3_IK, 1_IK/))
    residual_norms = (/3.7416573867739413_RK/)
    next_vectors = reshape((/1.0_RK, 2.0_RK, 3.0_RK, -1.0_RK, 2.0_RK, -3.0_RK/), (/3_IK, 2_IK/))

    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_enum_option('preconditioner', 'n')
    if (error /= OK) stop 1

    error = krylov_set_enum_option('orthonormalizer', 'n')
    if (error /= OK) stop 1

    ! Add real space with full dimension 3, current dimension 1, solution dimension 1
    index = krylov_add_space('r', 's', 'e', 3_IK, 1_IK, 1_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_real_space_vectors(index, 3_IK, 1_IK, vectors)
    if (error /= OK) stop 1

    select type (space => spaces(index)%space_p)
    type is (real_space_t)
        space%equation%residuals = residuals

        error = iteration%initialize(1_IK, 1_IK, 1.0E-12_RK, 0.1_RK)
        if (error /= OK) stop 1

        error = iteration%set_residual_norms(1_IK, residual_norms)
        if (error /= OK) stop 1

        index = space%convergence%add_iteration(iteration)
        if (index /= 1_IK) stop 1

        error = space%expand_basis()
        if (error /= OK) stop 1

        if (space%equation%vectors /= near_real_mat(next_vectors)) stop 1
    end select

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_real_space_expand_basis
