program test_set_space_diagonal

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_SPACE, INCOMPATIBLE_PRECONDITIONER
    use krylov, only: krylov_initialize, krylov_finalize, krylov_set_enum_option, krylov_add_space, &
                      krylov_set_space_diagonal
    implicit none

    integer(IK) :: error, index
    real(RK) :: diagonal(3_IK)

    diagonal = (/3.0_RK, 2.0_RK, 1.0_RK/)

    ! Davidson preconditioner
    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_enum_option('preconditioner', 'd')
    if (error /= OK) stop 1

    ! Add real space with full dimension 3, current dimension 2
    index = krylov_add_space('r', 's', 'e', 3_IK, 1_IK, 2_IK)
    if (index /= 1_IK) stop 1

    ! Add complex space with full dimension 3, current dimension 2
    index = krylov_add_space('c', 'h', 'e', 3_IK, 1_IK, 2_IK)
    if (index /= 2_IK) stop 1

    error = krylov_set_space_diagonal(1_IK, 3_IK, diagonal)
    if (error /= OK) stop 1

    error = krylov_set_space_diagonal(2_IK, 3_IK, diagonal)
    if (error /= OK) stop 1

    error = krylov_set_space_diagonal(3_IK, 3_IK, diagonal)
    if (error /= NO_SUCH_SPACE) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

    ! Null preconditioner
    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_enum_option('preconditioner', 'n')
    if (error /= OK) stop 1

    ! Add real space with full dimension 3, current dimension 2
    index = krylov_add_space('r', 's', 'e', 3_IK, 1_IK, 2_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_space_diagonal(1_IK, 3_IK, diagonal)
    if (error /= INCOMPATIBLE_PRECONDITIONER) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_set_space_diagonal
