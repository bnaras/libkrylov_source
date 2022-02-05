function krylov_real_space_expand_basis(space) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INCOMPLETE_CONFIGURATION, NO_BASIS_UPDATE, MAX_DIM_REACHED
    use linalg, only: real_ge_subset
    use krylov, only: real_space_t
    implicit none

    class(real_space_t), intent(inout) :: space
    integer(IK) :: error

    integer(IK) :: err, old_dim, new_dim, next_dim, max_dim, active_dim
    integer(IK), allocatable :: active_indices(:)
    real(RK), allocatable :: preconditioned(:, :), orthonormalized(:, :)

    if (space%config%find_option('max_dim') /= OK) then
        error = INCOMPLETE_CONFIGURATION
        return
    end if

    max_dim = space%config%get_integer_option('max_dim')

    allocate (preconditioned(space%full_dim, space%solution_dim), &
              orthonormalized(space%full_dim, space%solution_dim))

    err = space%preconditioner%transform_residuals( &
          space%full_dim, space%solution_dim, space%equation%residuals, preconditioned)
    if (err /= OK) then
        error = err
        deallocate (preconditioned, orthonormalized)
        return
    end if

    active_dim = space%convergence%get_active_dim()

    allocate (active_indices(active_dim))

    err = space%convergence%get_active(active_dim, active_indices)
    if (err /= OK) then
        error = err
        deallocate (active_indices, preconditioned, orthonormalized)
        return
    end if

    err = real_ge_subset(preconditioned, active_indices, space%full_dim, space%solution_dim, active_dim)
    if (err /= OK) then
        error = err
        deallocate (active_indices, preconditioned, orthonormalized)
        return
    end if

    deallocate (active_indices)

    err = space%orthonormalizer%prepare_vectors( &
          space%full_dim, space%basis_dim, active_dim, space%equation%vectors, preconditioned, &
          orthonormalized, new_dim)
    if (err /= OK) then
        error = err
        deallocate (preconditioned, orthonormalized)
        return
    end if

    if (new_dim == 0_IK) then
        error = NO_BASIS_UPDATE
        deallocate (preconditioned, orthonormalized)
        return
    end if

    old_dim = space%basis_dim
    next_dim = old_dim + new_dim
    if (next_dim > max_dim) then
        error = MAX_DIM_REACHED
        deallocate (preconditioned, orthonormalized)
        return
    end if

    err = space%equation%resize_vectors(next_dim)
    if (err /= OK) then
        error = err
        deallocate (preconditioned, orthonormalized)
        return
    end if

    space%equation%vectors(:, old_dim + 1_IK:next_dim) = orthonormalized(:, 1_IK:new_dim)
    space%equation%new_dim = new_dim

    space%basis_dim = next_dim
    space%new_dim = new_dim

    deallocate (preconditioned, orthonormalized)

    error = OK

end function krylov_real_space_expand_basis
