program test_testing

    use kinds, only: IK, RK, CK, LK
    use testing, only: near_real_num_t, near_real_vec_t, near_real_mat_t, &
                       near_real_num, near_real_vec, near_real_mat, fix_phase_real_num, &
                       fix_phase_real_vec, fix_phase_real_mat, near_complex_num_t, &
                       near_complex_num, near_complex_vec, near_complex_mat, &
                       fix_phase_complex_num, fix_phase_complex_vec, fix_phase_complex_mat
    implicit none

    type(near_real_num_t) :: r, r1, r2, r3
    type(near_real_vec_t) :: v, v1, v2
    type(near_real_mat_t) :: m, m1, m2
    type(near_complex_num_t) :: c, c1, c2
    real(RK) :: v3(2_IK), v4(2_IK), m3(4_IK, 1_IK), m4(2_IK, 2_IK), m5(2_IK, 2_IK)
    complex(CK) :: v5(2_IK), v6(2_IK), m6(2_IK, 2_IK), m7(2_IK, 2_IK)

    ! Initialization of approximate numbers using type constructor
    r = near_real_num_t(1.0_RK)
    r1 = near_real_num_t(1.0001_RK, thr=1.0E-6_RK)
    r2 = near_real_num_t(1.0_RK + epsilon(0.0_RK))

    ! Comparisons using == and /=
    if (r == r1) stop 1
    if (.not. r /= r1) stop 1
    if (.not. r == r2) stop 1
    if (r /= r2) stop 1
    if (r == 1.01_RK) stop 1
    if (.not. r == (1.0_RK + epsilon(0.0_RK))) stop 1

    ! Comparison with real variables
    if (r == 1.01_RK) stop 1
    if (.not. r /= 1.01_RK) stop 1
    if (1.01_RK == r) stop 1

    ! Initialization using factory function
    r3 = near_real_num(2.0_RK)
    if (r3 /= 2.0_RK) stop 1

    ! Phase normalization
    if (fix_phase_real_num(1.0_RK) /= near_real_num(1.0_RK)) stop 1
    if (fix_phase_real_num(-1.0_RK) /= near_real_num(1.0_RK)) stop 1
    if (-1.0_RK == near_real_num(1.0_RK)) stop 1
    if (-1.0_RK /= near_real_num(1.0_RK, fix_phase=.true._LK)) stop 1
    if (-1.01_RK /= near_real_num(1.0_RK, fix_phase=.true._LK, thr=0.1_RK)) stop 1

    ! Initialization of approximate vector using type constructor
    v = near_real_vec_t(2_IK, (/1.0_RK, 2.0_RK/))

    ! Initialization using factory function
    v1 = near_real_vec((/1.0_RK + epsilon(0.0_RK), 2.0_RK/))
    v2 = near_real_vec((/1.01_RK, 2.0_RK/), thr=1.0E-6_RK)

    ! Comparisons using == and /=
    if (.not. v == v1) stop 1
    if (v /= v1) stop 1
    if (v == v2) stop 1
    if (.not. v /= v2) stop 1

    ! Comparison with real vectors
    v3 = (/1.0_RK + epsilon(0.0_RK), 2.0_RK/)
    if (.not. v == v3) stop 1
    if (v /= v3) stop 1
    if (.not. v3 == v) stop 1
    if (v3 /= v) stop 1

    ! Phase normalization
    v4 = fix_phase_real_vec((/0.0_RK, -1.0_RK/))
    if (v4 /= near_real_vec((/0.0_RK, 1.0_RK/))) stop 1
    if ((/0.0_RK, 1.0_RK/) == near_real_vec((/0.0_RK, -1.0_RK/))) stop 1
    if ((/0.0_RK, 1.0_RK/) /= near_real_vec((/0.0_RK, -1.0_RK/), fix_phase=.true._LK)) stop 1

    ! Initialization of approximate matrix using type constructor
    m = near_real_mat_t(4_IK, 1_IK, reshape((/1.0_RK, 2.0_RK, 3.0_RK, 4.0_RK/), (/4_IK, 1_IK/)))

    ! Initialization using factory function
    m1 = near_real_mat(reshape((/1.0_RK, 2.0_RK, 3.0_RK, 4.0_RK/), (/2_IK, 2_IK/)))
    m2 = near_real_mat(reshape((/1.0_RK + epsilon(0.0_RK), 2.0_RK, 3.0_RK, 4.0_RK/), &
                               (/2_IK, 2_IK/)), thr=100.0_RK * epsilon(0.0_RK))

    ! Comparisons using == and /=
    if (.not. m1 == m2) stop 1
    if (m1 /= m2) stop 1

    ! Comparisons with real matrices
    m3 = reshape((/1.0_RK + epsilon(0.0_RK), 2.0_RK, 3.0_RK, 4.0_RK/), (/4_IK, 1_IK/))
    if (.not. m == m3) stop 1
    if (m /= m3) stop 1
    if (.not. m3 == m) stop 1
    if (m3 /= m) stop 1

    ! Phase normalization
    m4 = reshape((/-1.0_RK, 0.0_RK, 0.0_RK, -1.0_RK/), (/2_IK, 2_IK/))
    m5 = fix_phase_real_mat(m4)
    if (m5 /= near_real_mat(reshape((/1.0_RK, 0.0_RK, 0.0_RK, 1.0_RK/), (/2_IK, 2_IK/)))) stop 1
    if (m4 == near_real_mat(reshape((/1.0_RK, 0.0_RK, 0.0_RK, 1.0_RK/), (/2_IK, 2_IK/)))) stop 1
    if (m4 /= near_real_mat(reshape((/1.0_RK, 0.0_RK, 0.0_RK, 1.0_RK/), (/2_IK, 2_IK/)), fix_phase=.true._LK)) stop 1

    ! Initialization of approximate complex numbers using type constructor
    c = near_complex_num_t((0.0_CK, 1.0_CK))
    c1 = near_complex_num_t(cmplx(epsilon(0.0_CK), 1.0_CK, kind=CK), thr=1.0E-6_RK)

    ! Initialization using factory function
    c2 = near_complex_num((0.1_CK, 1.1_CK))

    ! Comparisons using == and /=
    if (.not. c == c1) stop 1
    if (c /= c1) stop 1

    ! Comparisons with complex numbers
    if (.not. c == (0.0_CK, 1.0_CK)) stop 1
    if (c /= (0.0_CK, 1.0_CK)) stop 1
    if (.not. (0.0_CK, 1.0_CK) == c) stop 1
    if ((0.0_CK, 1.0_CK) /= c) stop 1

    ! Phase normalization
    if (fix_phase_complex_num((3.0_CK, 4.0_CK)) /= near_complex_num((5.0_CK, 0.0_CK))) stop 1
    if (fix_phase_complex_num((-1.0_CK, 0.0_CK)) /= near_complex_num((1.0_CK, 0.0_CK))) stop 1
    if ((3.0_CK, 4.0_CK) == near_complex_num((-5.0_CK, 0.0_CK))) stop 1
    if ((3.0_CK, 4.0_CK) /= near_complex_num((-5.0_CK, 0.0_CK), fix_phase=.true._LK)) stop 1

    ! Complex vectors
    v5 = (/(0.0_CK, 1.0_CK), (1.0_CK, 0.0_CK)/)
    if (v5 /= near_complex_vec(v5)) stop 1
    v6 = fix_phase_complex_vec(v5)
    if (v6 /= near_complex_vec((/(1.0_CK, 0.0_CK), (0.0_CK, -1.0_CK)/))) stop 1
    if (v5 == near_complex_vec((/(1.0_CK, 0.0_CK), (0.0_CK, -1.0_CK)/))) stop 1
    if (v5 /= near_complex_vec((/(1.0_CK, 0.0_CK), (0.0_CK, -1.0_CK)/), fix_phase=.true._LK)) stop 1

    ! Complex matrices
    m6 = reshape((/(0.0_CK, 1.0_CK), (1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (-1.0_CK, 0.0_CK)/), &
                 (/2_IK, 2_IK/))
    if (m6 /= near_complex_mat(m6)) stop 1
    m7 = fix_phase_complex_mat(m6)
    if (m7 /= near_complex_mat(reshape((/(1.0_CK, 0.0_CK), (0.0_CK, -1.0_CK), (0.0_CK, 0.0_CK), (1.0_CK, 0.0_CK)/), &
                                       (/2_IK, 2_IK/)))) stop 1
    if (m6 == near_complex_mat(reshape((/(1.0_CK, 0.0_CK), (0.0_CK, -1.0_CK), (0.0_CK, 0.0_CK), (1.0_CK, 0.0_CK)/), &
                                       (/2_IK, 2_IK/)))) stop 1
    if (m6 /= near_complex_mat(reshape((/(1.0_CK, 0.0_CK), (0.0_CK, -1.0_CK), (0.0_CK, 0.0_CK), (1.0_CK, 0.0_CK)/), &
                                       (/2_IK, 2_IK/)), fix_phase=.true._LK)) stop 1

end program test_testing
