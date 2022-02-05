function krylov_real_eigenvalue_equation_expand_equation(equation) result(error)

    use kinds, only: IK, RK
    use errors, only: OK, INVALID_DIMENSION
    use blaswrapper, only: real_gemm
    use krylov, only: real_eigenvalue_equation_t
    implicit none

    class(real_eigenvalue_equation_t), intent(inout) :: equation
    integer(IK) :: error

    integer(IK) :: old_dim, vec1, vec2

    old_dim = equation%basis_dim - equation%new_dim

    if (old_dim < 0_IK) then
        error = INVALID_DIMENSION
        return
    end if

    call real_gemm('t', 'n', equation%new_dim, equation%basis_dim, equation%full_dim, &
                   1.0_RK, equation%vectors(1_IK, old_dim + 1_IK), equation%full_dim, &
                   equation%products, equation%full_dim, &
                   0.0_RK, equation%rayleigh(old_dim + 1_IK, 1_IK), equation%basis_dim)

    do vec1 = old_dim + 1_IK, equation%basis_dim
        do vec2 = 1_IK, old_dim
            equation%rayleigh(vec2, vec1) = equation%rayleigh(vec1, vec2)
        end do
    end do

    error = OK

end function krylov_real_eigenvalue_equation_expand_equation
