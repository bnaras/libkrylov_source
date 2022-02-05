program test_real_sy_diag_scale

    use kinds, only: IK, RK
    use errors, only: OK
    use testing, only: near_real_mat
    use linalg, only: real_sy_diag_scale
    implicit none

    real(RK) :: a(3_IK, 3_IK), d(3_IK), a1_ref(3_IK, 3_IK)
    integer(IK) :: error

    a = reshape((/1.0_RK, 2.0_RK, 3.0_RK, 2.0_RK, 4.0_RK, 5.0_RK, 3.0_RK, 5.0_RK, 6.0_RK/), &
                (/3_IK, 3_IK/))
    d = (/1.0_RK, 4.0_RK, 6.0_RK/)
    a1_ref = reshape((/1.0_RK, 1.0_RK, 1.22474487139159_RK, 1.0_RK, 1.0_RK, 1.02062072615966_RK, &
                       1.22474487139159_RK, 1.02062072615966_RK, 1.0_RK/), (/3_IK, 3_IK/))

    error = real_sy_diag_scale(a, d, 3_IK)
    if (error /= OK) stop 1

    if (a /= near_real_mat(a1_ref)) stop 1

end program test_real_sy_diag_scale
