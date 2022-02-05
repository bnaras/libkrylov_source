function krylov_real_space_restart(space) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, LINEARLY_DEPENDENT_BASIS
    use krylov, only: real_space_t
    implicit none

    class(real_space_t), intent(inout) :: space
    integer(IK) :: error

    integer(IK) :: err, restart_dim, new_dim
    real(RK), allocatable :: orthonormalized(:, :)

    restart_dim = space%solution_dim

    allocate (orthonormalized(space%full_dim, space%solution_dim))

    err = space%orthonormalizer%prepare_vectors( &
          space%full_dim, 0_IK, space%solution_dim, space%equation%vectors, space%equation%solutions, orthonormalized, new_dim)
    if (err /= OK) then
        error = err
        deallocate (orthonormalized)
        return
    end if

    if (new_dim /= restart_dim) then
        error = LINEARLY_DEPENDENT_BASIS
        deallocate (orthonormalized)
        return
    end if

    err = space%equation%resize_vectors(restart_dim)
    if (err /= OK) then
        error = err
        deallocate (orthonormalized)
        return
    end if

    space%equation%vectors = orthonormalized
    space%equation%new_dim = restart_dim

    space%basis_dim = restart_dim
    space%new_dim = restart_dim

    deallocate (orthonormalized)

    error = OK

end function krylov_real_space_restart
