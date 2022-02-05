program test_real_sy_diagonalize

    use kinds, only: IK, RK
    use errors, only: OK
    use linalg, only: real_sy_diagonalize
    use testing, only: near_real_vec, near_real_mat
    implicit none

    integer(IK) :: error
    real(RK) :: a(4_IK, 4_IK), eig(4_IK), eigv(4_IK, 4_IK), eig_ref(4_IK), eigv_ref(4_IK, 4_IK)

    a = reshape((/5.0_RK, 4.0_RK, 1.0_RK, 1.0_RK, 4.0_RK, 5.0_RK, 1.0_RK, 1.0_RK, &
                  1.0_RK, 1.0_RK, 4.0_RK, 2.0_RK, 1.0_RK, 1.0_RK, 2.0_RK, 4.0_RK/), &
                (/4_IK, 4_IK/))
    eig_ref = (/1.0_RK, 2.0_RK, 5.0_RK, 10.0_RK/)
    eigv_ref = reshape((/0.707106781186548_RK, -0.707106781186548_RK, 0.0_RK, 0.0_RK, &
                     0.0_RK, 0.0_RK, 0.707106781186548_RK, -0.707106781186548_RK, &
                     0.316227766016838_RK, 0.316227766016838_RK, -0.632455532033676_RK, -0.632455532033676_RK, &
                     0.632455532033676_RK, 0.632455532033676_RK, 0.316227766016838_RK, 0.316227766016838_RK/), &
                   (/4_IK, 4_IK/))

    error = real_sy_diagonalize(a, 4_IK, eig, eigv)
    if (error /= OK) stop 1

    if (eig /= near_real_vec(eig_ref)) stop 1
    if (eigv /= near_real_mat(eigv_ref, fix_phase=.true.)) stop 1

end program test_real_sy_diagonalize
