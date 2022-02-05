function krylov_get_num_spaces() result(num_spaces)

    use kinds, only: IK
    use krylov, only: spaces
    implicit none

    integer(IK) :: num_spaces

    num_spaces = size(spaces, kind=IK)

end function krylov_get_num_spaces
