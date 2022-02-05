module blaswrapper

    use iso_fortran_env, only: real32, real64
    use kinds, only: RK, CK
    implicit none

    real(real32), external :: sdot, snrm2, scnrm2
    real(real64), external :: ddot, dnrm2, dznrm2
    complex(real32), external :: cdotc
    complex(real64), external :: zdotc
    external :: saxpy, daxpy, caxpy, zaxpy, sscal, dscal, cscal, zscal, &
        sgemv, dgemv, cgemv, zgemv, sgbmv, dgbmv, cgbmv, zgbmv, &
        ssbmv, dsbmv, chbmv, zhbmv, stbsv, dtbsv, ctbsv, ztbsv, &
        sgemm, dgemm, cgemm, zgemm, ssymm, dsymm, csymm, zsymm, &
        ssyrk, ssyr2k, dsyrk, dsyr2k, cherk, cher2k, zherk, zher2k

#ifdef USE_REAL32
    procedure(real(RK)), pointer :: real_dot => sdot, real_nrm2 => snrm2
    procedure(), pointer :: real_axpy => saxpy, real_scal => sscal, &
        real_gemv => sgemv, real_gbmv => sgbmv, &
        real_sbmv => ssbmv, real_tbsv => stbsv, &
        real_gemm => sgemm, real_symm => ssymm, &
        real_syrk => ssyrk, real_syr2k => ssyr2k

#elif defined USE_REAL64
    procedure(real(RK)), pointer :: real_dot => ddot, real_nrm2 => dnrm2
    procedure(), pointer :: real_axpy => daxpy, real_scal => dscal, &
        real_gemv => dgemv, real_gbmv => dgbmv, &
        real_sbmv => dsbmv, real_tbsv => dtbsv, &
        real_gemm => dgemm, real_symm => dsymm, &
        real_syrk => dsyrk, real_syr2k => dsyr2k
#endif

#ifdef USE_COMPLEX32
    procedure(real(RK)), pointer :: complex_nrm2 => scnrm2
    procedure(), pointer :: complex_axpy => caxpy, complex_scal => cscal, &
        complex_gemv => cgemv, complex_gbmv => cgbmv, &
        complex_hbmv => chbmv, complex_tbsv => ctbsv, &
        complex_gemm => cgemm, complex_symm => csymm, &
        complex_herk => cherk, complex_her2k => cher2k

#elif defined USE_COMPLEX64
    procedure(real(RK)), pointer ::complex_nrm2 => dznrm2
    procedure(), pointer :: complex_axpy => zaxpy, complex_scal => zscal, &
        complex_gemv => zgemv, complex_gbmv => zgbmv, &
        complex_hbmv => zhbmv, complex_tbsv => ztbsv, &
        complex_gemm => zgemm, complex_symm => zsymm, &
        complex_herk => zherk, complex_her2k => zher2k
#endif

#ifdef USE_GENERIC_DOTC
    procedure(complex(CK)), pointer :: complex_dotc => dotc
#elif defined USE_COMPLEX32
    procedure(complex(CK)), pointer :: complex_dotc => cdotc
#elif defined USE_COMPLEX64
    procedure(complex(CK)), pointer :: complex_dotc => zdotc
#endif

contains

    function dotc(n, x, incx, y, incy)

        use kinds, only: IK, CK
        implicit none

        integer(IK) :: n, incx, incy
        complex(CK) :: x(n), y(n)
        complex(CK) :: dotc

        integer(IK) :: i, ix, iy

        dotc = (0.0_CK, 0.0_CK)
        if (n == 0_IK) return

        if (incx == 1_IK .and. incy == 1_IK) then
            do i = 1_IK, n
                dotc = dotc + conjg(x(i)) * y(i)
            end do
        else
            ix = 1_IK
            iy = 1_IK
            if (incx < 0) ix = (-n + 1_IK) * incx + 1_IK
            if (incy < 0) iy = (-n + 1_IK) * incy + 1_IK
            do i = 1_IK, n
                dotc = dotc + conjg(x(ix)) * y(iy)
                ix = ix + incx
                iy = iy + incy
            end do
        end if

    end function dotc

end module blaswrapper
