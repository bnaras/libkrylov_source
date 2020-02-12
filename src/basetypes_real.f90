!--------------------------------------------------------------------
!--------------------------------------------------------------------
module basetypes
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This module defines the base type for the elements of arrays
!< [((1))]
!< for krylovtypes_*.f90
!< which includes elemental operations on the base type,[((2))]
!< and wrappers for blas/lapack [((3))] and I/O operations.[((5))]
!< This is the real version using BLAS precisions
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
! [((1))]
! Base type for arrays, for the case
! where the elements are known to be real
! 
! This is the type definition of the matrix problem
! kind_float is defined in floatformat_*p.f90
!--------------------------------------------------------------------

  type :: base
    real(kind_float) :: element
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
![((2))]
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
![((5))]
! Format statements for reading/printing from files
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine read_base(funit,k1,k2,obj,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< read statement for one line from file funit
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
    use floatformat
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! file unit
    integer(kind_integer), intent(in) :: funit
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! position of value
    integer(kind_integer), intent(out) :: k1,k2
!! value to be read in
    type(base), intent(out) :: obj
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------

    read(unit=funit,&
  & fmt='(13x,i10,1x,i10,2x,'//base_format_string//',6x)', &
  &       iostat=ierr) k1,k2,obj%element

!--------------------------------------------------------------------
  end subroutine read_base
!--------------------------------------------------------------------
 
!--------------------------------------------------------------------
  subroutine print_base_format(funit,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< print format statement to file funit for readability
!< may be left blank
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
    use floatformat
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! file unit
    integer(kind_integer), intent(in) :: funit
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------

    write(unit=funit,fmt='(a2,5x,a3,5x,a6,6x,a4)', &
  &   iostat=ierr) '//','row','column','real'

!--------------------------------------------------------------------
  end subroutine print_base_format
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
  subroutine print_base(funit,k1,k2,obj,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< print statement for one line to file funit
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
    use floatformat
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! file unit
    integer(kind_integer), intent(in) :: funit
!! position of obj by rows and columns
    integer(kind_integer), intent(in) :: k1,k2
!! value to be printed
    type(base), intent(in) :: obj
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------

    write(unit=funit,&
  & fmt='(4x,a9,i10,a1,i10,a2,'//base_format_string//',a6)', &
  &       iostat=ierr) '{ "ele":[',k1,',',k2,',"',obj%element,'" ] },'

!--------------------------------------------------------------------
  end subroutine print_base
!--------------------------------------------------------------------

!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module basetypes
!--------------------------------------------------------------------
!--------------------------------------------------------------------
