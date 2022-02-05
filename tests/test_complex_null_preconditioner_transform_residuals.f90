program test_complex_null_preconditioner_transform_residuals

    use kinds, only: IK, CK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_complex_mat
    use krylov, only: complex_null_preconditioner_t
    implicit none

    type(complex_null_preconditioner_t) :: preconditioner
    type(config_t) :: config
    complex(CK) :: residuals(4_IK, 2_IK), preconditioned(4_IK, 2_IK), ref(4_IK, 2_IK)
    integer(IK) :: error

    residuals = reshape((/(-1.098997719501211_CK, -0.681643539498055_CK), (0.570419000511414_CK, -0.285209500255707_CK), &
                          (0.570419000511414_CK, -0.285209500255707_CK), (-0.041840281521618_CK, 1.252062540009469_CK), &
                          (0.303651136225665_CK, 0.332207894338115_CK), (0.417878168675463_CK, -0.208939084337732_CK), &
                          (0.417878168675463_CK, -0.208939084337731_CK), (-1.139407473576592_CK, 0.085670274337349_CK)/), &
                        (/4_IK, 2_IK/))
    ref = residuals

    error = config%initialize()
    if (error /= OK) stop 1

    error = preconditioner%initialize(4_IK, 2_IK, config)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%transform_residuals(4_IK, 2_IK, residuals, preconditioned)
    if (error /= OK) stop 1

    if (preconditioned /= near_complex_mat(ref)) stop 1

end program test_complex_null_preconditioner_transform_residuals
