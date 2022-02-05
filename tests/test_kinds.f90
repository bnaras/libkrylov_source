program test_kinds

    use kinds, only: IK, RK, CK
    implicit none

    if (IK <= 0 .or. RK <= 0 .or. CK <= 0) stop 1

end program test_kinds
