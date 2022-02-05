program test_complex_ge_subset

    use kinds, only: IK, CK
    use testing, only: near_complex_mat
    use errors, only: OK
    use linalg, only: complex_ge_subset
    implicit none

    integer(IK) :: indices(3_IK)
    complex(CK) :: a(4_IK, 4_IK), a_subset(4_IK, 3_IK)
    integer(IK) :: error

    a = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                  (1.0E-6_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                  (0.0_CK, 1.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                  (0.0_CK, 0.0_CK), (1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), (/4_IK, 4_IK/))
    indices = (/1_IK, 3_IK, 4_IK/)
    a_subset = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                         (0.0_CK, 1.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                         (0.0_CK, 0.0_CK), (1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), (/4_IK, 3_IK/))

    error = complex_ge_subset(a, indices, 4_IK, 4_IK, 3_IK)
    if (error /= OK) stop 1

    if (a(:, 1_IK:3_IK) /= near_complex_mat(a_subset)) stop 1

end program test_complex_ge_subset
