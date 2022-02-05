program test_complex_he_diagonalize

    use kinds, only: IK, RK, CK
    use errors, only: OK
    use linalg, only: complex_he_diagonalize
    use testing, only: near_real_vec, near_complex_mat
    implicit none

    complex(CK) :: a(2_IK, 2_IK), eigv(2_IK, 2_IK), eigv_ref(2_IK, 2_IK)
    real(RK) :: eig(2_IK), eig_ref(2_IK)
    integer(IK) :: error

    a = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, -1.0_CK), (0.0_CK, 1.0_CK), (1.0_CK, 0.0_CK)/), (/2_IK, 2_IK/))
    eig_ref = (/0.0_RK, 2.0_RK/)
    eigv_ref = reshape((/(0.707106781186547_CK, 0.0_CK), (0.0_CK, 0.707106781186547_CK), &
                         (0.707106781186547_CK, 0.0_CK), (0.0_CK, -0.707106781186547_CK)/), (/2_IK, 2_IK/))

    error = complex_he_diagonalize(a, 2_IK, eig, eigv)
    if (error /= OK) stop 1

    if (eig /= near_real_vec(eig_ref)) stop 1
    if (eigv /= near_complex_mat(eigv_ref, fix_phase=.true.)) stop 1

end program test_complex_he_diagonalize
