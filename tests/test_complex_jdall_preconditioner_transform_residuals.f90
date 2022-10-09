program test_complex_jdall_preconditioner_transform_residuals

    use kinds, only: IK, RK, CK
    use errors, only: OK, INCOMPLETE_PRECONDITIONER
    use blaswrapper, only: complex_dotc
    use options, only: config_t
    use testing, only: near_real_num, near_complex_mat
    use krylov, only: complex_jdall_preconditioner_t
    implicit none

    type(complex_jdall_preconditioner_t) :: preconditioner
    type(config_t) :: config
    complex(CK) :: residuals(4_IK, 2_IK), preconditioned(4_IK, 2_IK), ref1(4_IK, 2_IK), ref2(4_IK, 2_IK), &
                   ref3(4_IK, 2_IK), solutions(4_IK, 2_IK)
    real(RK) :: diagonal(4_IK), eigenvalues(2_IK), shifts(2_IK), dot_product
    integer(IK) :: error, sol1, sol2

    residuals = reshape((/(-1.098997719501211_CK, -0.681643539498055_CK), (0.570419000511414_CK, -0.285209500255707_CK), &
                          (0.570419000511414_CK, -0.285209500255707_CK), (-0.041840281521618_CK, 1.252062540009469_CK), &
                          (0.303651136225665_CK, 0.332207894338115_CK), (0.417878168675463_CK, -0.208939084337732_CK), &
                          (0.417878168675463_CK, -0.208939084337731_CK), (-1.139407473576592_CK, 0.085670274337349_CK)/), &
                        (/4_IK, 2_IK/))
    diagonal = (/3.0_RK, 3.0_RK, 1.0_RK, 1.0_RK/)
    eigenvalues = (/0.841687604822300_RK, 4.158312395177700_RK/)
    shifts = (/13.0_RK, 2.0_RK/)
    solutions = reshape((/(-0.264289359494898_CK, 0.132144679747449_CK), (-0.264289359494898_CK, -0.438274320763965_CK), &
                          (-0.264289359494898_CK, 0.702563680258863_CK), (-0.264289359494898_CK, 0.132144679747449_CK), &
                          (0.360764652450564_CK, -0.180382326225282_CK), (0.360764652450564_CK, -0.598260494900745_CK), &
                          (0.360764652450564_CK, 0.237495842450181_CK), (0.360764652450564_CK, -0.180382326225282_CK)/), &
                        (/4_IK, 2_IK/))
    ref1 = reshape((/(0.09910850981058694_CK, -1.46596966520125_CK), (0.404470903787542_CK, -2.43766911662543_CK), &
                    (0.404470903787542_CK, -2.43766911662543_CK), (-0.908050317385670_CK, 6.34130789845211_CK), &
                    (-0.135286744668962_CK, -0.242374587590648_CK), (-0.133335246612775_Ck, 0.126813949747582_CK), &
                    (-0.133335246612775_CK, 0.126813949747582_CK), (0.401957237894511_CK, -0.01125331190451549_CK)/), &
                    (/4_IK, 2_IK/))
    ref2 = reshape((/(0.10926122623537732_CK, 0.05920152282242624_CK), (-0.05689851295869495_CK, 0.02143145865150771_CK), &
                    (-0.05689851295869495_CK, 0.02143145865150772_CK), (0.00453579968201257_CK, -0.10206444012544169_CK), &
                    (-0.88594135510180627_CK, -0.83415126421843988_CK), (-0.86668047751197896_CK, 0.48031511024189699_CK), &
                    (-0.86668047751197885_CK, 0.48031511024189677_CK), (2.6193023101257644_CK, -0.12647895626535388_CK)/), &
                    (/4_IK, 2_IK/))
    ref3 = reshape((/(-0.38951059399888827_CK,-0.33287715982141025_CK), (0.25044246900798012_CK,-0.30109872011094141_CK), &
                     (0.25044246900798017_CK,-0.30109872011094141_CK), (-0.11137434401707180_CK,0.93507460004329324_CK), &
                     (0.18983308247892272_CK,0.11252637123951605_CK), (0.34186313994328305_CK,-0.10178393247864914_CK), &
                     (0.34186313994328310_CK,-0.10178393247864914_CK), (-0.87355936236548881_CK,9.10414937177821959E-002_CK)/), &
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

    if (preconditioner%get_status() /= INCOMPLETE_PRECONDITIONER) stop 1

    error = preconditioner%set_solutions(4_IK, 2_IK, solutions)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%set_eigenvalues(2_IK, eigenvalues)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%transform_residuals(4_IK, 2_IK, residuals, preconditioned)
    if (error /= OK) stop 1

    if (preconditioned /= near_complex_mat(ref1)) stop 1

    do sol1 = 1_IK, 2_IK
        do sol2 = 1_IK, 2_IK
            dot_product = abs(complex_dotc(4_IK, residuals(:, sol1), 1_IK, solutions(:, sol2), 1_IK))
            if (dot_product /= near_real_num(0.0_RK)) stop 1
        end do
    end do

    do sol1 = 1_IK, 2_IK
        do sol2 = 1_IK, 2_IK
            dot_product = abs(complex_dotc(4_IK, preconditioned(:, sol1), 1_IK, solutions(:, sol2), 1_IK))
            if (dot_product /= near_real_num(0.0_RK)) stop 1
        end do
    end do

    ! Test with ('has_shifts' == .true.)
    error = preconditioner%initialize(4_IK, 2_IK, config)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= INCOMPLETE_PRECONDITIONER) stop 1

    error = preconditioner%set_diagonal(4_IK, diagonal)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= INCOMPLETE_PRECONDITIONER) stop 1

    error = preconditioner%set_solutions(4_IK, 2_IK, solutions)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%set_shifts(2_IK, shifts)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%transform_residuals(4_IK, 2_IK, residuals, preconditioned)
    if (error /= OK) stop 1

    if (preconditioned /= near_complex_mat(ref2)) stop 1

    do sol1 = 1_IK, 2_IK
        do sol2 = 1_IK, 2_IK
            dot_product = abs(complex_dotc(4_IK, residuals(:, sol1), 1_IK, solutions(:, sol2), 1_IK))
            if (dot_product /= near_real_num(0.0_RK)) stop 1
        end do
    end do

    do sol1 = 1_IK, 2_IK
        do sol2 = 1_IK, 2_IK
            dot_product = abs(complex_dotc(4_IK, preconditioned(:, sol1), 1_IK, solutions(:, sol2), 1_IK))
            if (dot_product /= near_real_num(0.0_RK)) stop 1
        end do
    end do

   ! Test with ('has_eigenvalues' .and. 'has_shifts' == .false.)
    error = preconditioner%initialize(4_IK, 2_IK, config)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= INCOMPLETE_PRECONDITIONER) stop 1

    error = preconditioner%set_diagonal(4_IK, diagonal)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= INCOMPLETE_PRECONDITIONER) stop 1

    error = preconditioner%set_solutions(4_IK, 2_IK, solutions)
    if (error /= OK) stop 1

    if (preconditioner%get_status() /= OK) stop 1

    error = preconditioner%transform_residuals(4_IK, 2_IK, residuals, preconditioned)
    if (error /= OK) stop 1

    if (preconditioned /= near_complex_mat(ref3)) stop 1

    do sol1 = 1_IK, 2_IK
        do sol2 = 1_IK, 2_IK
            dot_product = abs(complex_dotc(4_IK, residuals(:, sol1), 1_IK, solutions(:, sol2), 1_IK))
            if (dot_product /= near_real_num(0.0_RK)) stop 1
        end do
    end do

    do sol1 = 1_IK, 2_IK
        do sol2 = 1_IK, 2_IK
            dot_product = abs(complex_dotc(4_IK, preconditioned(:, sol1), 1_IK, solutions(:, sol2), 1_IK))
            if (dot_product /= near_real_num(0.0_RK)) stop 1
        end do
    end do

end program test_complex_jdall_preconditioner_transform_residuals
