program test_utils

    use kinds, only: IK, RK
    use errors, only: OK
    use utils, only: lowercase, count, position, contains, substring, find, longest, circle_sort, &
                     circle_argsort, real_argsort
    use testing, only: near_real_vec
    implicit none

    integer(IK) :: ind(5_IK), error, i
    real(RK) :: a(5_IK), b(5_IK), c(5_IK), sorted(5_IK)

    ind = (/1_IK, 2_IK, 3_IK, 4_IK, 5_IK/)
    a = (/3.0_RK, 1.0_RK, 1.0_RK, -1.0_RK, 0.0_RK/)
    b = (/3.0_RK, 1.0_RK, 1.0_RK, -1.0_RK, 0.0_RK/)
    sorted = (/-1.0_RK, 0.0_RK, 1.0_RK, 1.0_RK, 3.0_RK/)

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

    if (position('', '', 1_IK) /= 0_IK) stop 1
    if (position('', ';', 1_IK) /= 0_IK) stop 1
    if (position(';', ';', 1_IK) /= 1_IK) stop 1
    if (position(';', ';', 2_IK) /= 2_IK) stop 1
    if (position('a', ';', 1_IK) /= 1_IK) stop 1
    if (position('a', ';', 2_IK) /= 3_IK) stop 1
    if (position('a;b', ';', 1_IK) /= 1_IK) stop 1
    if (position('a;b', ';', 2_IK) /= 3_IK) stop 1
    if (position('a;b', ';', 3_IK) /= 5_IK) stop 1
    if (position('ab;;cd', ';', 1_IK) /= 1_IK) stop 1
    if (position('ab;;cd', ';', 2_IK) /= 4_IK) stop 1
    if (position('ab;;cd', ';', 3_IK) /= 5_IK) stop 1
    if (position('ab;;cd', ';', 4_IK) /= 8_IK) stop 1
    if (position('a;b;', ';', 1_IK) /= 1_IK) stop 1
    if (position('a;b;', ';', 2_IK) /= 3_IK) stop 1
    if (position('a;b;', ';', 3_IK) /= 5_IK) stop 1
    if (position(';a;b', ';', 1_IK) /= 1_IK) stop 1
    if (position(';a;b', ';', 2_IK) /= 2_IK) stop 1
    if (position(';a;b', ';', 3_IK) /= 4_IK) stop 1
    if (position(';a;b', ';', 4_IK) /= 6_IK) stop 1

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

    if (substring('', 1_IK, ';') /= '') stop 1
    if (substring('a', 1_IK, ';') /= 'a') stop 1
    if (substring('a', 2_IK, ';') /= '') stop 1
    if (substring('ab', 1_IK, ';') /= 'ab') stop 1
    if (substring('a;b', 1_IK, ';') /= 'a') stop 1
    if (substring('a;b', 2_IK, ';') /= 'b') stop 1
    if (substring('ab;ac', 1_IK, ';') /= 'ab') stop 1
    if (substring('ab;ac', 2_IK, ';') /= 'ac') stop 1
    if (substring('ab;;ac', 1_IK, ';;') /= 'ab') stop 1
    if (substring('ab;;ac', 2_IK, ';;') /= 'ac') stop 1

    if (find('', '', ';') /= 0_IK) stop 1
    if (find('', 'a', ';') /= 0_IK) stop 1
    if (find('a', 'a', ';') /= 1_IK) stop 1
    if (find('ab', 'a', ';') /= 0_IK) stop 1
    if (find('a;b', 'a', ';') /= 1_IK) stop 1
    if (find('a;b', 'b', ';') /= 2_IK) stop 1
    if (find('a;b', 'ab', ';') /= 0_IK) stop 1
    if (find('ab;;ac', 'ab', ';;') /= 1_IK) stop 1
    if (find('ab;;ac', 'ac', ';;') /= 2_IK) stop 1
    if (find('ab;;ac', 'ba', ';;') /= 0_IK) stop 1

    if (longest('', ';') /= 0_IK) stop 1
    if (longest('a', ';') /= 1_IK) stop 1
    if (longest('a;b', ';') /= 1_IK) stop 1
    if (longest('ab;ac', ';') /= 2_IK) stop 1
    if (longest('a;bc', ';') /= 2_IK) stop 1
    if (longest('ab;c', ';') /= 2_IK) stop 1

    do while (circle_sort(a, 1_IK, 5_IK, 5_IK))
    end do
    if (near_real_vec(a) /= sorted) stop 1

    do while(circle_argsort(ind, b, 1_IK, 5_IK, 5_IK))
    end do

    do i = 1_IK, 5_IK
        c(i) = b(ind(i))
    end do
    if (near_real_vec(c) /= sorted) stop 1

    error = real_argsort(b, 5_IK, ind)
    if (error /= OK) stop 1

    do i = 1_IK, 5_IK
        c(i) = b(ind(i))
    end do
    if (near_real_vec(c) /= sorted) stop 1


end program test_utils
