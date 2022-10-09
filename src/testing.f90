module testing

    use kinds, only: IK, RK, CK, LK
    implicit none

    real(RK), parameter :: default_thr = 100.0_RK * epsilon(0.0_RK)

    type near_real_num_t
        real(RK) :: num
        logical(LK) :: fix_phase = .false._LK
        real(RK) :: thr = default_thr
    contains
        procedure::  near_real_num_eq_near_real_num, near_real_num_eq_num, near_real_num_ne_near_real_num, &
            near_real_num_ne_num
        procedure, pass(x2) :: num_eq_near_real_num, num_ne_near_real_num
        generic :: operator(==) => near_real_num_eq_near_real_num, near_real_num_eq_num, num_eq_near_real_num
        generic :: operator(/=) => near_real_num_ne_near_real_num, near_real_num_ne_num, num_ne_near_real_num
    end type near_real_num_t

    type near_real_vec_t
        integer(IK) :: dim
        real(RK), allocatable :: vec(:)
        logical(LK) :: fix_phase = .false._LK
        real(RK) :: thr = default_thr
    contains
        procedure :: near_real_vec_eq_near_real_vec, near_real_vec_eq_vec, near_real_vec_ne_near_real_vec, &
            near_real_vec_ne_vec
        procedure, pass(v2) :: vec_eq_near_real_vec, vec_ne_near_real_vec
        generic :: operator(==) => near_real_vec_eq_near_real_vec, near_real_vec_eq_vec, vec_eq_near_real_vec
        generic :: operator(/=) => near_real_vec_ne_near_real_vec, near_real_vec_ne_vec, vec_ne_near_real_vec
    end type near_real_vec_t

    type near_real_mat_t
        integer(IK) :: dim1, dim2
        real(RK), allocatable :: mat(:, :)
        logical(LK) :: fix_phase = .false._LK
        real(RK) :: thr = default_thr
    contains
        procedure :: near_real_mat_eq_near_real_mat, near_real_mat_eq_mat, near_real_mat_ne_near_real_mat, &
            near_real_mat_ne_mat
        procedure, pass(m2) :: mat_eq_near_real_mat, mat_ne_near_real_mat
        generic :: operator(==) => near_real_mat_eq_near_real_mat, near_real_mat_eq_mat, mat_eq_near_real_mat
        generic :: operator(/=) => near_real_mat_ne_near_real_mat, near_real_mat_ne_mat, mat_ne_near_real_mat
    end type near_real_mat_t

    type near_complex_num_t
        complex(CK) :: num
        logical(LK) :: fix_phase = .false._LK
        real(RK) :: thr = default_thr
    contains
        procedure::  near_complex_num_eq_near_complex_num, near_complex_num_eq_num, &
            near_complex_num_ne_near_complex_num, near_complex_num_ne_num
        procedure, pass(x2) :: num_eq_near_complex_num, num_ne_near_complex_num
        generic :: operator(==) => near_complex_num_eq_near_complex_num, near_complex_num_eq_num, &
            num_eq_near_complex_num
        generic :: operator(/=) => near_complex_num_ne_near_complex_num, near_complex_num_ne_num, &
            num_ne_near_complex_num
    end type near_complex_num_t

    type near_complex_vec_t
        integer(IK) :: dim
        complex(CK), allocatable :: vec(:)
        logical(LK) :: fix_phase = .false._LK
        real(RK) :: thr = default_thr
    contains
        procedure :: near_complex_vec_eq_near_complex_vec, near_complex_vec_eq_vec, &
            near_complex_vec_ne_near_complex_vec, near_complex_vec_ne_vec
        procedure, pass(v2) :: vec_eq_near_complex_vec, vec_ne_near_complex_vec
        generic :: operator(==) => near_complex_vec_eq_near_complex_vec, near_complex_vec_eq_vec, &
            vec_eq_near_complex_vec
        generic :: operator(/=) => near_complex_vec_ne_near_complex_vec, near_complex_vec_ne_vec, &
            vec_ne_near_complex_vec
    end type near_complex_vec_t

    type near_complex_mat_t
        integer(IK) :: dim1, dim2
        complex(CK), allocatable :: mat(:, :)
        logical(LK) :: fix_phase = .false._LK
        real(RK) :: thr = default_thr
    contains
        procedure :: near_complex_mat_eq_near_complex_mat, near_complex_mat_eq_mat, &
            near_complex_mat_ne_near_complex_mat, near_complex_mat_ne_mat
        procedure, pass(m2) :: mat_eq_near_complex_mat, mat_ne_near_complex_mat
        generic :: operator(==) => near_complex_mat_eq_near_complex_mat, near_complex_mat_eq_mat, &
            mat_eq_near_complex_mat
        generic :: operator(/=) => near_complex_mat_ne_near_complex_mat, near_complex_mat_ne_mat, &
            mat_ne_near_complex_mat
    end type near_complex_mat_t

contains

    function near_real_num(x, fix_phase, thr) result(x_near)
        implicit none
        real(RK), intent(in) :: x
        logical(LK), intent(in), optional :: fix_phase
        real(RK), intent(in), optional :: thr
        type(near_real_num_t) :: x_near

        logical(LK) :: fix_phase1
        real(RK) :: thr1

        fix_phase1 = .false._LK
        if (present(fix_phase)) fix_phase1 = fix_phase

        thr1 = default_thr
        if (present(thr)) thr1 = thr

        x_near = near_real_num_t(x, fix_phase1, thr1)
    end function near_real_num

    function near_real_vec(v, fix_phase, thr) result(v_near)
        implicit none
        real(RK), intent(in) :: v(:)
        logical(LK), intent(in), optional :: fix_phase
        real(RK), intent(in), optional :: thr
        type(near_real_vec_t) :: v_near

        logical(LK) :: fix_phase1
        real(RK) :: thr1

        fix_phase1 = .false._LK
        if (present(fix_phase)) fix_phase1 = fix_phase

        thr1 = default_thr
        if (present(thr)) thr1 = thr

        v_near = near_real_vec_t(size(v, kind=IK), v, fix_phase1, thr1)
    end function near_real_vec

    function near_real_mat(m, fix_phase, thr) result(m_near)
        implicit none
        real(RK), intent(in) :: m(:, :)
        logical(LK), intent(in), optional :: fix_phase
        real(RK), intent(in), optional :: thr
        type(near_real_mat_t) :: m_near

        logical(LK) :: fix_phase1
        real(RK) :: thr1

        fix_phase1 = .false._LK
        if (present(fix_phase)) fix_phase1 = fix_phase

        thr1 = default_thr
        if (present(thr)) thr1 = thr

        m_near = near_real_mat_t(size(m, 1_IK, kind=IK), size(m, 2_IK, kind=IK), m, fix_phase1, thr1)
    end function near_real_mat

    function fix_phase_real_num(x, thr) result(x_out)
        implicit none
        real(RK), intent(in) :: x
        real(RK), intent(in), optional :: thr
        real(RK) :: x_out

        real(RK) :: thr1

        thr1 = default_thr
        if (present(thr)) thr1 = thr

        x_out = x
        if (x_out < -thr1) x_out = -x_out
    end function fix_phase_real_num

    function fix_phase_real_vec(v, thr) result(v_out)
        implicit none
        real(RK), intent(in) :: v(:)
        real(RK), intent(in), optional :: thr
        real(RK), allocatable :: v_out(:)

        real(RK) :: thr1
        integer(IK) :: dim, i

        thr1 = default_thr
        if (present(thr)) thr1 = thr

        v_out = v
        dim = size(v_out, kind=IK)
        do i = 1_IK, dim
            if (abs(v_out(i)) >= thr1) exit
        end do

        if (i == dim + 1_IK) return
        if (v_out(i) < -thr1) v_out = -v_out
    end function fix_phase_real_vec

    function fix_phase_real_mat(m, thr) result(m_out)
        implicit none
        real(RK), intent(in) :: m(:, :)
        real(RK), intent(in), optional :: thr
        real(RK), allocatable :: m_out(:, :)

        real(RK) :: thr1
        integer(IK) :: dim1, dim2, i, j

        thr1 = default_thr
        if (present(thr)) thr1 = thr

        m_out = m
        dim1 = size(m_out, 1_IK, kind=IK)
        dim2 = size(m_out, 2_IK, kind=IK)
        do j = 1_IK, dim2
            do i = 1_IK, dim1
                if (abs(m_out(i, j)) >= thr1) exit
            end do

            if (i == dim1 + 1_IK) cycle
            if (m_out(i, j) < -thr1) m_out(:, j) = -m_out(:, j)
        end do
    end function fix_phase_real_mat

    function near_real_num_eq_near_real_num(x1, x2) result(eq)
        implicit none
        class(near_real_num_t), intent(in) :: x1, x2
        logical(LK) :: eq

        logical(LK) :: fix_phase
        real(RK) :: thr, num1, num2

        fix_phase = x1%fix_phase .or. x2%fix_phase
        thr = min(x1%thr, x2%thr)

        num1 = x1%num
        num2 = x2%num
        if (fix_phase) then
            num1 = fix_phase_real_num(num1, thr)
            num2 = fix_phase_real_num(num2, thr)
        end if

        eq = abs(num1 - num2) < thr
    end function near_real_num_eq_near_real_num

    function near_real_num_eq_num(x1, x2) result(eq)
        implicit none
        class(near_real_num_t), intent(in) :: x1
        real(RK), intent(in) :: x2
        logical(LK) :: eq

        eq = near_real_num_eq_near_real_num(x1, near_real_num(x2, x1%fix_phase, x1%thr))
    end function near_real_num_eq_num

    function num_eq_near_real_num(x1, x2) result(eq)
        implicit none
        real(RK), intent(in) :: x1
        class(near_real_num_t), intent(in) :: x2
        logical(LK) :: eq

        eq = near_real_num_eq_near_real_num(near_real_num(x1, x2%fix_phase, x2%thr), x2)
    end function num_eq_near_real_num

    function near_real_vec_eq_near_real_vec(v1, v2) result(eq)
        implicit none
        class(near_real_vec_t), intent(in) :: v1, v2
        logical(LK) :: eq

        logical(LK) :: fix_phase
        integer(IK) :: dim, i
        real(RK) :: thr, s
        real(RK), allocatable :: vec1(:), vec2(:)

        eq = .false._LK
        if (v1%dim /= v2%dim) return

        dim = v1%dim
        fix_phase = v1%fix_phase .or. v2%fix_phase
        thr = min(v1%thr, v2%thr)

        vec1 = v1%vec
        vec2 = v2%vec
        if (fix_phase) then
            vec1 = fix_phase_real_vec(vec1, thr)
            vec2 = fix_phase_real_vec(vec2, thr)
        end if

        s = 0.0_RK
        do i = 1_IK, dim
            s = s + (vec1(i) - vec2(i))**2_IK
        end do
        s = sqrt(s)
        eq = s < thr
    end function near_real_vec_eq_near_real_vec

    function near_real_vec_eq_vec(v1, v2) result(eq)
        implicit none
        class(near_real_vec_t), intent(in) :: v1
        real(RK), intent(in) :: v2(:)
        logical(LK) :: eq

        eq = near_real_vec_eq_near_real_vec(v1, near_real_vec(v2, v1%fix_phase, v1%thr))
    end function near_real_vec_eq_vec

    function vec_eq_near_real_vec(v1, v2) result(eq)
        implicit none
        real(RK), intent(in) :: v1(:)
        class(near_real_vec_t), intent(in) :: v2
        logical(LK) :: eq

        eq = near_real_vec_eq_near_real_vec(near_real_vec(v1, v2%fix_phase, v2%thr), v2)
    end function vec_eq_near_real_vec

    function near_real_mat_eq_near_real_mat(m1, m2) result(eq)
        implicit none
        class(near_real_mat_t), intent(in) :: m1, m2
        logical(LK) :: eq

        logical(LK) :: fix_phase
        integer(IK) :: dim1, dim2, i, j
        real(RK) :: thr, s
        real(RK), allocatable :: mat1(:, :), mat2(:, :)

        eq = .false._LK
        if (m1%dim1 /= m2%dim1 .or. m1%dim2 /= m2%dim2) return

        dim1 = m1%dim1
        dim2 = m1%dim2
        fix_phase = m1%fix_phase .or. m2%fix_phase
        thr = min(m1%thr, m2%thr)

        mat1 = m1%mat
        mat2 = m2%mat
        if (fix_phase) then
            mat1 = fix_phase_real_mat(mat1, thr)
            mat2 = fix_phase_real_mat(mat2, thr)
        end if

        s = 0.0_RK
        do j = 1_IK, dim2
            do i = 1_IK, dim1
                s = s + (mat1(i, j) - mat2(i, j))**2_IK
            end do
        end do
        s = sqrt(s)
        eq = s < thr
    end function near_real_mat_eq_near_real_mat

    function near_real_mat_eq_mat(m1, m2) result(eq)
        implicit none
        class(near_real_mat_t), intent(in) :: m1
        real(RK), intent(in) :: m2(:, :)

        logical(LK) :: eq

        eq = near_real_mat_eq_near_real_mat(m1, near_real_mat(m2, m1%fix_phase, m1%thr))
    end function near_real_mat_eq_mat

    function mat_eq_near_real_mat(m1, m2) result(eq)
        implicit none
        real(RK), intent(in) :: m1(:, :)
        class(near_real_mat_t), intent(in) :: m2

        logical(LK) :: eq

        eq = near_real_mat_eq_near_real_mat(near_real_mat(m1, m2%fix_phase, m2%thr), m2)
    end function mat_eq_near_real_mat

    function near_real_num_ne_near_real_num(x1, x2) result(ne)
        implicit none
        class(near_real_num_t), intent(in) :: x1, x2
        logical(LK) :: ne

        ne = .not. near_real_num_eq_near_real_num(x1, x2)
    end function near_real_num_ne_near_real_num

    function near_real_num_ne_num(x1, x2) result(ne)
        implicit none
        class(near_real_num_t), intent(in) :: x1
        real(RK), intent(in) :: x2
        logical(LK) :: ne

        ne = .not. near_real_num_eq_num(x1, x2)
    end function near_real_num_ne_num

    function num_ne_near_real_num(x1, x2) result(ne)
        implicit none
        real(RK), intent(in) :: x1
        class(near_real_num_t), intent(in) :: x2
        logical(LK) :: ne

        ne = .not. num_eq_near_real_num(x1, x2)
    end function num_ne_near_real_num

    function near_real_vec_ne_near_real_vec(v1, v2) result(ne)
        implicit none
        class(near_real_vec_t), intent(in) :: v1, v2
        logical(LK) :: ne

        ne = .not. near_real_vec_eq_near_real_vec(v1, v2)
    end function near_real_vec_ne_near_real_vec

    function near_real_vec_ne_vec(v1, v2) result(ne)
        implicit none
        class(near_real_vec_t), intent(in) :: v1
        real(RK), intent(in) :: v2(:)
        logical(LK) :: ne

        ne = .not. near_real_vec_eq_vec(v1, v2)
    end function near_real_vec_ne_vec

    function vec_ne_near_real_vec(v1, v2) result(ne)
        implicit none
        real(RK), intent(in) :: v1(:)
        class(near_real_vec_t), intent(in) :: v2
        logical(LK) :: ne

        ne = .not. vec_eq_near_real_vec(v1, v2)
    end function vec_ne_near_real_vec

    function near_real_mat_ne_near_real_mat(m1, m2) result(ne)
        implicit none
        class(near_real_mat_t), intent(in) :: m1, m2
        logical(LK) :: ne

        ne = .not. near_real_mat_eq_near_real_mat(m1, m2)
    end function near_real_mat_ne_near_real_mat

    function near_real_mat_ne_mat(m1, m2) result(ne)
        implicit none
        class(near_real_mat_t), intent(in) :: m1
        real(RK), intent(in) :: m2(:, :)
        logical(LK) :: ne

        ne = .not. near_real_mat_eq_mat(m1, m2)
    end function near_real_mat_ne_mat

    function mat_ne_near_real_mat(m1, m2) result(ne)
        implicit none
        real(RK), intent(in) :: m1(:, :)
        class(near_real_mat_t), intent(in) :: m2
        logical(LK) :: ne

        ne = .not. mat_eq_near_real_mat(m1, m2)
    end function mat_ne_near_real_mat

    function near_complex_num(x, fix_phase, thr) result(x_near)
        implicit none
        complex(CK), intent(in) :: x
        logical(LK), intent(in), optional :: fix_phase
        real(RK), intent(in), optional :: thr
        type(near_complex_num_t) :: x_near

        logical(LK) :: fix_phase1
        real(RK) :: thr1

        fix_phase1 = .false._LK
        if (present(fix_phase)) fix_phase1 = fix_phase

        thr1 = default_thr
        if (present(thr)) thr1 = thr

        x_near = near_complex_num_t(x, fix_phase1, thr1)
    end function near_complex_num

    function near_complex_vec(v, fix_phase, thr) result(v_near)
        implicit none
        complex(CK), intent(in) :: v(:)
        logical(LK), intent(in), optional :: fix_phase
        real(RK), intent(in), optional :: thr
        type(near_complex_vec_t) :: v_near

        logical(LK) :: fix_phase1
        real(RK) :: thr1

        fix_phase1 = .false._LK
        if (present(fix_phase)) fix_phase1 = fix_phase

        thr1 = default_thr
        if (present(thr)) thr1 = thr

        v_near = near_complex_vec_t(size(v, kind=IK), v, fix_phase1, thr1)
    end function near_complex_vec

    function near_complex_mat(m, fix_phase, thr) result(m_near)
        implicit none
        complex(CK), intent(in) :: m(:, :)
        logical(LK), intent(in), optional :: fix_phase
        real(RK), intent(in), optional :: thr
        type(near_complex_mat_t) :: m_near

        logical(LK) :: fix_phase1
        real(RK) :: thr1

        fix_phase1 = .false._LK
        if (present(fix_phase)) fix_phase1 = fix_phase

        thr1 = default_thr
        if (present(thr)) thr1 = thr

        m_near = near_complex_mat_t(size(m, 1_IK, kind=IK), size(m, 2_IK, kind=IK), m, fix_phase1, thr1)
    end function near_complex_mat

    function fix_phase_complex_num(x, thr) result(x_out)
        implicit none
        complex(CK), intent(in) :: x
        real(RK), intent(in), optional :: thr
        complex(CK) :: x_out

        real(RK) :: thr1
        real(RK) :: theta
        complex(CK) :: fac

        thr1 = default_thr
        if (present(thr)) thr1 = thr

        x_out = x
        if (abs(x_out) < thr1) return
        theta = atan2(aimag(x_out), real(x_out))
        fac = cmplx(cos(theta), -sin(theta), CK)
        x_out = x_out * fac
    end function fix_phase_complex_num

    function fix_phase_complex_vec(v, thr) result(v_out)
        implicit none
        complex(CK), intent(in) :: v(:)
        real(RK), intent(in), optional :: thr
        complex(CK), allocatable :: v_out(:)

        complex(CK) :: fac
        integer(IK) :: dim, i
        real(RK) :: thr1, theta

        thr1 = default_thr
        if (present(thr)) thr1 = thr

        v_out = v
        dim = size(v_out, 1_IK, kind=IK)
        do i = 1_IK, dim
            if (abs(v_out(i)) >= thr1) exit
        end do

        if (i == dim + 1_IK) return
        theta = atan2(aimag(v_out(i)), real(v_out(i)))
        fac = cmplx(cos(theta), -sin(theta), kind=CK)
        v_out = v_out * fac
    end function fix_phase_complex_vec

    function fix_phase_complex_mat(m, thr) result(m_out)
        implicit none
        complex(CK), intent(in) :: m(:, :)
        real(RK), intent(in), optional :: thr
        complex(CK), allocatable :: m_out(:, :)

        complex(CK) :: fac
        integer(IK) :: dim1, dim2, i, j
        real(RK) :: thr1, theta

        thr1 = default_thr
        if (present(thr)) thr1 = thr

        m_out = m
        dim1 = size(m_out, 1_IK, kind=IK)
        dim2 = size(m_out, 2_IK, kind=IK)
        do j = 1_IK, dim2
            do i = 1_IK, dim1
                if (abs(m_out(i, j)) >= thr1) exit
            end do

            if (i == dim1 + 1_IK) cycle
            theta = atan2(aimag(m_out(i, j)), real(m_out(i, j)))
            fac = cmplx(cos(theta), -sin(theta), kind=CK)
            m_out(:, j) = fac * m_out(:, j)
        end do
    end function fix_phase_complex_mat

    function near_complex_num_eq_near_complex_num(x1, x2) result(eq)
        implicit none
        class(near_complex_num_t), intent(in) :: x1, x2
        logical(LK) :: eq

        logical(LK) :: fix_phase
        real(RK) :: thr
        complex(CK) :: num1, num2

        fix_phase = x1%fix_phase .or. x2%fix_phase
        thr = min(x1%thr, x2%thr)

        num1 = x1%num
        num2 = x2%num
        if (fix_phase) then
            num1 = fix_phase_complex_num(num1, thr)
            num2 = fix_phase_complex_num(num2, thr)
        end if

        eq = abs(num1 - num2) < thr
    end function near_complex_num_eq_near_complex_num

    function near_complex_num_eq_num(x1, x2) result(eq)
        implicit none
        class(near_complex_num_t), intent(in) :: x1
        complex(CK), intent(in) :: x2
        logical(LK) :: eq

        eq = near_complex_num_eq_near_complex_num(x1, near_complex_num(x2, x1%fix_phase, x1%thr))
    end function near_complex_num_eq_num

    function num_eq_near_complex_num(x1, x2) result(eq)
        implicit none
        complex(CK), intent(in) :: x1
        class(near_complex_num_t), intent(in) :: x2
        logical(LK) :: eq

        eq = near_complex_num_eq_near_complex_num(near_complex_num(x1, x2%fix_phase, x2%thr), x2)
    end function num_eq_near_complex_num

    function near_complex_vec_eq_near_complex_vec(v1, v2) result(eq)
        implicit none
        class(near_complex_vec_t), intent(in) :: v1, v2
        logical(LK) :: eq

        logical(LK) :: fix_phase
        integer(IK) :: dim, i
        real(RK) :: thr, s
        complex(CK), allocatable :: vec1(:), vec2(:)

        eq = .false._LK
        if (v1%dim /= v2%dim) return

        dim = v1%dim
        fix_phase = v1%fix_phase .or. v2%fix_phase
        thr = min(v1%thr, v2%thr)

        vec1 = v1%vec
        vec2 = v2%vec
        if (fix_phase) then
            vec1 = fix_phase_complex_vec(vec1, thr)
            vec2 = fix_phase_complex_vec(vec2, thr)
        end if

        s = 0.0_RK
        do i = 1_IK, dim
            s = s + abs(vec1(i) - vec2(i))**2_IK
        end do
        s = sqrt(s)
        eq = s < thr
    end function near_complex_vec_eq_near_complex_vec

    function near_complex_vec_eq_vec(v1, v2) result(eq)
        implicit none
        class(near_complex_vec_t), intent(in) :: v1
        complex(CK), intent(in) :: v2(:)

        logical(LK) :: eq

        eq = near_complex_vec_eq_near_complex_vec(v1, near_complex_vec(v2, v1%fix_phase, v1%thr))
    end function near_complex_vec_eq_vec

    function vec_eq_near_complex_vec(v1, v2) result(eq)
        implicit none
        complex(CK), intent(in) :: v1(:)
        class(near_complex_vec_t), intent(in) :: v2

        logical(LK) :: eq

        eq = near_complex_vec_eq_near_complex_vec(near_complex_vec(v1, v2%fix_phase, v2%thr), v2)
    end function vec_eq_near_complex_vec

    function near_complex_mat_eq_near_complex_mat(m1, m2) result(eq)
        implicit none
        class(near_complex_mat_t), intent(in) :: m1, m2
        logical(LK) :: eq

        logical(LK) :: fix_phase
        integer(IK) :: dim1, dim2, i, j
        real(RK) :: thr, s
        complex(CK), allocatable :: mat1(:, :), mat2(:, :)

        eq = .false._LK
        if (m1%dim1 /= m2%dim1 .or. m1%dim2 /= m2%dim2) return

        dim1 = m1%dim1
        dim2 = m1%dim2
        fix_phase = m1%fix_phase .or. m2%fix_phase
        thr = min(m1%thr, m2%thr)

        mat1 = m1%mat
        mat2 = m2%mat
        if (fix_phase) then
            mat1 = fix_phase_complex_mat(mat1, thr)
            mat2 = fix_phase_complex_mat(mat2, thr)
        end if

        s = 0.0_RK
        do j = 1_IK, dim2
            do i = 1_IK, dim1
                s = s + abs(mat1(i, j) - mat2(i, j))**2_IK
            end do
        end do
        s = sqrt(s)
        eq = s < thr
    end function near_complex_mat_eq_near_complex_mat

    function near_complex_mat_eq_mat(m1, m2) result(eq)
        implicit none
        class(near_complex_mat_t), intent(in) :: m1
        complex(CK), intent(in) :: m2(:, :)
        logical(LK) :: eq

        eq = near_complex_mat_eq_near_complex_mat(m1, near_complex_mat(m2, m1%fix_phase, m1%thr))
    end function near_complex_mat_eq_mat

    function mat_eq_near_complex_mat(m1, m2) result(eq)
        implicit none
        complex(CK), intent(in) :: m1(:, :)
        class(near_complex_mat_t), intent(in) :: m2
        logical(LK) :: eq

        eq = near_complex_mat_eq_near_complex_mat(near_complex_mat(m1, m2%fix_phase, m2%thr), m2)
    end function mat_eq_near_complex_mat

    function near_complex_num_ne_near_complex_num(x1, x2) result(ne)
        implicit none
        class(near_complex_num_t), intent(in) :: x1, x2
        logical(LK) :: ne

        ne = .not. near_complex_num_eq_near_complex_num(x1, x2)
    end function near_complex_num_ne_near_complex_num

    function near_complex_num_ne_num(x1, x2) result(ne)
        implicit none
        class(near_complex_num_t), intent(in) :: x1
        complex(CK), intent(in) :: x2
        logical(LK) :: ne

        ne = .not. near_complex_num_eq_num(x1, x2)
    end function near_complex_num_ne_num

    function num_ne_near_complex_num(x1, x2) result(ne)
        implicit none
        complex(CK), intent(in) :: x1
        class(near_complex_num_t), intent(in) :: x2
        logical(LK) :: ne

        ne = .not. num_eq_near_complex_num(x1, x2)
    end function num_ne_near_complex_num

    function near_complex_vec_ne_near_complex_vec(v1, v2) result(ne)
        implicit none
        class(near_complex_vec_t), intent(in) :: v1, v2
        logical(LK) :: ne

        ne = .not. near_complex_vec_eq_near_complex_vec(v1, v2)
    end function near_complex_vec_ne_near_complex_vec

    function near_complex_vec_ne_vec(v1, v2) result(ne)
        implicit none
        class(near_complex_vec_t), intent(in) :: v1
        complex(CK), intent(in) :: v2(:)
        logical(LK) :: ne

        ne = .not. near_complex_vec_eq_vec(v1, v2)
    end function near_complex_vec_ne_vec

    function vec_ne_near_complex_vec(v1, v2) result(ne)
        implicit none
        complex(CK), intent(in) :: v1(:)
        class(near_complex_vec_t), intent(in) :: v2
        logical(LK) :: ne

        ne = .not. vec_eq_near_complex_vec(v1, v2)
    end function vec_ne_near_complex_vec

    function near_complex_mat_ne_near_complex_mat(m1, m2) result(ne)
        implicit none
        class(near_complex_mat_t), intent(in) :: m1, m2
        logical(LK) :: ne

        ne = .not. near_complex_mat_eq_near_complex_mat(m1, m2)
    end function near_complex_mat_ne_near_complex_mat

    function near_complex_mat_ne_mat(m1, m2) result(ne)
        implicit none
        class(near_complex_mat_t), intent(in) :: m1
        complex(CK), intent(in) :: m2(:, :)
        logical(LK) :: ne

        ne = .not. near_complex_mat_eq_mat(m1, m2)
    end function near_complex_mat_ne_mat

    function mat_ne_near_complex_mat(m1, m2) result(ne)
        implicit none
        complex(CK), intent(in) :: m1(:, :)
        class(near_complex_mat_t), intent(in) :: m2
        logical(LK) :: ne

        ne = .not. mat_eq_near_complex_mat(m1, m2)
    end function mat_ne_near_complex_mat

end module testing
