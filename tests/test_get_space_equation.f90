program test_get_space_equation

    use kinds, only: IK
    use errors, only: OK
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_get_space_equation
    implicit none

    integer(IK) :: error, index
    character(len=1) :: equation

    error = krylov_initialize()
    if (error /= OK) stop 1

    index = krylov_add_space('r', 's', 'e', 10_IK, 2_IK, 3_IK)
    equation = krylov_get_space_equation(index)
    if (equation /= 'e') stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_equation
