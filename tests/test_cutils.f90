program test_cutils

    use iso_c_binding, only: c_null_char
    use kinds, only: IK, AK
    use cutils, only: string_c2f, string_f2c
    implicit none

    character(len=4, kind=AK) :: sf1, sf2, sf3, sf4
    character(len=1, kind=AK) :: sc1(4_IK), sc2(4_IK), sc3(4_IK), sc4(4_IK)

    sf1 = 'abc'
    sf2 = 'abcd'

    sc1 = (/'a', 'b', 'c', c_null_char/)
    sc2 = (/'a', 'b', 'c', 'd'/)

    sf3 = string_c2f(sc1, 4_IK)
    if (sf3 /= 'abc') stop 1
    sf4 = string_c2f(sc2, 4_IK)
    if (sf4 /= 'abcd') stop 1

    sc3 = string_f2c(sf1, 4_IK)
    if (any(sc3 /= (/'a', 'b', 'c', c_null_char/))) stop 1
    sc4 = string_f2c(sf2, 4_IK)
    if (any(sc4 /= (/'a', 'b', 'c', c_null_char/))) stop 1

end program test_cutils
