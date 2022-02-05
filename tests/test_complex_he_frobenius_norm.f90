program test_complex_he_frobenius_norm

    use kinds, only: IK, RK, CK
    use testing, only: near_real_num
    use linalg, only: complex_he_frobenius_norm
    implicit none

    complex(CK) :: a(2_IK, 2_IK)
    real(RK) :: norm

    a = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, -1.0_CK), (0.0_CK, 1.0_CK), (1.0_CK, 0.0_CK)/), &
                (/2_IK, 2_IK/))

    norm = complex_he_frobenius_norm(a, 2_IK)
    if (norm /= near_real_num(2.0_RK)) stop 1

end program test_complex_he_frobenius_norm
