program test_complex_ortho_orthonormalizer_get_gram_rcond

    use kinds, only: IK, RK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_num
    use krylov, only: complex_ortho_orthonormalizer_t
    implicit none

    type(complex_ortho_orthonormalizer_t) :: orthonormalizer
    type(config_t) :: config
    real(RK) :: gram_rcond
    integer(IK) :: error

    error = config%initialize()
    if (error /= OK) stop 1

    error = orthonormalizer%initialize(config)
    if (error /= OK) stop 1

    gram_rcond = orthonormalizer%get_gram_rcond()
    if (gram_rcond /= near_real_num(1.0_RK)) stop 1

end program test_complex_ortho_orthonormalizer_get_gram_rcond
