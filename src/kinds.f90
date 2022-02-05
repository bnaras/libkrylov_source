module kinds

    use iso_fortran_env, only: real32, real64, real128, int32, int64
    implicit none

#ifdef USE_INT32
    integer, parameter :: IK = int32
#elif defined USE_INT64
    integer, parameter :: IK = int64
#else
    integer, parameter :: IK = int64
#endif

#ifdef USE_REAL32
    integer, parameter :: RK = real32
#elif defined USE_REAL64
    integer, parameter :: RK = real64
#elif defined USE_REAL128
    integer, parameter :: RK = real128
#else
    integer, parameter :: RK = real64
#endif

#ifdef USE_COMPLEX32
    integer, parameter :: CK = real32
#elif defined USE_COMPLEX64
    integer, parameter :: CK = real64
#elif defined USE_COMPLEX128
    integer, parameter :: CK = real128
#else
    integer, parameter :: CK = real64
#endif

end module kinds
