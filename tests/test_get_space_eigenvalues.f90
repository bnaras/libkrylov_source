program test_get_space_eigenvalues

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION, INCOMPATIBLE_EQUATION
    use krylov, only: spaces, real_space_t, complex_space_t, krylov_initialize, krylov_finalize, &
                      krylov_add_space, krylov_get_space_eigenvalues, real_eigenvalue_equation_t, &
                      complex_eigenvalue_equation_t
    implicit none

    integer(IK) :: error, index
    real(RK) :: eigenvalues_1(2_IK), eigenvalues_2(3_IK), eigenvalues_3(1_IK)

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with full dimension 10, solution dimension 2
    index = krylov_add_space('r', 's', 'e', 10_IK, 2_IK, 2_IK)
    if (index /= 1_IK) stop 1

    ! Add complex space with full dimension 15, solution dimension 3
    index = krylov_add_space('c', 'h', 'e', 15_IK, 3_IK, 3_IK)
    if (index /= 2_IK) stop 1

    ! Add real space with full dimension 20, solution dimension 1 for linear equation
    index = krylov_add_space('r', 's', 'l', 10_IK, 1_IK, 2_IK)
    if (index /= 3_IK) stop 1

    ! Get eigenvalues on real space
    select type (space => spaces(1_IK)%space_p)
    type is (real_space_t)
        select type (equation => space%equation)
        type is (real_eigenvalue_equation_t)
            equation%eigenvalues = 1.0_RK
        end select
    end select
    error = krylov_get_space_eigenvalues(1_IK, 2_IK, eigenvalues_1)
    if (error /= OK) stop 1
    if (eigenvalues_1(1_IK) /= 1.0_RK) stop 1

    ! Get eigenvalues on complex space
    select type (space => spaces(2_IK)%space_p)
    type is (complex_space_t)
        select type (equation => space%equation)
        type is (complex_eigenvalue_equation_t)
            equation%eigenvalues = 3.0_RK
        end select
    end select
    error = krylov_get_space_eigenvalues(2_IK, 3_IK, eigenvalues_2)
    if (error /= OK) stop 1
    if (eigenvalues_2(1_IK) /= 3.0_RK) stop 1

    ! Get eigenvalues from incompatible equation
    error = krylov_get_space_eigenvalues(3_IK, 1_IK, eigenvalues_3)
    if (error /= INCOMPATIBLE_EQUATION) stop 1

    ! Try to get eigenvalues with wrong dimension on real space
    error = krylov_get_space_eigenvalues(1_IK, 1_IK, eigenvalues_1)
    if (error /= INVALID_DIMENSION) stop 1

    ! Try to get eigenvalues with wrong dimension on complex space
    error = krylov_get_space_eigenvalues(2_IK, 2_IK, eigenvalues_2)
    if (error /= INVALID_DIMENSION) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_space_eigenvalues
