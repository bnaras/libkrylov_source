module utils

    use kinds, only: IK, RK, AK, LK
    implicit none

contains

    function lowercase(string)

        implicit none

        character(len=*, kind=AK), intent(in) :: string
        character(len=:, kind=AK), allocatable :: lowercase

        integer(IK), parameter :: shift = iachar('a', kind=IK) - iachar('A', kind=IK)
        integer(IK) :: pos
        character :: char

        allocate (character(len=len(string), kind=AK) :: lowercase)

        do pos = 1_IK, len(string)
            char = string(pos:pos)
            select case (char)
            case ('A':'Z')
                lowercase(pos:pos) = achar(iachar(char, kind=IK) + shift)
            case default
                lowercase(pos:pos) = char
            end select
        end do

    end function lowercase

    function count(string, sstring)

        ! Count occurrences of substring in string
        implicit none

        character(len=*, kind=AK), intent(in) :: string, sstring
        integer(IK) :: count

        integer(IK) :: pos, pos1

        if (len(sstring, kind=IK) == 0_IK) then
            count = len(string, kind=IK) - 1_IK
            return
        end if

        count = 0_IK
        pos = 1_IK
        pos1 = 0_IK
        do
            if (pos > len(string, kind=IK)) exit
            pos1 = index(string(pos:), sstring, kind=IK)
            if (pos1 == 0_IK) exit
            count = count + 1_IK
            pos = pos + pos1 + len(sstring, kind=IK) - 1_IK
        end do

    end function count

    function position(string, sstring, idx)

        ! Find index of substring number idx in string
        implicit none

        character(len=*, kind=AK), intent(in) :: string, sstring
        integer(IK), intent(in) :: idx
        integer(IK) :: position

        integer(IK) :: idx1, pos1

        if (len(string, kind=IK) == 0_IK) then
            position = 0_IK
            return
        end if

        if (len(sstring, kind=IK) == 0_IK) then
            position = max(idx, len(string, kind=IK))
            return
        end if

        if (idx < 1_IK) then
            position = 0_IK
            return
        end if

        position = 1_IK
        do idx1 = 1_IK, idx - 1_IK
            if (position > len(string, kind=IK)) exit
            pos1 = index(string(position:), sstring, kind=IK)
            if (pos1 == 0_IK) then
                position = len(string, kind=IK) + len(sstring, kind=IK) + 1_IK
                exit
            end if
            position = position + pos1 + len(sstring, kind=IK) - 1_IK
        end do

    end function position

    function contains(string, sstring, delim)

        implicit none

        ! Check if substring is present in delimited string
        character(len=*, kind=AK), intent(in) :: string, sstring, delim
        logical(LK) :: contains

        contains = find(string, sstring, delim) > 0_IK

    end function contains

    function substring(string, idx, delim)

        implicit none

        ! Retrieve substring by index from delimited string
        character(len=*, kind=AK), intent(in) :: string, delim
        integer(IK), intent(in) :: idx
        character(len=:, kind=AK), allocatable :: substring

        integer(IK) :: pos, pos1

        if (string == '') then
            substring = ''
            return
        end if

        if (idx > count(string, delim) + 1_IK) then
            substring = ''
            return
        end if

        pos = position(string, delim, idx)
        pos1 = position(string, delim, idx + 1_IK) - len(delim, kind=IK) - 1_IK
        substring = string(pos:pos1)

    end function substring

    function find(string, sstring, delim)

        implicit none

        ! Find index of substring in delimited string
        character(len=*, kind=AK), intent(in) :: string, sstring, delim
        integer(IK) :: find

        integer(IK) :: idx, pos, pos1

        find = 0_IK
        if (string == '') return

        do idx = 1_IK, count(string, delim) + 1_IK
            pos = position(string, delim, idx)
            pos1 = position(string, delim, idx + 1_IK) - len(delim, kind=IK) - 1_IK
            if (string(pos:pos1) == sstring) then
                find = idx
                exit
            end if
        end do

    end function find

    function longest(string, delim)

        implicit none

        ! Get length of longest substring in delimited string
        character(len=*, kind=AK), intent(in) :: string, delim
        integer(IK) :: longest

        integer(IK) :: idx, pos, pos1

        longest = 0_IK
        if (string == '') return

        do idx = 1_IK, count(string, delim) + 1_IK
            pos = position(string, delim, idx)
            pos1 = position(string, delim, idx + 1_IK) - len(delim, kind=IK) - 1_IK
            longest = max(longest, pos1 - pos + 1_IK)
        end do

    end function longest

    recursive function circle_sort(a, left, right, n) result(swapped)
        ! This code is a Fortran adaptation of a Forth algorithm laid out by "thebeez" at this URL;
        ! https://sourceforge.net/p/forth-4th/wiki/Circle%20sort/
        implicit none

        integer(IK), intent(in) :: left, right, n
        real(RK), intent(inout) :: a(n)
        logical(LK) :: swapped

        integer(IK) :: lo, hi, mid
        real(RK) :: tmp
        logical(LK) :: lefthalf, righthalf

        swapped = .false._LK
        if (right <= left) return
        ! Store the upper and lower bounds of list for recursion
        lo = left
        hi = right

        do while (lo < hi)
            ! Swap the pair of elements if hi < lo
            if (a(hi) < a(lo)) then
                swapped = .true._LK
                tmp = a(lo)
                a(lo) = a(hi)
                a(hi) = tmp
            end if
            lo = lo + 1_IK
            hi = hi - 1_IK
        end do

        ! Special case if array is an odd size (not even)
        if (lo == hi) then
            if (a(hi + 1_IK) < a(lo)) then
                swapped = .true._LK
                tmp = a(hi + 1_IK)
                a(hi + 1_IK) = a(lo)
                a(lo) = tmp
            end if
        end if
        mid = (left + right)/2_IK ! Bisection point
        lefthalf = circle_sort(a, left, mid, n)
        righthalf = circle_sort(a, mid + 1_IK, right, n)
        swapped = swapped .or. lefthalf .or. righthalf

    end function circle_sort

    recursive function circle_argsort(ind, a, left, right, n) result(swapped)
        implicit none

        ! This code is a Fortran adaptation of a Forth algorithm laid out by "thebeez" at this URL;
        ! https://sourceforge.net/p/forth-4th/wiki/Circle%20sort/
        ! This variant sorts index ind while comparing elements of a
        integer(IK), intent(in) :: left, right, n
        integer(IK), intent(inout) :: ind(n)
        real(RK), intent(in) :: a(n)
        logical(LK) :: swapped

        integer(IK) :: lo, hi, mid, tmp
        logical(LK) :: lefthalf, righthalf

        swapped = .false._LK
        if (right <= left) return
        ! Store the upper and lower bounds of list for recursion
        lo = left
        hi = right

        do while (lo < hi)
            ! Swap the pair of elements if hi < lo
            if (a(ind(hi)) < a(ind(lo))) then
                swapped = .true._LK
                tmp = ind(lo)
                ind(lo) = ind(hi)
                ind(hi) = tmp
            end if
            lo = lo + 1_IK
            hi = hi - 1_IK
        end do

        ! Special case if array is an odd size (not even)
        if (lo == hi) then
            if (a(ind(hi + 1_IK)) < a(ind(lo))) then
                swapped = .true._LK
                tmp = ind(hi + 1_IK)
                ind(hi + 1_IK) = ind(lo)
                ind(lo) = tmp
            end if
        end if
        mid = (left + right)/2_IK ! Bisection point
        lefthalf = circle_argsort(ind, a, left, mid, n)
        righthalf = circle_argsort(ind, a, mid + 1_IK, right, n)
        swapped = swapped .or. lefthalf .or. righthalf

    end function circle_argsort

    function real_argsort(a, n, index) result(error)

        use errors, only: OK
        implicit none

        integer(IK), intent(in) :: n
        real(RK), intent(in) :: a(n)
        integer(IK), intent(out) :: index(n)
        integer(IK) :: error

        integer(IK) :: i

        do i = 1_IK, n
            index(i) = i
        end do

        do while (circle_argsort(index, a, 1_IK, n, n))
        end do

        error = OK

    end function real_argsort

end module utils
