program test_complex_he_solve_linear

    use kinds, only: IK, CK
    use errors, only: OK
    use linalg, only: complex_he_solve_linear
    use testing, only: near_complex_mat
    implicit none

    complex(CK) :: a(3_IK, 3_IK), rhs(3_IK, 2_IK), solutions(3_IK, 2_IK), solutions_ref(3_IK, 2_IK)
    integer(IK) :: error

    a = reshape((/(2.0_CK, 0.0_CK), (0.0_CK, 1.0_CK), (0.0_CK, 0.0_CK), &
                  (0.0_CK, -1.0_CK), (2.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                  (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (3.0_CK, 0.0_CK)/), (/3_IK, 3_IK/))
    rhs = reshape((/(3.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                    (0.0_CK, 0.0_CK), (3.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), (/3_IK, 2_IK/))
    solutions_ref = reshape((/(2.0_CK, 0.0_CK), (0.0_CK, -1.0_CK), (0.0_CK, 0.0_CK), &
                              (0.0_CK, 1.0_CK), (2.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), (/3_IK, 2_IK/))

    error = complex_he_solve_linear(a, rhs, 3_IK, 2_IK, solutions)
    if (error /= OK) stop 1

    if (solutions /= near_complex_mat(solutions_ref)) stop 1

end program test_complex_he_solve_linear
