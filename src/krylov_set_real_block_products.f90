function krylov_set_real_block_products(num_spaces, total_size, full_dims, subset_dims, offsets, products) result(error)
    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: spaces, real_space_t, krylov_get_num_spaces, krylov_set_real_space_subset_products
    implicit none

    integer(IK), intent(in) :: num_spaces, total_size, full_dims(num_spaces), subset_dims(num_spaces), &
                               offsets(num_spaces)
    real(RK), intent(in) :: products(total_size)
    integer(IK) :: error

    integer(IK) :: index, err, length, skip_dim, subset_dim, offset

    if (num_spaces /= krylov_get_num_spaces()) then
        error = INVALID_DIMENSION
        return
    end if

    do index = 1_IK, num_spaces
        select type (space => spaces(index)%space_p)
        type is (real_space_t)
            if (full_dims(index) /= space%full_dim) then
                error = INVALID_DIMENSION
                return
            end if

            if (subset_dims(index) > space%basis_dim) then
                error = INVALID_DIMENSION
                return
            end if

            length = full_dims(index) * subset_dims(index)
            subset_dim = subset_dims(index)
            skip_dim = space%basis_dim - subset_dim
            offset = offsets(index)
            err = krylov_set_real_space_subset_products(index, space%full_dim, skip_dim, subset_dim, &
                                                        products(offset + 1_IK:offset + length))
            if (err /= OK) then
                error = err
                return
            end if
        end select
    end do

    error = OK

end function krylov_set_real_block_products
