program test_get_space_structure

    use kinds, only: IK, AK
    use errors, only: OK
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, krylov_get_space_structure
    implicit none

    integer(IK) :: error, index
    character(len=1, kind=AK) :: structure

    error = krylov_initialize()
    if (error /= OK) stop 1

    index = krylov_add_space('r', 's', 'e', 10_IK, 2_IK, 3_IK)
    error = krylov_get_space_structure(index, structure)
    if (error /= OK) stop 1
    if (structure /= 's') stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_structure
