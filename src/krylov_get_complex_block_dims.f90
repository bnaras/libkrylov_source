function krylov_get_complex_block_dims(num_spaces, full_dims, subset_dims, offsets, total_size) result(error)

    use kinds, only: IK
    use errors, only: OK, INVALID_DIMENSION
    use krylov, only: spaces, complex_space_t, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: num_spaces
    integer(IK), intent(out) :: full_dims(num_spaces), subset_dims(num_spaces), &
                                offsets(num_spaces), total_size
    integer(IK) :: error

    integer(IK) :: index, offset

    if (num_spaces /= krylov_get_num_spaces()) then
        error = INVALID_DIMENSION
        return
    end if

    offset = 0_IK
    do index = 1_IK, num_spaces
        select type (space => spaces(index)%space_p)
        type is (complex_space_t)
            full_dims(index) = space%full_dim
            subset_dims(index) = space%new_dim
            offsets(index) = offset
            offset = offset + space%full_dim * space%new_dim
        class default
            full_dims(index) = 0_IK
            subset_dims(index) = 0_IK
            offsets(index) = 0_IK
        end select
    end do
    total_size = offset

    error = OK

end function krylov_get_complex_block_dims
