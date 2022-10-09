program test_complex_ge_block_orthonormalize

    use kinds, only: IK, RK, CK
    use testing, only: near_complex_mat
    use linalg, only: complex_ge_block_orthonormalize, complex_ge_orthonormalize
    implicit none

    integer(IK) :: n_out, error
    complex(CK) :: q(4_IK, 2_IK), a(4_IK, 2_IK), a1(4_IK, 2_IK), a2(4_IK, 2_IK), q1_ref(4_IK, 2_IK), &
                   q2_ref(4_IK, 2_IK)

    q = reshape((/(0.5_CK, 0.0_CK), (0.0_CK, 0.5_CK), (0.5_CK, 0.0_CK), (0.0_CK, -0.5_CK), &
                  (0.5_CK, 0.0_CK), (0.0_CK, -0.5_CK), (0.5_CK, 0.0_CK), (0.0_CK, 0.5_CK)/), &
                (/4_IK, 2_IK/))
    a = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                  (0.0_CK, 0.0_CK), (0.0_CK, 1.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), &
                (/4_IK, 2_IK/))
    a1 = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                   (0.0_CK, 0.0_CK), (0.0_CK, 1.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), &
                 (/4_IK, 2_IK/))
    a2 = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                   (0.5_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), &
                 (/4_IK, 2_IK/))
    q1_ref = reshape((/(0.707106781186548_CK, 0.0_CK), (0.0_CK, 0.0_CK), (-0.707106781186548_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                       (0.0_CK, 0.0_CK), (0.0_CK, 0.707106781186548_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.707106781186548_CK)/), &
                     (/4_IK, 2_IK/))
    q2_ref = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                       (0.0_CK, 0.0_CK), (0.0_CK, 1.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), &
                     (/4_IK, 2_IK/))

    error = complex_ge_block_orthonormalize(a, q, 4_IK, 2_IK, 2_IK, 1.0E-14_RK, n_out)
    if (error /= 0_IK) stop 1

    if (n_out /= 2_IK) stop 1
    if (a /= near_complex_mat(q1_ref)) stop 1

    error = complex_ge_orthonormalize(a1, 4_IK, 2_IK, 1.0E-14_RK, n_out)
    if (error /= 0_IK) stop 1

    if (n_out /= 2_IK) stop 1
    if (a1 /= near_complex_mat(q2_ref)) stop 1

    error = complex_ge_orthonormalize(a2, 4_IK, 2_IK, 1.0E-14_RK, n_out)
    if (error /= 0_IK) stop 1

    if (n_out /= 1_IK) stop 1

end program test_complex_ge_block_orthonormalize
