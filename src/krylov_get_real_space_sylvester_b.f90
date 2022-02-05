function krylov_get_real_space_sylvester_b(index, solution_dim, sylvester_b) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INCOMPATIBLE_EQUATION
    use krylov, only: spaces, real_space_t, real_sylvester_equation_t, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index, solution_dim
    real(RK), intent(out) :: sylvester_b(solution_dim, solution_dim)
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
            type is (real_sylvester_equation_t)
                sylvester_b = equation%sylvester_b
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

end function krylov_get_real_space_sylvester_b
