function krylov_get_real_block_total_size() result(total_size)

    use kinds, only: IK
    use krylov, only: spaces, real_space_t, krylov_get_num_spaces
    implicit none

    integer(IK) :: total_size

    integer(IK) :: offset, index

    offset = 0_IK
    do index = 1_IK, krylov_get_num_spaces()
        select type (space => spaces(index)%space_p)
        type is (real_space_t)
            offset = offset + space%full_dim * space%new_dim
        end select
    end do
    total_size = offset

end function krylov_get_real_block_total_size
