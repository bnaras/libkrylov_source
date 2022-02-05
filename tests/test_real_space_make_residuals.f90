program test_real_space_make_residuals

    use kinds, only: IK, RK
    use errors, only: OK
    use testing, only: near_real_mat
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, spaces, &
                      real_space_t, real_eigenvalue_equation_t
    implicit none

    integer(IK) :: index, error
    real(RK) :: products(3_IK, 2_IK), basis_solutions(2_IK, 1_IK), solutions(3_IK, 1_IK), &
                eigenvalues(1_IK), residuals(3_IK, 1_IK)

    products = reshape((/2.0_RK, 1.0_RK, 3.0_RK, 2.0_RK, -1.0_RK, -3.0_RK/), (/3_IK, 2_IK/))
    basis_solutions = reshape((/sqrt(0.5_RK), -sqrt(0.5_RK)/), (/2_IK, 1_IK/))
    solutions = reshape((/sqrt(0.5_RK), -sqrt(0.5_RK), 0.0_RK/), (/3_IK, 1_IK/))
    eigenvalues = (/1.0_RK/)
    residuals = reshape((/-sqrt(0.5_RK), sqrt(4.5_RK), sqrt(18.0_RK)/), (/3_IK, 1_IK/))

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with full dimension 3, current dimension 2
    index = krylov_add_space('r', 's', 'e', 3_IK, 1_IK, 2_IK)
    if (index /= 1_IK) stop 1

    select type (space => spaces(1_IK)%space_p)
    type is (real_space_t)
        select type (equation => space%equation)
        type is (real_eigenvalue_equation_t)
            equation%products = products
            equation%solutions = solutions
            equation%basis_solutions = basis_solutions
            equation%eigenvalues = eigenvalues

            error = space%make_residuals()
            if (error /= OK) stop 1

            if (equation%residuals /= near_real_mat(residuals)) stop 1
        end select
    end select

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_real_space_make_residuals
