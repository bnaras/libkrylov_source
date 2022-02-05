program test_real_sy_spectral_norm

    use kinds, only: IK, RK
    use testing, only: near_real_num
    use linalg, only: real_sy_spectral_norm
    implicit none

    real(RK) :: a(3_IK, 3_IK), norm

    a = reshape((/2.0_RK, -1.0_RK, 0.0_RK, -1.0_RK, 2.0_RK, -1.0_RK, 0.0_RK, -1.0_RK, 2.0_RK/), &
                (/3_IK, 3_IK/))

    norm = real_sy_spectral_norm(a, 3_IK)
    if (norm /= near_real_num(3.41421356237309_RK)) stop 1

end program test_real_sy_spectral_norm
