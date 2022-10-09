function krylov_get_space_iteration_gram_rcond(index, iter) result(gram_rcond)

    use kinds, only: IK, RK
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index, iter
    real(RK) :: gram_rcond

    if (index > krylov_get_num_spaces()) then
        gram_rcond = -1.0_RK
        return
    end if

    gram_rcond = spaces(index)%space_p%convergence%get_iteration_gram_rcond(iter)

end function krylov_get_space_iteration_gram_rcond
