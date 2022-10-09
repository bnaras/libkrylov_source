program test_logging

    use kinds, only: IK, RK, CK, LK
    use logging, only: fmt, fmt_vec, fmt_mat

    implicit none

    if (fmt('abc') /= 'abc') stop 1
    if (fmt(1_IK) /= '1') stop 1
    if (fmt(-1.0_RK) /= '-1.00000000000') stop 1
    if (fmt((1.0_CK, 1.0_CK)) /= '(1.00000000000,1.00000000000)') stop 1
    if (fmt(.true._LK) /= 'T') stop 1
    if (fmt_vec((/1_IK, 2_IK/)) /= '1       2') stop 1
    if (fmt_vec((/1.0_RK, 2.0_RK/)) /= '1.00000000000       2.00000000000') stop 1
    if (fmt_vec((/(1.0_CK, 0.0_CK), (0.0_CK, 1.0_CK)/)) /= &
        '(   1.00000000000    ,   0.00000000000    )(   0.00000000000    ,   1.00000000000    )') stop 1
    if (fmt_mat(reshape((/1_IK, 2_IK, 3_IK, 4_IK/), (/2_IK, 2_IK/))) /= '1       2       3       4') stop 1
    if (fmt_mat(reshape((/1.0_RK, 2.0_RK, 3.0_RK, 4.0_RK/), (/2_IK, 2_IK/))) /= &
        '1.00000000000       2.00000000000       3.00000000000       4.00000000000') stop 1
    if (fmt_mat(reshape((/(1.0_CK, 0.0_CK), (0.0_CK, 1.0_CK)/), (/2_IK, 1_IK/))) /= &
        '(   1.00000000000    ,   0.00000000000    )(   0.00000000000    ,   1.00000000000    )') stop 1

end program test_logging
