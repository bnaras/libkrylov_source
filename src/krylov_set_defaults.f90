function krylov_set_defaults() result(error)

    use kinds, only: IK, RK
    use errors, only: OK, NO_OPTIONS
    use krylov, only: config
    implicit none

    integer(IK) :: error

    integer(IK) :: err

    if (.not. allocated(config)) then
        error = NO_OPTIONS
        return
    end if

    err = config%define_enum_option('kind', 'r;c')
    if (err /= OK) then
        error = err
        return
    end if

    err = config%define_enum_option('structure', 's;h')
    if (err /= OK) then
        error = err
        return
    end if

    err = config%define_enum_option('equation', 'e;l;h;s')
    if (err /= OK) then
        error = err
        return
    end if

    err = config%define_enum_option('preconditioner', 'n;c;d;j;a')
    if (err /= OK) then
        error = err
        return
    end if
    err = config%set_enum_option('preconditioner', 'n')
    if (err /= OK) then
        error = err
        return
    end if

    err = config%define_enum_option('orthonormalizer', 'o;n;s')
    if (err /= OK) then
        error = err
        return
    end if
    err = config%set_enum_option('orthonormalizer', 'o')
    if (err /= OK) then
        error = err
        return
    end if

    err = config%set_integer_option('max_iterations', 50_IK)
    if (err /= OK) then
        error = err
        return
    end if

    err = config%set_real_option('max_residual_norm', 10.0_RK**nint(log10(epsilon(1.0_RK)) / 2.0_RK))
    if (err /= OK) then
        error = err
        return
    end if

    err = config%set_real_option('min_gram_rcond', 1000.0_RK * epsilon(1.0_RK))
    if (err /= OK) then
        error = err
        return
    end if

    err = config%set_real_option('min_basis_vector_norm', 10.0_RK**nint(log10(epsilon(1.0_RK)) / 2.0_RK))
    if (err /= OK) then
        error = err
        return
    end if

    err = config%set_real_option('min_basis_vector_singular_value', 1000.0_RK * epsilon(1.0_RK))
    if (err /= OK) then
        error = err
        return
    end if

    err = config%set_real_option('min_diagonal_scaling', 1.0E-6_RK)
    if (err /= OK) then
        error = err
        return
    end if

    error = OK

end function krylov_set_defaults
