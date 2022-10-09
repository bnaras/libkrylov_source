module kinds

    use iso_fortran_env, only: real32, real64, real128, int32, int64
    use iso_c_binding, only: c_int, c_long, c_long_long, c_size_t, c_float, &
                             c_double, c_long_double, c_bool, c_char
    implicit none

#ifdef USE_INT32
    integer, parameter :: IK = int32
#elif defined USE_INT64
    integer, parameter :: IK = int64
#elif defined USE_C_INT
    integer, parameter :: IK = c_int
#elif defined USE_C_LONG
    integer, parameter :: IK = c_long
#elif defined USE_C_LONG_LONG
    integer, parameter :: IK = c_long_long
#elif defined USE_C_SIZE_T
    integer, parameter :: IK = c_size_t
#else
    integer, parameter :: IK = int64
#endif

#ifdef USE_REAL32
    integer, parameter :: RK = real32
#elif defined USE_REAL64
    integer, parameter :: RK = real64
#elif defined USE_REAL128
    integer, parameter :: RK = real128
#elif defined USE_C_FLOAT
    integer, parameter :: RK = c_float
#elif defined USE_C_DOUBLE
    integer, parameter :: RK = c_double
#elif defined USE_C_LONG_DOUBLE
    integer, parameter :: RK = c_long_double
#else
    integer, parameter :: RK = real64
#endif

#ifdef USE_COMPLEX32
    integer, parameter :: CK = real32
#elif defined USE_COMPLEX64
    integer, parameter :: CK = real64
#elif defined USE_COMPLEX128
    integer, parameter :: CK = real128
#elif defined USE_COMPLEX_C_FLOAT
    integer, parameter :: CK = c_float
#elif defined USE_COMPLEX_C_DOUBLE
    integer, parameter :: CK = c_double
#elif defined USE_COMPLEX_C_LONG_DOUBLE
    integer, parameter :: CK = c_long_double
#else
    integer, parameter :: CK = real64
#endif

#ifdef USE_C_CHAR
    integer, parameter :: AK = c_char
#elif defined USE_CHARACTER_DEFAULT
    integer, parameter :: AK = selected_char_kind('default')
#else
    integer, parameter :: AK = selected_char_kind('default')
#endif

#ifdef USE_C_BOOL
    integer, parameter :: LK = c_bool
#elif defined USE_LOGICAL_DEFAULT
    integer, parameter :: LK = kind(.true.)
#else
    integer, parameter :: LK = kind(.true.)
#endif

end module kinds
