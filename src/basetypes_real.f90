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
  use libkrylovinterface
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
  & basetype_string = trim('real')
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Character legend string for base type, for testing purposes
!--------------------------------------------------------------------
  character(len=32), parameter :: &
  & base_legend_string = trim('real')
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
  character(len=6), parameter :: &
  & base_format_string = float_format_string
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Base type for arrays, for the case
! where the elements are real
!--------------------------------------------------------------------

!  type :: base
!    real(kind_float) :: element
!  end type base

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Interface for overloading elementary operators with type
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
   &   cmplx_to_base, &
   &   real_to_base
  end interface assignment (=)
     
  interface operator (+)
    module procedure :: base_plus, base_plus_base 
  end interface operator (+)

  interface operator (-)
    module procedure :: base_minus, base_minus_base, &
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

  type(base) elemental function base_conjg(x)
    type(base), intent(in) :: x

    base_conjg%element = x%element

  end function base_conjg

  real(kind_float) elemental function base_det(x)
    type(base), intent(in) :: x

    base_det = x%element*x%element

  end function base_det

  elemental subroutine base_to_base(x1,x2)
    type(base), intent(out) :: x1
    type(base), intent(in) :: x2

    x1%element = x2%element

  end subroutine base_to_base

  elemental subroutine base_to_real(x1,x2)
    real(kind_float), intent(out) :: x1
    type(base), intent(in) :: x2

    x1 = real(x2%element,kind=kind_float)

  end subroutine base_to_real

  elemental subroutine base_to_cmplx(z,x)
    complex(kind_float), intent(out) :: z
    type(base), intent(in) :: x

    z = cmplx(x%element,0,kind=kind_float)

  end subroutine base_to_cmplx

  elemental subroutine cmplx_to_base(x,z)
    type(base), intent(out) :: x
    complex(kind_float), intent(in) :: z

    x%element = real(z,kind=kind_float)

  end subroutine cmplx_to_base

  elemental subroutine real_to_base(x1,x2)
    type(base), intent(out) :: x1
    real(kind_float), intent(in) :: x2

    x1%element = x2

  end subroutine real_to_base

  type(base) elemental function base_plus(x)
    type(base), intent(in) :: x

    base_plus%element=x%element   

  end function base_plus

  type(base) elemental function base_plus_base(x1,x2)
    type(base), intent(in) :: x1
    type(base), intent(in) :: x2
    
    base_plus_base%element = x1%element+x2%element

  end function base_plus_base

  type(base) elemental function base_minus(x)
    type(base), intent(in) :: x

    base_minus%element= - x%element

  end function base_minus

  type(base) elemental function base_minus_base(x1,x2)
    type(base), intent(in) :: x1
    type(base), intent(in) :: x2
    
    base_minus_base%element = x1%element-x2%element

  end function base_minus_base

  type(base) elemental function base_minus_real(x1,x2)
    type(base), intent(in) :: x1
    real(kind_float), intent(in) :: x2

    base_minus_real%element = x1%element-x2

  end function base_minus_real

  type(base) elemental function real_minus_base(x1,x2)
    real(kind_float), intent(in) :: x1
    type(base), intent(in) :: x2
 
    real_minus_base%element = x1-x2%element
  
  end function real_minus_base

  type(base) elemental function base_times_base(x1,x2)
    type(base), intent(in) :: x1
    type(base), intent(in) :: x2
    
    base_times_base%element = x1%element*x2%element

  end function base_times_base

  type(base) elemental function base_times_real(x1,x2)
    type(base), intent(in) :: x1
    real(kind_float), intent(in) :: x2
    
    base_times_real%element = x1%element*x2

  end function base_times_real

  type(base) elemental function base_by_base(x1,x2)
    type(base), intent(in) :: x1
    type(base), intent(in) :: x2
    
    base_by_base%element = x1%element/x2%element

  end function base_by_base

  type(base) elemental function base_by_real(x1,x2)
    type(base), intent(in) :: x1
    real(kind_float), intent(in) :: x2
    
    base_by_real%element = x1%element/x2

  end function base_by_real

!--------------------------------------------------------------------


!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module basetypes
!--------------------------------------------------------------------
!--------------------------------------------------------------------
