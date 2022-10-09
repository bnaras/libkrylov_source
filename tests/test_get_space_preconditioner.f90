program test_get_space_preconditioner

    use kinds, only: IK, AK
    use errors, only: OK, INVALID_OPTION, NO_SUCH_SPACE
    use krylov, only: spaces, real_space_t, complex_space_t, real_null_preconditioner_t, real_davidson_preconditioner_t, &
                      complex_null_preconditioner_t, complex_davidson_preconditioner_t, krylov_initialize, krylov_finalize, &
                      krylov_add_space, krylov_get_space_preconditioner, krylov_set_space_preconditioner
    implicit none

    integer(IK) :: error, index
    character(len=1, kind=AK) :: preconditioner

    error = krylov_initialize()
    if (error /= OK) stop 1

    index = krylov_add_space('r', 's', 'e', 10_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    index = krylov_add_space('c', 'h', 'e', 10_IK, 2_IK, 3_IK)
    if (index /= 2_IK) stop 1

    error = krylov_get_space_preconditioner(1_IK, preconditioner)
    if (error /= OK) stop 1
    if (preconditioner /= 'n') stop 1

    select type (space => spaces(1_IK)%space_p)
    type is (real_space_t)
        select type (preconditioner => space%preconditioner)
        type is (real_null_preconditioner_t)
        class default
            stop 1
        end select
    class default
        stop 1
    end select

    error = krylov_set_space_preconditioner(1_IK, 'd')
    if (error /= OK) stop 1

    error = krylov_get_space_preconditioner(1_IK, preconditioner)
    if (error /= OK) stop 1
    if (preconditioner /= 'd') stop 1

    select type (space => spaces(1_IK)%space_p)
    type is (real_space_t)
        select type (preconditioner => space%preconditioner)
        type is (real_davidson_preconditioner_t)
        class default
            stop 1
        end select
    class default
        stop 1
    end select

    error = krylov_set_space_preconditioner(1_IK, 'q')
    if (error /= INVALID_OPTION) stop 1

    error = krylov_get_space_preconditioner(2_IK, preconditioner)
    if (error /= OK) stop 1
    if (preconditioner /= 'n') stop 1

    select type (space => spaces(2_IK)%space_p)
    type is (complex_space_t)
        select type (preconditioner => space%preconditioner)
        type is (complex_null_preconditioner_t)
        class default
            stop 1
        end select
    class default
        stop 1
    end select

    error = krylov_set_space_preconditioner(2_IK, 'd')
    if (error /= OK) stop 1

    error = krylov_get_space_preconditioner(2_IK, preconditioner)
    if (error /= OK) stop 1
    if (preconditioner /= 'd') stop 1

    select type (space => spaces(2_IK)%space_p)
    type is (complex_space_t)
        select type (preconditioner => space%preconditioner)
        type is (complex_davidson_preconditioner_t)
        class default
            stop 1
        end select
    class default
        stop 1
    end select

    error = krylov_get_space_preconditioner(3_IK, preconditioner)
    if (error /= NO_SUCH_SPACE) stop 1
    if (preconditioner /= '') stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_preconditioner
