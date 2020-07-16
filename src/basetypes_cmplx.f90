!--------------------------------------------------------------------
!--------------------------------------------------------------------
module basetypes
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This module defines 
!< the base type for the elements of arrays, which is 
!< how compile time polymorphism is achieved.
!< There are strings defined to help debug the solver and
!< format output.
!< A selected range elemental operations on the base type,
!< are implemented.
!< This is the real version.
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! contains definition of single and double precision, and kind_integer
  use basekinds
! contains the precision parameter kind_float and related parameters
  use floatformat
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Character string for base type, for testing purposes
!--------------------------------------------------------------------
  character(len=32), parameter :: &
  & basetype_string = trim('cmplx')
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Character legend string for base type, for testing purposes
!--------------------------------------------------------------------
  character(len=32), parameter :: &
  & base_legend_string = trim('real imaginary')
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Character string for base type, for testing purposes
!--------------------------------------------------------------------
  character(len=32), parameter :: &
  & base_print_string = &
  &trim(trim(basetype_string)//'_'//trim(floattype_string))
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Character string for base type, for testing purposes
!--------------------------------------------------------------------
  character(len=16), parameter :: &
  & base_format_string = &
  & float_format_string//',1x,'//float_format_string
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! [((1))]
! Base type for arrays, for the case where the
! elements are known to be complex
! 
! This is the type definition of the matrix problem
! kind_float is defined in floatformat_dp.f90
!--------------------------------------------------------------------

  type :: base
    complex(kind_float) :: element
  end type base

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Interface for overloading operators with type
!--------------------------------------------------------------------
  
  interface conjg
    module procedure :: base_conjg 
  end interface conjg

  interface det
    module procedure :: base_det
  end interface det

  interface assignment (=)
    module procedure :: base_to_base, &
   &   base_to_real, &
   &   base_to_cmplx, &
   &   real_to_base, &
   &   cmplx_to_base
  end interface assignment (=)
     
  interface operator (+)
    module procedure :: base_plus, base_plus_base 
  end interface operator (+)

  interface operator (-)
    module procedure :: base_minus, base_minus_base,&
   &   base_minus_real, &
   &   real_minus_base
  end interface operator (-)
  
  interface operator (*)
    module procedure :: base_times_base, base_times_real
  end interface operator (*)
  interface operator (/)
    module procedure :: base_by_real, base_by_base
  end interface operator (/)

!--------------------------------------------------------------------
contains
!--------------------------------------------------------------------
! Overloaded operators
!--------------------------------------------------------------------

  type(base) elemental function base_conjg(z)
    type(base), intent(in) :: z

    base_conjg%element = conjg(z%element)

  end function base_conjg

  real(kind_float) elemental function base_det(z)
    type(base), intent(in) :: z

    base_det = real(z%element*z%element,kind=kind_float)&
  &        +aimag(z%element*z%element)

  end function base_det

  elemental subroutine base_to_base(z1,z2)
    type(base), intent(out) :: z1
    type(base), intent(in) :: z2

    z1%element = z2%element

  end subroutine base_to_base

  elemental subroutine base_to_real(x,z)
    real(kind_float), intent(out) :: x
    type(base), intent(in) :: z

    x = real(z%element,kind=kind_float)

  end subroutine base_to_real

  elemental subroutine base_to_cmplx(z1,z2)
    complex(kind_float), intent(out) :: z1
    type(base), intent(in) :: z2

    z1 = cmplx(z2%element,kind=kind_float)

  end subroutine base_to_cmplx

  elemental subroutine real_to_base(z,x)
    type(base), intent(out) :: z
    real(kind_float), intent(in) :: x

    z%element = cmplx(x,kind=kind_float)

  end subroutine real_to_base

  elemental subroutine cmplx_to_base(z1,z2)
    type(base), intent(out) :: z1
    complex(kind_float), intent(in) :: z2

    z1%element = cmplx(z2,kind=kind_float)

  end subroutine cmplx_to_base

  type(base) elemental function base_plus(z)
    type(base), intent(in) :: z

    base_plus%element= z%element

  end function base_plus

  type(base) elemental function base_plus_base(z1,z2)
    type(base), intent(in) :: z1
    type(base), intent(in) :: z2
    
    base_plus_base%element = cmplx(z1%element + z2%element,kind=kind_float)

  end function base_plus_base

  type(base) elemental function base_minus(z)
    type(base), intent(in) :: z

    base_minus%element= -z%element

  end function base_minus

  type(base) elemental function base_minus_base(z1,z2)
    type(base), intent(in) :: z1
    type(base), intent(in) :: z2
    
    base_minus_base%element = cmplx(z1%element - z2%element,kind=kind_float)

  end function base_minus_base

  type(base) elemental function base_minus_real(z,x)
    type(base), intent(in) :: z
    real(kind_float), intent(in) :: x
    
    base_minus_real%element = z%element-x

  end function base_minus_real

  type(base) elemental function real_minus_base(x,z)
    real(kind_float), intent(in) :: x
    type(base), intent(in) :: z

    real_minus_base%element = x-z%element
 
  end function real_minus_base

  type(base) elemental function base_times_base(z1,z2)
    type(base), intent(in) :: z1
    type(base), intent(in) :: z2
    
    base_times_base%element = z1%element*z2%element

  end function base_times_base

  type(base) elemental function base_times_real(z,x)
    type(base), intent(in) :: z
    real(kind_float), intent(in) :: x
    
    base_times_real%element = z%element*x

  end function base_times_real

  type(base) elemental function base_by_base(z1,z2)
    type(base), intent(in) :: z1
    type(base), intent(in) :: z2
    
    base_by_base%element = z1%element/z2%element

  end function base_by_base

  type(base) elemental function base_by_real(z,x)
    type(base), intent(in) :: z
    real(kind_float), intent(in) :: x
    
    base_by_real%element = z%element/x

  end function base_by_real

!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module basetypes
!--------------------------------------------------------------------
!--------------------------------------------------------------------
