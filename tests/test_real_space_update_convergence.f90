program test_real_space_update_convergence

    use kinds, only: IK, RK
    use errors, only: OK, NOT_CONVERGED
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, spaces, &
                      real_space_t, krylov_set_enum_option, krylov_set_real_option
    implicit none

    integer(IK) :: error, index, status
    real(RK) :: max_residual_norm, min_gram_rcond, residuals(3_IK, 1_IK)

    max_residual_norm = 1.0E-5_RK
    min_gram_rcond = 1.0E-10_RK
    residuals = 1.0E-4_RK

    error = krylov_initialize()
    if (error /= OK) stop 1

    error = krylov_set_enum_option('orthonormalizer', 'o')
    if (error /= OK) stop 1

    error = krylov_set_real_option('max_residual_norm', max_residual_norm)
    if (error /= OK) stop 1

    error = krylov_set_real_option('min_gram_rcond', min_gram_rcond)
    if (error /= OK) stop 1

    ! Add real space for eigenvalue equation
    index = krylov_add_space('r', 's', 'e', 3_IK, 1_IK, 2_IK)
    if (index /= 1_IK) stop 1

    select type (space => spaces(index)%space_p)
    type is (real_space_t)
        space%equation%residuals = residuals

        error = space%update_convergence()
        if (error /= OK) stop 1

        status = space%convergence%get_convergence()
        if (status /= NOT_CONVERGED) stop 1
    end select

end program test_real_space_update_convergence
