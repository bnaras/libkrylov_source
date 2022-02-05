program test_complex_he_diag_scale

    use kinds, only: IK, RK, CK
    use errors, only: OK
    use testing, only: near_complex_mat
    use linalg, only: complex_he_diag_scale
    implicit none

    complex(CK) :: a(2_IK, 2_IK), a1_ref(2_IK, 2_IK)
    real(RK) :: d(2_IK)
    integer(IK) :: error

    a = reshape((/(2.0_CK, 0.0_CK), (0.0_CK, 2.0_CK), (0.0_CK, -2.0_CK), (2.0_CK, 0.0_CK)/), &
                (/2_IK, 2_IK/))
    d = (/2.0_RK, 2.0_RK/)
    a1_ref = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, 1.0_CK), (0.0_CK, -1.0_CK), (1.0_CK, 0.0_CK)/), &
                     (/2_IK, 2_IK/))

    error = complex_he_diag_scale(a, d, 2_IK)
    if (error /= OK) stop 1

    if (a /= near_complex_mat(a1_ref)) stop 1

end program test_complex_he_diag_scale
