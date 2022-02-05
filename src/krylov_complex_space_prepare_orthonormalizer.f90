function krylov_complex_space_prepare_orthonormalizer(space) result(error)

    use kinds, only: IK
    use errors, only: OK
    use krylov, only: complex_space_t
    implicit none

    class(complex_space_t), intent(inout) :: space
    integer(IK) :: error

    error = space%orthonormalizer%prepare_transform(space%full_dim, space%basis_dim, space%equation%vectors)

end function krylov_complex_space_prepare_orthonormalizer
