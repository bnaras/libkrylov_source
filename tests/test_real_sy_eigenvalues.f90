program test_real_sy_eigenvalues

    use kinds, only: IK, RK
    use errors, only: OK
    use linalg, only: real_sy_eigenvalues
    use testing, only: near_real_vec
    implicit none

    integer(IK) :: error
    real(RK) :: a(3_IK, 3_IK), eig(3_IK), eig_ref(3_IK)

    a = reshape((/2.0_RK, -1.0_RK, 0.0_RK, -1.0_RK, 2.0_RK, -1.0_RK, 0.0_RK, -1.0_RK, 2.0_RK/), &
                (/3_IK, 3_IK/))
    eig_ref = (/2.0_RK - sqrt(2.0_RK), 2.0_RK, 2.0_RK + sqrt(2.0_RK)/)

    error = real_sy_eigenvalues(a, 3_IK, eig)
    if (error /= OK) stop 1

    if (eig /= near_real_vec(eig_ref)) stop 1

end program test_real_sy_eigenvalues
