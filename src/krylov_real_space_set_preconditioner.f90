function krylov_real_space_set_preconditioner(space, value) result(error)

    use kinds, only: IK, AK
    use errors, only: OK, INVALID_INPUT
    use krylov, only: real_space_t, real_null_preconditioner_t, real_cg_preconditioner_t, &
                      real_davidson_preconditioner_t, real_jd_preconditioner_t, &
                      real_jdall_preconditioner_t
    implicit none

    class(real_space_t), intent(inout) :: space
    character(len=*, kind=AK), intent(in) :: value
    integer(IK) :: error

    if (space%config%validate_enum_option('preconditioner', value) /= OK) then
        error = INVALID_INPUT
        return
    end if

    if (associated(space%preconditioner)) deallocate (space%preconditioner)

    if (value == 'n') then
        allocate (real_null_preconditioner_t :: space%preconditioner)
    else if (value == 'c') then
        allocate (real_cg_preconditioner_t :: space%preconditioner)
    else if (value == 'd') then
        allocate (real_davidson_preconditioner_t :: space%preconditioner)
    else if (value == 'j') then
        allocate (real_jd_preconditioner_t :: space%preconditioner)
    else if (value == 'a') then
        allocate (real_jdall_preconditioner_t :: space%preconditioner)
    end if

    error = OK

end function krylov_real_space_set_preconditioner
