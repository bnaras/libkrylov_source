module utils

    implicit none

contains

    function lowercase(string)

        use kinds, only: IK
        implicit none

        character(len=*), intent(in) :: string
        character(len=:), allocatable :: lowercase

        integer(IK), parameter :: shift = iachar('a', kind=IK) - iachar('A', kind=IK)
        integer(IK) :: pos
        character :: char

        allocate (character(len=len(string)) :: lowercase)

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

    function count(string, substring)

        ! Count occurrences of substring in string

        use kinds, only: IK
        implicit none

        character(len=*), intent(in) :: string, substring
        integer(IK) :: count

        integer(IK) :: pos, pos1

        if (len(substring, kind=IK) == 0_IK) then
            count = len(string, kind=IK) - 1_IK
            return
        end if

        count = 0_IK
        pos = 1_IK
        pos1 = 0_IK
        do
            if (pos > len(string, kind=IK)) exit
            pos1 = index(string(pos:), substring, kind=IK)
            if (pos1 == 0_IK) exit
            count = count + 1_IK
            pos = pos + pos1 + len(substring, kind=IK) - 1_IK
        end do

    end function count

    function find(string, substring, idx) result(pos)

        ! Find index of substring number idx in string

        use kinds, only: IK
        implicit none

        character(len=*), intent(in) :: string, substring
        integer(IK), intent(in) :: idx
        integer(IK) :: pos

        integer(IK) :: idx1, pos1

        if (len(string, kind=IK) == 0_IK) then
            pos = 0_IK
            return
        end if

        if (len(substring, kind=IK) == 0_IK) then
            pos = max(idx, len(string, kind=IK))
            return
        end if

        if (idx < 1_IK) then
            pos = 0_IK
            return
        end if

        pos = 1_IK
        do idx1 = 1_IK, idx - 1_IK
            if (pos > len(string, kind=IK)) exit
            pos1 = index(string(pos:), substring, kind=IK)
            if (pos1 == 0_IK) then
                pos = len(string, kind=IK) + len(substring, kind=IK) + 1_IK
                exit
            end if
            pos = pos + pos1 + len(substring, kind=IK) - 1_IK
        end do

    end function find

    function contains(string, substring, delim)

        use kinds, only: IK
        implicit none

        character(len=*), intent(in) :: string, substring, delim
        logical :: contains

        integer(IK) :: idx, pos, pos1

        contains = .false.
        if (string == '') then
            return
        end if

        do idx = 1_IK, count(string, delim) + 1_IK
            pos = find(string, delim, idx)
            pos1 = find(string, delim, idx + 1_IK) - len(delim, kind=IK) - 1_IK
            if (string(pos:pos1) == substring) then
                contains = .true.
                exit
            end if
        end do

    end function contains

    recursive logical function circle_sort(a, left, right, n) result(swapped)
        ! This code is a Fortran adaptation of a Forth algorithm laid out by "thebeez" at this URL;
        ! https://sourceforge.net/p/forth-4th/wiki/Circle%20sort/
        use kinds, only: IK, RK
        implicit none

        integer(IK), intent(in) :: left, right, n
        real(IK), intent(inout) :: a(n)
        integer(IK) :: lo, hi, mid
        real(RK) :: tmp
        logical :: lefthalf, righthalf

        swapped = .false.
        if (right <= left) return
        lo = left   !Store the upper and lower bounds of list for
        hi = right  !Recursion later

        do while (lo < hi)
        ! Swap the pair of elements if hi < lo
            if (a(hi) < a(lo)) then
                swapped = .true.
                tmp = a(lo)
                a(lo) = a(hi)
                a(hi) = tmp
            endif
            lo = lo + 1_IK
            hi = hi - 1_IK
        end do

        ! Special case if array is an odd size (not even)
        if (lo == hi)then
            if(a(hi+1_IK) < a(lo))then
                swapped = .true.
                tmp = a(hi+1_IK)
                a(hi+1_IK) = a(lo)
                a(lo) = tmp
            endif
        endif
        mid = (left + right) / 2_IK ! Bisection point
        lefthalf = circle_sort(a, left, mid,n)
        righthalf = circle_sort(a, mid + 1_IK, right,n)
        swapped = swapped .or. lefthalf .or. righthalf

    end function circle_sort

    function real_argsort(a, n, index) result(error)
        
        use kinds, only: IK, RK
        use errors, only: OK
        implicit none

        integer(IK), intent(in) :: n
        real(RK), intent(in) :: a(n)
        integer(IK), intent(out) :: index(n)
        integer(IK) :: error

        real(RK) :: tmp(n)
        integer(IK) :: i, j
    
        tmp = a
        do while (circle_sort(tmp, 1_IK, n, n))
        end do

        do i = 1_IK, n
            do j = 1_IK, n
                if (tmp(i) == a(j)) index(i) = j
            end do
        end do

        error = OK

    end function real_argsort

end module utils
