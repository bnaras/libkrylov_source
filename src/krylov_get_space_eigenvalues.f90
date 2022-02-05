function krylov_get_space_eigenvalues(index, solution_dim, eigenvalues) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INCOMPATIBLE_EQUATION, INVALID_DIMENSION
    use krylov, only: spaces, real_space_t, complex_space_t, krylov_get_num_spaces, &
                      real_eigenvalue_equation_t, complex_eigenvalue_equation_t
    implicit none

    integer(IK), intent(in) :: index, solution_dim
    real(RK), intent(out) :: eigenvalues(solution_dim)
    integer(IK) :: error

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        return
    end if

    associate (space => spaces(index)%space_p)
        if (solution_dim /= space%solution_dim) then
            error = INVALID_DIMENSION
            return
        end if

        select type (space)
        type is (real_space_t)
            select type (equation => space%equation)
            type is (real_eigenvalue_equation_t)
                eigenvalues = equation%eigenvalues
            class default
                error = INCOMPATIBLE_EQUATION
                return
            end select
        type is (complex_space_t)
            select type (equation => space%equation)
            type is (complex_eigenvalue_equation_t)
                eigenvalues = equation%eigenvalues
            class default
                error = INCOMPATIBLE_EQUATION
            end select
        class default
            error = INCOMPATIBLE_SPACE
            return
        end select
    end associate

    error = OK

end function krylov_get_space_eigenvalues
