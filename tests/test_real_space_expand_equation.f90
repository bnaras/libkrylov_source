program test_real_space_expand_equation

    use kinds, only: IK, RK
    use errors, only: OK
    use testing, only: near_real_mat
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, spaces, &
                      real_space_t, krylov_set_real_space_vectors, &
                      krylov_resize_real_space_vectors
    implicit none

    integer(IK) :: index, error
    real(RK) :: vectors(3_IK, 2_IK), products(3_IK, 2_IK), rayleigh1(1_IK, 1_IK), rayleigh(2_IK, 2_IK)

    vectors = reshape((/1.0_RK, 2.0_RK, 3.0_RK, -1.0_RK, 2.0_RK, -3.0_RK/), (/3_IK, 2_IK/))
    products = reshape((/2.0_RK, 1.0_RK, 3.0_RK, 2.0_RK, -1.0_RK, -3.0_RK/), (/3_IK, 2_IK/))
    rayleigh1 = reshape((/13.0_RK/), (/1_IK, 1_IK/))
    rayleigh = reshape((/13.0_RK, -9.0_RK, -9.0_RK, 5.0_RK/), (/2_IK, 2_IK/))

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with full dimension 3, current dimension 1
    index = krylov_add_space('r', 's', 'e', 3_IK, 1_IK, 1_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_real_space_vectors(index, 3_IK, 1_IK, vectors(:, 1_IK))
    if (error /= OK) stop 1

    select type (space => spaces(1_IK)%space_p)
    type is (real_space_t)
        space%new_dim = 1_IK
        space%equation%products = products(:, 1_IK:1_IK)

        error = space%expand_equation()
        if (error /= OK) stop 1

        if (space%equation%rayleigh /= near_real_mat(rayleigh1)) stop 1
    end select

    ! Update to current dimension 2, new dimension 1
    error = krylov_resize_real_space_vectors(index, 2_IK)
    if (error /= OK) stop 1

    error = krylov_set_real_space_vectors(index, 3_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    select type (space => spaces(1_IK)%space_p)
    type is (real_space_t)
        space%new_dim = 1_IK
        space%equation%products = products

        error = space%expand_equation()
        if (error /= OK) stop 1

        if (space%equation%rayleigh /= near_real_mat(rayleigh)) stop 1
    end select

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_real_space_expand_equation
