program test_complex_he_eigenvalues

    use kinds, only: IK, RK, CK
    use errors, only: OK
    use linalg, only: complex_he_eigenvalues
    use testing, only: near_real_vec
    implicit none

    complex(CK) :: a(2_IK, 2_IK)
    real(RK) :: eig(2_IK), eig_ref(2_IK)
    integer(IK) :: error

    a = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, -1.0_CK), (0.0_CK, 1.0_CK), (1.0_CK, 0.0_CK)/), (/2_IK, 2_IK/))
    eig_ref = (/0.0_RK, 2.0_RK/)

    error = complex_he_eigenvalues(a, 2_IK, eig)
    if (error /= OK) stop 1

    if (eig /= near_real_vec(eig_ref)) stop 1

end program test_complex_he_eigenvalues
