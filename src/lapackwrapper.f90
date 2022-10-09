module lapackwrapper

    use iso_fortran_env, only: real32, real64
    use kinds, only: RK, CK
    implicit none

    real(real32), external :: slansy, clanhe
    real(real64), external :: dlansy, zlanhe
    external :: sgesv, dgesv, cgesv, zgesv, ssysv, dsysv, chesv, zhesv, &
        strsm, dtrsm, ctrsm, ztrsm, ssyev, dsyev, cheev, zheev, &
        spotrf, dpotrf, cpotrf, zpotrf, spotri, dpotri, cpotri, zpotri, &
        spocon, dpocon, cpocon, zpocon, sgesvd, dgesvd, cgesvd, zgesvd, &
        sgeqrf, dgeqrf, cgeqrf, zgeqrf, sorgqr, dorgqr, cungqr, zungqr

#if (defined USE_REAL32 || USE_C_FLOAT)
    procedure(real(RK)), pointer :: real_lansy => slansy
    procedure(), pointer :: real_gesv => sgesv, real_sysv => ssysv, &
        real_trsm => strsm, real_syev => ssyev, &
        real_potrf => spotrf, real_potri => spotri, &
        real_pocon => spocon, real_gesvd => sgesvd, &
        real_geqrf => sgeqrf, real_orgqr => sorgqr
#elif (defined USE_REAL64 || USE_C_DOUBLE)
    procedure(real(RK)), pointer :: real_lansy => dlansy
    procedure(), pointer :: real_gesv => dgesv, real_sysv => dsysv, &
        real_trsm => dtrsm, real_syev => dsyev, &
        real_potrf => dpotrf, real_potri => dpotri, &
        real_pocon => dpocon, real_gesvd => dgesvd, &
        real_geqrf => dgeqrf, real_orgqr => dorgqr
#endif

#if (defined USE_COMPLEX32 || USE_COMPLEX_C_FLOAT)
    procedure(real(RK)), pointer :: complex_lanhe => clanhe
    procedure(), pointer :: complex_gesv => cgesv, complex_hesv => chesv, &
        complex_trsm => ctrsm, complex_heev => cheev, &
        complex_potrf => cpotrf, complex_potri => cpotri, &
        complex_pocon => cpocon, complex_gesvd => cgesvd, &
        complex_geqrf => cgeqrf, complex_ungqr => cungqr
#elif (defined USE_COMPLEX64 || USE_COMPLEX_C_DOUBLE)
    procedure(real(RK)), pointer :: complex_lanhe => zlanhe
    procedure(), pointer :: complex_gesv => zgesv, complex_hesv => zhesv, &
        complex_trsm => ztrsm, complex_heev => zheev, &
        complex_potrf => zpotrf, complex_potri => zpotri, &
        complex_pocon => zpocon, complex_gesvd => zgesvd, &
        complex_geqrf => zgeqrf, complex_ungqr => zungqr
#endif

end module lapackwrapper
