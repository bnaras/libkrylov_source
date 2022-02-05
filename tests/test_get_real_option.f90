program test_get_real_option

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_OPTION
    use krylov, only: krylov_initialize, krylov_finalize, krylov_get_real_option, krylov_set_real_option
    implicit none

    integer(IK) :: error

    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_real_option('real', 1.0_RK)
    if (error /= OK) stop 1

    if (krylov_get_real_option('real') /= 1.0_RK) stop 1

    if (krylov_get_real_option('missing') /= -huge(1.0_RK)) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_real_option
