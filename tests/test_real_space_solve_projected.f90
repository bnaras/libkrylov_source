program test_real_space_solve_projected

    use kinds, only: IK, RK
    use errors, only: OK
    use testing, only: near_real_vec, near_real_mat
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, spaces, &
                      real_space_t, krylov_set_real_space_vectors, krylov_set_enum_option, &
                      real_eigenvalue_equation_t
    implicit none

    integer(IK) :: index, error
    real(RK) :: rayleigh(2_IK, 2_IK), eigenvalues(1_IK), basis_solutions(2_IK, 1_IK)

    rayleigh = reshape((/0.0_RK, 1.0_RK, 1.0_RK, 0.0_RK/), (/2_IK, 2_IK/))
    eigenvalues = (/-1.0_RK/)
    basis_solutions = reshape((/sqrt(0.5_RK), -sqrt(0.5_RK)/), (/2_IK, 1_IK/))

    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_enum_option('orthonormalizer', 'o')
    if (error /= OK) stop 1

    ! Add real space with full dimension 3, current dimension 2
    index = krylov_add_space('r', 's', 'e', 3_IK, 1_IK, 2_IK)
    if (index /= 1_IK) stop 1

    select type (space => spaces(1_IK)%space_p)
    type is (real_space_t)
        error = space%prepare_orthonormalizer()
        if (error /= OK) stop 1

        space%equation%rayleigh = rayleigh

        error = space%solve_projected()
        if (error /= OK) stop 1

        select type (equation => space%equation)
        type is (real_eigenvalue_equation_t)
            if (equation%eigenvalues /= near_real_vec(eigenvalues)) stop 1
            if (equation%basis_solutions /= near_real_mat(basis_solutions, fix_phase=.true.)) stop 1
        end select
    end select

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_real_space_solve_projected
