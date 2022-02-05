function krylov_get_complex_space_solutions(index, full_dim, solution_dim, solutions) result(error)

    use kinds, only: IK, CK
    use errors, only: OK, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INVALID_DIMENSION
    use krylov, only: spaces, complex_space_t, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index, full_dim, solution_dim
    complex(CK), intent(out) :: solutions(full_dim, solution_dim)
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
        type is (complex_space_t)
            solutions = space%equation%solutions
        class default
            error = INCOMPATIBLE_SPACE
            return
        end select
    end associate

    error = OK

end function krylov_get_complex_space_solutions
