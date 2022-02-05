program test_real_space_prepare_preconditioner

    use kinds, only: IK, RK
    use errors, only: OK
    use testing, only: near_real_vec
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, spaces, &
                      real_space_t, real_eigenvalue_equation_t, krylov_set_enum_option, &
                      krylov_set_space_diagonal, real_davidson_preconditioner_t
    implicit none

    integer(IK) :: error, index
    real(RK) :: diagonal(3_IK), eigenvalues(2_IK)

    diagonal = (/-3.0_RK, -2.0_RK, -1.0_RK/)
    eigenvalues = (/-2.0_RK, -1.0_RK/)

    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_enum_option('preconditioner', 'd')
    if (error /= OK) stop 1

    ! Add real space for eigenvalue equation
    index = krylov_add_space('r', 's', 'e', 3_IK, 2_IK, 2_IK)
    if (index /= 1_IK) stop 1

    error = krylov_set_space_diagonal(index, 3_IK, diagonal)
    if (error /= OK) stop 1

    select type (space => spaces(index)%space_p)
    type is (real_space_t)
        select type (equation => space%equation)
        type is (real_eigenvalue_equation_t)
            equation%eigenvalues = eigenvalues
        end select

        error = space%prepare_preconditioner()
        if (error /= OK) stop 1

        select type (preconditioner => space%preconditioner)
        type is (real_davidson_preconditioner_t)
            if (preconditioner%diagonal /= near_real_vec(diagonal)) stop 1
            if (preconditioner%eigenvalues /= near_real_vec(eigenvalues)) stop 1
        end select
    end select

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_real_space_prepare_preconditioner
