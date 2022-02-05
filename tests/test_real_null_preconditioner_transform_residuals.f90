program test_real_null_preconditioner_transform_residuals

    use kinds, only: IK, RK
    use errors, only: OK
    use options, only: config_t
    use testing, only: near_real_mat
    use krylov, only: real_null_preconditioner_t
    implicit none

    type(real_null_preconditioner_t) :: preconditioner
    type(config_t) :: config
    real(RK) :: residuals(4_IK, 2_IK), preconditioned(4_IK, 2_IK)
    integer(IK) :: error

    residuals = reshape((/1.0_RK, -1.0_RK, -3.0_RK, 3.0_RK, 1.5_RK, -1.5_RK, 0.5_RK, -0.5_RK/), (/4_IK, 2_IK/))

    error = config%initialize()
    if (error /= OK) stop 1

    error = preconditioner%initialize(4_IK, 2_IK, config)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%transform_residuals(4_IK, 2_IK, residuals, preconditioned)
    if (error /= OK) stop 1

    if (preconditioned /= near_real_mat(residuals)) stop 1

end program test_real_null_preconditioner_transform_residuals
