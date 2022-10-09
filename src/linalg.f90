module linalg

    use iso_fortran_env, only: real32, real64
    use kinds, only: RK, CK, AK
    implicit none

    character(len=1, kind=AK), parameter :: uplo = 'u'

contains

    function real_ge_subset(a, indices, m, n, n_indices) result(error)

        use kinds, only: IK, RK
        use errors, only: OK, INVALID_DIMENSION
        implicit none

        integer(IK), intent(in) :: m, n, n_indices
        real(RK), intent(inout) :: a(m, n)
        integer(IK), intent(in) :: indices(n_indices)
        integer(IK) :: error

        integer(IK) :: i, index

        do i = 1_IK, n_indices
            index = indices(i)
            if (index > n) then
                error = INVALID_DIMENSION
                return
            end if
            if (index > i) a(:, i) = a(:, index)
        end do

        error = OK

    end function real_ge_subset

    function complex_ge_subset(a, indices, m, n, n_indices) result(error)

        use kinds, only: IK, CK
        use errors, only: OK, INVALID_DIMENSION
        implicit none

        integer(IK), intent(in) :: m, n, n_indices
        complex(CK), intent(inout) :: a(m, n)
        integer(IK), intent(in) :: indices(n_indices)
        integer(IK) :: error

        integer(IK) :: i, index

        do i = 1_IK, n_indices
            index = indices(i)
            if (index > n) then
                error = INVALID_DIMENSION
                return
            end if
            if (index > i) a(:, i) = a(:, index)
        end do

        error = OK

    end function complex_ge_subset

    function real_ge_block_orthonormalize(a, q, m, n, n_q, thr_zero, n_out) result(error)

        ! This function orthonormalizes the input vectors in place against each other
        ! and against reference vectors q
        use kinds, only: IK, RK
        use errors, only: OK
        use blaswrapper, only: real_nrm2, real_dot, real_gemm, real_scal, real_axpy
        implicit none

        integer(IK), intent(in) :: m, n, n_q
        real(RK), intent(inout) :: a(m, n)
        real(RK), intent(in) :: q(m, n_q), thr_zero
        integer(IK), intent(out) :: n_out
        integer(IK) :: error

        integer(IK) :: i, j, iter
        real(RK) :: s1, s2
        real(RK), allocatable :: s(:, :), q1(:)

        ! q is assumed to be orthonormal
        ! Uses two-pass block Gram-Schmidt (B2GS) algorithm to orthogonalize against q
        ! Jalby, Philippe, SIAM J. Sci. Stat. Comput., 1991, 12, 1058.
        ! Uses modified Gram-Schmidt (MGS) algorithm for intra-block orthonormalization
        integer(IK), parameter :: num_iter = 2_IK

        ! Orthogonalize a against q using B2GS
        if (n_q > 0_IK) then
            allocate (s(n_q, n))
            do iter = 1_IK, num_iter
                call real_gemm('t', 'n', n_q, n, m, 1.0_RK, q, m, a, m, 0.0_RK, s, n_q)
                call real_gemm('n', 'n', m, n, n_q, -1.0_RK, q, m, s, n_q, 1.0_RK, a, m)
            end do
            deallocate (s)
        end if

        ! Orthonormalize a using MGS
        allocate (q1(m))
        n_out = 0_IK
        do i = 1_IK, n
            q1 = a(1_IK:m, i)
            s1 = real_nrm2(m, q1, 1_IK)

            if (s1 >= thr_zero) then
                call real_scal(m, 1.0_RK/s1, q1, 1_IK)

                do j = i + 1_IK, n
                    s2 = -real_dot(m, q1, 1_IK, a(1_IK, j), 1_IK)
                    call real_axpy(m, s2, q1, 1_IK, a(1_IK, j), 1_IK)
                end do

                n_out = n_out + 1_IK
                a(1_IK:m, n_out) = q1
            end if
        end do
        deallocate (q1)

        error = OK

    end function real_ge_block_orthonormalize

    function complex_ge_block_orthonormalize(a, q, m, n, n_q, thr_zero, n_out) result(error)

        ! This function orthonormalizes the input vectors in place against each other
        ! and against reference vectors q
        use kinds, only: IK, RK, CK
        use errors, only: OK
        use blaswrapper, only: complex_nrm2, complex_dotc, complex_gemm, complex_scal, complex_axpy
        implicit none

        integer(IK), intent(in) :: m, n, n_q
        complex(CK), intent(inout) :: a(m, n)
        complex(CK), intent(in) :: q(m, n_q)
        real(RK), intent(in) :: thr_zero
        integer(IK), intent(out) :: n_out
        integer(IK) :: error

        integer(IK) :: i, j, iter
        real(RK) :: s1
        complex(CK) :: s2
        complex(CK), allocatable :: s(:, :), q1(:)

        ! q is assumed to be orthonormal
        ! Uses two-pass block Gram-Schmidt (B2GS) algorithm to orthogonalize against q
        ! Jalby, Philippe, SIAM J. Sci. Stat. Comput., 1991, 12, 1058.
        ! Uses modified Gram-Schmidt (MGS) algorithm for intra-block orthonormalization
        integer(IK), parameter :: num_iter = 2_IK

        ! Orthogonalize a against q using B2GS
        if (n_q > 0_IK) then
            allocate (s(n_q, n))
            do iter = 1_IK, num_iter
                call complex_gemm('c', 'n', n_q, n, m, (1.0_CK, 0.0_CK), q, m, a, m, (0.0_CK, 0.0_CK), s, n_q)
                call complex_gemm('n', 'n', m, n, n_q, (-1.0_CK, 0.0_CK), q, m, s, n_q, (1.0_CK, 0.0_CK), a, m)
            end do
            deallocate (s)
        end if

        ! Orthonormalize a using MGS
        allocate (q1(m))
        n_out = 0_IK
        do i = 1_IK, n
            q1 = a(1_IK:m, i)
            s1 = complex_nrm2(m, q1, 1_IK)

            if (s1 >= thr_zero) then
                call complex_scal(m, cmplx(1.0_RK/s1, kind=CK), q1, 1_IK)

                do j = i + 1_IK, n
                    s2 = -complex_dotc(m, q1, 1_IK, a(1_IK, j), 1_IK)
                    call complex_axpy(m, s2, q1, 1_IK, a(1_IK, j), 1_IK)
                end do

                n_out = n_out + 1_IK
                a(1_IK:m, n_out) = q1
            end if
        end do
        deallocate (q1)

        error = OK

    end function complex_ge_block_orthonormalize

    function real_ge_orthonormalize(a, m, n, thr_zero, n_out) result(error)

        ! This function orthonormalizes the input vectors in place
        ! Implemented as a special case of the real_ge_block_orthonormalize function
        ! If the output vectors should not be renormalized, use real_ge_orthogonalize
        use kinds, only: IK, RK
        use errors, only: OK
        implicit none

        integer(IK), intent(in) :: m, n
        real(RK), intent(inout) :: a(m, n)
        real(RK), intent(in) :: thr_zero
        integer(IK), intent(out) :: n_out
        integer(IK) :: error

        real(RK) :: dum(1_IK, 1_IK)

        error = real_ge_block_orthonormalize(a, dum, m, n, 0_IK, thr_zero, n_out)

    end function real_ge_orthonormalize

    function complex_ge_orthonormalize(a, m, n, thr_zero, n_out) result(error)

        ! This function orthonormalizes the input vectors in place
        ! Implemented as a special case of the complex_ge_block_orthonormalize function
        ! If the output vectors should not be renormalized, use complex_ge_orthogonalize
        use kinds, only: IK, RK, CK
        use errors, only: OK
        implicit none

        integer(IK), intent(in) :: m, n
        complex(CK), intent(inout) :: a(m, n)
        real(RK), intent(in) :: thr_zero
        integer(IK), intent(out) :: n_out
        integer(IK) :: error

        complex(RK) :: dum(1_IK, 1_IK)

        error = complex_ge_block_orthonormalize(a, dum, m, n, 0_IK, thr_zero, n_out)

    end function complex_ge_orthonormalize

    function real_ge_orthogonalize(a, m, n, thr_zero, n_out) result(error)

        ! Orthogonalize vectors in place but do not renormalize
        ! If renormalization is desired, use real_ge_orthonormalize
        use kinds, only: IK, RK
        use errors, only: OK, LINEAR_ALGEBRA_ERROR
        use blaswrapper, only: real_scal
        use lapackwrapper, only: real_gesvd
        implicit none

        integer(IK), intent(in) :: m, n
        real(RK), intent(inout) :: a(m, n)
        real(RK), intent(in) :: thr_zero
        integer(IK), intent(out) :: n_out
        integer(IK) :: error

        integer(IK) :: info, lwork, vec
        real(RK) :: dum(1_IK), work1(1_IK)
        real(RK), allocatable :: s(:), q1(:), work(:)

        allocate (s(n), q1(m))

        ! Compute requirement for SVD (returned on work1(1))
        info = 0_IK
        call real_gesvd('o', 'n', m, n, a, m, s, dum, 1_IK, dum, 1_IK, work1, -1_IK, info)
        lwork = int(work1(1_IK), kind=IK)
        if (info /= 0_IK .or. lwork <= 0_IK) then
            deallocate (s)
            error = LINEAR_ALGEBRA_ERROR
            return
        end if

        ! Overwrite matrix a with left singular vectors u
        allocate (work(lwork))
        call real_gesvd('o', 'n', m, n, a, m, s, dum, 1_IK, dum, 1_IK, work, lwork, info)
        if (info /= 0_IK) then
            deallocate (s, work)
            error = LINEAR_ALGEBRA_ERROR
            return
        end if

        ! Rescale singular vectors by singular values
        n_out = 0_IK
        do vec = 1_IK, n
            q1 = a(1_IK:m, vec)

            if (s(vec) >= thr_zero) then
                call real_scal(m, s(vec), q1, 1_IK)

                n_out = n_out + 1_IK
                a(1_IK:m, n_out) = q1
            end if
        end do

        deallocate (s, q1, work)

        error = OK

    end function real_ge_orthogonalize

    function complex_ge_orthogonalize(a, m, n, thr_zero, n_out) result(error)

        ! Orthogonalize vectors in place but do not renormalize
        ! If renormalization is desired, use complex_ge_orthonormalize
        use kinds, only: IK, RK, CK
        use errors, only: OK, LINEAR_ALGEBRA_ERROR
        use blaswrapper, only: complex_scal
        use lapackwrapper, only: complex_gesvd
        implicit none

        integer(IK), intent(in) :: m, n
        complex(CK), intent(inout) :: a(m, n)
        real(RK), intent(in) :: thr_zero
        integer(IK), intent(out) :: n_out
        integer(IK) :: error

        integer(IK) :: info, lwork, vec
        complex(CK) :: dum(1_IK), work1(1_IK)
        real(RK), allocatable :: s(:), rwork(:)
        complex(CK), allocatable :: q1(:), work(:)

        allocate (s(n), q1(m), rwork(5_IK*m))

        ! Compute requirement for SVD (returned on work1(1))
        info = 0_IK
        call complex_gesvd('o', 'n', m, n, a, m, s, dum, 1_IK, dum, 1_IK, work1, -1_IK, rwork, info)
        if (info /= 0_IK) then
            deallocate (s, q1, rwork)
            error = LINEAR_ALGEBRA_ERROR
            return
        end if

        ! Overwrite matrix a with left singular vectors u
        lwork = int(work1(1_IK), kind=IK)
        allocate (work(lwork))
        call complex_gesvd('o', 'n', m, n, a, m, s, dum, 1_IK, dum, 1_IK, work, lwork, rwork, info)
        if (info /= 0_IK) then
            deallocate (s, q1, work, rwork)
            error = LINEAR_ALGEBRA_ERROR
            return
        end if

        ! Rescale singular vectors by singular values
        n_out = 0_IK
        do vec = 1_IK, n
            q1 = a(1_IK:m, vec)

            if (s(vec) >= thr_zero) then
                call complex_scal(m, cmplx(s(vec), kind=CK), q1, 1_IK)

                n_out = n_out + 1_IK
                a(1_IK:m, n_out) = q1
            end if
        end do

        deallocate (s, q1, work, rwork)

        error = OK

    end function complex_ge_orthogonalize

    function real_sy_eigenvalues(a, n, eig) result(error)

        use kinds, only: IK, RK
        use errors, only: OK, LINEAR_ALGEBRA_ERROR
        use lapackwrapper, only: real_syev
        implicit none

        integer(IK), intent(in) :: n
        real(RK), intent(in) :: a(n, n)
        real(RK), intent(out) :: eig(n)
        integer(IK) :: error

        real(RK), allocatable :: tmp(:, :), work(:)
        integer(IK) :: info, lwork
        real(RK) :: work1(1_IK)

        ! Compute space requirement for diagonalization (returned on work1(1))
        info = 0_IK
        call real_syev('n', uplo, n, a, n, eig, work1, -1_IK, info)
        lwork = int(work1(1_IK), kind=IK)
        if (info /= 0_IK .or. lwork <= 0_IK) then
            error = LINEAR_ALGEBRA_ERROR
            return
        end if

        ! Copy matrix to temporary array
        ! Compute eigenvalues, tmp is destroyed
        allocate (tmp(n, n), work(lwork))
        tmp = a
        call real_syev('n', uplo, n, tmp, n, eig, work, lwork, info)
        if (info /= 0_IK) then
            error = LINEAR_ALGEBRA_ERROR
            deallocate (tmp, work)
            return
        end if
        deallocate (tmp, work)

        error = OK

    end function real_sy_eigenvalues

    function complex_he_eigenvalues(a, n, eig) result(error)

        use kinds, only: IK, RK, CK
        use errors, only: OK, LINEAR_ALGEBRA_ERROR
        use lapackwrapper, only: complex_heev
        implicit none

        integer(IK), intent(in) :: n
        complex(CK), intent(in) :: a(n, n)
        real(RK), intent(out) :: eig(n)
        integer(IK) :: error

        complex(CK), allocatable :: work(:)
        real(RK), allocatable :: rwork(:)
        integer(IK) :: info, lwork
        complex(CK) :: work1(1_IK)

        ! Compute space requirement for diagonalization (returned on work1(1))
        info = 0_IK
        allocate (rwork(3_IK*n - 2_IK))
        call complex_heev('n', uplo, n, a, n, eig, work1, -1_IK, rwork, info)
        lwork = int(work1(1_IK), kind=IK)
        if (info /= 0_IK .or. lwork <= 0_IK) then
            error = LINEAR_ALGEBRA_ERROR
            return
        end if

        ! Compute eigenvalues, matrix is unchanged
        allocate (work(lwork))
        call complex_heev('n', uplo, n, a, n, eig, work, lwork, rwork, info)
        if (info /= 0_IK) then
            error = LINEAR_ALGEBRA_ERROR
            deallocate (work, rwork)
            return
        end if
        deallocate (work, rwork)

        error = OK

    end function complex_he_eigenvalues

    function real_sy_diagonalize(a, n, eig, eigv) result(error)

        use kinds, only: IK, RK
        use errors, only: OK, LINEAR_ALGEBRA_ERROR
        use lapackwrapper, only: real_syev
        implicit none

        integer(IK), intent(in) :: n
        real(RK), intent(in) :: a(n, n)
        real(RK), intent(out) :: eig(n), eigv(n, n)
        integer(IK) :: error

        real(RK), allocatable :: work(:)
        integer(IK) :: info, lwork
        real(RK) :: work1(1_IK)

        ! Compute space requirement for diagonalization (returned on work1)
        info = 0_IK
        call real_syev('v', uplo, n, a, n, eig, work1, -1_IK, info)
        lwork = int(work1(1_IK), IK)
        if (info /= 0_IK .or. lwork <= 0_IK) then
            error = LINEAR_ALGEBRA_ERROR
            return
        end if

        ! Diagonalize in place
        allocate (work(lwork))
        eigv = a
        call real_syev('v', uplo, n, eigv, n, eig, work, lwork, info)
        if (info /= 0_IK) then
            error = LINEAR_ALGEBRA_ERROR
            deallocate (work)
            return
        end if
        deallocate (work)

        error = OK

    end function real_sy_diagonalize

    function complex_he_diagonalize(a, n, eig, eigv) result(error)

        use kinds, only: IK, RK, CK
        use errors, only: OK, LINEAR_ALGEBRA_ERROR
        use lapackwrapper, only: complex_heev
        implicit none

        integer(IK), intent(in) :: n
        complex(CK), intent(in) :: a(n, n)
        real(RK), intent(out) :: eig(n)
        complex(CK), intent(out) :: eigv(n, n)
        integer(IK) :: error

        complex(CK), allocatable :: work(:)
        real(RK), allocatable :: rwork(:)
        integer(IK) :: info, lwork
        complex(CK) :: work1(1_IK)

        ! Compute space requirement for diagonalization (returned on work1(1))
        info = 0_IK
        allocate (rwork(3_IK*n - 2_IK))
        call complex_heev('v', uplo, n, a, n, eig, work1, -1_IK, rwork, info)
        lwork = int(work1(1_IK), IK)
        if (info /= 0_IK .or. lwork <= 0_IK) then
            error = LINEAR_ALGEBRA_ERROR
            return
        end if

        ! Diagonalize in place
        allocate (work(lwork))
        eigv = a
        call complex_heev('v', uplo, n, eigv, n, eig, work, lwork, rwork, info)
        if (info /= 0_IK) then
            error = LINEAR_ALGEBRA_ERROR
            deallocate (work, rwork)
            return
        end if
        deallocate (work, rwork)

        error = OK

    end function complex_he_diagonalize

    function real_ge_frobenius_norm(a, m, n) result(norm)

        use kinds, only: IK, RK
        use blaswrapper, only: real_nrm2
        implicit none

        integer(IK), intent(in) :: m, n
        real(RK), intent(in) :: a(m, n)
        real(RK) :: norm

        norm = real_nrm2(m*n, a, 1_IK)

    end function real_ge_frobenius_norm

    function complex_ge_frobenius_norm(a, m, n) result(norm)

        use kinds, only: IK, RK, CK
        use blaswrapper, only: complex_nrm2
        implicit none

        integer(IK), intent(in) :: m, n
        complex(CK), intent(in) :: a(m, n)
        real(RK) :: norm

        norm = complex_nrm2(m*n, a, 1_IK)

    end function complex_ge_frobenius_norm

    function real_sy_frobenius_norm(a, m) result(norm)

        use kinds, only: IK, RK
        use lapackwrapper, only: real_lansy
        implicit none

        integer(IK), intent(in) :: m
        real(RK), intent(in) :: a(m, m)
        real(RK) :: norm

        real(RK), allocatable :: work(:)

        allocate (work(m))
        norm = real_lansy('f', uplo, m, a, m, work)
        deallocate (work)

    end function real_sy_frobenius_norm

    function complex_he_frobenius_norm(a, m) result(norm)

        use kinds, only: IK, RK, CK
        use lapackwrapper, only: complex_lanhe
        implicit none

        integer(IK), intent(in) :: m
        complex(CK), intent(in) :: a(m, m)
        real(RK) :: norm

        real(RK), allocatable :: work(:)

        allocate (work(m))
        norm = complex_lanhe('f', uplo, m, a, m, work)
        deallocate (work)

    end function complex_he_frobenius_norm

    function real_sy_one_norm(a, m) result(norm)

        use kinds, only: IK, RK
        use lapackwrapper, only: real_lansy
        implicit none

        integer(IK), intent(in) :: m
        real(RK), intent(in) :: a(m)
        real(RK) :: norm

        real(RK), allocatable :: work(:)

        allocate (work(m))
        norm = real_lansy('o', uplo, m, a, m, work)
        deallocate (work)

    end function real_sy_one_norm

    function complex_he_one_norm(a, m) result(norm)

        use kinds, only: IK, RK, CK
        use lapackwrapper, only: complex_lanhe
        implicit none

        integer(IK), intent(in) :: m
        complex(CK), intent(in) :: a(m, m)
        real(RK) :: norm

        real(RK), allocatable :: work(:)

        allocate (work(m))
        norm = complex_lanhe('o', uplo, m, a, m, work)
        deallocate (work)

    end function complex_he_one_norm

    function real_sy_spectral_norm(a, m) result(norm)

        use kinds, only: IK, RK
        use errors, only: OK
        implicit none

        integer(IK), intent(in) :: m
        real(RK), intent(in) :: a(m, m)
        real(RK) :: norm

        real(RK), allocatable :: eig(:)
        integer(IK) :: err

        allocate (eig(m))
        err = real_sy_eigenvalues(a, m, eig)
        if (err /= OK) then
            deallocate (eig)
            norm = -1.0_RK
            return
        end if

        norm = abs(eig(m))
        deallocate (eig)

    end function real_sy_spectral_norm

    function complex_he_spectral_norm(a, m) result(norm)

        use kinds, only: IK, RK, CK
        use errors, only: OK
        implicit none

        integer(IK), intent(in) :: m
        complex(CK), intent(in) :: a(m, m)
        real(RK) :: norm

        real(RK), allocatable :: eig(:)
        integer(IK) :: err

        allocate (eig(m))
        err = complex_he_eigenvalues(a, m, eig)
        if (err /= OK) then
            deallocate (eig)
            norm = -1.0_RK
            return
        end if

        norm = abs(eig(m))
        deallocate (eig)

    end function complex_he_spectral_norm

    function real_sy_rcond_one_norm(a, m) result(rcond)

        use kinds, only: IK, RK
        use lapackwrapper, only: real_potrf, real_pocon
        implicit none

        integer(IK), intent(in) :: m
        real(RK), intent(in) :: a(m, m)
        real(RK) :: rcond

        real(RK), allocatable :: chol(:, :), work(:)
        integer(IK), allocatable :: iwork(:)
        real(RK) :: norm
        integer(IK) :: info

        ! Get 1-norm of a
        norm = real_sy_one_norm(a, m)

        ! Compute Cholesky factorization of a in place
        allocate (chol(m, m))
        chol = a
        info = 0_IK
        call real_potrf(uplo, m, chol, m, info)
        if (info /= 0_IK) then
            deallocate (chol)
            rcond = -1.0_RK
            return
        end if

        ! Compute inverse 1-norm condition number
        allocate (work(3_IK*m), iwork(m))
        info = 0_IK
        call real_pocon(uplo, m, chol, m, norm, rcond, work, iwork, info)
        if (info /= 0_IK) then
            deallocate (chol, work, iwork)
            rcond = -1.0_RK
            return
        end if

        deallocate (chol, work, iwork)

    end function real_sy_rcond_one_norm

    function complex_he_rcond_one_norm(a, m) result(rcond)

        use kinds, only: IK, RK, CK
        use lapackwrapper, only: complex_potrf, complex_pocon
        implicit none

        integer(IK), intent(in) :: m
        complex(CK), intent(in) :: a(m, m)
        real(RK) :: rcond

        complex(CK), allocatable :: chol(:, :), work(:)
        real(RK), allocatable :: rwork(:)
        real(RK) :: norm
        integer(IK) :: info

        ! Get 1-norm of a
        norm = complex_he_one_norm(a, m)

        ! Compute Cholesky factorization of a in place
        allocate (chol(m, m))
        chol = a
        info = 0_IK
        call complex_potrf(uplo, m, chol, m, info)
        if (info /= 0_IK) then
            deallocate (chol)
            rcond = -1.0_RK
            return
        end if

        ! Compute inverse 1-norm condition number
        info = 0_IK
        allocate (work(2_IK*m), rwork(m))
        call complex_pocon(uplo, m, chol, m, norm, rcond, work, rwork, info)
        if (info /= 0_IK) then
            deallocate (chol, work, rwork)
            rcond = -1.0_RK
            return
        end if

        deallocate (chol, work, rwork)

    end function complex_he_rcond_one_norm

    function real_sy_rcond_spectral_norm(a, m) result(rcond)

        use kinds, only: IK, RK
        use errors, only: OK
        implicit none

        integer(IK), intent(in) :: m
        real(RK), intent(in) :: a(m, m)
        real(RK) :: rcond

        real(RK), allocatable :: eig(:)
        integer(IK) :: err

        allocate (eig(m))
        err = real_sy_eigenvalues(a, m, eig)
        if (err /= OK) then
            deallocate (eig)
            rcond = -1.0_RK
            return
        end if

        rcond = abs(eig(1_IK))/abs(eig(m))
        deallocate (eig)

    end function real_sy_rcond_spectral_norm

    function complex_he_rcond_spectral_norm(a, m) result(rcond)

        use kinds, only: IK, RK, CK
        use errors, only: OK
        implicit none

        integer(IK), intent(in) :: m
        complex(CK), intent(in) :: a(m, m)
        real(RK) :: rcond

        real(RK), allocatable :: eig(:)
        integer(IK) :: err

        allocate (eig(m))
        err = complex_he_eigenvalues(a, m, eig)
        if (err /= OK) then
            deallocate (eig)
            rcond = -1.0_RK
            return
        end if

        rcond = abs(eig(1_IK))/abs(eig(m))
        deallocate (eig)

    end function complex_he_rcond_spectral_norm

    function real_sy_diag_scale(a, d, n) result(error)

        use kinds, only: IK, RK
        use errors, only: OK
        use blaswrapper, only: real_scal
        implicit none

        integer(IK), intent(in) :: n
        real(RK), intent(inout) :: a(n, n)
        real(RK), intent(in) :: d(n)
        integer(IK) :: error

        integer(IK) :: i, j
        real(RK), allocatable :: d1(:)

        allocate (d1(n))

        d1 = 1.0_RK/sqrt(d)

        do j = 1_IK, n
            do i = 1_IK, n
                a(i, j) = a(i, j)*d1(i)
            end do
            call real_scal(n, d1(j), a(1_IK, j), 1_IK)
        end do

        deallocate (d1)

        error = OK

    end function real_sy_diag_scale

    function complex_he_diag_scale(a, d, n) result(error)

        use kinds, only: IK, RK, CK
        use errors, only: OK
        use blaswrapper, only: complex_scal
        implicit none

        integer(IK), intent(in) :: n
        complex(CK), intent(inout) :: a(n, n)
        real(RK), intent(in) :: d(n)
        integer(IK) :: error

        integer(IK) :: i, j
        complex(CK), allocatable :: d1(:)

        allocate (d1(n))

        d1 = cmplx(1.0_RK/sqrt(d), kind=CK)

        do j = 1_IK, n
            do i = 1_IK, n
                a(i, j) = a(i, j)*d1(i)
            end do
            call complex_scal(n, d1(j), a(1_IK, j), 1_IK)
        end do

        deallocate (d1)

        error = OK

    end function complex_he_diag_scale

    function real_sy_solve_linear(a, rhs, n, n_rhs, x) result(error)

        use kinds, only: IK, RK
        use errors, only: OK, LINEAR_ALGEBRA_ERROR
        use lapackwrapper, only: real_sysv
        implicit none

        integer(IK), intent(in) :: n, n_rhs
        real(RK), intent(in) :: a(n, n), rhs(n, n_rhs)
        real(RK), intent(out) :: x(n, n_rhs)
        integer(IK) :: error

        integer(IK) :: info, idum, lwork
        integer(IK), allocatable :: ipiv(:)
        real(RK) :: work1(1_IK)
        real(RK), allocatable :: a1(:, :), work(:)

        ! Compute space requirement for solution (returned on work1(1))
        info = 0_IK
        call real_sysv(uplo, n, n_rhs, a, n, idum, rhs, n, work1, -1_IK, info)
        lwork = int(work1(1_IK), IK)
        if (info /= 0_IK .or. lwork <= 0_IK) then
            error = LINEAR_ALGEBRA_ERROR
            return
        end if

        ! Solve linear equation in place
        allocate (a1(n, n), ipiv(n), work(lwork))
        a1 = a
        x = rhs
        call real_sysv(uplo, n, n_rhs, a1, n, ipiv, x, n, work, lwork, info)
        if (info /= 0_IK) then
            error = LINEAR_ALGEBRA_ERROR
            deallocate (a1, ipiv, work)
            return
        end if
        deallocate (a1, ipiv, work)

        error = OK

    end function real_sy_solve_linear

    function complex_he_solve_linear(a, rhs, n, n_rhs, x) result(error)

        use kinds, only: IK, CK
        use errors, only: OK, LINEAR_ALGEBRA_ERROR
        use lapackwrapper, only: complex_hesv
        implicit none

        integer(IK), intent(in) :: n, n_rhs
        complex(CK), intent(in) :: a(n, n), rhs(n, n_rhs)
        complex(CK), intent(out) :: x(n, n_rhs)
        integer(IK) :: error

        integer(IK) :: info, idum, lwork
        integer(IK), allocatable :: ipiv(:)
        complex(CK) :: work1(1_IK)
        complex(CK), allocatable :: a1(:, :), work(:)

        ! Compute space requirement for solution (returned on work1(1))
        info = 0_IK
        call complex_hesv(uplo, n, n_rhs, a, n, idum, rhs, n, work1, -1_IK, info)
        lwork = int(work1(1_IK), IK)
        if (info /= 0_IK .or. lwork <= 0_IK) then
            error = LINEAR_ALGEBRA_ERROR
            return
        end if

        ! Solve linear equation in place
        allocate (a1(n, n), ipiv(n), work(lwork))
        a1 = a
        x = rhs
        call complex_hesv(uplo, n, n_rhs, a1, n, ipiv, x, n, work, lwork, info)
        if (info /= 0_IK) then
            error = LINEAR_ALGEBRA_ERROR
            deallocate (a1, ipiv, work)
            return
        end if
        deallocate (a1, ipiv, work)

        error = OK

    end function complex_he_solve_linear

end module linalg
