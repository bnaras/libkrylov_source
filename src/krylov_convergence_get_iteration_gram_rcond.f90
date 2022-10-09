function krylov_convergence_get_iteration_gram_rcond(convergence, index) result(gram_rcond)

    use kinds, only: IK, RK
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(in) :: convergence
    integer(IK), intent(in) :: index
    real(RK) :: gram_rcond

    if (index > convergence%get_num_iterations()) then
        gram_rcond = -1.0_RK
        return
    end if

    gram_rcond = convergence%iterations(index)%get_gram_rcond()

end function krylov_convergence_get_iteration_gram_rcond