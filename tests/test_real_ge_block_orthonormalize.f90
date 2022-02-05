program test_real_ge_block_orthonormalize

    use kinds, only: IK, RK
    use testing, only: near_real_mat
    use linalg, only: real_ge_block_orthonormalize
    implicit none

    integer(IK) :: n_out, error
    real(RK) :: q(4_IK, 2_IK), a(4_IK, 2_IK), q1_ref(4_IK, 2_IK)

    q = reshape((/0.25819888974716_RK, -0.51639777949432_RK, 0.77459666924148_RK, 0.25819888974716_RK, &
                  -0.91098027282223_RK, -0.33562431103977_RK, 0.14383899044562_RK, -0.19178532059415_RK/), &
                (/4_IK, 2_IK/))

    a = reshape((/1.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 0.0_RK, 1.0_RK, 0.0_RK, 0.0_RK/), (/4_IK, 2_IK/))

    q1_ref = reshape((/0.321633760451336_RK, -0.536056267418898_RK, -0.214422506967558_RK, -0.750478774386457_RK, &
                       0.0_RK, 0.577350269189627_RK, 0.577350269189623_RK, -0.577350269189628_RK/), &
                     (/4_IK, 2_IK/))

    error = real_ge_block_orthonormalize(a, q, 4_IK, 2_IK, 2_IK, 1.0E-14_RK, n_out)
    if (error /= 0_IK) stop 1

    if (n_out /= 2_IK) stop 1
    if (a /= near_real_mat(q1_ref)) stop 1

end program test_real_ge_block_orthonormalize
