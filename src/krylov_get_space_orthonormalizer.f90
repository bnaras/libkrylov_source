function krylov_get_space_orthonormalizer(index) result(orthonormalizer)

    use kinds, only: IK
    use krylov, only: spaces, krylov_get_num_spaces
    implicit none

    integer(IK), intent(in) :: index
    character(len=1) :: orthonormalizer

    if (index > krylov_get_num_spaces()) then
        orthonormalizer = ''
        return
    end if

    orthonormalizer = spaces(index)%space_p%config%get_enum_option('orthonormalizer')

end function krylov_get_space_orthonormalizer
