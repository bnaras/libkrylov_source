program test_real_ge_orthogonalize

    use kinds, only: IK, RK
    use testing, only: near_real_mat
    use linalg, only: real_ge_orthogonalize
    implicit none

    integer(IK) :: n_out, error
    real(RK) :: a(4_IK, 2_IK), q1_ref(4_IK, 2_IK)

    a = reshape((/0.25_RK, 0.25_RK, 0.25_RK, 0.25_RK, 0.25_RK, 0.25_RK, 0.25_RK, -0.25_RK/), &
                (/4_IK, 2_IK/))

    q1_ref = reshape((/0.353553390593274_RK, 0.353553390593274_RK, 0.353553390593274_RK, 0.0_RK, &
                       0.0_RK, 0.0_RK, 0.0_RK, 0.353553390593274_RK/), (/4_IK, 2_IK/))

    error = real_ge_orthogonalize(a, 4_IK, 2_IK, 1.0E-14_RK, n_out)
    if (error /= 0_IK) stop 1

    if (n_out /= 2_IK) stop 1

    if (a(1_IK, 1_IK) < 0.0_RK) a(:, 1_IK) = -a(:, 1_IK)
    if (a(4_IK, 2_IK) < 0.0_RK) a(:, 2_IK) = -a(:, 2_IK)

    if (a /= near_real_mat(q1_ref)) stop 1

end program test_real_ge_orthogonalize
