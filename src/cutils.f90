module cutils

    use iso_c_binding, only: c_null_char
    use kinds, only: IK, AK
    implicit none

contains

    function string_c2f(string_c, length) result(string_f)

        implicit none
        character(len=1, kind=AK), intent(in) :: string_c(*)
        integer(IK), intent(in) :: length
        character(len=:, kind=AK), allocatable :: string_f

        integer(IK) :: length1, i

        length1 = length
        if (string_c(length1) == c_null_char) length1 = length1 - 1_IK
        allocate (character(len=length1, kind=AK) :: string_f)

        do i = 1_IK, length1
            string_f(i:i) = string_c(i)
        end do

    end function string_c2f

    function string_f2c(string_f, length) result(string_c)

        implicit none
        character(len=*, kind=AK), intent(in) :: string_f
        integer(IK), intent(in) :: length
        character(len=1, kind=AK), allocatable :: string_c(:)

        integer(IK) :: length1, i

        length1 = len(string_f, kind=IK)
        if (length1 > length - 1_IK) length1 = length - 1_IK
        allocate (string_c(length))
        do i = 1_IK, length1
            string_c(i) = string_f(i:i)
        end do
        string_c(length1 + 1_IK) = c_null_char

    end function string_f2c

end module cutils
