program test_get_logical_option

    use kinds, only: IK
    use errors, only: OK, NO_SUCH_OPTION
    use krylov, only: krylov_initialize, krylov_finalize, krylov_get_logical_option, krylov_set_logical_option
    implicit none

    integer(IK) :: error

    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_logical_option('logical', .true.)
    if (error /= OK) stop 1

    if (krylov_get_logical_option('logical') .neqv. .true.) stop 1

    if (krylov_get_logical_option('missing') .neqv. .false.) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_logical_option
