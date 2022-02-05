function krylov_get_space_rhs_size(index) result(length)

    use kinds, only: IK
    use errors, only: OK, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INCOMPATIBLE_EQUATION
    use krylov, only: spaces, krylov_get_num_spaces, real_space_t, complex_space_t, &
                      real_linear_equation_t, real_sylvester_equation_t, &
                      complex_linear_equation_t, complex_sylvester_equation_t
    implicit none

    integer(IK), intent(in) :: index
    integer(IK) :: length

    if (index > krylov_get_num_spaces()) then
        length = NO_SUCH_SPACE
        return
    end if

    select type (space => spaces(index)%space_p)
    type is (real_space_t)
        select type (equation => space%equation)
        type is (real_linear_equation_t)
            length = space%full_dim * space%solution_dim
        type is (real_sylvester_equation_t)
            length = space%full_dim * space%solution_dim
        class default
            length = INCOMPATIBLE_EQUATION
        end select
    type is (complex_space_t)
        select type (equation => space%equation)
        type is (complex_linear_equation_t)
            length = space%full_dim * space%solution_dim
        type is (complex_sylvester_equation_t)
            length = space%full_dim * space%solution_dim
        class default
            length = INCOMPATIBLE_EQUATION
        end select
    end select

end function krylov_get_space_rhs_size
