function krylov_set_complex_space_shifts(index, solution_dim, shifts) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INCOMPATIBLE_EQUATION
    use krylov, only: spaces, complex_space_t, complex_shifted_linear_equation_t, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index, solution_dim
    real(RK), intent(in) :: shifts(solution_dim)
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
        type is (complex_space_t)
            select type (equation => space%equation)
            type is (complex_shifted_linear_equation_t)
                equation%shifts = shifts
            class default
                error = INCOMPATIBLE_EQUATION
                return
            end select
        class default
            error = INCOMPATIBLE_SPACE
            return
        end select
    end associate

    error = OK

end function krylov_set_complex_space_shifts
