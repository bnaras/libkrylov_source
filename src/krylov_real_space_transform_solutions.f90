function krylov_real_space_transform_solutions(space) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use blaswrapper, only: real_gemm
    use krylov, only: real_space_t
    implicit none

    class(real_space_t), intent(inout) :: space
    integer(IK) :: error

    call real_gemm('n', 'n', space%full_dim, space%solution_dim, space%basis_dim, &
                   1.0_RK, space%equation%vectors, space%full_dim, space%equation%basis_solutions, space%basis_dim, &
                   0.0_RK, space%equation%solutions, space%full_dim)

    error = OK

end function krylov_real_space_transform_solutions
