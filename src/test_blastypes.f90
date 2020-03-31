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
  real(kind_float) :: r_testarray1(n,n)
  real(kind_float) :: r_refarray1(n,n)
  real(kind_float) :: r_testarray2(n)
  real(kind_float) :: r_refarray2(n)
  integer(kind_integer) :: ipiv(n)
  integer(kind_integer) :: iseed(4)
  type(base) :: z_array1(n,n)
  type(base) :: z_array2(n,n)
  type(base) :: z_array3(n,n)
  type(base) :: z_array4(n,n)
  type(base) :: z_vector1(n)
  type(base) :: z_vector2(n)

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
!! write gheev and test operation on test input
  write(unit=funit,fmt=*) 'test gheev',&
  &', calculate for eigenvalues and eigenvectors'
!! call gheev on test input onto test output
  call gheev('v','u',n,z_array1,n,x_array1,ierr)
!! check ierr value to see whether gheev terminated with an error
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
    write(unit=funit,fmt=*) 'printing type(base) eigenvectors = z_array1'
    write(unit=funit,fmt=*) 'This should be an identity'
!! assign the test output to real(kind_float) test array
!! for comparison to reference
    r_testarray1 = z_array1
!! assign the reference array (real(kind_float))
!! by operations on real(kind_float) numbers
!! using a do loop to fill in the matrix for the reference array
    r_refarray1 = real(0,kind=kind_float)
    do j1 = 1, n
      r_refarray1(j1,j1) = real(1,kind=kind_float)
    end do  
!! write reference array (unformatted) to the output file
    write(unit=funit,fmt=*) 'z_array1 should be equal to', r_refarray1  
!! write test to check each element
!! in both test array and reference 
    write(unit=funit,fmt=*) 'test eigenvectors, for each element'
!! set logical check = .false.
    check = .false.
!! using do loops to take the absolute difference
!! between the elements in test array 
!! and the elements in reference value
    do j1 = 1, n 
      do j2 = 1,n
!! test if difference if greater than machine precision
!! (defined by the constant eps)
        if (abs(r_testarray1(j1,j2)-r_refarray1(j1,j2)).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
          write(unit=funit,fmt=*) 'failed for elements', j1, j2 
!! set logical check = .true.
          check = .true.
        else
!! if false, write the test succeeded for elements
!! to the output file and list the position of element succeeded
          write(unit=funit,fmt=*) 'succeeded for elements', j1, j2
        end if
      end do
    end do
!! write the explanation of function and result
    write(unit=funit,fmt=*) 'printing',&
    &' real(kind_float) eigenvalues = x_array1'
    write(unit=funit,fmt=*) 'This should be 1,2,3'
!! assign the test output to a real(kind_float) test array
!! for comparision to reference
    r_testarray2 = x_array1
!! assign a reference array (real(kind_float))
!! by operations on real(kind_float) numbers
!! usuing a do loop to fill in the matrix for the reference
    do j1 = 1, n
      r_refarray2(j1) = real(j1,kind=kind_float)
    end do
!! write the reference array (unformatted) to the output file
    write(unit=funit,fmt=*) 'x_array1 should be equal to', r_refarray2
!! write start to check each element
!! in both test array and reference
    write(unit=funit,fmt=*) 'test eigenvalues, for each element'
!! using a do loop to take the absolute difference
!! between the elements in test array
!! and elements in reference value
!! test if difference is greater than machine precision
!! (defined by the constant eps)
    do j1 = 1, n
      if (abs(r_testarray2(j1)-r_refarray2(j1)).gt.eps) then
!! if true, write the test failed 
!! and the position of the element that failed
        write(unit=funit,fmt=*) 'failed for elements', j1
!! set logical check = .true.
        check = .true.
      else
!! if wrong, write the test succeeded 
!! and the position of the element that succeeded
        write(unit=funit,fmt=*) 'succeeded for elements', j1
      end if
    end do
!! check value of logical check
    if (check) then
!! write subroutine gheev failed to output file
      print *, 'subroutine gheev failed'
    else
!! write subroutine gheev succeeded to output file
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
!! write ghesv and operation 
  write(unit=funit,fmt=*) 'test ghesv',&
  &', calculate for the solution of a linear equation'
  call ghesv('l',n,n,z_array1,n,ipiv,z_array2,n,ierr)
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
    write(unit=funit,fmt=*) 'printing',&
    &' type(base) result of a linear equation'
    write(unit=funit,fmt=*) 'This should be an identity'
!! assign the test output to real(kind_float) test array
!! for comparision to referenec
    r_testarray1 = z_array2
!! assign the reference array (real(kind_float))
!! by operations on real(kind_float) numbers
!! using a do loop to fill in the matrix for the reference
    r_refarray1 = real(0,kind=kind_float)
    do j1 = 1, n
      r_refarray1(j1,j1) = real(1,kind=kind_float)
    end do
!! write the reference array (unformatted) to the output file
    write(unit=funit,fmt=*) 'z_array2 should be equal to', r_refarray1
!! write start to check each element
!! in test arrya and reference
    write(unit=funit,fmt=*) 'test ghesv, for each element'
!! set logical check = .false.
    check = .false.
!! using a do loop to take the absolute difference
!! between the elements in test array
!! and elements in reference value
   do j1 = 1, n 
      do j2 =1, n
!! test if difference if greater than machine precision
!! (defined by thecon)
        if (abs(r_testarray1(j1,j2)-r_refarray1(j1,j2)).gt.eps) then
!! if true, write failed for elements
!! and the position of the element that failed
          write(unit=funit,fmt=*) 'failed for elements', j1, j2
!! set logical check = .true.
          check = .true.
        else
!! if false, write the test succeeded for elements
!! to the output file and list the position of element succeeded
          write(unit=funit,fmt=*) 'succeeded for elements', j1, j2
        end if
      end do  
    end do
!! check value of logical check
    if (check) then
!! if true, write subroutine ghesv test failed to the output file
      print *, 'subroutine ghesv failed'
    else
!! if false, write subroutine ghesv test tested to the output file 
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
!! write ggemm and operation
  write(unit=funit,fmt=*) 'test ggemm',&
  &', calculate for normal matrix multiplication'
!! call ggemm on test input onto test output
  call ggemm('n','n',n,n,n,z1,z_array1,n,z_array2,n,z2,z_array3,n)
!! write  an explanation of the function, using formula
  write(unit=funit,fmt=*) 'printing', &
  &'type(base) z_array3 = z1 * z_array1 * z_array2 +  z2 * z_array_3'
!! assign the test output to a real(kind_float) test array
!! for comparison to reference
  r_testarray1 = z_array3  
!! assign a reference array (real(lomd_float))
!! by operations on real(kind_float)
!! using a do loop to fill in the matrix for the reference
  r_refarray1 = real(0,kind=kind_float)
  do j1 = 1, n
    r_refarray1(j1,j1) = real(3,kind=kind_float) * &
  & real(j1,kind=kind_float) * real(j1,kind=kind_float) 
  end do
!! write the reference array (unformatted) to the output file
  write(unit=funit,fmt=*) 'z_array3 should be equal to', r_refarray1
!! write start to check each element
!! in both test array and reference
  write(unit=funit,fmt=*) 'test ggemm, for each element'
!! set logical check = .false.
  check = .false.
!! using a do loop to take the absolute difference
!! between elements in test array and elements in reference
  do j1 = 1, n 
    do j2 = 1,n
      if (abs(r_testarray1(j1,j2)-r_refarray1(j1,j2)).gt.eps) then
!! if true, write the test failed
!! and the position of the element that failed the test
        write(unit=funit,fmt=*) 'failed for elements', j1, j2
!! set logical check = .true.
        check = .true.
      else
!! if false, write the test succeeded for elements
!! and the position of the element that failed the test
        write(unit=funit,fmt=*) 'succeeded for elements', j1, j2
      end if
    end do
  end do
!! check value of logical check
  if (check) then
!! if true, write subroutine ggemm failed to the output file
    print *, 'subroutine ggemm failed'
  else
!! if flase, write subroutine ggemm succeeded to the output file
    print *, 'tested subroutine ggemm for two real number matrixes'
  end if

 
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
!! write ggemm and operation
  write(unit=funit,fmt=*) 'test ggemm', &
  &', calculate for hermitian conjugate matrix multiplication'
!! call ggemm on test input onto tes output
  call ggemm('c','n',n,n,n,z1,z_array1,n,z_array1,n,z2,z_array4,n)
!! write the explanation of the function using formula 
  write(unit=funit,fmt=*) 'printing', &
  &' type(base) z_array4 = z1 * (z_array1^H) * z_array1 +  z2 * z_array4'
!! assign the test output to a real(kind_float) test array
!! for comparison test
  r_testarray1 = z_array4  
!! assign the reference array (real(kind_float))
!! by operations on real(kind_float)
!! using a do loop to fill in the matrix for the reference array
  r_refarray1 = real(0,kind=kind_float)
  do j1 = 1, n
    r_refarray1(j1,j1) = real(3,kind=kind_float) * &
  & real(j1,kind=kind_float) * real(j1,kind=kind_float)
  end do
!! write the reference array (unformatted) to the output file
  write(unit=funit,fmt=*) 'z_array4 should be equal to', r_refarray1
!! write start to check each element
!! in both test array and reference
  write(unit=funit,fmt=*) 'test ggemm, for each element'
!! set logical check = .false.
  check = .false.
!! using a do loop to take the absolurte difference
!! bewteen the elements in test array and the element in reference
  do j1 = 1, n 
    do j2 = 1,n
!! test if difference is greater than machine precision
!! defined by the constant eps
      if (abs(r_testarray1(j1,j2)-r_refarray1(j1,j2)).gt.eps) then
!! if true, write the test failed
!! and the position of the element that failed the test
        write(unit=funit,fmt=*) 'failed for elements', j1, j2
!! set logical check = .true. 
        check = .true.
      else
!! if false, write the test succeeded
!! and the position of the element that succeeded the test
        write(unit=funit,fmt=*) 'succeeded for elements', j1, j2
      end if
    end do
  end do
!! check value of logical check
  if (check) then
!! if true, write subroutine ggemm failed to the output file
    print *, 'subroutine ggemm failed'
  else
!! if false, write subroutine ggemm tested to the output file
    print *, 'tested subroutine ggemm for a real and on conjugated matrix'
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
!! write gdot and operation
  write(unit=funit,fmt=*) 'test gdot', &
  &', calculate for dot product of two vectors'
!! call gdot on test input onto test output
  call gdot(n,z_vector1,1,z_vector2,1,z3,ierr)
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
    write(unit=funit,fmt=*) 'printing', &
    &', type(base) solution for the dot product' 
!! assign the test output to a real(kind_float) test scalar variable
!! for comparison to referene
    r_test = z3
!! assign a reference array (real(kind_float))
!! by operations on real(kind_float) 
!! using a do loop to fill in the matrix for reference 
    r_ref = real(0,kind=kind_float) 
    do j1 = 1,n
      r_ref = r_ref + real(j1,kind=kind_float) * real(j1,kind=kind_float)
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
      else
!! if false, write the test succeeded for elements
!! and the position of the element that failed 
        write(unit=funit,fmt=*) 'succeeded for element', j1
      end if
    end do
!! check value of logical check
    if (check) then
!! if true, write the subroutine test failed to the output file
      print *, 'subroutine gdot failed'
    else
!! if false, write the subroutine test tested to the output file
      print *, 'tested subroutine gdot'
    end if 
  end if


!!! test gpotrf
!! using a do loop to fill in the test input matrix
!! z_array1 
  z_array1 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array1(j1,j1) = real(j1,kind=kind_float) * real(j1,kind=kind_float)
  end do
!! write gpotrf and operation
  write(unit=funit,fmt=*) 'test gpotrf', &
  &', calculate for cholesky decomposition of a matrix'
!! call gpotrf to on test input onto test output
  call gpotrf('l',n,z_array1,n,ierr)
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
    write(unit=funit,fmt=*) 'printing', &
    &', type(base) solution for cholesky decomposition' 
!! assign the test output to real(kind_float) test array
!! for comparision to reference
    r_testarray1 = z_array1
!! assign a reference array (real(kind_float)) 
!! by operations on real(kind_float) numbers
!! using a do loop to fill in the matrix for the reference array  
    r_refarray1 = real(0,kind=kind_float)
    do j1 = 1, n
      r_refarray1(j1,j1) = real(j1,kind=kind_float)
    end do
!! write the reference array (unformatted) to the output file
    write(unit=funit,fmt=*) 'z_array1 should be equal to', r_refarray1
!! write start to check each element in both test array and reference  
    write(unit=funit,fmt=*) 'test gpotrf, for each element'
!! set logical check = .false.
    check = .false.
!! using do loops to take the absolute difference 
!! between the elements in test array and the elements in reference value
    do j1 = 1, n 
      do j2 = 1,n
!! test if difference is greater than machine precision
!! defined by the constant eps
        if (abs(r_testarray1(j1,j2)-r_refarray1(j1,j2)).gt.eps) then
!! if true, write the test failed and the position of element failed
          write(unit=funit,fmt=*) 'failed for element', j1, j2
!! set logical check = .true.
          check = .true.
        else
!! if false, write the test succeeded 
!! and the position of element succeeded
          write(unit=funit,fmt=*) 'succeeded for element', j1, j2
        end if
      end do
    end do  
!! check value of logical check
    if (check) then
!! if true, write the subroutine gpotrf test failed to the output file
      print *, 'subroutine gpotrf failed'
    else
!! if false, write the subroutine gpotrf test tested to the output file
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
!! write glanhe and operation  
  write(unit=funit,fmt=*) 'test glanhe', &
& ',calculate the 1-norm of z_array1'
!! call glanhe on test input onto test output
  call glanhe('1','l',n,z_array1,n,x1,ierr)
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
    write(unit=funit,fmt=*) 'printing'&
    &' type(base) solution of a norm'
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
!! set logical check = .false.
    check = .false.
!! test if the difference of test and reference is greater than 
!!machine precision (defined by the constant eps)
    if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed for every elements
!! and the position of the element failed
      write(unit=funit,fmt=*) 'failed for elements', j1
!! set logical check = .true.
      check = .true.
    else
!! if false, wirte the test succeeded for every elements
!! and the position of the element succeeded
      write(unit=funit,fmt=*) 'succeeded for elements', j1
    end if
!! check value of logical check
    if (check) then
!! if true, write subroutine glanhe failed to the output file
      print *, 'subroutine glanhe failed'
    else
!! if false, write test subroutine glanhe tested to the output file
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
!! write gpocon and operation
  write(unit=funit,fmt=*) 'test gpocon',&
  &',calculate for the reciprocal of the condition number'
!! call gpocon on test input onton test output 
  call gpocon('l',n,z_array1,n,x1,x2,ierr)
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
    write(unit=funit,fmt=*) 'printing', &
    & 'type(base) solution for the reciprocal of the condition number'
!! assign the test output to real(kind_float) test scalar variable
!! for comparison to reference
    r_test = x2
!! assign a reference value (real(kind_float))
    r_ref  = real(1,kind=kind_float) / real(3,kind=kind_float)
!! the reference value (unformatted) to the output file
    write(unit=funit,fmt=*) 'x2 should be equal to', x2
!! write start to check each element in both test and reference
    write(unit=funit,fmt=*) 'test gpocon, for each element'
!! set logical check = .false.
    check = .false.
!! test if the difference of test and reference is greater than
!! machine precision (defined by the constant eps)  
    if (abs(r_test-r_ref).gt.eps) then
!! if true, write the test failed
!! and the position of the element that failed the test
      write(unit=funit,fmt=*) 'failed for elements', j1
!! set logical check = .true.
      check = .true.
    else
!! if false, write test succeeded
!! and the position of element succeeded
      write(unit=funit,fmt=*) 'succeeded for elements', j1
    end if
!! check value of logical check
    if (check) then
!! if true, write the subroutine gpocon failed to the output file
      print *, 'subroutine gpocon failed'
    else
!! if false, write the subroutin gpocon tested to the output file
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
!! write gtrsm and operation
  write(unit=funit,fmt=*) 'test gtrsm',&
  &', calculate for one of the matrix equations'
!! call gtrsm to solve for matrix multiplication of an inverse matrix
!! with left side operation 
!! on test input onto test output
  call gtrsm('l','l','c','n',n,n,z1,z_array2,n,z_array1,n)
!! write an explanation of the function using formula  
  write(unit=funit,fmt=*) 'printing'&
  &'type(base) z_array1 = z_array1^H * z1 * z_array2'
!! assign the test output to real(kind_float) test array
!! for comparison to reference
  r_testarray1 = z_array1
!! assign a reference array (real(kind_float))
!! by operation on real(kind_float) numbers
!! using a do loop to fill in the matrix 
  r_refarray1 = real(0,kind=kind_float)
  do j1 = 1, n
    r_refarray1(j1,j1) = (real(1,kind=kind_float) / &
  & real(j1,kind=kind_float)) * real(j1,kind=kind_float)
  end do
!! write the reference array (unformatted) to the output file
  write(unit=funit,fmt=*) 'z_array1 should be equal to', r_refarray1
!! write start to check each element 
!! in both test array and reference array
  write(unit=funit,fmt=*) 'test gtrsm, for each element'
!! set logical check = .false.
  check = .false.
!! using do loops to take the absolute difference
!! between the elements in test array and elements in reference value
  do j1 = 1, n 
    do j2 = 1,n
!! test if difference is greater than machine precision
!! (defined by the constant eps)
      if (abs(r_testarray1(j1,j2)-r_refarray1(j1,j2)).gt.eps) then
!! if true, write the test failed
!! and the position of the element that failed
        write(unit=funit,fmt=*) 'failed for elements', j1, j2
!! set logical check = .true.
      check = .true.
      else
!! if false, write the test succeeded
!! and the position of the element that succeeded
        write(unit=funit,fmt=*) 'succeeded for elements', j1, j2
      end if
    end do
  end do  
!! check value of logical check
  if (check) then
!! if true, write subroutine gtrsm failed to the output file
    print *, 'subroutine gtrsm failed'
  else
!! if false, write subroutine gtrsm tested to the output file
    print *, 'tested subroutine gtrsm'
  end if


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
!! write gtrsm and operation
  write(unit=funit,fmt=*) 'test gtrsm', &
  &', calculate for one of the matrix equations'
!! call gtrsm to solve for matrix multiplication of an inverse matrix
!! with left side operation 
!! on test input onto test output
  call gtrsm('l','l','n','n',n,n,z1,z_array2,n,z_array1,n)
!! write an explanation of the function using formula
  write(unit=funit,fmt=*) 'printing'&
  &',type(base) z_array1 = z_array1^H * z1 * z_array2' 
!! assign the test output to a real(kind_float) test array
!! for comparison to reference
  r_testarray1 = z_array1
!! assign a reference array (real(kind_float)) 
!! by operations on real(kind_float) numbers
!1 using a do loop to fill in the matrix for reference
  r_refarray1 = real(0,kind=kind_float)
  do j1 = 1, n
    r_refarray1(j1,j1) = (real(1,kind=kind_float) / &
  & real(j1,kind=kind_float)) * real(j1,kind=kind_float)
  end do
!! write the reference array (unformatted) to the output file
  write(unit=funit,fmt=*) 'z_array1 should be equal to', r_refarray1
!! write start to check each element
!! in both test array and reference array
  write(unit=funit,fmt=*) 'test gtrsm, for each element'
!! set logical check = .false.
  check = .false.
!! using do loops to take the absolute difference
!! between elements in test array and elements in reference array
  do j1 = 1, n 
    do j2 = 1,n
!! test if difference is greater than machine precision
!! (defined by the constant eps
      if (abs(r_testarray1(j1,j2)-r_refarray1(j1,j2)).gt.eps) then
!! if true, write the test failed
!! and the position of the element that failed
        write(unit=funit,fmt=*) 'failed for elements', j1, j2
!! set logical check = .true.
        check = .true.
      else
!! if flase, write the test succeeded
!! and the position of the element that succeeded
        write(unit=funit,fmt=*) 'succeeded for elements', j1, j2
      end if
    end do
  end do  
!! check value of logical check
  if (check) then
!! if true, write subroutine gtrsm failed to the output file
    print *, 'subroutine gtrsm failed'
  else
!! if false, write subroutine gtrsm tested to the output file
    print *, 'tested subroutine gtrsm'
  end if


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
!! assign the test output to a real(kind_float) test array
!! for comparison to reference
  r_testarray1 = z_array1
!! assign a reference array (real(kind_float))
!! by operations on real(kind_float) numbers
!! using a do loop to fill in the matrix for the reference array
  r_refarray1 = real(0,kind=kind_float)
  do j1 = 1, n
    r_refarray1(j1,j1) = real(j1,kind=kind_float) * &
  & (real(1,kind=kind_float) / real(j1,kind=kind_float))
  end do
!! write the reference array (unformatted) to the output file
  write (unit=funit, fmt=*) 'z_array1 should be equal to', r_refarray1
!! write start to check each element 
!! in both test array and reference array
  write(unit=funit,fmt=*) 'test gtrsm, for each element'
!! set logical check = .false.
  check = .false.
!! using do loops to take the absolute difference
!! between the elements in test array and the elements in reference array
  do j1 = 1, n 
    do j2 = 1,n
!! test if difference is greater than machine precision
!! (defined by the constant eps)
      if (abs(r_testarray1(j1,j2)-r_refarray1(j1,j2)).gt.eps) then
!! if true, write the test failed
!! and the position of the element that failed
        write(unit=funit,fmt=*) 'failed for elements', j1, j2
!! set logical check = .true.
        check = .true.
      else
!! if false. write the test succeeded
!! and the position of the element that succeeded
        write(unit=funit,fmt=*) 'succeeded for elements', j1, j2
      end if
    end do
  end do  
!! check value of logical check
  if (check) then
!! if true, write subroutine gtrsm failed to the output
    print *, 'subtoutine gtrsm failed'
  else
!! if false, write subroutine gtrsm tested to the output
    print *, 'tested subroutine gtrsm'
  end if



!!! test ggetrf
!! using a do loop to fill in the test input matrix
!! z_array2 
  z_array2 = real(0,kind=kind_float)
  do j1 = 1, n
    z_array2(j1,j1) = real(j1,kind=kind_float)
  end do
!! write ggetrf and operation
  write(unit=funit,fmt=*) 'test ggetrf', &
  &', calculate for LU decomposition of a matrix'
!! call gpotrf to on test input onto test output
  call ggetrf(n,n,z_array2,n,ipiv,ierr)
!! checking ierr value to see if gpotrf terminated with an error
!! test if ierr is not equal to 0
  if (ierr.ne.0) then
!! if true, write gpotrf failed and write the ierr value
    write(unit=funit,fmt=*) 'ggetrf failed, ierr=', ierr
!! set ierr to 0
    ierr = 0
  else
!! if false, write gpotrf runs
    write(unit=funit,fmt=*) 'ggetrf runs'
!! write an explanation of the funtion
    write(unit=funit,fmt=*) 'printing', &
    &', type(base) solution for LU decomposition' 
!! assign the test output to real(kind_float) test array
!! for comparision to reference
    r_testarray1 = z_array2
!! assign a reference array (real(kind_float)) 
!! by operations on real(kind_float) numbers
!! using a do loop to fill in the matrix for the reference array  
    r_refarray1 = real(0,kind=kind_float)
    do j1 = 1, n
      r_refarray1(j1,j1) = real(j1,kind=kind_float)
    end do
!! write the reference array (unformatted) to the output file
    write(unit=funit,fmt=*) 'z_array2 should be equal to', r_refarray1
!! write start to check each element in both test array and reference  
    write(unit=funit,fmt=*) 'test ggetrf, for each element'
!! set logical check = .false.
    check = .false.
!! using do loops to take the absolute difference 
!! between the elements in test array and the elements in reference value
    do j1 = 1, n 
      do j2 = 1,n
!! test if difference is greater than machine precision
!! defined by the constant eps
        if (abs(r_testarray1(j1,j2)-r_refarray1(j1,j2)).gt.eps) then
!! if true, write the test failed and the position of element failed
          write(unit=funit,fmt=*) 'failed for element', j1, j2
!! set logical check = .true.
          check = .true.
        else
!! if false, write the test succeeded 
!! and the position of element succeeded
          write(unit=funit,fmt=*) 'succeeded for element', j1, j2
        end if
      end do
    end do  
!! check value of logical check
    if (check) then
!! if true, write the subroutine gpotrf test failed to the output file
      print *, 'subroutine ggetrf failed'
    else
!! if false, write the subroutine gpotrf test tested to the output file
      print *, 'tested subroutine ggetrf'
    end if
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
!! call gtrsm to solve for matrix multiplication of an inverse matrix
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
!! assign the test output to a real(kind_float) test array
!! for comparison to reference
    r_testarray1 = z_array1
!! assign a reference array (real(kind_float)) 
!! by operations on real(kind_float) numbers
!1 using a do loop to fill in the matrix for reference
    r_refarray1 = real(0,kind=kind_float)
    do j1 = 1, n
      r_refarray1(j1,j1) = (real(1,kind=kind_float) / &
      & real(j1,kind=kind_float)) * real(j1,kind=kind_float)
    end do
!! write the reference array (unformatted) to the output file
    write(unit=funit,fmt=*) 'z_array1 should be equal to', r_refarray1
!! write start to check each element
!! in both test array and reference array
    write(unit=funit,fmt=*) 'test ggetrs, for each element'
!! set logical check = .false.
    check = .false.
!! using do loops to take the absolute difference
!! between elements in test array and elements in reference array
    do j1 = 1, n 
      do j2 = 1,n
!! test if difference is greater than machine precision
!! (defined by the constant eps
        if (abs(r_testarray1(j1,j2)-r_refarray1(j1,j2)).gt.eps) then
!! if true, write the test failed
!! and the position of the element that failed
          write(unit=funit,fmt=*) 'failed for elements', j1, j2
!! set logical check = .true.
          check = .true.
        else
!! if flase, write the test succeeded
!! and the position of the element that succeeded
          write(unit=funit,fmt=*) 'succeeded for elements', j1, j2
        end if
      end do
    end do  
!! check value of logical check
    if (check) then
!! if true, write subroutine gtrsm failed to the output file
      print *, 'subroutine ggetrs failed'
    else
!! if false, write subroutine gtrsm tested to the output file
      print *, 'tested subroutine ggetrs'
    end if
  end if


!! close file
  close(unit=funit,iostat=ierr,status='keep')

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program test_blastypes
!--------------------------------------------------------------------
!--------------------------------------------------------------------
