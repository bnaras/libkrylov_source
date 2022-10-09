function krylov_complex_space_prepare_preconditioner(space) result(error)

    use kinds, only: IK
    use errors, only: OK, INCOMPATIBLE_PRECONDITIONER, MAX_DIM_REACHED
    use krylov, only: complex_space_t, complex_eigenvalue_equation_t, &
                      complex_linear_equation_t, complex_shifted_linear_equation_t, &
                      complex_davidson_preconditioner_t, complex_jd_preconditioner_t, &
                      complex_jdall_preconditioner_t
    implicit none

    class(complex_space_t), intent(inout) :: space
    integer(IK) :: error, err

    select type (preconditioner => space%preconditioner)
    type is (complex_davidson_preconditioner_t)
        select type (equation => space%equation)
        type is (complex_eigenvalue_equation_t)
            err = preconditioner%set_eigenvalues(space%solution_dim, equation%eigenvalues)
            if (err /= OK) then
                error = err
                return
            end if
        type is (complex_linear_equation_t)
        type is (complex_shifted_linear_equation_t)
            err = preconditioner%set_shifts(space%solution_dim, equation%shifts)
            if (err /= OK) then
                error = err
                return
            end if
        class default
            error = INCOMPATIBLE_PRECONDITIONER
        end select
    type is (complex_jd_preconditioner_t)
        select type (equation => space%equation)
        type is (complex_eigenvalue_equation_t)
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
        type is (complex_linear_equation_t)
            err = preconditioner%set_solutions(space%full_dim, space%solution_dim, equation%solutions)
            if (err /= OK) then
                error = err
                return
            end if
        type is (complex_shifted_linear_equation_t)
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
    type is (complex_jdall_preconditioner_t)
        select type (equation => space%equation)
        type is (complex_eigenvalue_equation_t)
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
        type is (complex_linear_equation_t)
            err = preconditioner%set_solutions(space%full_dim, space%solution_dim, equation%solutions)
            if (err /= OK) then
                error = err
                return
            end if
        type is (complex_shifted_linear_equation_t)
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

end function krylov_complex_space_prepare_preconditioner
