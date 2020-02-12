!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
program problem_1a
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This program generates the problem matrix for driver_1a to be 
!< tested on. Compiling with the different floatformat_*.f90
!< and basetypes_*.f90 gives the different matrix types
!< uses fortran intrinsic function for random_number
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
  use basekinds
! define parameters of precision of real(kind_float)
  use floatformat
! define type(base) and type(basereal) and associated operations
  use basetypes
! for file i/o : printing problem matrix
  use arrayfile
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
  implicit none
!--------------------------------------------------------------------
! Local Variables for Subroutines and reading problem
!--------------------------------------------------------------------
! contains the matrix problem, read in from file
  type(base), allocatable :: krylov_a(:,:)
! character string to identify all files
  character(len=32), target :: a1_string = ''
! character string for file name that contains the problem
  character(len=32) :: problemname_string = ''
! character string for file name that contains the exact solution
  character(len=32) :: eigenname_string = ''
! integers for the size of the problem
  integer(kind_integer) :: n = 100
!! dummy indexes
  integer(kind_integer) :: j,k = 0
!! diagonal for lapack and eigenvalues
  real(kind_float), allocatable :: diag(:)
!! seed for lapack random generator
  integer(kind_integer) :: iseed(4) = 0
!! real number for random_number
  real(kind_float) :: seed = 0
!! factor for scaling diagonals
  type(base) :: factor
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
  integer(kind_integer) :: ierr = 0
!--------------------------------------------------------------------

!! setting up the problem before calling solver

!! set a1_string based on basetypes
  a1_string = trim(base_print_string)//'_huckel'

!! set the filename_string for the file name 
  problemname_string = trim(a1_string)//'_prob'

!! set the filename_string for the file name 
  eigenname_string = trim(a1_string)//'_exact_vals'


!! allocate array to contain problem, diagonal used to 
!! construct problem, and work array
  allocate(krylov_a(n,n))
  allocate(diag(n))

!!filling krylov_a

!! print problem array size
  call array_print_base(problemname_string,n,&
  &   n,krylov_a,ierr)

  if (ierr.ne.0) then
    print *, 'problem printing problem matrix!'
    stop
  end if

! call exact solver
  call gheev('v','l',n,krylov_a,n,diag,ierr)

  if (ierr.ne.0) then
    print *, 'problem solving problem matrix!'
    stop
  end if

!! print exact eigens
  call array_print_float(eigenname_string,n,&
  &   diag,ierr)

  if (ierr.ne.0) then
    print *, 'problem printing exact solutions!'
    stop
  end if

  deallocate(krylov_a)
  deallocate(diag)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program problem_1a
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
