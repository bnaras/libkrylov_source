function krylov_complex_space_transform_solutions(space) result(error)

    use kinds, only: IK, CK
    use errors, only: OK
    use blaswrapper, only: complex_gemm
    use krylov, only: complex_space_t
    implicit none

    class(complex_space_t), intent(inout) :: space
    integer(IK) :: error

    call complex_gemm('n', 'n', space%full_dim, space%solution_dim, space%basis_dim, &
                      (1.0_CK, 0.0_CK), space%equation%vectors, space%full_dim, &
                      space%equation%basis_solutions, space%basis_dim, (0.0_CK, 0.0_CK), &
                      space%equation%solutions, space%full_dim)

    error = OK

end function krylov_complex_space_transform_solutions
