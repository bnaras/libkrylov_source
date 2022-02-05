function krylov_set_complex_space_subset_products(index, full_dim, skip_dim, subset_dim, products) result(error)

    use kinds, only: IK, CK
    use errors, only: OK, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INVALID_DIMENSION
    use krylov, only: spaces, complex_space_t, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index, full_dim, skip_dim, subset_dim
    complex(CK), intent(in) :: products(full_dim, subset_dim)
    integer(IK) :: error

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        return
    end if

    associate (space => spaces(index)%space_p)
        select type (space)
        type is (complex_space_t)
            if (full_dim /= space%full_dim) then
                error = INVALID_DIMENSION
                return
            end if

            if (space%basis_dim < subset_dim + skip_dim) then
                error = INVALID_DIMENSION
                return
            end if

            space%equation%products(1_IK:space%full_dim, skip_dim + 1_IK:skip_dim + subset_dim) = products
        class default
            error = INCOMPATIBLE_SPACE
            return
        end select
    end associate

    error = OK

end function krylov_set_complex_space_subset_products
