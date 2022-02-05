function krylov_get_space_last_gram_rcond(index) result(last_gram_rcond)

    use kinds, only: IK, RK
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    real(RK) :: last_gram_rcond

    if (index > krylov_get_num_spaces()) then
        last_gram_rcond = -1.0_RK
    end if

    associate (space => spaces(index)%space_p)
        last_gram_rcond = space%convergence%get_last_gram_rcond()
    end associate

end function krylov_get_space_last_gram_rcond
