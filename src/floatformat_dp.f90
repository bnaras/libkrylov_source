!--------------------------------------------------------------------
!--------------------------------------------------------------------
module floatformat
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This module defines the precision of real(kind_float)
!< which is to be used in basetypes_*.f90 and above,
!< as well as a epsilon 'eps' value for machine precision.
!< This module also defines some strings that can be used 
!< in the solver to identify what has been compiled
!< and format output.
!< This is for double precision.
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! define kind_integer and other kind parameters
  use basekinds
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Character string for printing float precision, for testing purposes
!--------------------------------------------------------------------
  character(len=32), parameter :: &
  & float_print_string = trim('doubleprecision')
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Character string for formatting basetype, for testing purposes
!--------------------------------------------------------------------
  character(len=8), parameter :: &
  & floattype_string = trim('dp')
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Character string for formatting float print
!--------------------------------------------------------------------
  character(len=6), parameter :: &
  & float_format_string = 'e24.17'
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Setting the precision of reals for array operations - 
! in blastypes_*.f90, the BLAS calls must match
! please make a new blastypes_*.f90 if implementing a new precision
! the blastypes_*_bf.f90 for the 'BLAS-free' implementation
! is coming soon.
!--------------------------------------------------------------------

!! precision parameter
  integer, parameter :: kind_float = kind_double
  
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Constants for precision chosen
!--------------------------------------------------------------------

!! real, double precision epsilon (machine precision)
  real(kind_float), parameter :: &
  & eps = epsilon(real(0,kind=kind_float))
  
!! real, double precision log10(epsilon) (machine precision)
  real(kind_float), parameter :: &
  & logeps = log10(epsilon(real(0,kind=kind_float)))
  
!--------------------------------------------------------------------

!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module floatformat
!--------------------------------------------------------------------
!--------------------------------------------------------------------
