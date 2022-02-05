program test_set_defaults

    use kinds, only: IK
    use errors, only: OK, NO_OPTIONS
    use krylov, only: config, krylov_finalize, krylov_set_defaults
    implicit none

    integer(IK) :: error

    error = krylov_set_defaults()
    if (error /= NO_OPTIONS) stop 1

    allocate (config)

    error = config%initialize()
    if (error /= OK) stop 1

    error = krylov_set_defaults()
    if (error /= OK) stop 1

    if (config%find_enum('kind') /= OK) stop 1
    if (config%find_enum('structure') /= OK) stop 1
    if (config%find_enum('equation') /= OK) stop 1

    if (config%find_option('preconditioner') /= OK) stop 1
    if (config%find_enum('preconditioner') /= OK) stop 1
    if (config%get_enum_option('preconditioner') /= 'n') stop 1

    if (config%find_option('orthonormalizer') /= OK) stop 1
    if (config%find_enum('orthonormalizer') /= OK) stop 1
    if (config%get_enum_option('orthonormalizer') /= 'o') stop 1

    if (config%find_option('max_iterations') /= OK) stop 1
    if (config%get_integer_option('max_iterations') /= 50_IK) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_set_defaults
