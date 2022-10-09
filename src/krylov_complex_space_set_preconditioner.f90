function krylov_complex_space_set_preconditioner(space, value) result(error)

    use kinds, only: IK, AK
    use errors, only: OK, INVALID_INPUT
    use krylov, only: complex_space_t, complex_null_preconditioner_t, &
                      complex_cg_preconditioner_t, complex_davidson_preconditioner_t, &
                      complex_jd_preconditioner_t, complex_jdall_preconditioner_t
    implicit none

    class(complex_space_t), intent(inout) :: space
    character(len=*, kind=AK), intent(in) :: value
    integer(IK) :: error

    if (space%config%validate_enum_option('preconditioner', value) /= OK) then
        error = INVALID_INPUT
        return
    end if

    if (associated(space%preconditioner)) deallocate (space%preconditioner)

    if (value == 'n') then
        allocate (complex_null_preconditioner_t :: space%preconditioner)
    else if (value == 'c') then
        allocate (complex_cg_preconditioner_t :: space%preconditioner)
    else if (value == 'd') then
        allocate (complex_davidson_preconditioner_t :: space%preconditioner)
    else if (value == 'j') then
        allocate (complex_jd_preconditioner_t :: space%preconditioner)
    else if (value == 'a') then
        allocate (complex_jdall_preconditioner_t :: space%preconditioner)
    end if

    error = OK

end function krylov_complex_space_set_preconditioner
