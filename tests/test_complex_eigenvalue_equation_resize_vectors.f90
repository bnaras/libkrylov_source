program test_complex_eigenvalue_equation_resize_vectors

    use kinds, only: IK, CK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_complex_mat
    use krylov, only: complex_eigenvalue_equation_t
    implicit none

    type(complex_eigenvalue_equation_t) :: equation
    type(config_t) :: config
    complex(CK) :: vectors(6_IK, 2_IK), vectors_ref(6_IK, 4_IK), vectors_ref1(6_IK, 2_IK)
    integer(IK) :: error

    vectors = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                        (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (1.0_CK, 0.0_CK), &
                        (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), (/6_IK, 2_IK/))
    vectors_ref = reshape((/(1.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                            (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (1.0_CK, 0.0_CK), &
                            (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                            (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                            (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), &
                            (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK), (0.0_CK, 0.0_CK)/), (/6_IK, 4_IK/))
    vectors_ref1 = (0.0_CK, 0.0_CK)

    error = config%initialize()
    if (error /= OK) stop 1

    error = equation%initialize(6_IK, 1_IK, 2_IK, config)
    if (error /= OK) stop 1

    equation%vectors = vectors

    error = equation%resize_vectors(4_IK)
    if (error /= OK) stop 1

    if (equation%basis_dim /= 4_IK) stop 1
    if (size(equation%vectors) /= 24_IK) stop 1
    if (size(equation%products) /= 24_IK) stop 1
    if (size(equation%rayleigh) /= 16_IK) stop 1
    if (size(equation%basis_solutions) /= 4_IK) stop 1
    if (equation%vectors /= near_complex_mat(vectors_ref)) stop 1

    error = equation%resize_vectors(2_IK)
    if (error /= OK) stop 1

    if (equation%basis_dim /= 2_IK) stop 1
    if (size(equation%vectors) /= 12_IK) stop 1
    if (size(equation%products) /= 12_IK) stop 1
    if (size(equation%rayleigh) /= 4_IK) stop 1
    if (size(equation%basis_solutions) /= 2_IK) stop 1
    if (equation%vectors /= near_complex_mat(vectors_ref1)) stop 1

end program test_complex_eigenvalue_equation_resize_vectors
