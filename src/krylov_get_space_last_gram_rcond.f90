function krylov_get_space_last_gram_rcond(index) result(last_gram_rcond)

    use kinds, only: IK, RK
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    real(RK) :: last_gram_rcond

    if (index > krylov_get_num_spaces()) then
        last_gram_rcond = -1.0_RK
        return
    end if

    last_gram_rcond = spaces(index)%space_p%convergence%get_last_gram_rcond()

end function krylov_get_space_last_gram_rcond
