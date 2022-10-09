function krylov_real_space_prepare_preconditioner(space) result(error)

    use kinds, only: IK
    use errors, only: OK, INCOMPATIBLE_PRECONDITIONER, MAX_DIM_REACHED
    use krylov, only: real_space_t, real_eigenvalue_equation_t, real_linear_equation_t, &
                      real_shifted_linear_equation_t, real_davidson_preconditioner_t, &
                      real_jd_preconditioner_t, real_jdall_preconditioner_t
    implicit none

    class(real_space_t), intent(inout) :: space
    integer(IK) :: error

    integer(IK) :: err

    select type (preconditioner => space%preconditioner)
    type is (real_davidson_preconditioner_t)
        select type (equation => space%equation)
        type is (real_eigenvalue_equation_t)
            err = preconditioner%set_eigenvalues(space%solution_dim, equation%eigenvalues)
            if (err /= OK) then
                error = err
                return
            end if
        type is (real_linear_equation_t)
        type is (real_shifted_linear_equation_t)
            err = preconditioner%set_shifts(space%solution_dim, equation%shifts)
            if (err /= OK) then
                error = err
                return
            end if
        class default
            error = INCOMPATIBLE_PRECONDITIONER
        end select
    type is (real_jd_preconditioner_t)
        select type (equation => space%equation)
        type is (real_eigenvalue_equation_t)
            err = preconditioner%set_eigenvalues(space%solution_dim, equation%eigenvalues)
            if (err /= OK) then
                error = err
                return
            end if
            err = preconditioner%set_solutions(space%full_dim, space%solution_dim, equation%solutions)
            if (err /= OK) then
                error = err
                return
            end if
        type is (real_linear_equation_t)
            err = preconditioner%set_solutions(space%full_dim, space%solution_dim, equation%solutions)
            if (err /= OK) then
                error = err
                return
            end if
        type is (real_shifted_linear_equation_t)
            err = preconditioner%set_shifts(space%solution_dim, equation%shifts)
            if (err /= OK) then
                error = err
                return
            end if
            err = preconditioner%set_solutions(space%full_dim, space%solution_dim, equation%solutions)
            if (err /= OK) then
                error = err
                return
            end if
        class default
            error = INCOMPATIBLE_PRECONDITIONER
        end select
    type is (real_jdall_preconditioner_t)
        select type (equation => space%equation)
        type is (real_eigenvalue_equation_t)
            err = preconditioner%set_eigenvalues(space%solution_dim, equation%eigenvalues)
            if (err /= OK) then
                error = err
                return
            end if
            err = preconditioner%set_solutions(space%full_dim, space%solution_dim, equation%solutions)
            if (err /= OK) then
                error = err
                return
            end if
        type is (real_linear_equation_t)
            err = preconditioner%set_solutions(space%full_dim, space%solution_dim, equation%solutions)
            if (err /= OK) then
                error = err
                return
            end if
        type is (real_shifted_linear_equation_t)
            err = preconditioner%set_shifts(space%solution_dim, equation%shifts)
            if (err /= OK) then
                error = err
                return
            end if
            err = preconditioner%set_solutions(space%full_dim, space%solution_dim, equation%solutions)
            if (err /= OK) then
                error = err
                return
            end if
        class default
            error = INCOMPATIBLE_PRECONDITIONER
        end select
    end select

    error = OK

end function krylov_real_space_prepare_preconditioner
