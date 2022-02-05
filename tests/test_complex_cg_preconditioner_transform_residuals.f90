program test_complex_cg_preconditioner_transform_residuals

    use kinds, only: IK, RK, CK
    use errors, only: OK, INCOMPLETE_PRECONDITIONER
    use options, only: config_t
    use testing, only: near_complex_mat
    use krylov, only: complex_cg_preconditioner_t
    implicit none

    type(complex_cg_preconditioner_t) :: preconditioner
    type(config_t) :: config
    complex(CK) :: residuals(4_IK, 2_IK), preconditioned(4_IK, 2_IK), ref(4_IK, 2_IK)
    real(RK) :: diagonal(4_IK)
    integer(IK) :: error

    residuals = reshape((/(-1.098997719501211_CK, -0.681643539498055_CK), (0.570419000511414_CK, -0.285209500255707_CK), &
                          (0.570419000511414_CK, -0.285209500255707_CK), (-0.041840281521618_CK, 1.252062540009469_CK), &
                          (0.303651136225665_CK, 0.332207894338115_CK), (0.417878168675463_CK, -0.208939084337732_CK), &
                          (0.417878168675463_CK, -0.208939084337731_CK), (-1.139407473576592_CK, 0.085670274337349_CK)/), &
                        (/4_IK, 2_IK/))
    diagonal = (/3.0_RK, 3.0_RK, 1.0_RK, 1.0_RK/)
    ref = reshape((/(-0.36633257316707035_CK, -0.22721451316601834_CK), (0.19013966683713801_CK, -9.50698334185690053E-002_CK), &
                    (0.57041900051141403_CK, -0.28520950025570702_CK), (-4.18402815216179988E-002_CK, 1.2520625400094689_CK), &
                    (0.10121704540855499_CK, 0.11073596477937166_CK), (0.13929272289182101_CK, -6.96463614459106733E-002_CK), &
                    (0.41787816867546301_CK, -0.20893908433773101_CK), (-1.1394074735765920_CK, 8.56702743373490005E-002_CK)/), &
                  (/4_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = config%set_real_option('min_diagonal_scaling', 1.0E-6_RK)
    if (error /= OK) stop 1

    error = preconditioner%initialize(4_IK, 2_IK, config)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= INCOMPLETE_PRECONDITIONER) stop 1

    error = preconditioner%set_diagonal(4_IK, diagonal)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%transform_residuals(4_IK, 2_IK, residuals, preconditioned)
    if (error /= OK) stop 1

    if (preconditioned /= near_complex_mat(ref)) stop 1

end program test_complex_cg_preconditioner_transform_residuals
