program test_real_sy_rcond_one_norm

    use kinds, only: IK, RK
    use testing, only: near_real_num
    use linalg, only: real_sy_rcond_one_norm
    implicit none

    real(RK) :: a(3_IK, 3_IK), rcond

    a = reshape((/2.0_RK, -1.0_RK, 0.0_RK, -1.0_RK, 2.0_RK, -1.0_RK, 0.0_RK, -1.0_RK, 2.0_RK/), &
                (/3_IK, 3_IK/))

    rcond = real_sy_rcond_one_norm(a, 3_IK)
    if (rcond /= near_real_num(0.125_RK)) stop 1

end program test_real_sy_rcond_one_norm
