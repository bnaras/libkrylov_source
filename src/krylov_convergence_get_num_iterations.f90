function krylov_convergence_get_num_iterations(convergence) result(num_iterations)

    use kinds, only: IK
    use krylov, only: convergence_t
    implicit none

    class(convergence_t), intent(in) :: convergence
    integer(IK) :: num_iterations

    num_iterations = size(convergence%iterations, kind=IK)

end function krylov_convergence_get_num_iterations
