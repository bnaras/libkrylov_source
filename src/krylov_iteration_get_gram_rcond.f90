function krylov_iteration_get_gram_rcond(iteration) result(gram_rcond)

    use kinds, only: RK
    use krylov, only: iteration_t

    class(iteration_t), intent(in) :: iteration
    real(RK) :: gram_rcond

    gram_rcond = iteration%gram_rcond

end function krylov_iteration_get_gram_rcond