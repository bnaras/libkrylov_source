!--------------------------------------------------------------------
!--------------------------------------------------------------------
module basekinds
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This module defines the parameters used 
!< by basetypes_*.f90,
!< intended to match most blas/LApack definition
!< of single and double precision.
!< and a reasonably sized kind parameter for integers.
!< Lastly, there are also subroutines to define
!< file unit numbers.
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
  use libkrylovinterface
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Fixed Kind parameters
!--------------------------------------------------------------------

!! single precision parameter
  integer, parameter :: kind_single = kind(16e0)

!! double precision parameter
  integer, parameter :: &
  & kind_double = selected_real_kind(2*precision(16.0_kind_single))

!! 8 byte parameter for integers (long)
!  integer, parameter :: kind_integer = 8

!--------------------------------------------------------------------

contains

!-------------------------------------------------------------------- 
  subroutine find_free_file_unit(funit,ierr) 
!-------------------------------------------------------------------- 
! 
!-------------------------------------------------------------------- 
!< Description: 
!< This routine returns a free file unit, 14 < funit < 256 
!-------------------------------------------------------------------- 
! 
    implicit none 
! 
!-------------------------------------------------------------------- 
! Output Parameters 
!-------------------------------------------------------------------- 
!! name of file to be read 
    integer(kind_integer), intent(out) :: funit 
!-------------------------------------------------------------------- 
! Error Parameter 
!-------------------------------------------------------------------- 
    integer(kind_integer), intent(inout) :: ierr 
!-------------------------------------------------------------------- 
!  Local Variables 
!-------------------------------------------------------------------- 
!! dummy indexes 
    integer(kind_integer) :: j = 0 
!! logic for file unit 
    logical :: already_used = .true. 
!-------------------------------------------------------------------- 
 
! Assume file unit number 0 to 14 are reserved for other output files
!! INCREASE THIS NUMBER TO RESERVE MORE FILE UNIT NUMBERS
    j = 14 


    already_used = .true. 
    ierr = -1
    do  
      j = j + 1 
      inquire(unit=j,opened=already_used) 
      !! Example of how to skip a file unit number if you so choose
     ! if (j.eq.10) cycle 
      !!! automatically stop if more than 256 funits are used. 
      !!! Think carefully before increasing this number
      if (j.gt.256) exit
      if(.not.already_used) then 
        funit = j
        ierr = 0 
        exit 
      end if 
    end do 
 
!-------------------------------------------------------------------- 
  end subroutine find_free_file_unit 
!-------------------------------------------------------------------- 

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module basekinds
!--------------------------------------------------------------------
!--------------------------------------------------------------------
