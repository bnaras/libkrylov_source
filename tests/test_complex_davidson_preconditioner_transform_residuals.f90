program test_complex_davidson_preconditioner_transform_residuals

    use kinds, only: IK, RK, CK
    use errors, only: OK, INCOMPLETE_PRECONDITIONER
    use options, only: config_t
    use testing, only: near_complex_mat
    use krylov, only: complex_davidson_preconditioner_t
    implicit none

    type(complex_davidson_preconditioner_t) :: preconditioner
    type(config_t) :: config
    complex(CK) :: residuals(4_IK, 2_IK), preconditioned(4_IK, 2_IK), ref1(4_IK, 2_IK), ref2(4_IK, 2_IK), ref3(4_IK, 2_IK)
    real(RK) :: diagonal(4_IK), eigenvalues(2_IK), shifts(2_IK)
    integer(IK) :: error

    residuals = reshape((/(-1.098997719501211_CK, -0.681643539498055_CK), (0.570419000511414_CK, -0.285209500255707_CK), &
                          (0.570419000511414_CK, -0.285209500255707_CK), (-0.041840281521618_CK, 1.252062540009469_CK), &
                          (0.303651136225665_CK, 0.332207894338115_CK), (0.417878168675463_CK, -0.208939084337732_CK), &
                          (0.417878168675463_CK, -0.208939084337731_CK), (-1.139407473576592_CK, 0.085670274337349_CK)/), &
                        (/4_IK, 2_IK/))
    diagonal = (/3.0_RK, 3.0_RK, 1.0_RK, 1.0_RK/)
    eigenvalues = (/0.841687604822300_RK, 4.158312395177700_RK/)
    shifts = (/13.0_RK, 2.0_RK/)
    ref1 = reshape((/(-0.50919307230811117_CK, -0.31582246435735889_CK), (0.26428935949489823_CK, -0.13214467974744912_CK), &
                    (3.6031227995201451_CK, -1.8015613997600726_CK), (-0.26428935949490107_CK, 7.9088092792991569_CK), &
                    (-0.26214960445025803_CK, -0.28680336645033488_CK), (-0.36076465245056377_CK, 0.18038232622528233_CK), &
                    (-0.13231058755096689_CK, 6.61552937754832926E-002_CK), &
                    (0.36076465245056422_CK, -2.71253326517527198E-002_CK)/), (/4_IK, 2_IK/))
    ref2 = reshape((/(0.10989977195012110_CK, 0.06816435394980550_CK), (-0.05704190005114140_CK, 0.02852095002557070_CK), &
                    (-0.04753491670928450_CK, 0.02376745835464225_CK), (0.00348669012680150_CK, -0.10433854500078908_CK), &
                    (0.30365113622566497_CK, 0.33220789433811498_CK), (0.41787816867546301_CK, -0.20893908433773201_CK), &
                    (-0.4178781686754630_CK, 0.20893908433773101_CK), (1.1394074735765920_CK , -0.08567027433734900_CK)/), &
                    (/4_IK, 2_IK/))
    ref3 = reshape((/(-0.366332573167070_CK, -0.227214513166018_CK), (0.190139666837138_CK, -0.095069833418569_CK), &
                    (0.570419000511414_CK, -0.285209500255707_CK), (-0.041840281521618_CK, 1.252062540009469_CK), &
                    (0.101217045408555_CK, 0.110735964779372_CK), (0.139292722891821_CK, -0.069646361445911_CK), &
                    (0.417878168675463_CK, -0.208939084337731_CK), (-1.139407473576592_CK, 0.085670274337349_CK)/), &
                    (/4_IK, 2_IK/))    

    error = config%initialize()
    if (error /= OK) stop 1

    error = config%set_real_option('min_diagonal_scaling', 1.0E-6_RK)
    if (error /= OK) stop 1

    ! Test with ('has_eigenvalues' == .true.)
    error = preconditioner%initialize(4_IK, 2_IK, config)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= INCOMPLETE_PRECONDITIONER) stop 1

    error = preconditioner%set_diagonal(4_IK, diagonal)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%set_eigenvalues(2_IK, eigenvalues)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%transform_residuals(4_IK, 2_IK, residuals, preconditioned)
    if (error /= OK) stop 1

    if (preconditioned /= near_complex_mat(ref1)) stop 1

    ! Test with ('has_shifts' == .true.)
    error = preconditioner%initialize(4_IK, 2_IK, config)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= INCOMPLETE_PRECONDITIONER) stop 1

    error = preconditioner%set_diagonal(4_IK, diagonal)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%set_shifts(2_IK, shifts)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%transform_residuals(4_IK, 2_IK, residuals, preconditioned)
    if (error /= OK) stop 1

    if (preconditioned /= near_complex_mat(ref2)) stop 1

    ! Test with ('has_eigenvalues' .and. 'has_shifts' == .false.)
    error = preconditioner%initialize(4_IK, 2_IK, config)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= INCOMPLETE_PRECONDITIONER) stop 1

    error = preconditioner%set_diagonal(4_IK, diagonal)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%transform_residuals(4_IK, 2_IK, residuals, preconditioned)
    if (error /= OK) stop 1

    if (preconditioned /= near_complex_mat(ref3)) stop 1

end program test_complex_davidson_preconditioner_transform_residuals
