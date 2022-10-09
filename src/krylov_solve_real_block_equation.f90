function krylov_solve_real_block_equation(multiply) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, NOTHING_TO_DO, NOT_CONVERGED, NO_BASIS_UPDATE, MAX_DIM_REACHED
    use krylov, only: spaces, krylov_i_real_block_multiply, krylov_get_num_spaces, &
                      krylov_get_integer_option, krylov_get_real_block_total_size, &
                      krylov_get_real_block_dims, krylov_get_real_block_vectors, &
                      krylov_set_real_block_products, krylov_get_real_block_convergence, &
                      krylov_get_space_convergence
    implicit none

    procedure(krylov_i_real_block_multiply) :: multiply
    integer(IK) :: error

    integer(IK) :: num_spaces, max_iterations, iter, err, total_size, index, status
    integer(IK), allocatable :: full_dims(:), subset_dims(:), offsets(:)
    real(RK), allocatable :: vectors(:), products(:)

    num_spaces = krylov_get_num_spaces()
    if (num_spaces == 0_IK) then
        error = NOTHING_TO_DO
        return
    end if

    allocate (full_dims(num_spaces), subset_dims(num_spaces), offsets(num_spaces))
    full_dims = 0_IK
    subset_dims = 0_IK
    offsets = 0_IK
    total_size = 0_IK
    max_iterations = krylov_get_integer_option('max_iterations')

    allocate (vectors(total_size), products(total_size))

    do iter = 1_IK, max_iterations

        total_size = krylov_get_real_block_total_size()
        if (total_size == 0_IK) then
            error = NOTHING_TO_DO
            exit
        end if

        if (total_size /= size(vectors, kind=IK)) then
            deallocate (vectors, products)
            allocate (vectors(total_size), products(total_size))
        end if
        vectors = 0.0_RK
        products = 0.0_RK

        err = krylov_get_real_block_dims(num_spaces, full_dims, subset_dims, offsets)
        if (err /= OK) then
            error = err
            exit
        end if

        err = krylov_get_real_block_vectors(num_spaces, total_size, full_dims, subset_dims, offsets, vectors)
        if (err /= OK) then
            error = err
            exit
        end if

        err = multiply(num_spaces, total_size, full_dims, subset_dims, offsets, vectors, products)
        if (err /= OK) then
            error = err
            exit
        end if

        err = krylov_set_real_block_products(num_spaces, total_size, full_dims, subset_dims, offsets, products)
        if (err /= OK) then
            error = err
            exit
        end if

        do index = 1_IK, num_spaces
            if (full_dims(index) == 0_IK .or. subset_dims(index) == 0_IK) cycle
            associate (space => spaces(index)%space_p)
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
            end associate
        end do

        status = krylov_get_real_block_convergence()
        if (status == OK) then
            error = OK
            exit
        else if (status == NOT_CONVERGED) then
            do index = 1_IK, num_spaces
                if (full_dims(index) == 0_IK .or. subset_dims(index) == 0_IK) cycle
                status = krylov_get_space_convergence(index)
                if (status == NOT_CONVERGED) then
                    associate (space => spaces(index)%space_p)
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
                    end associate
                else if (status == NO_BASIS_UPDATE .or. status == MAX_DIM_REACHED) then
                    associate (space => spaces(index)%space_p)
                        err = space%restart()
                        if (err /= OK) then
                            error = err
                            exit
                        end if
                    end associate
                else
                    error = status
                    exit
                end if
            end do
        else
            error = status
            exit
        end if

    end do

    deallocate (full_dims, subset_dims, offsets, vectors, products)

end function krylov_solve_real_block_equation
