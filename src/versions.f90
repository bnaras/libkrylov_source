module versions

    use kinds, only: AK
    implicit none

    character(len=80, kind=AK) :: krylov_version = LIBKRYLOV_VERSION
    character(len=80, kind=AK) :: krylov_compiled_dt = LIBKRYLOV_COMPILED_DT

end module versions
