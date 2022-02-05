function krylov_set_space_diagonal(index, full_dim, diagonal) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_SPACE, INVALID_DIMENSION, INCOMPATIBLE_PRECONDITIONER, INCOMPATIBLE_SPACE
    use krylov, only: real_space_t, complex_space_t, real_cg_preconditioner_t, complex_cg_preconditioner_t, &
                      real_davidson_preconditioner_t, complex_davidson_preconditioner_t, real_jd_preconditioner_t, &
                      complex_jd_preconditioner_t, real_jdall_preconditioner_t, complex_jdall_preconditioner_t, &
                      krylov_get_num_spaces, spaces
    implicit none

    integer(IK), intent(in) :: index, full_dim
    real(RK), intent(in) :: diagonal(full_dim)
    integer(IK) :: error

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        return
    end if

    associate (space => spaces(index)%space_p)
        if (space%full_dim /= full_dim) then
            error = INVALID_DIMENSION
            return
        end if

        select type (space)
        type is (real_space_t)
            select type (preconditioner => space%preconditioner)
            type is (real_cg_preconditioner_t)
                error = preconditioner%set_diagonal(full_dim, diagonal)
            type is (real_davidson_preconditioner_t)
                error = preconditioner%set_diagonal(full_dim, diagonal)
            type is (real_jd_preconditioner_t)
                error = preconditioner%set_diagonal(full_dim, diagonal)
            type is (real_jdall_preconditioner_t)
                error = preconditioner%set_diagonal(full_dim, diagonal)
            class default
                error = INCOMPATIBLE_PRECONDITIONER
                return
            end select
        type is (complex_space_t)
            select type (preconditioner => space%preconditioner)
            type is (complex_cg_preconditioner_t)
                error = preconditioner%set_diagonal(full_dim, diagonal)
            type is (complex_davidson_preconditioner_t)
                error = preconditioner%set_diagonal(full_dim, diagonal)
            type is (complex_jd_preconditioner_t)
                error = preconditioner%set_diagonal(full_dim, diagonal)
            type is (complex_jdall_preconditioner_t)
                error = preconditioner%set_diagonal(full_dim, diagonal)
            class default
                error = INCOMPATIBLE_PRECONDITIONER
                return
            end select
        class default
            error = INCOMPATIBLE_SPACE
            return
        end select
    end associate

    error = OK

end function krylov_set_space_diagonal
