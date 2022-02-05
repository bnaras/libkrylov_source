function krylov_resize_real_space_vectors(index, basis_dim) result(error)

    use kinds, only: IK
    use errors, only: OK, INVALID_DIMENSION, NO_SUCH_SPACE, INCOMPATIBLE_SPACE
    use krylov, only: spaces, real_space_t, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index, basis_dim
    integer(IK) :: error

    integer(IK) :: err

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        return
    end if

    associate (space => spaces(index)%space_p)
        select type (space)
        type is (real_space_t)
            if (basis_dim > space%full_dim) then
                error = INVALID_DIMENSION
                return
            end if

            err = space%equation%resize_vectors(basis_dim)
            if (err /= OK) then
                error = err
                return
            end if

            space%basis_dim = basis_dim
        class default
            error = INCOMPATIBLE_SPACE
            return
        end select
    end associate

    error = OK

end function krylov_resize_real_space_vectors
