function krylov_header() result(error)

    ! R-package (r-pkg) edit: the original implementation wrote a banner to
    ! stdout via write(*, ...). CRAN policy forbids output to stdout/stderr from
    ! compiled code, so the banner is removed here and rendered in R instead.
    ! The function is kept (the C API ckrylov_header references it) as a no-op
    ! that returns OK.

    use kinds, only: IK
    use errors, only: OK
    implicit none

    integer(IK) :: error

    error = OK

end function krylov_header
