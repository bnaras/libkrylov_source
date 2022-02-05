program test_utils

    use kinds, only: IK
    use utils, only: lowercase, count, find, contains
    implicit none

    if (lowercase('A') /= 'a') stop 1
    if (lowercase('a') /= 'a') stop 1
    if (lowercase('AA') /= 'aa') stop 1
    if (lowercase('Aa') /= 'aa') stop 1
    if (lowercase('aa') /= 'aa') stop 1
    if (lowercase('AbCdeF') /= 'abcdef') stop 1
    if (lowercase('0') /= '0') stop 1

    if (count('', 'a') /= 0_IK) stop 1
    if (count('a', '') /= 0_IK) stop 1
    if (count('ab', '') /= 1_IK) stop 1
    if (count('aaaa', 'a') /= 4_IK) stop 1
    if (count('aaaa', 'aa') /= 2_IK) stop 1
    if (count('aaaaa', 'aa') /= 2_IK) stop 1
    if (count('ababa', 'aba') /= 1_IK) stop 1
    if (count('aa', 'b') /= 0_IK) stop 1
    if (count('a', 'aa') /= 0_IK) stop 1

    if (find('', '', 1_IK) /= 0_IK) stop 1
    if (find('', ';', 1_IK) /= 0_IK) stop 1
    if (find(';', ';', 1_IK) /= 1_IK) stop 1
    if (find(';', ';', 2_IK) /= 2_IK) stop 1
    if (find('a', ';', 1_IK) /= 1_IK) stop 1
    if (find('a', ';', 2_IK) /= 3_IK) stop 1
    if (find('a;b', ';', 1_IK) /= 1_IK) stop 1
    if (find('a;b', ';', 2_IK) /= 3_IK) stop 1
    if (find('a;b', ';', 3_IK) /= 5_IK) stop 1
    if (find('ab;;cd', ';', 1_IK) /= 1_IK) stop 1
    if (find('ab;;cd', ';', 2_IK) /= 4_IK) stop 1
    if (find('ab;;cd', ';', 3_IK) /= 5_IK) stop 1
    if (find('ab;;cd', ';', 4_IK) /= 8_IK) stop 1
    if (find('a;b;', ';', 1_IK) /= 1_IK) stop 1
    if (find('a;b;', ';', 2_IK) /= 3_IK) stop 1
    if (find('a;b;', ';', 3_IK) /= 5_IK) stop 1
    if (find(';a;b', ';', 1_IK) /= 1_IK) stop 1
    if (find(';a;b', ';', 2_IK) /= 2_IK) stop 1
    if (find(';a;b', ';', 3_IK) /= 4_IK) stop 1
    if (find(';a;b', ';', 4_IK) /= 6_IK) stop 1

    if (contains('', '', ';')) stop 1
    if (contains('', 'a', ';')) stop 1
    if (.not. contains('a', 'a', ';')) stop 1
    if (contains('ab', 'a', ';')) stop 1
    if (.not. contains('a;b', 'a', ';')) stop 1
    if (.not. contains('a;b', 'b', ';')) stop 1
    if (contains('a;b', 'ab', ';')) stop 1
    if (.not. contains('ab;;ac', 'ab', ';;')) stop 1
    if (.not. contains('ab;;ac', 'ac', ';;')) stop 1
    if (contains('ab;;ac', 'ba', ';;')) stop 1

end program test_utils
