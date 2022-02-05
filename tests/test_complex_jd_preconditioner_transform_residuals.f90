program test_complex_jd_preconditioner_transform_residuals

    use kinds, only: IK, RK, CK
    use errors, only: OK, INCOMPLETE_PRECONDITIONER
    use options, only: config_t
    use blaswrapper, only: complex_dotc
    use testing, only: near_real_num, near_complex_mat
    use krylov, only: complex_jd_preconditioner_t
    implicit none

    type(complex_jd_preconditioner_t) :: preconditioner
    type(config_t) :: config
    complex(CK) :: residuals(4_IK, 2_IK), solutions(4_IK, 2_IK), preconditioned(4_IK, 2_IK), ref(4_IK, 2_IK)
    real(RK) :: diagonal(4_IK), eigenvalues(2_IK), dot_product
    integer(IK) :: error, sol1

    residuals = reshape((/(-1.098997719501211_CK, -0.681643539498055_CK), (0.570419000511414_CK, -0.285209500255707_CK), &
                          (0.570419000511414_CK, -0.285209500255707_CK), (-0.041840281521618_CK, 1.252062540009469_CK), &
                          (0.303651136225665_CK, 0.332207894338115_CK), (0.417878168675463_CK, -0.208939084337732_CK), &
                          (0.417878168675463_CK, -0.208939084337731_CK), (-1.139407473576592_CK, 0.085670274337349_CK)/), &
                        (/4_IK, 2_IK/))
    diagonal = (/3.0_RK, 3.0_RK, 1.0_RK, 1.0_RK/)
    eigenvalues = (/0.841687604822300_RK, 4.158312395177700_RK/)
    solutions = reshape((/(-0.264289359494898_CK, 0.132144679747449_CK), (-0.264289359494898_CK, -0.438274320763965_CK), &
                          (-0.264289359494898_CK, 0.702563680258863_CK), (-0.264289359494898_CK, 0.132144679747449_CK), &
                          (0.360764652450564_CK, -0.180382326225282_CK), (0.360764652450564_CK, -0.598260494900745_CK), &
                          (0.360764652450564_CK, 0.237495842450181_CK), (0.360764652450564_CK, -0.180382326225282_CK)/), &
                        (/4_IK, 2_IK/))
    ref = reshape((/(-0.593074333498670_CK, -0.410347350058333_CK), (0.416036270573562_CK, -0.289897445064533_CK), &
                    (-0.752829050228559_CK, -2.22824129484405_CK), (-1.40786352845058_CK, 6.62012792094962_CK), &
                    (-0.135531943429809_CK, -0.239560947211957_CK), (-0.131704685121161_CK, 0.132183092409743_CK), &
                    (-0.123444266074061_CK, 0.118484737114573_CK), (0.407201732719232_CK, -0.009799155587841408_CK)/), &
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

    if (preconditioner%get_status() /= INCOMPLETE_PRECONDITIONER) stop 1

    error = preconditioner%set_eigenvalues(2_IK, eigenvalues)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= INCOMPLETE_PRECONDITIONER) stop 1

    error = preconditioner%set_solutions(4_IK, 2_IK, solutions)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%transform_residuals(4_IK, 2_IK, residuals, preconditioned)
    if (error /= OK) stop 1

    if (preconditioned /= near_complex_mat(ref)) stop 1

    do sol1 = 1_IK, 2_IK
        dot_product = abs(complex_dotc(4_IK, preconditioned(:, sol1), 1_IK, solutions(:, sol1), 1_IK))
        if (dot_product /= near_real_num(0.0_RK)) stop 1
    end do

end program test_complex_jd_preconditioner_transform_residuals
