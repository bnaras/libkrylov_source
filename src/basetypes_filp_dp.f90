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
!< for arrayoperations.f90 and krylovtypes_*.f90
!< which includes elemental operations on the base type,[((2))]
!< and wrappers for blas/lapack [((3))] and I/O operations.[((5))]
!< This is the split-complex version
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! contains definition of single and double precision, and kind_integer
  use basekinds
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Setting the precision of reals for array operations and below
! Only this and the blas routines need to be adjusted
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
! Character string for base type, for testing purposes
!--------------------------------------------------------------------
  character(len=32), parameter :: &
  & basetype_string = trim('filp_dp')
!--------------------------------------------------------------------

!--------------------------------------------------------------------
! [((1))]
! Base type for arrays, with base for the case where the
! elements are known to be split-complex
! 
! This is the type definition of the matrix problem
!--------------------------------------------------------------------

  type :: base
    real(kind_float) :: re, jm
  end type base

!--------------------------------------------------------------------

!--------------------------------------------------------------------
! Interface for overloading operators with type
!--------------------------------------------------------------------
  
  interface conjg
    module procedure :: base_conjg 
  end interface conjg

  interface assignment (=)
    module procedure :: base_to_base, &
   &   base_to_real, &
   &   real_to_base, &
   &   cmplx_to_base
  end interface assignment (=)
     
  interface operator (+)
    module procedure :: base_plus, base_plus_base 
  end interface operator (+)
  interface operator (-)
    module procedure :: base_minus, base_minus_base,&
   &   base_minus_real
  end interface operator (-)
  
  interface operator (*)
    module procedure :: base_times_base, base_times_real
  end interface operator (*)
  interface operator (/)
    module procedure :: base_by_real, base_by_base
  end interface operator (/)

  interface operator (.ne.)
    module procedure :: base_ne_base
  end interface operator (.ne.)

!--------------------------------------------------------------------
contains
!--------------------------------------------------------------------
![((2))]
! Overloaded operators
!--------------------------------------------------------------------

  type(base) elemental function base_conjg(z)
    type(base), intent(in) :: z

    base_conjg%re = z%re
    base_conjg%jm = -z%jm

  end function base_conjg

  elemental subroutine set_zero(z)
    type(base), intent(inout) :: z

    if (log10(abs(z%re)).lt.logeps) then
      z%re = real(0,kind=kind_float)
    end if
    if (log10(abs(z%jm)).lt.logeps) then
      z%jm = real(0,kind=kind_float)
    end if

  end subroutine set_zero

  type(base) elemental function spcmplx(x1,x2)
    real(kind_float), intent(in) :: x1
    real(kind_float), intent(in) :: x2

    spcmplx%re = x1
    spcmplx%jm = x2

  end function spcmplx

! unknown purpose, not tested
  real(kind_float) elemental function det(z)
    type(base), intent(in) :: z

    det = (z%re+z%jm)*(z%re-z%jm)

  end function det

  elemental subroutine base_to_base(z1,z2)
    type(base), intent(out) :: z1
    type(base), intent(in) :: z2

    z1%re = z2%re
    z1%jm = z2%jm

  end subroutine base_to_base

  elemental subroutine base_to_real(x,z)
    real(kind_float), intent(out) :: x
    type(base), intent(in) :: z

    x = z%re

  end subroutine base_to_real

  elemental subroutine real_to_base(z,x)
    type(base), intent(out) :: z
    real(kind_float), intent(in) :: x

    z%re = x
    z%jm = real(0,kind=kind_float)

  end subroutine real_to_base

  elemental subroutine cmplx_to_base(z1,z2)
    type(base), intent(out) :: z1
    complex(kind_float), intent(in) :: z2

    z1%re = real(z2,kind=kind_float)
    z1%jm = real(0,kind=kind_float)

  end subroutine cmplx_to_base

  type(base) elemental function base_plus(z)
    type(base), intent(in) :: z

    base_plus%re = z%re
    base_plus%jm = z%jm   

  end function base_plus

  type(base) elemental function base_plus_base(z1,z2)
    type(base), intent(in) :: z1
    type(base), intent(in) :: z2
    
    base_plus_base%re = z1%re+z2%re
    base_plus_base%jm = z1%jm+z2%jm

  end function base_plus_base

  type(base) elemental function base_minus(z)
    type(base), intent(in) :: z

    base_minus%re = - z%re
    base_minus%jm = - z%jm

  end function base_minus

  type(base) elemental function base_minus_base(z1,z2)
    type(base), intent(in) :: z1
    type(base), intent(in) :: z2
    
    base_minus_base%re = z1%re-z2%re
    base_minus_base%jm = z1%jm-z2%jm

  end function base_minus_base

  type(base) elemental function base_minus_real(z,x)
    type(base), intent(in) :: z
    real(kind_float), intent(in) :: x
    
    base_minus_real%re = z%re-x
    base_minus_real%jm = z%jm

  end function base_minus_real

  type(base) elemental function base_times_base(z1,z2)
    type(base), intent(in) :: z1
    type(base), intent(in) :: z2
    
    base_times_base%re = z1%re*z2%re+z1%jm*z2%jm
    base_times_base%jm = z1%re*z2%jm+z1%jm*z2%re

  end function base_times_base

  type(base) elemental function base_times_real(z,x)
    type(base), intent(in) :: z
    real(kind_float), intent(in) :: x
    
    base_times_real%re = z%re*x
    base_times_real%jm = z%jm*x

  end function base_times_real

  type(base) elemental function base_by_base(z1,z2)
    type(base), intent(in) :: z1
    type(base), intent(in) :: z2
    real(kind_float) :: tmp1
    real(kind_float) :: tmp2
    
    tmp1 = (z1%re+z1%jm)/(z2%re+z2%jm)
    tmp2 = (z1%re-z1%jm)/(z2%re-z2%jm)

    base_by_base%re = real(0.5,kind=kind_float)*(tmp1+tmp2)
    base_by_base%jm = real(0.5,kind=kind_float)*(tmp1-tmp2)

  end function base_by_base

  type(base) elemental function base_by_real(z,x)
    type(base), intent(in) :: z
    real(kind_float), intent(in) :: x
    real(kind_float) :: tmp

    tmp = real(1,kind=kind_float)/x
    
    base_by_real%re = z%re*tmp
    base_by_real%jm = z%jm*tmp

  end function base_by_real

  logical function base_ne_base(z1,z2)
    type(base), intent(in) :: z1
    type(base), intent(in) :: z2
    
    base_ne_base = ((z1%re.ne.z1%re).or.(z2%jm.ne.z2%jm))

  end function base_ne_base

  logical function logeps_gt(x)
    real(kind_float), intent(in) :: x

    logeps_gt = (logeps.gt.x)

  end function logeps_gt

!--------------------------------------------------------------------

!--------------------------------------------------------------------
![((3))]
! Wrapper for blas routines
! all other multiplications are done with explicit loops,
! requiring the overloading above
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine ggemm(trans1,trans2,m,n,k,alpha,obj1,ld1,obj2,ld2, &
  &   beta,obj3,ld3)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< Matrix Multiplication alpha*(obj1**T)*obj2 = beta*obj3 
!< or Matrix Multiplication alpha*obj1*(obj2**T) = beta*obj3 
!< or Matrix Multiplication alpha*obj1*obj2 = beta*obj3 
!< of type(base)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! array 1
    type(base), intent(in) :: obj1(:,:)
!! array 2
    type(base), intent(in) :: obj2(:,:)
!! the number of rows in obj1 and obj3
    integer(kind_integer), intent(in) :: m
!! the number of columns in obj2 and obj3
    integer(kind_integer), intent(in) :: n
!! the number of rows in obj2 and columns in obj1
    integer(kind_integer), intent(in) :: k
!! first dimension of obj1
    integer(kind_integer), intent(in) :: ld1
!! first dimension of obj2
    integer(kind_integer), intent(in) :: ld2
!! first dimension of obj3
    integer(kind_integer), intent(in) :: ld3
!! scalar multiplying obj1
    type(base), intent(in) :: alpha
!! scalar multiplying obj3
    type(base), intent(in) :: beta
!! character for obj1**H('c'), obj1**T('t') or obj1('n')
    character(len=1), intent(in) :: trans1
!! character for obj2**H('c'), obj2**T('t') or obj2('n')
    character(len=1), intent(in) :: trans2
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! array 3
    type(base), intent(out) :: obj3(m,n)
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!! real part of obj1
    real(kind_double), allocatable :: reobj1(:,:)
!! split-imaginary part of obj1
    real(kind_double), allocatable :: jmobj1(:,:)
!! real part of obj2
    real(kind_double), allocatable :: reobj2(:,:)
!! split imaginary part of obj2
    real(kind_double), allocatable :: jmobj2(:,:)
!! array for addition of real and split-imaginary parts of obj3
    real(kind_double), allocatable :: addarray1(:,:)
!! array for addition of real and split-imaginary parts of obj3
    real(kind_double), allocatable :: addarray2(:,:)
!--------------------------------------------------------------------

!! allocate local arrays
    allocate(reobj1(m,k))
    allocate(jmobj1(m,k))
    allocate(reobj2(k,n))
    allocate(jmobj2(k,n))
    allocate(addarray1(m,n))
    allocate(addarray2(m,n))
    reobj1 = obj1%re
    jmobj1 = obj1%jm
    reobj2 = obj2%re
    jmobj2 = obj2%jm

!! do multiplication of real and split-imaginary part
    call dgemm(trans1,trans2,m,n,k,alpha%re,reobj1, &
  &   ld1,reobj2,ld2,beta%re,addarray1,ld3)
    call dgemm(trans1,trans2,m,n,k,alpha%re,jmobj1, &
  &   ld1,jmobj2,ld2,beta%re,addarray2,ld3)
    obj3%re = addarray1+addarray2
    call dgemm(trans1,trans2,m,n,k,alpha%re,reobj1, &
  &   ld1,jmobj2,ld2,beta%re,addarray1,ld3)
    call dgemm(trans1,trans2,m,n,k,alpha%re,jmobj1, &
  &   ld1,reobj2,ld2,beta%re,addarray2,ld3)
    obj3%jm = addarray1+addarray2

!--------------------------------------------------------------------
  end subroutine ggemm
!--------------------------------------------------------------------


!--------------------------------------------------------------------
  subroutine gdot(n,obj1,inc1,obj2,inc2,obj3,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< inner product of type(base) (obj1**T)*obj2 = obj3
!< where obj1 and obj2 are vectors
!< not only BLAS
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! array 1
    type(base), intent(in) :: obj1(n)
!! array 2
    type(base), intent(in) :: obj2(n)
!! number of elements in obj1 and obj2
    integer(kind_integer), intent(in) :: n
!! spacing between elements in obj1
    integer(kind_integer), intent(in) :: inc1
!! spacing between elements in obj2
    integer(kind_integer), intent(in) :: inc2
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! array 3
    type(base), intent(out) :: obj3
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! the first real part of the norm
    real(kind_float) :: renorm1
!! the second real part of the norm
    real(kind_float) :: renorm2
!! the first split-imaginary part of the norm
    real(kind_float) :: jmnorm1
!! the second split-imaginary part of the norm
    real(kind_float) :: jmnorm2
!! variable for function call
    real(kind_double), external :: ddot
!--------------------------------------------------------------------

!   for mkl! openblas=> obj3%element = zdotc(n,obj1,inc1,obj2,inc2)
    renorm1 = ddot(n,obj1%re,inc1,obj2%re,inc2)
    renorm2 = ddot(n,obj1%jm,inc1,obj2%jm,inc2)
    obj3%re = renorm1+renorm2
    jmnorm1 = -ddot(n,obj1%re,inc1,obj2%jm,inc2)
    jmnorm2 = -ddot(n,obj1%jm,inc1,obj2%re,inc2)
    obj3%jm = jmnorm1+jmnorm2

!--------------------------------------------------------------------
  end subroutine gdot
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine gpotrf(uplo,n,obj1,ld1,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< cholesky decomposition
!< where obj1 is the matrix to be decomposed
!< and obj1 is the output
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! scaled overlap matrix
    type(base), intent(inout) :: obj1(:,:)
!! number of rows and columns in obj1
    integer(kind_integer), intent(in) :: n
!! first dimension of obj1
    integer(kind_integer), intent(in) :: ld1
!! obj1 as upper('u') or lower('l') triangular matrix
    character(len=1), intent(in) :: uplo
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------

!   call ?potrf(uplo,n,obj1%element,ld1,ierr)

!--------------------------------------------------------------------
  end subroutine gpotrf
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine gtrsm(side,uplo,trans1,diag,m,n,alpha,obj1,ld1, &
  &   obj2,ld2)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< Matrix Multiplication obj1**(-T)*alpha*obj2
!< or Matrix Multiplication obj1**(-1)*alpha*obj2
!< or Matrix Multiplication alpha*obj2*obj1^(-T) of type(base)
!< where obj1 is lower triangular
!< done by forward (and backward) substitution
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! lower triangular decomposition of overlap
    type(base), intent(in) :: obj1(:,:)
!! eigenvectors or matrix to be transformed
    type(base), intent(inout) :: obj2(:,:)
!! number of rows in obj2
    integer(kind_integer), intent(in) :: m
!! number of columns in obj2
    integer(kind_integer), intent(in) :: n
!! first dimension of obj1
    integer(kind_integer), intent(in) :: ld1
!! first dimension of obj2
    integer(kind_integer), intent(in) :: ld2
!! scalar multiplying obj2
    type(base), intent(in) :: alpha
!! obj1 on the left('l') or right('r') side of the multiplication
    character(len=1), intent(in) :: side
!! obj1 as upper('u') or lower('l') triangular matrix
    character(len=1), intent(in) :: uplo
!! character for obj1**H('c'), obj1**T('t') or obj1('n')
    character(len=1), intent(in) :: trans1
!! obj1 being unit triangular('u') or not unit triangular('n')
    character(len=1), intent(in) :: diag
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------

!    call ?trsm(side,uplo,trans1,diag,m,n,alpha%element, &
!  &   obj1%element,ld1,obj2%element,ld2)

!--------------------------------------------------------------------
  end subroutine gtrsm
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine glanhe(norm,uplo,n,obj1,ld1,onorm,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< finding the 1-norm of a matrix
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! overlap matrix
    type(base), intent(in) :: obj1(:,:)
!! the number of rows and columns of obj1
    integer(kind_integer), intent(in) :: n
!! first dimension of obj1
    integer(kind_integer), intent(in) :: ld1
!! type of norm: one norm('1'), infinity norm('i'), 
!! Frobenius norm('f') or max(abs(A(i,j)))('m')
    character(len=1), intent(in) :: norm
!! obj1 as upper('u') or lower('l') triangular matrix
    character(len=1), intent(in) :: uplo
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! 1-norm of obj1
    real(kind_float), intent(out) :: onorm
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!! modulus
    real(kind_float), allocatable :: det1(:,:)
!! array for work
    real(kind_double), allocatable :: work(:)
!! variable for function call
    real(kind_double), external :: dlansy
!--------------------------------------------------------------------

!! allocate det1
    allocate(det1(n,n))

!! allocate work
    allocate(work(n))

    det1 = det(obj1)

!! call LAPACK routine
    onorm = dlansy(norm,uplo,n,det1,ld1,work)

!--------------------------------------------------------------------
  end subroutine glanhe
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine gpocon(uplo,n,obj1,ld1,anorm,rcond,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< solving the reciprocal of the condition number
!< using the cholesky decomposition of a matrix
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! cholesky decomposition of overlap
    type(base), intent(in) :: obj1(:,:)
!! the number of rows and columns of obj1
    integer(kind_integer), intent(in) :: n
!! first dimension of obj1
    integer(kind_integer), intent(in) :: ld1
!! 1-norm of obj1
    real(kind_float), intent(in) :: anorm
!! obj1 as upper('u') or lower('l') triangular matrix
    character(len=1), intent(in) :: uplo
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! reciprocal of condition number of obj1
    real(kind_float), intent(out) :: rcond
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!! integer variables for work size and rwork size
    integer(kind_integer) :: work_val = 1
    integer(kind_integer) :: rwork_val = 1
!! array for work
    complex(kind_double), allocatable :: work(:)
!! array for rwork
    real(kind_double), allocatable :: rwork(:)
!--------------------------------------------------------------------

!! allocate work
    work_val = 2*n
    allocate(work(work_val),stat=ierr)
!! allocate rwork
    rwork_val = n
    allocate(rwork(rwork_val),stat=ierr)

!! solve for reciprocal of condition number
!    call ?pocon(uplo,n,obj1%element,ld1,anorm,rcond,work,rwork,ierr)

!--------------------------------------------------------------------
  end subroutine gpocon
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine gheev(jobz,uplo,n,obj1,ld1,obj2,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< BLAS solve type(base) eigenvalue problem 
!< with real(kind_float) eigenvalues
!< calculates optimized lwork
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! matrix problem in, eigenvectors out
    type(base), intent(inout) :: obj1(:,:)
!! number of rows and columns in obj1
    integer(kind_integer), intent(in) :: n
!! first dimension of obj1
    integer(kind_integer), intent(in) :: ld1
!! character for computing only eigenvalues('n') or both
!! eigenvalues and eigenvectors('v')
    character(len=1), intent(in) :: jobz
!! obj1 as upper('u') or lower('l') triangular matrix
    character(len=1), intent(in) :: uplo
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! eigenvalues (intent out for the sake of LAPACK)
    real(kind_float), intent(out) :: obj2(n)
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!!  integer variable to store optimal WORK size
    integer(kind_integer) :: lwork_val = 1
    integer(kind_integer) :: rwork_val = 1
!!  'array' for optimal lwork (work in first call of LAPACK)
    real(kind_double) :: lworker
!!  array for work
    complex(kind_double), allocatable :: lwork(:)
!!  array for rwork
    real(kind_double), allocatable :: rwork(:)
!--------------------------------------------------------------------

!! allocate rwork
    rwork_val=((3*n)-2)
    allocate(rwork(rwork_val),stat=ierr)
    obj2=real(0,kind=kind_float)
!! first call to LAPACK for optimal lwork
!    call ?heev(jobz,uplo,n,obj1(:,:)%element,ld1,obj2(:),&
!  &     lworker,-1,rwork,ierr) 
!    lwork_val = int(lworker)
!! allocate lwork
!    allocate(lwork(lwork_val),stat=ierr)
!    call ?heev(jobz,uplo,n,obj1(:,:)%element,ld1,obj2(:),&
!  &     lwork,lwork_val,rwork,ierr) 

    if (ierr.ne.0) print *, 'LAPACK solve error!', ierr

!--------------------------------------------------------------------
  end subroutine gheev
!--------------------------------------------------------------------

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

    read(unit=funit, &
  &   fmt='(i10,1x,i10,1x,f23.16,1x,f23.16)', &
  &   iostat=ierr) k1,k2,obj%re,obj%jm

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

    write(unit=funit,fmt='(7x,a3,5x,a6,6x,a4,20x,a15)', &
  &   iostat=ierr) 'row','column','real','split-imaginary'

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
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! file unit
    integer(kind_integer), intent(in) :: funit
!! position of obj in rows and columns
    integer(kind_integer), intent(in) :: k1,k2
!! value to be printed
    type(base), intent(in) :: obj
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------

    write(unit=funit,fmt='(i10,1x,i10,1x,f23.16,1x,f23.16)', &
  &       iostat=ierr) k1,k2,obj%re,obj%jm

!--------------------------------------------------------------------
  end subroutine print_base
!--------------------------------------------------------------------

!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module basetypes
!--------------------------------------------------------------------
!--------------------------------------------------------------------
