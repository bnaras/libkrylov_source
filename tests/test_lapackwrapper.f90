program test_lapackwrapper

    use kinds, only: IK, RK, CK
    use blaswrapper, only: real_gemm, complex_gemm
    use lapackwrapper, only: real_lansy, complex_lanhe
    use testing, only: near_real_num, near_complex_num, near_real_mat, near_complex_mat
    implicit none

    real(RK) :: r, r1(2_IK, 2_IK), r2(2_IK, 2_IK), work(2_IK), ref_r(2_IK, 2_IK)
    complex(CK) :: c, c1(2_IK, 2_IK), c2(2_IK, 2_IK), ref_c(2_IK, 2_IK)

    r1 = reshape((/1.0_RK, 1.0_RK, 1.0_RK, 1.0_RK/), (/2_IK, 2_IK/))
    c1 = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, 1.0_CK), (0.0_CK, -1.0_CK), (1.0_CK, 1.0_CK)/), &
                 (/2_IK, 2_IK/))
    ref_r = reshape((/2.0_RK, 2.0_RK, 2.0_RK, 2.0_RK/), (/2_IK, 2_IK/))
    ref_c = reshape((/(2.0_CK, 0.0_CK), (-1.0_CK, 2.0_CK), (1.0_CK, -2.0_CK), (1.0_CK, 2.0_CK)/), (/2_IK, 2_IK/))

    r = real_lansy('f', 'u', 2_IK, r1, 2_IK, work)
    if (r /= near_real_num(2.0_RK)) stop 1

    c = complex_lanhe('f', 'u', 2_IK, c1, 2_IK, work)
    if (c /= near_compleX_num((2.0_CK, 0.0_CK))) stop 1

    call real_gemm('n', 'n', 2_IK, 2_IK, 2_IK, 1.0_RK, r1, 2_IK, r1, 2_IK, 0.0_RK, r2, 2_IK)
    if (r2 /= near_real_mat(ref_r)) stop 1

    call complex_gemm('n', 'n', 2_IK, 2_IK, 2_IK, (1.0_CK, 0.0_CK), c1, 2_IK, c1, 2_IK, &
                      (0.0_CK, 0.0_CK), c2, 2_IK)
    if (c2 /= near_complex_mat(ref_c)) stop 1

end program test_lapackwrapper
