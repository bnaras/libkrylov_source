function krylov_real_space_update_convergence(space) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: real_space_t, iteration_t
    use blaswrapper, only: real_nrm2
    implicit none

    class(real_space_t), intent(inout) :: space
    integer(IK) :: error

    integer(IK) :: index, sol, err
    real(RK) :: gram_rcond, lagrangian
    real(RK), allocatable :: expectation_vals(:), residual_norms(:)
    type(iteration_t), allocatable :: iteration

    gram_rcond = space%orthonormalizer%get_gram_rcond()
    lagrangian = space%equation%get_lagrangian()

    allocate (expectation_vals(space%solution_dim), residual_norms(space%solution_dim))

    err = space%equation%get_expectation_vals(space%solution_dim, expectation_vals)
    if (err /= OK) then
        error = err
        deallocate (expectation_vals, residual_norms)
        return
    end if

    do sol = 1_IK, space%solution_dim
        residual_norms(sol) = real_nrm2(space%full_dim, space%equation%residuals(:, sol), 1_IK)
    end do

    allocate (iteration)

    err = iteration%initialize(space%basis_dim, space%solution_dim, gram_rcond, lagrangian)
    if (err /= OK) then
        error = err
        deallocate (iteration, expectation_vals, residual_norms)
        return
    end if

    err = iteration%set_expectation_vals(space%solution_dim, expectation_vals)
    if (err /= OK) then
        error = err
        deallocate (iteration, expectation_vals, residual_norms)
        return
    end if

    err = iteration%set_residual_norms(space%solution_dim, residual_norms)
    if (err /= OK) then
        error = err
        deallocate (iteration, expectation_vals, residual_norms)
        return
    end if

    index = space%convergence%add_iteration(iteration)
    if (index < 0_IK) then
        error = index
        deallocate (iteration, expectation_vals, residual_norms)
        return
    end if

    deallocate (iteration, expectation_vals, residual_norms)

    error = OK

end function krylov_real_space_update_convergence
