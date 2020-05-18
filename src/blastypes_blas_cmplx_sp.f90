!--------------------------------------------------------------------
!--------------------------------------------------------------------
module blastypes
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This module defines the blas/lapack calls for the array operations
!< for krylovtypes_*.f90
!< This is the complex version using BLAS 
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! contains definition of single and double precision, and kind_integer
  use basekinds
! contains the precision parameter kind_float and related parameters
  use floatformat
! contains the array element definition type(base)
  use basetypes
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------


!--------------------------------------------------------------------
contains

!--------------------------------------------------------------------
! Wrapper for blas routines
! all other multiplications are done with explicit loops,
! requiring the overloading in basetypes
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine ggemm(trans1,trans2,m,n,k,alpha,obj1,ld1,obj2,ld2, &
  &   beta,obj3,ld3)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< Matrix Multiplication alpha*(obj1**T)*obj2 +  beta*obj3 = obj3 
!< or Matrix Multiplication alpha*obj1*(obj2**T) + beta*obj3 = obj3 
!< or Matrix Multiplication alpha*obj1*obj2 + beta*obj3 = obj3 
!< of type(base)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
    use floatformat
    use basetypes
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
    type(base), intent(inout) :: obj3(m,n)
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------

    call cgemm(trans1,trans2,m,n,k,alpha%element,obj1%element, &
  &     ld1,obj2%element,ld2,beta%element,obj3%element,ld3)

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
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
    use floatformat
    use basetypes
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! number of elements in obj1 and obj2
    integer(kind_integer), intent(in) :: n
!! array 1
    type(base), intent(in) :: obj1(n)
!! array 2
    type(base), intent(in) :: obj2(n)
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
!! variable for function call
    complex(kind_double), external :: zdotc
    complex(kind_single), external :: cdotc
!--------------------------------------------------------------------

    obj3%element = cdotc(n,obj1%element,inc1,obj2%element,inc2)

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
    use floatformat
    use basetypes
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

    call cpotrf(uplo,n,obj1%element,ld1,ierr)

!--------------------------------------------------------------------
  end subroutine gpotrf
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine ggetrf(m,n,obj1,ld1,ipiv,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< LU decomposition
!< where obj1 is the matrix to be decomposed
!< and obj1 is the output
!< note dim(ipiv) = min(m,n)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
    use floatformat
    use basetypes
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! scaled overlap matrix
    type(base), intent(inout) :: obj1(:,:)
!! number of rows in obj1
    integer(kind_integer), intent(in) :: m
!! number of rows in obj1
    integer(kind_integer), intent(in) :: n
!! first dimension of obj1
    integer(kind_integer), intent(in) :: ld1
!! pivot index
    integer(kind_integer), intent(inout) :: ipiv(:)
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------

    call cgetrf(m,n,obj1%element,ld1,ipiv,ierr)

!--------------------------------------------------------------------
  end subroutine ggetrf
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
    use floatformat
    use basetypes
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

    call ctrsm(side,uplo,trans1,diag,m,n,alpha%element, &
  &     obj1%element,ld1,obj2%element,ld2)

!--------------------------------------------------------------------
  end subroutine gtrsm
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine gpotrs(trans1,n,m,obj1,ld1, &
  &   obj2,ld2,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< Matrix Multiplication ((obj1)**-1)*obj2
!< of type(base)
!< where obj1 is cholesky decomposed
!< done by forward (and backward) substitution
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
!! lower triangular decomposition of overlap
    type(base), intent(in) :: obj1(:,:)
!! eigenvectors or matrix to be transformed
    type(base), intent(inout) :: obj2(:,:)
!! number of rows in obj1
    integer(kind_integer), intent(in) :: n
!! number of columns in obj2
    integer(kind_integer), intent(in) :: m
!! first dimension of obj1
    integer(kind_integer), intent(in) :: ld1
!! first dimension of obj2
    integer(kind_integer), intent(in) :: ld2
!! character for L or U of  obj1 stored
    character(len=1), intent(in) :: trans1
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------

    call gpotrs(trans1,n,m,obj1%element,ld1, &
  &   obj2%element,ld2,ierr)

!--------------------------------------------------------------------
  end subroutine gpotrs
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine ggetrs(trans1,m,n,obj1,ld1,ipiv, &
  &   obj2,ld2,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< Matrix Multiplication obj1**(-T)*obj2
!< or Matrix Multiplication obj1**(-1)*obj2
!< of type(base)
!< where obj1 is LU decomposed
!< done by forward (and backward) substitution
!< note dim(ipiv) = min(m,n)
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
!! character for obj1**T('c' or 't') or obj1('n')
    character(len=1), intent(in) :: trans1
!! pivot index
    integer(kind_integer), intent(in) :: ipiv(:)
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------

    call cgetrs(trans1,m,n,obj1%element,ld1,ipiv, &
  &   obj2%element,ld2,ierr)

!--------------------------------------------------------------------
  end subroutine ggetrs
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine glanhe(norm,uplo,n,obj1,ld1,onorm,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< finding the 1-norm, infinity-norm, frobenius-norm
!< or maximum element of a triangular matrix
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
    use floatformat
    use basetypes
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! the number of rows and columns of obj1
    integer(kind_integer), intent(in) :: n
!! overlap matrix
    type(base), intent(in) :: obj1(:,:)
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
!! size of work array
    integer(kind_integer) :: lwork = 1
!! array for work
    real(kind_float), allocatable :: work(:)
!! variable for function call
    real(kind_double), external :: zlanhe
    real(kind_single), external :: clanhe
!--------------------------------------------------------------------

!! allocate work
    lwork = n
    allocate(work(lwork))

!! call LAPACK routine
    onorm = clanhe(norm,uplo,n,obj1%element,ld1,work)

    deallocate(work)

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
    use floatformat
    use basetypes
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
    complex(kind_float), allocatable :: work(:)
!! array for rwork
    real(kind_float), allocatable :: rwork(:)
!--------------------------------------------------------------------

!! allocate work
    work_val = 2*n
    allocate(work(work_val),stat=ierr)
!! allocate rwork
    rwork_val = n
    allocate(rwork(rwork_val),stat=ierr)

!! solve for reciprocal of condition number
    call cpocon(uplo,n,obj1%element,ld1,anorm,rcond,work,rwork,ierr)

    deallocate(work,rwork)

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
    use floatformat
    use basetypes
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
    real(kind_float), intent(inout) :: obj2(:)
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
    complex(kind_float) :: lworker
!!  array for work
    complex(kind_float), allocatable :: lwork(:)
!!  array for rwork
    real(kind_float), allocatable :: rwork(:)
!--------------------------------------------------------------------

!! allocate rwork
    rwork_val=((3*n)-2)
    lwork_val = ((2*n)-1) 
    allocate(rwork(rwork_val))
!! first call to LAPACK for optimal lwork
    call cheev(jobz,uplo,n,obj1(:,:)%element,ld1,obj2(:),&
  &       lworker,-1,rwork,ierr) 

    if (ierr.ne.0) return

    lwork_val = int(lworker,kind=kind_integer)

!! allocate lwork
    allocate(lwork(lwork_val))
!! second call to LAPACK to solve
    call cheev(jobz,uplo,n,obj1(:,:)%element,ld1,obj2(:),&
  &       lwork,lwork_val,rwork,ierr) 
 
    deallocate(rwork,lwork)

!--------------------------------------------------------------------
  end subroutine gheev
!--------------------------------------------------------------------

!!--------------------------------------------------------------------
!  subroutine glaghe(n,k,obj1,obj2,ld2,iseed,ierr)
!!--------------------------------------------------------------------
!!
!!--------------------------------------------------------------------
!!< Description:
!!< wrapper for
!!< obtaining a symmetric matrix obj2 from the vector obj1
!!< as the diagonals, using iseed as a randomizer
!!--------------------------------------------------------------------
!!
!!--------------------------------------------------------------------
!! Modules
!!--------------------------------------------------------------------
!    use basekinds
!    use floatformat
!    use basetypes
!!--------------------------------------------------------------------
!!
!    implicit none
!!
!!--------------------------------------------------------------------
!! Input Parameters
!!--------------------------------------------------------------------
!!! number of rows and columns in obj2 and rows in obj1
!    integer(kind_integer), intent(in) :: n
!!! 
!    integer(kind_integer), intent(in) :: k
!!! diagonal to be used to generate obj2
!    real(kind_float), intent(in) :: obj1(:)
!!! first dimension of obj2
!    integer(kind_integer), intent(in) :: ld2
!!! iseed for randomizing
!    integer(kind_integer), intent(in) :: iseed(4)
!!--------------------------------------------------------------------
!! Output Parameters
!!--------------------------------------------------------------------
!!! eigenvalues (intent out for the sake of LAPACK)
!    type(base), intent(inout) :: obj2(:,:)
!!--------------------------------------------------------------------
!! Error Parameter
!!--------------------------------------------------------------------
!    integer(kind_integer), intent(inout) :: ierr
!!--------------------------------------------------------------------
!!  Local Variables
!!--------------------------------------------------------------------
!!!  integer variable to store optimal WORK size
!    integer(kind_integer) :: work_val = 1
!!!  array for work
!    type(base), allocatable :: work(:)
!!--------------------------------------------------------------------
!
!!! allocate lwork
!    work_val = 2*n
!    allocate(work(work_val))
!    call claghe(n,k,obj1,obj2(:,:)%element,ld2, &
!  &     iseed,work,ierr)
!
!    deallocate(work)
!
!!--------------------------------------------------------------------
!  end subroutine glaghe
!!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine ghesv(uplo,n,nrhs,obj1,ld1,ipiv,obj2,ld2,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< wrapper for
!< BLAS solve type(base) linear problem 
!< calculates optimized lwork
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules
!--------------------------------------------------------------------
    use basekinds
    use floatformat
    use basetypes
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! matrix problem in, block diagonal out
    type(base), intent(inout) :: obj1(:,:)
!! number of rows and columns in obj1
    integer(kind_integer), intent(in) :: n
!! number of columns in obj2
    integer(kind_integer), intent(in) :: nrhs
!! first dimension of obj1
    integer(kind_integer), intent(in) :: ld1
!! first dimension of obj2
    integer(kind_integer), intent(in) :: ld2
!! obj1 as upper('u') or lower('l') matrix stored
    character(len=1), intent(in) :: uplo
!--------------------------------------------------------------------
! Input/Output Parameters
!--------------------------------------------------------------------
!! rhs in, solutions out
    type(base), intent(inout) :: obj2(:,:)
!! details of interchange (intent out in LAPACK)
    integer(kind_integer), intent(inout) :: ipiv(:)
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!!  integer variable to store optimal WORK size
    integer(kind_integer) :: lwork_val = 1
!!  'array' for optimal lwork (work in first call of LAPACK)
    complex(kind_float) :: lworker
!!  array for lwork
    complex(kind_float), allocatable :: lwork(:)
!--------------------------------------------------------------------


    lwork_val = n
!! first call to LAPACK for optimal lwork
    call chesv(uplo,n,nrhs,obj1(:,:)%element,ld1,ipiv,&
  &     obj2(:,:)%element,ld2, &
  &     lworker,-1,ierr)

    if (ierr.ne.0) return

    lwork_val = int(lworker,kind=kind_integer)
!! allocate lwork
    allocate(lwork(lwork_val))

    call chesv(uplo,n,nrhs,obj1(:,:)%element,ld1,ipiv,&
  &     obj2(:,:)%element,ld2, &
  &     lwork,lwork_val,ierr)

    deallocate(lwork)

!--------------------------------------------------------------------
  end subroutine ghesv
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module blastypes
!--------------------------------------------------------------------
!--------------------------------------------------------------------
