function krylov_complex_semi_orthonormalizer_initialize(orthonormalizer, config) result(error)

    use kinds, only: IK
    use errors, only: OK
    use options, only: config_t
    use krylov, only: complex_semi_orthonormalizer_t
    implicit none

    class(complex_semi_orthonormalizer_t), intent(inout) :: orthonormalizer
    type(config_t), intent(in) :: config
    integer(IK) :: error

    integer(IK) :: basis_dim

    basis_dim = 0_IK

    orthonormalizer%basis_dim = basis_dim

    if (allocated(orthonormalizer%config)) deallocate (orthonormalizer%config)
    allocate (orthonormalizer%config)
    orthonormalizer%config = config

    if (allocated(orthonormalizer%vector_norm_squared)) deallocate (orthonormalizer%vector_norm_squared)
    if (allocated(orthonormalizer%gram_matrix)) deallocate (orthonormalizer%gram_matrix)
    if (allocated(orthonormalizer%scaled_gram_matrix)) deallocate (orthonormalizer%scaled_gram_matrix)
    if (allocated(orthonormalizer%gram_matrix_decomposed)) deallocate (orthonormalizer%gram_matrix_decomposed)

    allocate (orthonormalizer%vector_norm_squared(basis_dim), &
              orthonormalizer%gram_matrix(basis_dim, basis_dim), &
              orthonormalizer%scaled_gram_matrix(basis_dim, basis_dim), &
              orthonormalizer%gram_matrix_decomposed(basis_dim, basis_dim))

    error = OK

end function krylov_complex_semi_orthonormalizer_initialize
