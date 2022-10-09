program test_complex_ge_orthogonalize

    use kinds, only: IK, RK, CK, LK
    use testing, only: near_complex_mat
    use linalg, only: complex_ge_orthogonalize
    implicit none

    integer(IK) :: n_out, error
    complex(CK) :: a(4_IK, 2_IK), q1_ref(4_IK, 2_IK)

    a = reshape((/(0.5_CK, 0.0_CK), (0.5_CK, 0.0_CK), (0.0_CK, 0.5_CK), (0.0_CK, 0.5_CK), &
                  (0.5_CK, 0.0_CK), (0.5_CK, 0.0_CK), (0.0_CK, 0.5_CK), (0.0_CK, -0.5_CK)/), &
                (/4_IK, 2_IK/))
    q1_ref = reshape((/(0.707106781186548_CK, 0.0_CK), (0.707106781186548_CK, 0.0_CK), &
                       (0.0_CK, 0.707106781186548_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                       (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.707106781186548_CK)/), &
                     (/4_IK, 2_IK/))

    error = complex_ge_orthogonalize(a, 4_IK, 2_IK, 1.0E-14_RK, n_out)
    if (error /= 0_IK) stop 1

    if (n_out /= 2_IK) stop 1
    if (a /= near_complex_mat(q1_ref, fix_phase=.true._LK)) stop 1

end program test_complex_ge_orthogonalize
