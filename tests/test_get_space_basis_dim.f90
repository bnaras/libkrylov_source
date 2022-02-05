program test_get_space_basis_dim

    use kinds, only: IK
    use errors, only: OK, NO_SUCH_SPACE
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_get_space_basis_dim
    implicit none

    integer(IK) :: error, index, basis_dim

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with dimension 100
    index = krylov_add_space('r', 's', 'e', 100_IK, 2_IK, 3_IK)
    basis_dim = krylov_get_space_basis_dim(index)
    if (basis_dim /= 3_IK) stop 1

    ! Nonexistent space
    basis_dim = krylov_get_space_basis_dim(index + 1_IK)
    if (basis_dim /= NO_SUCH_SPACE) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_basis_dim
