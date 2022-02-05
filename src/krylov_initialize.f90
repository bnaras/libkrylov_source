function krylov_initialize() result(error)

    use kinds, only: IK
    use errors, only: OK
    use krylov, only: config, spaces, krylov_set_defaults
    implicit none

    integer(IK) :: error

    integer(IK) :: err

    if (allocated(config)) deallocate (config)
    if (allocated(spaces)) deallocate (spaces)

    allocate (config, spaces(0_IK))

    err = config%initialize()
    if (err /= OK) then
        error = err
        return
    end if

    err = krylov_set_defaults()
    if (err /= OK) then
        error = err
        return
    end if

    error = OK

end function krylov_initialize
