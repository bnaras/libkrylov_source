function krylov_complex_space_set_orthonormalizer(space, value) result(error)

    use kinds, only: IK
    use errors, only: OK, INVALID_INPUT
    use krylov, only: complex_space_t, complex_ortho_orthonormalizer_t, complex_nks_orthonormalizer_t, &
                      complex_semi_orthonormalizer_t
    implicit none

    class(complex_space_t), intent(inout) :: space
    character(len=*), intent(in) :: value
    integer(IK) :: error

    if (space%config%validate_enum_option('orthonormalizer', value) /= OK) then
        error = INVALID_INPUT
        return
    end if

    if (associated(space%orthonormalizer)) deallocate (space%orthonormalizer)

    if (value== 'o') then
        allocate (complex_ortho_orthonormalizer_t :: space%orthonormalizer)
    else if (value== 'n') then
        allocate (complex_nks_orthonormalizer_t :: space%orthonormalizer)
    else if (value== 's') then
        allocate (complex_semi_orthonormalizer_t :: space%orthonormalizer)
    end if

    error = OK

end function krylov_complex_space_set_orthonormalizer
