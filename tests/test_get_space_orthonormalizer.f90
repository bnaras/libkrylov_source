program test_get_space_orthonormalizer

    use kinds, only: IK, AK
    use errors, only: OK, INVALID_OPTION, NO_SUCH_SPACE
    use krylov, only: spaces, real_space_t, complex_space_t, real_ortho_orthonormalizer_t, real_nks_orthonormalizer_t, &
                      complex_ortho_orthonormalizer_t, complex_nks_orthonormalizer_t, krylov_initialize, krylov_finalize, &
                      krylov_add_space, krylov_get_space_orthonormalizer, krylov_set_space_orthonormalizer
    implicit none

    integer(IK) :: error, index
    character(len=1, kind=AK) :: orthonormalizer

    error = krylov_initialize()
    if (error /= OK) stop 1

    index = krylov_add_space('r', 's', 'e', 10_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    index = krylov_add_space('c', 'h', 'e', 10_IK, 2_IK, 3_IK)
    if (index /= 2_IK) stop 1

    error = krylov_get_space_orthonormalizer(1_IK, orthonormalizer)
    if (error /= OK) stop 1
    if (orthonormalizer /= 'o') stop 1

    select type (space => spaces(1_IK)%space_p)
    type is (real_space_t)
        select type (orthonormalizer => space%orthonormalizer)
        type is (real_ortho_orthonormalizer_t)
        class default
            stop 1
        end select
    class default
        stop 1
    end select

    error = krylov_set_space_orthonormalizer(1_IK, 'n')
    if (error /= OK) stop 1

    error = krylov_get_space_orthonormalizer(1_IK, orthonormalizer)
    if (error /= OK) stop 1
    if (orthonormalizer /= 'n') stop 1

    select type (space => spaces(1_IK)%space_p)
    type is (real_space_t)
        select type (orthonormalizer => space%orthonormalizer)
        type is (real_nks_orthonormalizer_t)
        class default
            stop 1
        end select
    class default
        stop 1
    end select

    error = krylov_set_space_orthonormalizer(1_IK, 'q')
    if (error /= INVALID_OPTION) stop 1

    error = krylov_get_space_orthonormalizer(2_IK, orthonormalizer)
    if (error /= OK) stop 1
    if (orthonormalizer /= 'o') stop 1

    select type (space => spaces(2_IK)%space_p)
    type is (complex_space_t)
        select type (orthonormalizer => space%orthonormalizer)
        type is (complex_ortho_orthonormalizer_t)
        class default
            stop 1
        end select
    class default
        stop 1
    end select

    error = krylov_set_space_orthonormalizer(2_IK, 'n')
    if (error /= OK) stop 1

    error = krylov_get_space_orthonormalizer(2_IK, orthonormalizer)
    if (error /= OK) stop 1
    if (orthonormalizer /= 'n') stop 1

    select type (space => spaces(2_IK)%space_p)
    type is (complex_space_t)
        select type (orthonormalizer => space%orthonormalizer)
        type is (complex_nks_orthonormalizer_t)
        class default
            stop 1
        end select
    class default
        stop 1
    end select

    error = krylov_get_space_orthonormalizer(3_IK, orthonormalizer)
    if (error /= NO_SUCH_SPACE) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_orthonormalizer
