function krylov_iteration_get_lagrangian(iteration) result(lagrangian)

    use kinds, only: RK
    use krylov, only: iteration_t

    class(iteration_t), intent(in) :: iteration
    real(RK) :: lagrangian

    lagrangian = iteration%lagrangian

end function krylov_iteration_get_lagrangian
