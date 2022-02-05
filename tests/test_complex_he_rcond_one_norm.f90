program test_complex_he_rcond_one_norm

    use kinds, only: IK, RK, CK
    use testing, only: near_real_num
    use linalg, only: complex_he_rcond_one_norm
    implicit none

    complex(CK) :: a(2_IK, 2_IK)
    real(RK) :: rcond

    a = reshape((/(3.0_CK, 0.0_CK), (0.0_CK, -1.0_CK), (0.0_CK, 1.0_CK), (3.0_CK, 0.0_CK)/), &
                (/2_IK, 2_IK/))

    rcond = complex_he_rcond_one_norm(a, 2_IK)
    if (rcond /= near_real_num(0.5_RK)) stop 1

end program test_complex_he_rcond_one_norm
