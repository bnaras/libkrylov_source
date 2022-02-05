program test_complex_eigenvalue_equation_get_lagrangian

    use kinds, only: IK, RK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_num
    use krylov, only: complex_eigenvalue_equation_t
    implicit none

    type(complex_eigenvalue_equation_t) :: equation
    type(config_t) :: config
    real(RK) ::   eigenvalues(2_IK), lagrangian
    integer(IK) :: error

    eigenvalues = (/1.0_RK, 2.0_RK/)

    error = config%initialize()
    if (error /= OK) stop 1

    error = equation%initialize(3_IK, 2_IK, 2_IK, config)
    if (error /= OK) stop 1

    equation%eigenvalues = eigenvalues

    lagrangian = equation%get_lagrangian()
    if (lagrangian /= near_real_num(3.0_RK)) stop 1

end program test_complex_eigenvalue_equation_get_lagrangian
