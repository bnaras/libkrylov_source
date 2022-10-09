function krylov_get_version(version) result(error)

    use kinds, only: IK, AK
    use errors, only: OK
    use versions, only: krylov_version
    implicit none

    character(len=*, kind=AK), intent(out) :: version
    integer(IK) :: error

    version = krylov_version

    error = OK

end function krylov_get_version
