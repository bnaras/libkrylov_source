!--------------------------------------------------------------------
!--------------------------------------------------------------------
program test_blastypes
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This program tests generic blas
!< calls defined in a basetypes_* file
!< structured like the print subroutines in arrayfile
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
  use basekinds
  use floatformat
  use basetypes
  use blastypes
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!! parameter for array sizes for the test
  integer(kind_integer), parameter :: n = 3
!! variables of the derived type for testing
  type(base) :: z1
  type(base) :: z2
  type(base) :: z3
  real(kind_float) :: r_test
  real(kind_float) :: r_ref
  real(kind_float) :: x1
  real(kind_float) :: x2
  real(kind_float) :: x_array1(n)
  integer(kind_integer) :: ipiv(n)
  integer(kind_integer) :: iseed(4)
  type(base) :: z_array1(n,n)
  type(base) :: z_array2(n,n)
  type(base) :: z_array3(n,n)
  type(base) :: z_array4(n,n)
  type(base) :: z_vector1(n)
  type(base) :: z_vector2(n)
  type(base) :: tau(n)

! integer for loops
  integer(kind_integer) :: j1,j2 = 0
! integer for error variable
  integer(kind_integer) :: ierr = 0
! variable for array tests
  logical :: check = .false.
! file unit
  integer(kind_integer) :: funit = 0
  character(len=32) :: fname = ''
!! name of file
  character(len=32) :: name_string = '_blas_test'
!--------------------------------------------------------------------

!!  find free unit numbers for files
!!  presumes first 14 unit numbers are saved for
!!  specific use.
  call find_free_file_unit(funit,ierr)
  if (ierr.ne.0) then
    print *, 'No free file units!, test failed'
    stop 
  end if

!! define fname
  fname = trim(base_print_string)//trim(name_string)//'.out'

!! open file
  open(unit=funit,file=fname,action='write',status='replace',iostat=ierr)

!! printing test results as they run
  write(unit=funit,fmt=*) 'Testing basetype array operations'

  write(unit=funit,fmt=*) 'This basetype is ',base_print_string

  write(unit=funit,fmt=*) 'machine precision'
  write(unit=funit,fmt=*) eps

  write(unit=funit,fmt=*) 'log10 of machine precision'
  write(unit=funit,fmt=*) logeps


!!! testing gheev
!! Using do loop to fill in the test input matrix z_array1
!! with 1, 2, 3 on diagonal
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array1(j1,j1) = real(j1,kind=kind_float)
  end do
!! set origin value of r_test and r_ref to real number 0
   r_test = real(0,kind=kind_float)
   r_ref = real(0,kind=kind_float)
!! write gheev and test operation on test input
  write(unit=funit,fmt=*) 'test gheev',&
  &', calculate for eigenvalues and eigenvectors'
!! call gheev on test input onto test output
  call gheev('v','u',n,z_array1,n,x_array1,ierr)
!! set logical check = .false.
    check = .false.
! check ierr value to see whether gheev terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write gheev failed, write the ierr value
    write(unit=funit,fmt=*) 'gheev failed, ierr=',ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write gheev runs
    write(unit=funit,fmt=*) 'gheev runs'
!! write an explanation of the function and result
    write(unit=funit,fmt=*) 'type(base) eigenvectors = z_array1'
    write(unit=funit,fmt=*) 'This should be an identity'   
!! write test to check each element
!! in both test array and reference 
    write(unit=funit,fmt=*) 'test eigenvectors, for each element'
!! using do loops to assign z_array1 to r_test element by element
!! and the elements in reference value
!! since r_ref is supposed to be identity
!! using if statement to assign real number 1 if row = column number
!! else assign real number 0 
    do j2 = 1, n 
      do j1 = 1,n
         r_test = z_array1(j1,j2)
         if (j1.eq.j2) then
           r_ref = real(1,kind=kind_float)
         else
           r_ref = real(0,kind=kind_float)
         end if
!! test if difference is greater than machine precision
!! (defined by the constant eps)
         if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
           write(unit=funit,fmt=*) 'failed for elements', j1, j2 
!! set logical check = .true.
           check = .true.
        end if
      end do
    end do
!! write the explanation of function and result
    write(unit=funit,fmt=*) 'real(kind_float) eigenvalues = x_array1'
    write(unit=funit,fmt=*) 'This should be 1,2,3'
!! write start to check each element
!! in both test array and reference
    write(unit=funit,fmt=*) 'test eigenvalues, for each element'
!! assign a reference array (real(kind_float))
!! by operations on real(kind_float) numbers
!! using a do loop to fill in the matrix for the reference
    do j1 = 1, n
      r_test = x_array1(j1)
      r_ref = real(j1,kind=kind_float)
!! using a do loop to take the absolute difference
!! between the elements in test array
!! and elements in reference value
!! test if difference is greater than machine precision
!! (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed 
!! and the position of the element that failed
        write(unit=funit,fmt=*) 'failed for elements', j1
!! set logical check = .true.
        check = .true.
      end if
    end do
!! check value of logical check
    if (check) then
!! write subroutine gheev failed to output and output file
      write(unit=funit,fmt=*) 'subroutine gheev failed'  
      print *, 'subroutine gheev failed'
    else
!! write subroutine gheev succeeded to output file
      write(unit=funit,fmt=*) 'tested subroutine gheev'
      print *, 'tested subroutine gheev'
    end if
  end if
 

!!! testing ghesv
!! using do loops to fill in test input
!! z_array1 and z_array2
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array1(j1,j1) = real(j1,kind=kind_float)
  end do
  z_array2 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array2(j1,j1) = real(j1,kind=kind_float)
  end do 
!! set origin value of r_test and r_ref to real number 0
  r_test = real(0,kind=kind_float)
  r_ref = real(0,kind=kind_float)
!! write ghesv and operation 
  write(unit=funit,fmt=*) 'test ghesv',&
  &', calculate for the solution of a linear equation'
!! call ghesv on test input onto test output    
    call ghesv('l',n,n,z_array1,n,ipiv,z_array2,n,ierr)
!! set logical check = .false.
    check = .false. 
!! checking ierr value to see whether the subroutine
!! terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write ghesv  failed
!! write the ierr value 
    write(unit=funit,fmt=*) 'ghesv failed, ierr= ', ierr
!! set ierr to 0
    ierr = 0
  else
!! if wrong, write ghesv runs
    write(unit=funit,fmt=*) 'ghesv runs'
!! write an explanation of the function and result
    write(unit=funit,fmt=*) 'type(base) result of a linear equation'
    write(unit=funit,fmt=*) 'This should be an identity'
!! write start to check each element
!! in test arrya and reference
    write(unit=funit,fmt=*) 'test ghesv, for each element'
!! using do loops to assign z_array2 to r_test element by element
!! and the elements in reference value
!! since r_ref is supposed to be identity
!! using if statement to assign real number 1 if row = column number
!! else assign real number 0
   do j2 = 1, n 
      do j1 =1, n
         r_test = z_array2(j1,j2)
         if (j1.eq.j2) then
           r_ref = real(1,kind=kind_float)
         else
           r_ref = real(0,kind=kind_float)
         end if
!! test if difference if greater than machine precision
!! (defined by thecon)
        if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
          write(unit=funit,fmt=*) 'failed for elements', j1, j2
!! set logical check = .true.
          check = .true.
        end if
      end do  
    end do
!! check value of logical check
    if (check) then
!! if true, write subroutine ghesv failed to output and  output file
      write(unit=funit,fmt=*) 'subroutine ghesv failed' 
      print *, 'subroutine ghesv failed'
    else
!! if false, write subroutine ghesv tested to output and output file 
      write(unit=funit,fmt=*) 'tested subroutine ghesv'
      print *, 'tested subroutine ghesv'
    end if
  end if


!!! testing ggemm 
!! using do loops to fill in test input 
!! z_array1 and z_array2, z1 and z2
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array1(j1,j1) = real(j1,kind=kind_float)
  end do
  z_array2 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array2(j1,j1) = real(j1,kind=kind_float)
  end do
  z1 = real(3,kind=kind_float)
  z2 = real(0,kind=kind_float) 
!! set origin value of r_test and r_ref
  r_test = real(0,kind=kind_float)
  r_ref = real(0,kind=kind_float)
!! write ggemm and operation
  write(unit=funit,fmt=*) 'test ggemm',&
  &', calculate for normal matrix multiplication'
!! call ggemm on test input onto test output
  call ggemm('n','n',n,n,n,z1,z_array1,n,z_array2,n,z2,z_array3,n)
!! set logical check = .false.
    check = .false. 
!! write  an explanation of the function, using formula
  write(unit=funit,fmt=*) 'type(base) z_array3', &
  &' = z1 * z_array1 * z_array2 +  z2 * z_array_3'
!! explain the output z_array3
  write(unit=funit,fmt=*) 'z_array3 should be diagonal matrix', &
  &' with 3, 12 ,27 on the diagonal'
!! write start to check each element
!! in both test array and reference
  write(unit=funit,fmt=*) 'test ggemm on real matrix, for each element'
!! using do loops to assign z_array3 element by element to r_test
!! assign r_ref to be a diagonal matrix with 3,12,27 on diagonal
  do j2 = 1, n 
    do j1 = 1,n
       r_test = z_array3(j1,j2)
      if (j1.eq.j2) then
        r_ref = real(3,kind=kind_float) * real(j2,kind=kind_float) * &
  & real(j2,kind=kind_float)
      else 
        r_ref = real(0,kind=kind_float)
      end if
!! using if statement to take the absolute difference
!! between elements in test array and elements in reference
!! to see whether it is greater than eps
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed
!! and the position of the element that failed the test
        write(unit=funit,fmt=*) 'failed for elements', j1, j2
!! set logical check = .true.
        check = .true.
      end if
    end do
  end do

 
!!!testing ggemm
!! using do loops to fill in the test input
!! z_array1 and z_array2, z1 and z2
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array1(j1,j1) = real(j1,kind=kind_float)
  end do
  z_array2 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array2(j1,j1) = real(j1,kind=kind_float)
  end do
  z1 = real(3,kind=kind_float)
  z2 = real(0,kind=kind_float)
!! set origin value of r_test and r_ref to real number 0
  r_test = real(0,kind=kind_float)
  r_ref = real(0,kind=kind_float)
!! write ggemm and operation
  write(unit=funit,fmt=*) 'test ggemm', &
  &', calculate for hermitian conjugate matrix multiplication'
!! call ggemm on test input onto tes output
  call ggemm('c','n',n,n,n,z1,z_array1,n,z_array1,n,z2,z_array4,n)
!! write the explanation of the function using formula 
  write(unit=funit,fmt=*) 'type(base) z_array4', &
  &' = z1 * (z_array1^H) * z_array1 +  z2 * z_array4'
!! explain the output z_array4
  write(unit=funit,fmt=*) 'z_array4 should be a diagonal matrix', &
  & ' with 3,12,27 on the diagonal'
!! write start to check each element
!! in both test array and reference
  write(unit=funit,fmt=*) 'test ggemm',&
  &' on conjugated matrix, for each element'
!! using do loops to assign z_array4 element by element to r_test
!! assign r_ref to be a diagonal matrix with 3,12,27 on diagonal
  do j2 = 1, n 
    do j1 = 1,n
      r_test = z_array4(j1,j2)
      if (j1.eq.j2) then
        r_ref = real(3,kind=kind_float) * real(j2,kind=kind_float) * &
  & real(j2,kind=kind_float)
      else
        r_ref = real(0,kind=kind_float)
      end if
!! using if statement to take the absolute difference 
!! between elements in test array and elements in reference
!! to see whether it isis greater than eps
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed
!! and the position of the element that failed the test
        write(unit=funit,fmt=*) 'failed for elements', j1, j2
!! set logical check = .true. 
        check = .true.
      end if
    end do
  end do
!! check value of logical check
  if (check) then
!! if true, write subroutine ggemm failed to output and output file
    write(unit=funit,fmt=*) 'subroutine ggemm failed'
    print *, 'subroutine ggemm failed'
  else
!! if false, write subroutine ggemm tested to output and output file
    write(unit=funit,fmt=*) 'tested subtoutine ggemm'
    print *, 'tested subroutine ggemm'
  end if


!!! testing gdot
!! using do loops to fill in the test input
!! z_vector1 and z_vector2
  z_vector1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_vector1(j1) = real(j1,kind=kind_float)
  end do
  z_vector2 = real(0,kind=kind_float)
  do j1 = 1, n
    z_vector2(j1) = real(j1,kind=kind_float)
  end do
!! set orgin value of r_test and r_ref to real number 0
  r_test = real(0,kind=kind_float)
  r_ref = real(0,kind=kind_float)
!! write gdot and operation
  write(unit=funit,fmt=*) 'test gdot', &
  &', calculate for dot product of two vectors'
!! call gdot on test input onto test output
  call gdot(n,z_vector1,1,z_vector2,1,z3,ierr)
!! set logical check = .false.
    check = .false. 
!! checking ierr value to see if gdot terminated with an error
  if (ierr.ne.0) then
!! if true, write gdot failed and write the ierr value
    write(unit=funit,fmt=*) 'gdot failed, ierr=', ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write gdot runs 
    write(unit=funit,fmt=*) 'gdot runs'
!! write an explanation of the function 
    write(unit=funit,fmt=*) 'type(base) solution is a dot product' 
!! assign the test output to a real(kind_float) test scalar variable
!! for comparison to referene
    r_test = z3
!! assign a reference array (real(kind_float))
!! by operations on real(kind_float) 
!! using a do loop to fill in the matrix for reference 
    r_ref = real(0,kind=kind_float) 
    do j1 = 1,n
      r_ref = r_ref + &
  & real(j1,kind=kind_float) * real(j1,kind=kind_float)
    end do
!! write the reference to the output file
    write(unit=funit, fmt=*) 'z3 should be equal to', r_ref
!! write start to check each element 
!! in both test array and reference
    write(unit=funit,fmt=*) 'test gdot, for each element'
!! set logical check = .false.
    check = .false.
!! using a do loop to take the absolute difference 
!! between the elements in test sclar and the elements in reference
    do j1 = 1, n 
!! test if difference is greater than machine precision
!! (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
        write(unit=funit,fmt=*) 'failed for element', j1
!! set logical check = .true.
        check = .true.
      end if
    end do
!! check value of logical check
    if (check) then
!! if true, write the subroutine gdot failed to output and output file
      write(unit=funit,fmt=*) 'subroutine gdot failed'
      print *, 'subroutine gdot failed'
    else
!! if false, write the subroutine gdot tested to output and output file
      write(unit=funit,fmt=*) 'tested subroutine gdot'
      print *, 'tested subroutine gdot'
    end if 
  end if


!!! test gpotrf
!! using a do loop to fill in the test input matrix
!! z_array1 
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array1(j1,j1) = real(j1,kind=kind_float) &
  & * real(j1,kind=kind_float)
  end do
!! set origin value of r_test and r_ref to real number 0
  r_test = real(0,kind=kind_float)
  r_ref = real(0,kind=kind_float)
!! write gpotrf and operation
  write(unit=funit,fmt=*) 'test gpotrf', &
  &', calculate for cholesky decomposition of a matrix'
!! call gpotrf to on test input onto test output
  call gpotrf('l',n,z_array1,n,ierr)
!! set logical check = .false.
  check = .false.
!! checking ierr value to see if gpotrf terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write gpotrf failed and write the ierr value
    write(unit=funit,fmt=*) 'gpotrf failed, ierr=', ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write gpotrf runs
    write(unit=funit,fmt=*) 'gpotrf runs'
!! write an explanation of the funtion
    write(unit=funit,fmt=*) 'type(base) result a cholesky decomposition' 
!! write the reference array (unformatted) to the output file
    write(unit=funit,fmt=*) 'z_array1 should be a diagonal matrix',&
  &' with 1,2,3 on the diagonal'
!! write start to check each element in both test array and reference  
    write(unit=funit,fmt=*) 'test gpotrf, for each element'
!! using do loops to assign z_array1 to t_test element by element
!! and the elements in reference value
!! since r_ref is supposed to be a diagonal matrix
!! with 1,2,3 on diagonal matirx
!! using if ststemnt to assign real number 1,2,3 if row =  column number
!! else assign real number 0
    do j2 = 1, n 
      do j1 = 1,n
        r_test = z_array1(j1,j2)
        if (j1.eq.j2) then
          r_ref = real(j2,kind=kind_float)
        else 
          r_ref = real(0,kind=kind_float)
        end if
!! test if difference is greater than machine precision
!! defined by the constant eps
        if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed and the position of element failed
          write(unit=funit,fmt=*) 'failed for element', j1, j2
!! set logical check = .true.
          check = .true.
        end if
      end do
    end do  
!! check value of logical check
    if (check) then
!! if true, write subroutine gpotrf failed to the output and output file
      write(unit=funit,fmt=*) 'subroutine gpotrf failed'
      print *, 'subroutine gpotrf failed'
    else
!! if false, write subroutine gpotrf tested to the output and ouput file
      write(unit=funit,fmt=*) 'tested subroutine gpotrf'
      print *, 'tested subroutine gpotrf'
    end if
  end if


!!! testing glanhe
!! using a do loop to fill in the test input matrix
!! z_array1
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array1(j1,j1) = real(j1,kind=kind_float)
  end do
!! set original r_test and r_ref to real number 0
  r_test = real(0,kind=kind_float)
!! write glanhe and operation  
  write(unit=funit,fmt=*) 'test glanhe', &
  & ',calculate the 1-norm of z_array1'
!! call glanhe on test input onto test output
  call glanhe('1','l',n,z_array1,n,x1,ierr)
!! set logical check = .false.
  check = .false.
!! checking ierr value to see if glanhe terminated with an error 
  if (ierr.ne.0) then
!! if true, write glanhe failed and write ierr value
    write(unit=funit,fmt=*) 'glanhe failed, ierr=', ierr
!! set ierr to 0
    ierr = 0
  else
 !! if false, write glanhe runs
    write(unit=funit,fmt=*) 'glanhe runs'
!! write an explanation of the function
    write(unit=funit,fmt=*) 'test the norm of a type(base)'
!! assign the test output to a real(kind_float) test scalar variable
!! for comparison to reference
    r_test = x1
!! assign a reference value (real(kind_float))
!! by operations on real(kind_float) numbers
    r_ref  = real(3,kind=kind_float)
!! write the reference value (unformatted) to the output file
    write(unit=funit,fmt=*) 'x1 should be equal to', r_ref
!! write start to check each element in both test and reference value 
    write(unit=funit,fmt=*) 'test glanhe, for each element'
!! test if the difference of test and reference is greater than 
!!machine precision (defined by the constant eps)
    if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed for every elements
!! and the position of the element failed
      write(unit=funit,fmt=*) 'failed for elements', j1
!! set logical check = .true.
      check = .true.
    end if
!! check value of logical check
    if (check) then
!! if true, write subroutine glanhe failed to output and output file
      write(unit=funit,fmt=*) 'subroutine glanhe failed'
      print *, 'subroutine glanhe failed'
    else
!! if false, write tested subroutine glanhe to output and output file
      write(unit=funit,fmt=*) 'tested subroutine glanhe'
      print *, 'tested subroutine glanhe'
    end if
  end if

  
!! testing gpocon
!! using a do loop to fill in the test input
!! z_array1 and x1
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array1(j1,j1) = real(j1,kind=kind_float)
  end do
  x1 = real(3,kind=kind_float)
!! set original r_test and r_ref to real number 0
  r_test = real(0,kind=kind_float)
  r_ref = real(0,kind=kind_float)
!! write gpocon and operation
  write(unit=funit,fmt=*) 'test gpocon',&
  &',calculate for the reciprocal of the condition number'
!! call gpocon on test input onton test output 
  call gpocon('l',n,z_array1,n,x1,x2,ierr)
!! set logical check = .false.
  check = .false.
!! checking ierr value to see if gpocon terminated with an error
  if (ierr.ne.0) then
!! if true, write the subroutine failed and write the ierr value
    write(unit=funit,fmt=*) 'gpocon failed, ierr', ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write gpocon runs
    write(unit=funit,fmt=*) 'gpocon runs'
!! write an explanation of the subroutine
    write(unit=funit,fmt=*) 'test type(base)', &
  &' is the reciprocal of the condition number'
!! assign the test output to real(kind_float) test scalar variable
!! for comparison to reference
    r_test = x2
!! assign a reference value (real(kind_float))
    r_ref  = real(1,kind=kind_float) / real(3,kind=kind_float)
!! the reference value (unformatted) to the output file
    write(unit=funit,fmt=*) 'x2 should be equal to', x2
!! write start to check each element in both test and reference
    write(unit=funit,fmt=*) 'test gpocon, for each element'
!! test if the difference of test and reference is greater than
!! machine precision (defined by the constant eps)  
    if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed
!! and the position of the element that failed the test
      write(unit=funit,fmt=*) 'failed for elements', j1
!! set logical check = .true.
      check = .true.
    end if 
    if (check) then
!! if true, write subroutine gpocon failed to output and output file
      write(unit=funit,fmt=*) 'subroutine gpocon failed'
      print *, 'subroutine gpocon failed'
    else
!! if false, write subroutin gpocon tested to output and output file
      write(unit=funit,fmt=*) 'tested subroutine gpocon'
      print *, 'tested subroutine gpocon'
    end if
  end if


!!! testing gtrsm
!! using do loop to fill in the test input
!! z_array1, z_array2 and z1
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array1(j1,j1) = real(j1,kind=kind_float)
  end do
  z_array2 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array2(j1,j1) = real(j1,kind=kind_float)
  end do
  z1 = real(1,kind=kind_float)
!! set original r_test and r_ref to real number 0
  r_test = real(0,kind=kind_float)
  r_ref = real(0,kind=kind_float)
!! write gtrsm and operation
  write(unit=funit,fmt=*) 'test gtrsm',&
  &', calculate for one of the matrix equations'
!! call gtrsm to solve for matrix multiplication of an inverse matrix
!! with left side operation 
!! on test input onto test output
  call gtrsm('l','l','c','n',n,n,z1,z_array2,n,z_array1,n)
!! set logical check = .false.
  check = .false.
!! write an explanation of the function using formula  
  write(unit=funit,fmt=*) 'type(base)', &
  &' z_array1 = z_array1^H * z1 * z_array2'
!! write the reference array (unformatted) to the output file
  write(unit=funit,fmt=*) 'z_array1 should be equal to identity'
!! write start to check each element 
!! in both test array and reference array
  write(unit=funit,fmt=*) 'test gtrsm, for each element'
!! using do loops to assign z_array1 element by element to r_test
!! assign r_ref to be a identity matrix
  do j2 = 1, n 
    do j1 = 1,n
       r_test = z_array1(j1,j2)
       if (j1.eq.j2) then
         r_ref = (real(1,kind=kind_float) / &
  & real(j2,kind=kind_float)) * real(j2,kind=kind_float)
       else
         r_ref = real(0,kind=kind_float)
       end if 
!! test if the absolute difference of r_test and r_ref 
!! is greater than machine precision (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed
!! and the position of the element that failed
        write(unit=funit,fmt=*) 'failed for elements', j1, j2
!! set logical check = .true.
      check = .true.
      end if
    end do
  end do  



!!! testing gtrsm
!! using do loops to fill in the test input
!! z_array1 and z_array2
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array1(j1,j1) = real(j1,kind=kind_float)
  end do
  z_array2 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array2(j1,j1) = real(j1,kind=kind_float)
  end do
  z1 = real(1,kind=kind_float)
!! set original r_test and r_ref to real number 0
  r_test = real(0,kind=kind_float)
  r_ref = real(0,kind=kind_float)
!! write gtrsm and operation
  write(unit=funit,fmt=*) 'test gtrsm', &
  &', calculate for one of the matrix equations'
!! call gtrsm to solve for matrix multiplication of an inverse matrix
!! with left side operation 
!! on test input onto test output
  call gtrsm('l','l','n','n',n,n,z1,z_array2,n,z_array1,n)
!! write an explanation of the function using formula
  write(unit=funit,fmt=*) 'type(base)', &
  &' z_array1 = z_array1^H * z1 * z_array2' 
!! write the reference array (unformatted) to the output file
  write(unit=funit,fmt=*) 'z_array1 should be equal to identity'
!! write start to check each element
!! in both test array and reference array
  write(unit=funit,fmt=*) 'test gtrsm, for each element'
!! using do loops to assign z_array1 element by element to r_test
!! assign r_ref to be a identity matrix
  do j2 = 1, n 
    do j1 = 1,n
       r_test = z_array1(j1,j2)
       if (j1.eq.j2) then
         r_ref = (real(1,kind=kind_float) / &
  & real(j2,kind=kind_float)) * real(j2,kind=kind_float)
       else
         r_ref = real(0,kind=kind_float)
       end if 
!! test if the absolute difference of r_test and r_ref 
!! is greater than machine precision (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed
!! and the position of the element that failed
        write(unit=funit,fmt=*) 'failed for elements', j1, j2
!! set logical check = .true.
      check = .true.
      end if
    end do
  end do 


!!! testing gtrsm
!! using do loops to fill in the test input 
!! z_array1, z_array2 and z1
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array1(j1,j1) = real(j1,kind=kind_float)
  end do
  z_array2 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array2(j1,j1) = real(j1,kind=kind_float)
  end do
  z1 = real(1,kind=kind_float)
!! set origional r_test and r_ref to real number 0
  r_test = real(0,kind=kind_float)
  r_ref = real(0,kind=kind_float)
!! write gtrsm and operation
  write(unit=funit,fmt=*) 'test gtrsm', &
  &', calculate for one of the matrix equations'  
!! call gtrsm to solve for matrix multiplication of an inverse matrix
!! with right side operation 
!! on test input onto test output
  call gtrsm('r','l','c','n',n,n,z1,z_array2,n,z_array1,n)
!! write an explanation of the function using formula
  write(unit=funit,fmt=*) 'printing',&
  &'type(base) z_array1 = z1 * z_array2 * z_array1^H'
!! write the reference array (unformatted) to the output file
  write (unit=funit, fmt=*) 'z_array1 should be equal to identity'
!! write start to check each element 
!! in both test array and reference array
  write(unit=funit,fmt=*) 'test gtrsm, for each element'
!! using do loops to assign z_array1 element by element to r_test
!! assign r_ref to be a identity matrix
  do j2 = 1, n 
    do j1 = 1,n
       r_test = z_array1(j1,j2)
       if (j1.eq.j2) then
         r_ref = (real(1,kind=kind_float) / &
  & real(j2,kind=kind_float)) * real(j2,kind=kind_float)
       else
         r_ref = real(0,kind=kind_float)
       end if 
!! test if the absolute difference of r_test and r_ref 
!! is greater than machine precision (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed
!! and the position of the element that failed
        write(unit=funit,fmt=*) 'failed for elements', j1, j2
!! set logical check = .true.
      check = .true.
      end if
    end do
  end do  
!! check value of logical check
  if (check) then
!! if true, write subroutine gtrsm failed to output and output file
    write(unit=funit,fmt=*) 'subroutine gtrsm failed'
    print *, 'subroutine gtrsm failed'
  else
!! if false, write subroutine gtrsm tested to output and output file
    write(unit=funit,fmt=*) 'tested subroutine gtrsm'
    print *, 'tested subroutine gtrsm'
  end if




!!! test ggetrf
!! using a do loop to fill in the test input matrix
!! z_array2 
  z_array2 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array2(j1,j1) = real(j1,kind=kind_float)
  end do
!! set original r_test and r_ref to real number 0
  r_test = real(0,kind=kind_float)
  r_ref = real(0,kind=kind_float)
!! write ggetrf and operation
  write(unit=funit,fmt=*) 'test ggetrf', &
  &', calculate for LU decomposition of a matrix'
!! call ggetrf to on test input onto test output
  call ggetrf(n,n,z_array2,n,ipiv,ierr)
!! set logical check = .false.
  check = .false.
!! checking ierr value to see if ggetrf terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write ggetrf failed and write the ierr value
    write(unit=funit,fmt=*) 'ggetrf failed, ierr=', ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write gpotrf runs
    write(unit=funit,fmt=*) 'ggetrf runs'
!! write an explanation of the funtion
    write(unit=funit,fmt=*) 'type(base) solution for LU decomposition' 
!! write explanation to the output file
    write(unit=funit,fmt=*) 'z_array2 should be equal to', &
  & ' a diagonal matrix with 1,2,3 on diagonal'
!! write start to check each element in both test array and reference  
    write(unit=funit,fmt=*) 'test ggetrf, for each element'
!! using do loops to assign z_array2 to r_test element by elemnt
!! and r_ref as a diagonal matrix with 1,2,3 on the diagonal
    do j2 = 1, n 
      do j1 = 1,n
        r_test = z_array2(j1,j2)
        if (j1.eq.j2) then
          r_ref = real(j2,kind=kind_float)
        else
          r_ref = real(0,kind=kind_float) 
        end if
!! test the absolute difference of r_test and r_ref 
!! whether it is greater than machine precision defined by constant eps
        if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed and the position of element failed
          write(unit=funit,fmt=*) 'failed for element', j1, j2
!! set logical check = .true.
          check = .true.
        end if
      end do
    end do  
  end if


!!! testing ggetrs
!! using do loops to fill in the test input
!! z_array1
!! reuse output from ggetrf test, z_array2 and ipiv
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array1(j1,j1) = real(j1,kind=kind_float)
  end do
!! write gtrsm and operation
  write(unit=funit,fmt=*) 'test ggetrs', &
  &', calculate for one of the matrix equations'
!! write an explanation of the function using formula
  write(unit=funit,fmt=*) 'printing'&
  &',type(base) z_array1 = z_array2^(-1) * z_array2' 
!! call ggetrs to solve for matrix multiplication of an inverse matrix
!! with left side operation 
!! on test input onto test output
  call ggetrs('n',n,n,z_array2,n,ipiv,z_array1,n,ierr)
!! checking ierr value to see if ggetrs terminated with an error
  if (ierr.ne.0) then
!! if true, write the subroutine failed and write the ierr value
    write(unit=funit,fmt=*) 'ggetrs failed, ierr', ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write gpocon runs
    write(unit=funit,fmt=*) 'ggetrs runs'
!! write the explanation  to the output file
    write(unit=funit,fmt=*) 'z_array1 should be equal to', &
  & ' a diagonal matrix with 1,2,3 on the diagonal'
!! write start to check each element
!! in both test array and reference array
    write(unit=funit,fmt=*) 'test ggetrs, for each element'
!! using do loops to assign z_array2 to r_test element by elemnt
!! and r_ref as a diagonal matrix with 1,2,3 on the diagonal
    do j2 = 1, n 
      do j1 = 1,n
        r_test = z_array2(j1,j2)
        if (j1.eq.j2) then
          r_ref = real(j2,kind=kind_float)
        else
          r_ref = real(0,kind=kind_float) 
        end if
!! test the absolute difference of r_test and r_ref 
!! whether it is greater than machine precision defined by constant eps
        if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed and the position of element failed
          write(unit=funit,fmt=*) 'failed for element', j1, j2
!! set logical check = .true.
          check = .true.
        end if
      end do
    end do  
!! check value of logical check
    if (check) then
!! if true, write subroutine ggetrs failed to output and output file
      write(unit=funit,fmt=*) 'subroutine ggetrs failed'
      print *, 'subroutine ggetrs failed'
    else
!! if false, write subroutine ggetrs tested to output and output file
      write(unit=funit,fmt=*) 'tested subroutine ggetrs'
      print *, 'tested subroutine ggetrs'
    end if
  end if

!!! test ggesvd
!! using a do loop to fill in the test input matrix
!! z_array1 
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array1(j1,j1) = real(j1,kind=kind_float)
  end do
!! write ggesvd and operation
  write(unit=funit,fmt=*) 'test ggesvd', &
  &', calculate the singular value decomposition of z_array1'
!! call ggesvd to on test input onto test output
  call ggesvd('a','a',n,n,z_array1,n,x_array1,z_array2,n,z_array3,n,ierr)
!! set logical check = .false.
  check = .false.
!! checking ierr value to see if ggesvd terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write ggesvd failed and write the ierr value
    write(unit=funit,fmt=*) 'ggesvd failed, ierr=', ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write ggesvd runs
    write(unit=funit,fmt=*) 'ggesvd runs'
!! write an explanation of the funtion
    write(unit=funit,fmt=*) 'type(base) solution for SVD' 
!! write explanation to the output file
    write(unit=funit,fmt=*) 'z_array1 is unchanged'
!! write start to check each element in both test array and reference  
    write(unit=funit,fmt=*) 'test z_array1, for each element'
!! using do loops to assign z_array1 to r_test element by element
!! and r_ref as a diagonal matrix with 1,2,3 on the diagonal
    do j2 = 1, n 
      do j1 = 1,n
        r_test = z_array1(j1,j2)
        if (j1.eq.j2) then
          r_ref = real(j2,kind=kind_float)
        else
          r_ref = real(0,kind=kind_float) 
        end if
!! test the absolute difference of r_test and r_ref 
!! whether it is greater than machine precision defined by constant eps
        if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed and the position of element failed
          write(unit=funit,fmt=*) 'failed for element', j1, j2
!! set logical check = .true.
          check = .true.
        end if
      end do
    end do  
!! write the explanation of function and result
    write(unit=funit,fmt=*) 'real(kind_float) diagonal matrix S = x_array1'
    write(unit=funit,fmt=*) 'This should be 1,2,3'
!! write start to check each element
!! in both test array and reference
    write(unit=funit,fmt=*) 'test singular values of x_array1, for each element'
!! assign a reference array (real(kind_float))
!! by operations on real(kind_float) numbers
!! using a do loop to fill in the matrix for the reference
    do j1 = n, 1
      r_test = x_array1(j1)
      r_ref = real(j1,kind=kind_float)
!! using a do loop to take the absolute difference
!! between the elements in test array
!! and elements in reference value
!! test if difference is greater than machine precision
!! (defined by the constant eps)
      if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed 
!! and the position of the element that failed
        write(unit=funit,fmt=*) 'failed for elements', j1
!! set logical check = .true.
        check = .true.
      end if
    end do
!! check value of logical check
    if (check) then
!! write subroutine ggesvd failed to output and output file
      write(unit=funit,fmt=*) 'subroutine ggesvd failed'  
      print *, 'subroutine ggesvd failed'
      write(unit=funit,fmt=*) 'test singular values of z_array1, for each element'
!! using do loops to assign z_array2 to r_test element by element
!! and r_ref as a diagonal matrix with 1,2,3 on the diagonal
    write(unit=funit,fmt=*) 'test left singular vectors of z_array1, for each element'
    write(unit=funit,fmt=*) 'contains ones on the secondary diagonal'
    do j2 = 1, n 
      do j1 = 1,n
        r_test = z_array2(j1,j2)
        if (j1.eq.(j2+2)) then
          r_ref = real(j2,kind=kind_float)
        else if (j1.eq.(j2-2)) then
          r_ref = real(j1,kind=kind_float)
        else if ((j1.eq.2) .or. (j2.eq.2)) then
          r_ref = real(j2,kind=kind_float)
        else
          r_ref = real(0,kind=kind_float) 
        end if
!! test the absolute difference of r_test and r_ref 
!! whether it is greater than machine precision defined by constant eps
        if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed and the position of element failed
          write(unit=funit,fmt=*) 'failed for element', j1, j2
!! set logical check = .true.
          check = .true.
        end if
      end do
    end do  
!! using do loops to assign z_array2 to r_test element by element
!! and r_ref as a diagonal matrix with 1,2,3 on the diagonal
    write(unit=funit,fmt=*) 'test right singular vectorss of z_array1, for each element'
    write(unit=funit,fmt=*) 'contains ones on the secondary diagonal'
    do j2 = 1, n 
      do j1 = 1,n
        r_test = z_array3(j1,j2)
        if (j1.eq.(j2+2)) then
          r_ref = real(j2,kind=kind_float)
        else if (j1.eq.(j2-2)) then
          r_ref = real(j1,kind=kind_float)
        else if ((j1.eq.2) .or. (j2.eq.2)) then
          r_ref = real(j2,kind=kind_float)
        else
          r_ref = real(0,kind=kind_float) 
        end if
!! test the absolute difference of r_test and r_ref 
!! whether it is greater than machine precision defined by constant eps
        if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed and the position of element failed
          write(unit=funit,fmt=*) 'failed for element', j1, j2
!! set logical check = .true.
          check = .true.
        end if
      end do
    end do  
    else
!! write subroutine ggesvd succeeded to output file
      write(unit=funit,fmt=*) 'tested subroutine ggesvd'
      print *, 'tested subroutine ggesvd'
    end if
  end if

!!! test ggeqrf
!! using a do loop to fill in the test input matrix
!! z_array1 
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array2(j1,j1) = real(j1,kind=kind_float)
  end do
!! set original r_test and r_ref to real number 0
  r_test = real(0,kind=kind_float)
  r_ref = real(0,kind=kind_float)
!! write ggeqrf and operation
  write(unit=funit,fmt=*) 'test ggeqrf', &
  &', calculate for Q of QR decomposition'
!! call ggeqrf to on test input onto test output
  call ggeqrf(n,n,z_array1,n,tau,ierr)
!! set logical check = .false.
  check = .false.
!! checking ierr value to see if ggeqrf terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write ggeqrf failed and write the ierr value
    write(unit=funit,fmt=*) 'ggeqrf failed, ierr=', ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write ggeqrf runs
    write(unit=funit,fmt=*) 'ggeqrf runs'
!! write an explanation of the funtion
    write(unit=funit,fmt=*) 'type(base) solution for QR decomposition' 
!! write explanation to the output file
    write(unit=funit,fmt=*) 'z_array1 should be equal to', &
  & ' a diagonal matrix with 1,2,3 on diagonal'
!! write start to check each element in both test array and reference  
    write(unit=funit,fmt=*) 'test ggeqrf, for each element'
!! using do loops to assign z_array1 to r_test element by element
!! and r_ref as a diagonal matrix with 1,2,3 on the diagonal
    do j2 = 1, n 
      do j1 = 1,n
        r_test = z_array1(j1,j2)
        if (j1.eq.j2) then
          r_ref = real(j2,kind=kind_float)
        else
          r_ref = real(0,kind=kind_float) 
        end if
!! test the absolute difference of r_test and r_ref 
!! whether it is greater than machine precision defined by constant eps
        if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed and the position of element failed
          write(unit=funit,fmt=*) 'failed for element', j1, j2
!! set logical check = .true.
          check = .true.
        end if
      end do
    end do  
  end if


!! close file
  close(unit=funit,iostat=ierr,status='keep')

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program test_blastypes
!--------------------------------------------------------------------
!--------------------------------------------------------------------
