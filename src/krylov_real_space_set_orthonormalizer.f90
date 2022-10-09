function krylov_real_space_set_orthonormalizer(space, value) result(error)

    use kinds, only: IK, AK
    use errors, only: OK, INVALID_INPUT
    use krylov, only: real_space_t, real_ortho_orthonormalizer_t, real_nks_orthonormalizer_t, &
                      real_semi_orthonormalizer_t
    implicit none

    class(real_space_t), intent(inout) :: space
    character(len=*, kind=AK), intent(in) :: value
    integer(IK) :: error

    if (space%config%validate_enum_option('orthonormalizer', value) /= OK) then
        error = INVALID_INPUT
        return
    end if

    if (associated(space%orthonormalizer)) deallocate (space%orthonormalizer)

    if (value == 'o') then
        allocate (real_ortho_orthonormalizer_t :: space%orthonormalizer)
    else if (value == 'n') then
        allocate (real_nks_orthonormalizer_t :: space%orthonormalizer)
    else if (value == 's') then
        allocate (real_semi_orthonormalizer_t :: space%orthonormalizer)
    end if

    error = OK

end function krylov_real_space_set_orthonormalizer
