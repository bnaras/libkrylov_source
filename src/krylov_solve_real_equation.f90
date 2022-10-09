function krylov_solve_real_equation(index, multiply) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, NOTHING_TO_DO, NOT_CONVERGED, &
                      NO_BASIS_UPDATE, MAX_DIM_REACHED
    use krylov, only: spaces, real_space_t, krylov_i_real_multiply, krylov_get_num_spaces, &
                      krylov_get_space_integer_option, krylov_get_real_space_subset_vectors, &
                      krylov_set_real_space_subset_products, krylov_get_space_convergence
    implicit none

    integer(IK), intent(in) :: index
    procedure(krylov_i_real_multiply) :: multiply
    integer(IK) :: error

    integer(IK) :: max_iterations, iter, err, full_dim, skip_dim, subset_dim, status
    real(RK), allocatable :: vectors(:, :), products(:, :)

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        return
    end if

    select type (space => spaces(index)%space_p)
    type is (real_space_t)

        full_dim = space%full_dim
        subset_dim = 0_IK
        max_iterations = krylov_get_space_integer_option(index, 'max_iterations')

        allocate (vectors(full_dim, subset_dim), products(full_dim, subset_dim))

        do iter = 1_IK, max_iterations

            skip_dim = space%basis_dim - space%new_dim
            subset_dim = space%new_dim

            if (subset_dim == 0_IK) then
                error = NOTHING_TO_DO
                exit
            end if

            if (subset_dim*full_dim /= size(vectors, kind=IK)) then
                deallocate (vectors, products)
                allocate (vectors(full_dim, subset_dim), products(full_dim, subset_dim))
            end if
            vectors = 0.0_RK
            products = 0.0_RK

            err = krylov_get_real_space_subset_vectors(index, full_dim, skip_dim, subset_dim, vectors)
            if (err /= OK) then
                error = err
                exit
            end if

            err = multiply(full_dim, subset_dim, vectors, products)
            if (err /= OK) then
                error = err
                exit
            end if

            err = krylov_set_real_space_subset_products(index, full_dim, skip_dim, subset_dim, products)
            if (err /= OK) then
                error = err
                exit
            end if

            err = space%prepare_orthonormalizer()
            if (err /= OK) then
                error = err
                exit
            end if

            err = space%expand_equation()
            if (err /= OK) then
                error = err
                exit
            end if

            err = space%solve_projected()
            if (err /= OK) then
                error = err
                exit
            end if

            err = space%transform_solutions()
            if (err /= OK) then
                error = err
                exit
            end if

            err = space%make_residuals()
            if (err /= OK) then
                error = err
                exit
            end if

            err = space%update_convergence()
            if (err /= OK) then
                error = err
                exit
            end if

            status = krylov_get_space_convergence(index)
            if (status == OK) then
                error = OK
                exit
            else if (status == NOT_CONVERGED) then
                err = space%prepare_preconditioner()
                if (err /= OK) then
                    error = err
                    exit
                end if

                err = space%expand_basis()
                if (err /= OK) then
                    error = err
                    exit
                end if
            else if (status == NO_BASIS_UPDATE .or. status == MAX_DIM_REACHED) then
                err = space%restart()
                if (err /= OK) then
                    error = err
                    exit
                end if
            else
                error = status
                exit
            end if

        end do

        deallocate (vectors, products)

    class default
        error = INCOMPATIBLE_SPACE
        return
    end select

end function krylov_solve_real_equation
