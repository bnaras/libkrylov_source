program test_real_space_prepare_orthonormalizer

    use kinds, only: IK, RK
    use errors, only: OK
    use testing, only: near_real_mat
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, spaces, &
                      real_space_t, krylov_set_enum_option, krylov_set_real_space_vectors, &
                      real_nks_orthonormalizer_t
    implicit none

    integer(IK) :: index, error
    real(RK) :: vectors(3_IK, 2_IK), gram_factor(2_IK, 2_IK)

    vectors = reshape((/1.0_RK, 2.0_RK, 3.0_RK, -1.0_RK, 2.0_RK, -3.0_RK/), (/3_IK, 2_IK/))
    gram_factor = reshape((/1.0_RK, -0.42857142857142855_RK, -0.42857142857142855_RK, 0.90350790290525129_RK/), &
                          (/2_IK, 2_IK/))

    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_enum_option('orthonormalizer', 'n')
    if (error /= OK) stop 1

    ! Add real space with full dimension 3, current dimension 2
    index = krylov_add_space('r', 's', 'e', 3_IK, 1_IK, 2_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_real_space_vectors(index, 3_IK, 2_IK, vectors)
    if (error /= OK) stop 1

    select type (space => spaces(index)%space_p)
    type is (real_space_t)
        error = space%prepare_orthonormalizer()
        if (error /= OK) stop 1
        select type (ortho => space%orthonormalizer)
        type is (real_nks_orthonormalizer_t)
            if (ortho%gram_matrix_decomposed /= near_real_mat(gram_factor)) stop 1
        end select
    end select

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_real_space_prepare_orthonormalizer
