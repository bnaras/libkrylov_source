function krylov_set_space_preconditioner(index, preconditioner) result(error)

    use kinds, only: IK, AK
    use errors, only: OK, NO_SUCH_SPACE, INVALID_KIND
    use krylov, only: spaces, real_space_t, complex_space_t, krylov_get_num_spaces, &
                      krylov_set_space_enum_option
    implicit none

    integer(IK), intent(in) :: index
    character(len=*, kind=AK), intent(in) :: preconditioner
    integer(IK) :: error

    integer(IK) :: err

    if (index > krylov_get_num_spaces()) then
        error = NO_SUCH_SPACE
        return
    end if

    associate (space => spaces(index)%space_p)
        err = space%config%set_enum_option('preconditioner', preconditioner)
        if (err /= OK) then
            error = err
            return
        end if

        err = space%set_preconditioner(preconditioner)
        if (err /= OK) then
            error = err
            return
        end if

        select type (space)
        type is (real_space_t)

            err = space%preconditioner%initialize(space%full_dim, space%solution_dim, space%config%link())
            if (err /= OK) then
                error = err
                return
            end if

            error = OK

        type is (complex_space_t)

            err = space%preconditioner%initialize(space%full_dim, space%solution_dim, space%config%link())
            if (err /= OK) then
                error = err
                return
            end if

            error = OK

        class default
            error = INVALID_KIND
        end select
    end associate

end function krylov_set_space_preconditioner
