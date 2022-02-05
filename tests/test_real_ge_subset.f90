program test_real_ge_subset

    use kinds, only: IK, RK
    use testing, only: near_real_mat
    use errors, only: OK
    use linalg, only: real_ge_subset
    implicit none

    integer(IK) :: indices(3_IK)
    real(RK) :: a(4_IK, 4_IK), a_subset(4_IK, 3_IK)
    integer(IK) :: error

    a = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 1.0E-6_RK, 0.0_RK, 0.0_RK, 0.0_RK, &
                  0.0_RK, 1.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 1.0_RK, 0.0_RK/), (/4_IK, 4_IK/))
    indices = (/1_IK, 3_IK, 4_IK/)
    a_subset = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 1.0_RK, 0.0_RK, 0.0_RK, &
                         0.0_RK, 0.0_RK, 1.0_RK, 0.0_RK/), (/4_IK, 3_IK/))

    error = real_ge_subset(a, indices, 4_IK, 4_IK, 3_IK)
    if (error /= OK) stop 1

    if (a(:, 1_IK:3_IK) /= near_real_mat(a_subset)) stop 1

end program test_real_ge_subset
