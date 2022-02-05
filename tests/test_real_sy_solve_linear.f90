program test_real_sy_solve_linear

    use kinds, only: IK, RK
    use errors, only: OK
    use linalg, only: real_sy_solve_linear
    use testing, only: near_real_mat
    implicit none

    integer(IK) :: error
    real(RK) :: a(3_IK, 3_IK), rhs(3_IK, 2_IK), solutions(3_IK, 2_IK), solutions_ref(3_IK, 2_IK)

    a = reshape((/2.0_RK, -1.0_RK, 0.0_RK, -1.0_RK, 2.0_RK, -1.0_RK, 0.0_RK, -1.0_RK, 2.0_RK/), &
                (/3_IK, 3_IK/))
    rhs = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 1.0_RK, 0.0_RK/), (/3_IK, 2_IK/))
    solutions_ref = reshape((/0.75_RK, 0.5_RK, 0.25_RK, 0.5_RK, 1.0_RK, 0.5_RK/), (/3_IK, 2_IK/))

    error = real_sy_solve_linear(a, rhs, 3_IK, 2_IK, solutions)
    if (error /= OK) stop 1

    if (solutions /= near_real_mat(solutions_ref)) stop 1

end program test_real_sy_solve_linear
