function krylov_resize_complex_space_solutions(index, solution_dim) result(error)

    use kinds, only: IK
    use errors, only: OK, INVALID_DIMENSION, NO_SUCH_SPACE, INCOMPATIBLE_SPACE
    use krylov, only: spaces, complex_space_t, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index, solution_dim
    integer(IK) :: error

    integer(IK) :: err

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        return
    end if

    associate (space => spaces(index)%space_p)
        select type (space)
        type is (complex_space_t)
            if (solution_dim > space%full_dim) then
                error = INVALID_DIMENSION
                return
            end if

            if (solution_dim > space%basis_dim) then
                error = INVALID_DIMENSION
                return
            end if

            err = space%equation%resize_solutions(solution_dim)
            if (err /= OK) then
                error = err
                return
            end if

            space%solution_dim = solution_dim
        class default
            error = INCOMPATIBLE_SPACE
            return
        end select
    end associate

    error = OK

end function krylov_resize_complex_space_solutions
