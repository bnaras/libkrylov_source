function krylov_get_complex_block_convergence() result(status)

    use kinds, only: IK
    use errors, only: OK, NO_ITERATIONS, NOT_CONVERGED, NO_BASIS_UPDATE, MAX_DIM_REACHED
    use krylov, only: spaces, complex_space_t, krylov_get_num_spaces
    implicit none

    integer(IK) :: status

    integer(IK) :: index, num_spaces, stat

    num_spaces = krylov_get_num_spaces()

    status = OK

    do index = 1_IK, num_spaces
        select type (space => spaces(index)%space_p)
        type is (complex_space_t)
            stat = space%convergence%get_convergence()
            if (stat == NO_ITERATIONS .or. stat == NOT_CONVERGED &
                .or. stat == NO_BASIS_UPDATE .or. stat == MAX_DIM_REACHED) then
                status = NOT_CONVERGED
            else if (stat /= OK) then
                status = stat
                return
            end if
        end select
    end do

end function krylov_get_complex_block_convergence
