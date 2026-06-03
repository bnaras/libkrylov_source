function krylov_footer() result(error)

    ! R-package (r-pkg) edit: see krylov_header. The original wrote a footer to
    ! stdout; CRAN forbids output from compiled code, so this is a no-op that
    ! returns OK (the C API ckrylov_footer references it).

    use kinds, only: IK
    use errors, only: OK
    implicit none

    integer(IK) :: error

    error = OK

end function krylov_footer
