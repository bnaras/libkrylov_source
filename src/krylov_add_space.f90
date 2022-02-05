function krylov_add_space(kind, structure, equation, full_dim, solution_dim, basis_dim) result(index)

    use kinds, only: IK
    use errors, only: OK, NO_SPACES, INVALID_KIND, INVALID_STRUCTURE, INVALID_EQUATION, INVALID_DIMENSION, &
                      INVALID_INPUT
    use options, only: config_t
    use utils, only: lowercase
    use krylov, only: real_space_t, complex_space_t, space_pointer_t, config, spaces, krylov_validate_enum_option
    implicit none

    character(len=1), intent(in) :: kind, structure, equation
    integer(IK), intent(in) :: full_dim, solution_dim, basis_dim
    integer(IK) :: index

    integer(IK) :: err
    character(len=1) :: kind_l, structure_l, equation_l
    type(space_pointer_t), allocatable  :: spaces_tmp(:)

    if (.not. allocated(spaces)) then
        index = NO_SPACES
        return
    end if

    kind_l = lowercase(kind)
    structure_l = lowercase(structure)
    equation_l = lowercase(equation)

    if (krylov_validate_enum_option('kind', kind_l) /= OK) then
        index = INVALID_KIND
        return
    end if

    if (krylov_validate_enum_option('structure', structure_l) /= OK) then
        index = INVALID_STRUCTURE
        return
    end if

    if (krylov_validate_enum_option('equation', equation_l) /= OK) then
        index = INVALID_EQUATION
        return
    end if

    if (full_dim <= 0_IK) then
        index = INVALID_DIMENSION
        return
    end if

    if (basis_dim > full_dim) then
        index = INVALID_DIMENSION
        return
    end if

    if (solution_dim > full_dim) then
        index = INVALID_DIMENSION
        return
    end if

    ! Number of eigenvectors cannot exceed basis size
    if (equation_l == 'e' .and. basis_dim < solution_dim) then
        index = INVALID_DIMENSION
        return
    end if

    index = size(spaces, kind=IK) + 1_IK

    allocate (spaces_tmp(index))
    spaces_tmp(1_IK:index - 1_IK) = spaces
    call move_alloc(spaces_tmp, spaces)

    if (kind_l == 'r' .and. structure_l == 's') then
        allocate (real_space_t :: spaces(index)%space_p)
    else if (kind_l == 'c' .and. structure_l == 'h') then
        allocate (complex_space_t :: spaces(index)%space_p)
    else
        index = INVALID_INPUT
    end if

    err = spaces(index)%space_p%initialize(equation, full_dim, solution_dim, basis_dim, config%link())
    if (err /= OK) then
        index = err
        return
    end if

end function krylov_add_space
