function krylov_real_space_prepare_orthonormalizer(space) result(error)

    use kinds, only: IK, RK
    use errors, only: OK
    use krylov, only: real_space_t
    implicit none

    class(real_space_t), intent(inout) :: space
    integer(IK) :: error

    error = space%orthonormalizer%prepare_transform(space%full_dim, space%basis_dim, space%equation%vectors)

end function krylov_real_space_prepare_orthonormalizer
