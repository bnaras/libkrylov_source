!-------------------------------------------------------------------
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
  use blastypes
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
  type(base), allocatable :: krylov_a(:,:), obj1(:,:), obj2(:,:), &
 & d(:,:)
! character string to identify all files
  character(len=32), target :: a1_string = ''
! character string for file name that contains the problem
  character(len=32) :: problemname_string = ''
! character string for file name that contains the exact solution
  character(len=32) :: eigenname_string = ''
! integers for the size of the problem
  integer(kind_integer) :: n = 10
!! dummy indexes
  integer(kind_integer) :: j,k = 0
!! first dimension of obj1
  integer(kind_integer), allocatable :: ipiv(:)
!! diagonal for lapack and eigenvalues
  real(kind_float), allocatable :: diag(:)
!! seed for lapack random generator
  integer(kind_integer) :: iseed(4) = 0
!! real number for random_number
  real(kind_float) :: seed = 0
!! factor for scaling diagonals
  type(base) :: factor
!! one in kind base
  type(base) :: one_kb
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
  integer(kind_integer) :: ierr = 0
!--------------------------------------------------------------------

!! setting up the problem before calling solver

!! set a1_string based on basetypes
  a1_string = trim(base_print_string)//'_1a'

!! set the filename_string for the file name 
  problemname_string = trim(a1_string)//'_prob'

!!allocate set the filename_string for the file name 
  eigenname_string = trim(a1_string)//'_exact_vals'


!! allocate array to contain problem, diagonal used to 
!! construct problem, and work array
  allocate(krylov_a(n,n))
  allocate(d(n,n))
  allocate(obj1(n,n))
  allocate(obj2(n,n))
  allocate(ipiv(n))
  allocate(diag(n))


!! creating the (I + B) matrix into obj1
  obj1 = real(0,kind=kind_float)
  do j = 1, n
     do k = 1, j
        if ( j == k ) then
          obj2(j, k) = real(1 + 2,kind=kind_float)
       else
          obj1(j, k) = sin(real(j + k,kind=kind_float))
       end if
    end do
 end do

 do k = 1, n
   do j = 1, k
      if ( j == k) then
         obj1(j, k) = real(1,kind=kind_float)
      else
         obj1(j, k) = -(sin(real(j + k,kind=kind_float)))
      end if
   end do
 end do

!! creating the (I - B) matrix into obj2
  obj2 = real(0,kind=kind_float)
  do j = 1, n
     do k = 1, j
        if ( j == k ) then
          obj2(j, k) = real(1 - 2,kind=kind_float)
       else
          obj2(j, k) = -sin(real(j + k,kind=kind_float))
       end if
    end do
 end do

 do k = 1, n
   do j = 1, k
      if ( j == k) then
         obj2(j, k) = real(1,kind=kind_float)
      else
         obj2(j, k) = (sin(real(j + k,kind=kind_float)))
      end if
   end do
 end do



!! call ggetrf to invert obj1
  call ggetrf(n,n,obj1,n,ipiv,ierr)

  if ( ierr .eq. 0 ) then
    print *, 'successful exit from ggetrf'
  else if ( ierr .lt. 0 ) then
    print *, 'illegal value'
  else
    print *, 'obj1(j,j) is zero'
  end if

!! call ggetrs to multiply results from ggetrf
  call ggetrs('n',n,n,obj1,n,ipiv,obj2,n,ierr)
  
  if ( ierr .eq. 0 ) then
    print *, 'successful exit from ggetrs'
  else
    print *, 'illegal value'
  end if

!! generate eigenvalues of krylov_a into d
  d = real(0,kind=kind_float) 
 do j = 1, n
    do k = 1, n
       if ( j .eq. k ) then
          d(j, k) = cos(real(j + k,kind=kind_float))
       else
          d(j, k) = real(0,kind=kind_float)
       end if
    end do
 end do

! assigning constant value
  one_kb = real(1,kind=kind_float)

!! creating the symmetric matrix into krylov_a
  call ggemm('n','n',n,n,n,one_kb,obj2,n,d,n,&
  &  one_kb,obj1,n)

  krylov_a = real(0,kind=kind_float)

  call ggemm('n','t',n,n,n,one_kb,obj1,n,obj2,n,&
  &  one_kb,krylov_a,n)

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
  deallocate(obj1)
  deallocate(obj2)
  deallocate(ipiv)
  deallocate(d)
  deallocate(diag)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program problem_1a
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
