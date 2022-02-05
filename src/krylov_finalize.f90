function krylov_finalize() result(error)

    use kinds, only: IK
    use errors, only: OK
    use krylov, only: config, spaces, krylov_get_num_spaces
    implicit none

    integer(IK) :: error

    integer(IK) :: index

    if (allocated(config)) deallocate (config)
    if (allocated(spaces)) then
        do index = 1_IK, krylov_get_num_spaces()
            deallocate (spaces(index)%space_p)
        end do
        deallocate (spaces)
    end if

    error = OK

end function krylov_finalize
