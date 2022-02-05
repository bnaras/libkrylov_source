program test_complex_eigenvalue_equation_resize_solutions

    use kinds, only: IK, CK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_complex_mat
    use krylov, only: complex_eigenvalue_equation_t
    implicit none

    type(complex_eigenvalue_equation_t) :: equation
    type(config_t) :: config
    complex(CK) :: solutions(6_IK, 2_IK), solutions_ref(6_IK, 2_IK), solutions_ref1(6_IK, 1_IK)
    integer(IK) :: error

    solutions = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                          (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (1.0_CK, 0.0_CK), &
                          (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), (/6_IK, 2_IK/))
    solutions_ref = solutions
    solutions_ref1 = (0.0_CK, 0.0_CK)

    error = config%initialize()
    if (error /= OK) stop 1

    error = equation%initialize(6_IK, 1_IK, 2_IK, config)
    if (error /= OK) stop 1

    error = equation%resize_solutions(2_IK)
    if (error /= OK) stop 1

    equation%solutions = solutions

    if (equation%solution_dim /= 2_IK) stop 1
    if (size(equation%solutions) /= 12_IK) stop 1
    if (size(equation%residuals) /= 12_IK) stop 1
    if (size(equation%basis_solutions) /= 4_IK) stop 1
    if (equation%solutions /= near_complex_mat(solutions_ref)) stop 1

    error = equation%resize_solutions(1_IK)
    if (error /= OK) stop 1

    if (equation%solution_dim /= 1_IK) stop 1
    if (size(equation%solutions) /= 6_IK) stop 1
    if (size(equation%residuals) /= 6_IK) stop 1
    if (size(equation%basis_solutions) /= 2_IK) stop 1
    if (equation%solutions /= near_complex_mat(solutions_ref1)) stop 1

end program test_complex_eigenvalue_equation_resize_solutions
