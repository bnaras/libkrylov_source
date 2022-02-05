function krylov_set_real_space_rhs(index, full_dim, solution_dim, rhs) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INCOMPATIBLE_EQUATION
    use krylov, only: spaces, real_space_t, real_linear_equation_t, real_sylvester_equation_t, &
                      krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index, full_dim, solution_dim
    real(RK), intent(in) :: rhs(full_dim, solution_dim)
    integer(IK) :: error

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        return
    end if

    associate (space => spaces(index)%space_p)
        if (full_dim /= space%full_dim) then
            error = INVALID_DIMENSION
            return
        end if

        if (solution_dim /= space%solution_dim) then
            error = INVALID_DIMENSION
            return
        end if

        select type (space)
        type is (real_space_t)
            select type (equation => space%equation)
            type is (real_linear_equation_t)
                equation%rhs = rhs
            type is (real_sylvester_equation_t)
                equation%rhs = rhs
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

end function krylov_set_real_space_rhs
