!-------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
program problem_1
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This program generates the problem matrix for driver_1 to be 
!< tested on. Compiling with the different floatformat_*.f90
!< and basetypes_*.f90 gives the different matrix types
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
  type(base), allocatable :: krylov_a(:,:), obj1(:,:), obj2(:,:)
  type(base), allocatable :: rhs(:,:), soln(:,:), ax(:,:), lagr(:,:)
! character string to identify all files
  character(len=32), target :: p1_string = ''
! character string for file name that contains the problem
  character(len=32) :: problemname_string = ''
! character string for file name that contains the exact solution
  character(len=32) :: eigenname_string = ''
! character string for file name that contains the rhs solution
  character(len=32) :: rhs_string = ''
! character string for file name that contains the lagr solution
  character(len=32) :: lagr_string = ''
! character string for file name that contains the frequencies
  character(len=32) :: freqname_string = ''
! string indicating which eigenvalue
  character(len=32) :: eigenvalue_string = ''
! integers for the size of the problem
  integer(kind_integer) :: n = 500
  integer(kind_integer) :: m = 1
  integer(kind_integer) :: l = 2
!! dummy indexes
  integer(kind_integer) :: j,k = 0
!! output variable for BLAS
  integer(kind_integer), allocatable :: ipiv(:)
!! diagonal for lapack and eigenvalues
  real(kind_float), allocatable :: diag(:), freq(:)
!! one in kind base
  type(base) :: one_kb
!! zero in kind base
  type(base) :: zero_kb
!! scalars
  type(base) :: xax, xp, px, xx
!! variables for testing
  real(kind_float) :: rtest
  real(kind_float) :: rref
!! variables for normalization
  type(base) :: norm_sq_base
  real(kind_float) :: norm_real
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
  integer(kind_integer) :: ierr = 0
!--------------------------------------------------------------------


!! allocate array to contain problem, diagonal used to 
!! construct problem, and work array
  allocate(krylov_a(n,n))
  allocate(obj1(n,n))
  allocate(obj2(n,n))
  allocate(ipiv(n))
  allocate(diag(n))
  allocate(rhs(n,m))
  allocate(soln(n,m*l))
  allocate(ax(n,m))
  allocate(lagr(l,m))
  allocate(freq(l))

  print *, 'all allocations successful'

!! creating the (I + B) matrix into obj1
  do k = 1, n
    obj1(k, k) = real(1,kind=kind_float)
  end do

  do k = 1, n
    do j = (k+1), n
      obj1(j,k) = -(sin(real(j + k,kind=kind_float)))
    end do
  end do
  
  do k = 1, n
    do j = 1, (k-1)
      obj1(j,k) = sin(real(j + k,kind=kind_float))
    end do
  end do

!! creating the (I - B) matrix into obj2
  do k = 1, n
    obj2(k, k) = real(1,kind=kind_float)
  end do

  do k = 1, n
    do j = (k+1), n
      obj2(j,k) = sin(real(j + k,kind=kind_float))
    end do
  end do
  
  do k = 1, n
    do j = 1, (k-1)
      obj2(j,k) = -(sin(real(j + k,kind=kind_float)))
    end do
  end do

!! call ggetrf to invert obj1
  call ggetrf(n,n,obj1,n,ipiv,ierr)

  if ( ierr .eq. 0 ) then
    print *, 'successful exit from ggetrf'
  else if ( ierr .lt. 0 ) then
    print *, 'illegal value'
    stop
  else
    print *, 'obj1(j,j) is zero, where j = ', ierr
    stop
  end if

!! call ggetrs to multiply results from ggetrf
  call ggetrs('n',n,n,obj1,n,ipiv,obj2,n,ierr)
  
  if ( ierr .eq. 0 ) then
    print *, 'successful exit from ggetrs'
  else
    print *, 'illegal value, ierr = ', ierr
    stop
  end if

!! normalizing obj2
  do k = 1, n
    call gdot(n,obj2(1:n,k),1,obj2(1:n,k), &
  &       1,norm_sq_base,ierr)
    if (ierr.ne.0) stop
    norm_real = norm_sq_base
    norm_real = sqrt(norm_real)
! normalize
!    obj2(1:n,k) = obj2(1:n,k)/norm_real
  end do


!! obj2 contains the eigenvectors, U matrix

  one_kb = real(1,kind=kind_float)
  zero_kb = real(0,kind=kind_float)

  call ggemm('c','n',n,n,n,one_kb,obj2,n,obj2,n,&
  & zero_kb,obj1,n)

  do k = 1, n
    do j = 1, n
      rtest = obj1(j,k)
      rtest = abs(rtest)
      if (j .eq. k) then
        rref = real(1,kind=kind_float)
        if (abs(rtest-rref) .gt. eps) then
          print *, 'diag problem', j, obj1(j,k)
        end if
      else
        if (abs(rtest) .gt. eps) then
          print *, 'problem', j,k, obj1(j,k) 
        end if
      end if
    end do
  end do 

  print *, 'transformation matrix okay'

!! generate eigenvalues
!  do k = 1, n
!    diag(k) = real(k+k,kind=kind_float)
!  end do


!! ask for user input on preconditoner
  print *, 'Please enter an option for type of eigenvalue'
  print *, '"positive" for positive eigenvalues' 
  print *, '"negative" for negative eigenvalues' 
  print *, '"variable" for both positive and negative eigenvalues' 
  read (*,*) eigenvalue_string
  print *, eigenvalue_string,' eigenvalues entered'


  if (eigenvalue_string.eq.'positive') then
    do k = 1, n
      diag(k) = abs(cos(real(k+k,kind=kind_float)))
    end do
  else if (eigenvalue_string.eq.'negative') then
    do k = 1, n
      diag(k) = -abs(cos(real(k+k,kind=kind_float)))
    end do
  else if (eigenvalue_string.eq.'variable') then
    do k = 1, n
      diag(k) = cos(real(k+k,kind=kind_float))
    end do
  end if

!! set a1_string based on basetypes
  p1_string = trim(base_print_string)//'_1a'

!!allocate set the filename_string for the file name 
  eigenname_string = trim(p1_string)//'_exact_vals'

!! print exact eigens
  call array_print_float(eigenname_string,n,&
  &   diag,ierr)

  if (ierr.ne.0) then
    print *, 'problem printing exact solutions!'
    stop
  end if

!! Compute D*U matrix into obj1, where D = (j + k)
  do k = 1, n
    obj1(k, 1:n) = obj2(k, 1:n) * diag(k)
  end do

! assigning constant value
  one_kb = real(1,kind=kind_float)
  zero_kb = real(0,kind=kind_float)

  krylov_a = real(0,kind=kind_float)
  
!! compute Ut*[D*U]
  call ggemm('c','n',n,n,n,one_kb,obj2,n,obj1,n,&
  &  zero_kb,krylov_a,n)

  print *, 'matrix A generated'

!! set a1_string based on basetypes
  p1_string = trim(base_print_string)//'_1a'

!! set the filename_string for the file name 
  problemname_string = trim(p1_string)//'_prob'

!! print problem array size
  call array_print_base(problemname_string,n,&
  &   n,krylov_a,ierr)

  if (ierr.ne.0) then
    print *, 'problem printing problem a matrix A!'
    stop
  end if

!! set a1_string based on basetypes
  p1_string = trim(base_print_string)//'_1b'

!! set the filename_string for the file name 
  problemname_string = trim(p1_string)//'_prob'

!! print problem array size
  call array_print_base(problemname_string,n,&
  &   n,krylov_a,ierr)

  if (ierr.ne.0) then
    print *, 'problem printing problem b matrix A!'
    stop
  end if

!! set a1_string based on basetypes
  p1_string = trim(base_print_string)//'_1c'

!! set the filename_string for the file name 
  problemname_string = trim(p1_string)//'_prob'

!! print problem array size
  call array_print_base(problemname_string,n,&
  &   m,krylov_a,ierr)

  if (ierr.ne.0) then
    print *, 'problem printing problem c matrix A!'
    stop
  end if

  obj1 = krylov_a
  call gheev('v','l',n,obj1,n,diag,ierr)

  if (ierr.ne.0) then
    print *, 'problem solving problem a!'
    stop
  end if

!! set a1_string based on basetypes
  p1_string = trim(base_print_string)//'_1a'

!!allocate set the filename_string for the file name 
  eigenname_string = trim(p1_string)//'_test_vals'

!! print exact eigens
  call array_print_float(eigenname_string,n,&
  &   diag,ierr)

  if (ierr.ne.0) then
    print *, 'problem printing exact solutions!'
    stop
  end if

!! generate rhs matrix
  do k = 1, m
    do j = 1, n
      rhs(j, k) = cos(real(j + k,kind=kind_float))
    end do
  end do
  

!! set a1_string based on basetypes
  p1_string = trim(base_print_string)//'_1b'

!! set the filename_string for the file name 
  rhs_string = trim(p1_string)//'_rhs'

!! print problem array size
  call array_print_base(rhs_string,n,&
  &   m,rhs,ierr)

  if (ierr.ne.0) then
    print *, 'problem printing problem b rhs!'
    stop
  end if

!! set a1_string based on basetypes
  p1_string = trim(base_print_string)//'_1c'

!! set the filename_string for the file name 
  rhs_string = trim(p1_string)//'_rhs'

!! print problem array size
  call array_print_base(rhs_string,n,&
  &   m,rhs,ierr)

  if (ierr.ne.0) then
    print *, 'problem printing problem c rhs!'
    stop
  end if

  do j = 0, l-1
    soln(1:n,(1+m*j):(m+m*j)) = rhs
    if ( j .ne. 0 ) then
      do k = 1, n
        krylov_a(k,k) = krylov_a(k,k) - freq(j+1)
      end do
    end if

! call exact solver
    call ghesv('l',n,m,krylov_a,n,ipiv,&
   &  soln(1:n,(1+m*j):(m+m*j)),n,ierr)

    if (ierr.ne.0) then
      print *, 'problem solving problem c, frequency = ', (j+1)
      stop
    end if

    if ( j .ne. 0 ) then
      do k = 1, n
        krylov_a(k,k) = krylov_a(k,k) - (-freq(j+1))
      end do
    end if

! generate lagragian
    lagr = real(0,kind=kind_float)
    call ggemm('n','n',n,m,n,one_kb,krylov_a,n,&
  &  soln(1:n,(1+m*j):(m+m*j)),n,&
  &  zero_kb,ax,n)
    do k = 1, m
      call gdot(n,soln(1:n,(k+m*j)),1,ax(1:n,k), &
  &       1,xax,ierr)
      call gdot(n,soln(1:n,(k+m*j)),1,rhs(1:n,k), &
  &       1,xp,ierr)
      call gdot(n,rhs(1:n,k),1,soln(1:n,(k+m*j)), &
  &       1,px,ierr)
      if ( j .eq. 0 ) then
        lagr(j+1,k) = xax - xp - px
      else
        call gdot(n,soln(1:n,(k+m*j)),1,soln(1:n,(k+m*j)), &
  &       1,xx,ierr)
        lagr(j+1,k) = xax - (xx*freq(j+1)) - xp - px
      end if
    end do
  end do   

!! set a1_string based on basetypes
  p1_string = trim(base_print_string)//'_1b'

!! set the filename_string for the file name 
  lagr_string = trim(p1_string)//'_exact_lagr'

!! print problem array size
  call array_print_base(lagr_string,1,&
  &   m,lagr(1,1:m),ierr)

    if (ierr.ne.0) then
      print *, 'problem printing problem b lagragian!'
      stop
    end if 

!! set a1_string based on basetypes
    p1_string = trim(base_print_string)//'_1c'

!! set the filename_string for the file name 
    lagr_string = trim(p1_string)//'_exact_lagr'

!! print problem array size
    call array_print_base(lagr_string,l,&
  &   m,lagr,ierr)

    if (ierr.ne.0) then
      print *, 'problem printing problem c lagragian!'
      stop
    end if 

  deallocate(krylov_a)
  deallocate(obj1)
  deallocate(obj2)
  deallocate(ipiv)
  deallocate(diag)
  deallocate(rhs)
  deallocate(soln)
  deallocate(ax)
  deallocate(lagr)
  deallocate(freq)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program problem_1
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
