function krylov_convergence_get_last_gram_rcond(convergence) result(last_gram_rcond)

    use kinds, only: IK, RK
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(in) :: convergence
    real(RK) :: last_gram_rcond

    integer(IK) :: index

    index = convergence%get_num_iterations()

    if (index == 0_IK) then
        last_gram_rcond = -1.0_RK
        return
    end if

    last_gram_rcond = convergence%iterations(index)%get_gram_rcond()

end function krylov_convergence_get_last_gram_rcond
