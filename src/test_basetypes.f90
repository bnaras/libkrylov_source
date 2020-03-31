!--------------------------------------------------------------------
!--------------------------------------------------------------------
program test_basetypes
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This program tests the overloaded operators
!< defined in a basetypes_* file
!< structured like the print subroutines in arrayfile
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
  use basekinds
  use floatformat
  use basetypes
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
  type(base) :: z4
  type(base) :: z5 
  type(base) :: z6
  type(base) :: z7
  type(base) :: z8
  type(base) :: z9
  type(base) :: z10
  type(base) :: z11
  real(kind_float) :: r_test
  real(kind_float) :: r_ref
  real(kind_float) :: r_testr
  real(kind_float) :: r_refr
  real(kind_float) :: r_testi
  real(kind_float) :: r_refi
  real(kind_float) :: x1
  real(kind_float) :: x2
  complex(kind_float) :: c1

! integer for loops
  integer(kind_integer) :: j1,j2 = 0
! integer for error variable
  integer(kind_integer) :: ierr = 0
! variable for type base tests
  logical :: check = .false.
! file unit
  integer(kind_integer) :: funit = 0
  character(len=32) :: fname = ''
!! name of file
  character(len=32) :: name_string = '_base_test'
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
  write(unit=funit,fmt=*) 'Testing basetype elementary operations'

  write(unit=funit,fmt=*) 'This basetype is ',base_print_string

  write(unit=funit,fmt=*) 'machine precision'
  write(unit=funit,fmt=*) eps

  write(unit=funit,fmt=*) 'log10 of machine precision'
  write(unit=funit,fmt=*) logeps


!! testing real_to_base (integer)
!! writing test real_to _base to the output file
  write(unit=funit,fmt=*) 'test type(base)',&
  & ', check real_to_base (integer)'
!! running real_to_base on assigning real number 3 to type(base) z1
  z1 = real(3,kind=kind_float)
!! writing the test output to the output file
  write(unit=funit,fmt=*) 'z1 =', z1  
!! assigning the test output z1 
!! to a real(kind_float) test variable r_test 
  r_test = z1
!! assigning a reference value (real(kind_float)) 
!! from the operation on real(kind_float) numbers
  r_ref = real(3,kind=kind_float)
!! writing the reference value (unformatted) to the output file
  write(unit=funit,fmt=*) 'z1 should be equal to', r_ref
!! taking the absolute difference 
!! between test variable and reference value
!! testing if the difference is greater than machine precision 
!! (defined by the constant eps)
  if (abs(r_test-r_ref).gt.eps) then      
!! if true
!! writing the test failed to the output file
!! writing the test failed to standard output
    write(unit=funit,fmt=*) 'test real_to_base (with integer) failed'
    print *, 'test real_to_base (with integer) failed'
  else
!! if false
!! writing the test succeeded to the output file
!! writing the test tested to standard output
    write(unit=funit,fmt=*) 'test real_to_base (with integer) succeeded'
    print *, 'tested real_to_base (with integer)'
  end if


!! testing real_to_base decimal
!! writing start test real_to_base to the output file
  write(unit=funit,fmt=*) 'test type(base)',&
  & ', check real_to_base (decimal)'
!! running real_to_base on assigning test input to test output
  z2 = real(25.34,kind=kind_float)
!! writing the test output to the output file
  write(unit=funit,fmt=*) 'z2 =', z2
!! assigning the test output z2 
!! to a real(kind_float) test variable r_test
  r_test = z2
!! assigning a reference value (real(kind_float))
!! from the operation on real(kind_float) numbers
  r_ref = real(25.34,kind=kind_float)
!! writing the reference value (unformatted) to the output file
  write(unit=funit,fmt=*) 'z2 should be equal to ', r_ref
!! taking the absolute difference 
!! between test variable and reference value
!! testing if the difference is greater than machine precision
!! (defined by the constant eps)
  if (abs(r_test-r_ref).gt.eps) then
!! if true
!! writing the test failed to the output file
!! writing the test failed to standard output     
    write(unit=funit,fmt=*) 'test real_to_base (with decimal) failed'
    print *, 'test real_to _base (with decimal) failed'
  else
!! if false
!! writing the test succeeded to the output file
!! writing the test tested to standard output
    write(unit=funit,fmt=*) 'test real_to_base (with decimal) succeeded'
    print *, 'tested real_to_base (with decimal)'
  end if


!! testing type(base) determinant operator
!! writing start type(base) determinant operator
  write(unit=funit,fmt=*) 'test type(base)',&
  & ', calculte determinant operator'
!! assigning real number 25.34 to z2
  z2 = real(25.34,kind=kind_float)
!! running determinant operator on test input onto test output
  z3 = det(z2) 
!! writing the test output to the output file
  write(unit=funit,fmt=*) 'z3 = det(',z2,') = ', z3
!! assigning the test output z3 
!! to a real(kind_float) test variable r_test 
  r_test = z3
!! assigning a reference value (real(kind_float))
!! from the operation on real(kind_float) numbers
  r_ref = real(25.34,kind=kind_float) * real(25.34,kind=kind_float)
!! writing the reference value (unformatted) to the output file
  write(unit=funit,fmt=*) 'z3 should be equal to ', r_ref
!! taking the absolute difference 
!! between test variable and reference value
!! testing if the difference is greater than machine precision
!! (defined by the constant eps)
  if (abs(r_test-r_ref).gt.eps) then
!! if true
!! writing the test failed to the output file
!! writing the test failed to standard output      
    write(unit=funit,fmt=*) 'test type(base) determinant failed'
    print *, 'test type(base) determinant failed'
  else
!! if wrong
!! writing the test succeeded to the output file
!! writing the test tested to standard output
    write(unit=funit,fmt=*) 'test type(base) determinant succeeded'
    print *, 'tested type(base) determinant'
  end if

!! testing type(base) conjugation operator
!! writing start type(base) conjugation operator to the output file
  write(unit=funit,fmt=*) 'test type(base)',&
  & ', calculate conjugation operator'
!! running conjugate operator on test input  onto test output 
  z4 = conjg(z2)
!! writing the test output to the output file
  write(unit=funit,fmt=*) 'z4 = conjg(z2) =', z4
!! assigning the test output z4
!! to a real(kind_float) test variable r_test
  r_test = z4
!! assigning a reference value (real(kind_float))
!! from the operation on real(kind_float) numbers
  r_ref = real(25.34,kind=kind_float)
!! writing the reference value (unformatted) to the output file
  write(unit=funit,fmt=*) 'z4 should be equal to', r_ref 
!! taking the absolute difference
!! between test variable and reference value
!! testing if the difference is greater than machine precision
!! (defined by the constant eps)
  if (abs(r_test-r_ref).gt.eps) then
!! if true
!! writing the test failed to the output file
!! writing the test failed to standard output     
    write(unit=funit,fmt=*) 'test type(base) conjugate failed'
    print *, 'test type(base) conjugate failed'
  else
!! if wrong
!! writing the test succeeded to the output file
!! writing the test tested to standard output
    write(unit=funit,fmt=*) 'test type(base) conjugate succeeded'
    print *, 'tested type(base) conjugate'
  end if


!! testing type(base) operations


!! testing base_to_cmplx 
  write(unit=funit,fmt=*)'test type(base)',&
  &', check base_to_real'
!! assigning complex number (1,2) to z1
!! if z1 is type(base) real, the imaginary part of z1 should be 0
!! if z1 is type(base) complex, the imaginary part of z1 should be 2
  z1 = cmplx(1,2,kind=kind_float)  
!! assigning type(base) z1 to complex c1
  c1 = z1
!! write the operation function and test input (unformatted) to output file
  write(unit=funit,fmt=*) 'c1 =', c1
!! assigning the test output c1 separately 
!! real part of c1 to r_testr
!! imaginary part of c1 to r_testc
  r_testr = real(c1,kind=kind_float)
  r_testi = aimag(c1)
!! assigning the reference value (real(kind_float))
!! assigning reference value of the real part to r_refr
  r_refr = real(1,kind=kind_float)
!! assigning reference value of the imaginary part to r_refi
  if (basetype_string.eq.'cmplx') then
!! if type base complex, then the imaginary part should be 2
    r_refi = real(2,kind=kind_float)
  else
!! if type base real, then the imaginary part should be 0
    r_refi = real(0,kind=kind_float)
  end if
!! write the reference value (unformatted) to the output file
!! separately for the real part and the imaginary part
  write(unit=funit,fmt=*) 'real part of c1 should be equal to', r_refr
  write(unit=funit,fmt=*) 'imaginary part of c1 should be equal to', r_refi
!! write start to test base_to_cmplx
  write(unit=funit,fmt=*) 'test base_to_cmplx'
!! set logical check = .false.
  check = .false.
!! check the absolute difference of real part of the type base 
!! between the number in test and reference
  if (abs(r_testr-r_refr).gt.eps) then
!! if true, write test for real part of complex number failed
    write(unit=funit,fmt=*) 'test real part of c1 failed'
!! set logical check = .true.
    check = .true.
  else
!! if false, write test for real part of complex number succeeded
    write(unit=funit,fmt=*) 'test real part of c1 succeeded'
  end if
!! check the absolute difference of imaginary part of the type base
!! between the number in test and reference
  if (abs(r_testi-r_refi).gt.eps) then
!! if true, write test for imaginary part of complex number failed
    write(unit=funit,fmt=*) 'test imaginary part of c1 failed'
!! set logical check = .true.
    check = .true.
  else
!! if false, write test for imaginary part of complex number succeeded
    write(unit=funit,fmt=*) 'test imaginary part of c1 succeeded'
  end if
!! check value of logical check
  if (check) then
!! if true, write the base_to_cmplx test failed to the output file
    print *, 'test base_to_cmplx failed'
  else
!! if false, write the base_to_cmplx test tested to the output file
    print *, 'tested base_to_cmplx'
  end if 

 
!! testing base_plus_base
!! writing start base_plus_base to the output file
  write(unit=funit,fmt=*) 'test type(base)',&
  &', calculate addition operator of base_plus_base' 
!! assigning real number 21.23 to z3
!! assigning real number 35.63 to z4
  z3 = real(21.23,kind=kind_float)
  z4 = real(35.63,kind=kind_float)
!! write the operation function and test input (unformated) to output file
  write(unit=funit,fmt=*) 'operation ', z3,'+',z4 
!! running base_plus_base and assigning test input onto test output
  z5 = z3 + z4
!! writing the test output to the output file
  write(unit=funit,fmt=*) '= ', z5
!! assigning the test output z5
!! to a real(kind_float) test variable r_test
  r_test = z5
!! assigning a reference value (real(kind_float))
!! from the operation on real(kind_float) numbers
  r_ref = real(21.23,kind=kind_float) + real(35.63,kind=kind_float)
!! writing the reference value (unformatted) to the output file
  write(unit=funit,fmt=*) 'z5 should be equal to', r_ref
!! taking the absolute difference
!! between test variable and reference value
!! testing if the difference is greater than machine precision
!! (defined by the constant eps)
  if (abs(r_test-r_ref).gt.eps) then 
!! if true
!! writing the test failed to the output file
!! writing the test failed to standard output     
    write(unit=funit,fmt=*) 'test base_plus_base failed'
    print *, 'test base_plus_base failed'
  else
!! writing the test succeeded to the output file
!! writing the test tested to standard output
    write(unit=funit,fmt=*) 'test base_plus_base succeeded'
    print *, 'tested vase_plus_base'
  end if


!! testing base_minus_base
!! writing start base_minus_base to the output file 
  write(unit=funit,fmt=*) 'test type(base)',&
  &', calculate subtraction operation base_minus_base'
!! assigning real number 35.63 to z4
!! assigning real number 53.82 to z5
  z4 = real(35.63,kind=kind_float)
  z5 = real(53.82,kind=kind_float)
!! writing the operation function and test input(unformatted) to output file
  write(unit=funit,fmt=*) 'operation', z5, '-', z4
!! running base_minus_base and assigning test input onto test output 
  z6 = z5 - z4
!! writing the test output to the output file
  write(unit=funit,fmt=*) '= ', z6
!! assigning the test output z6
!! to a real(kind_float) test variable r_test
  r_test = z6
!! assigning a reference value (real(kind_float))
!! from the operation on real(kind_float) numbers
  r_ref = real(53.82,kind=kind_float) - real(35.63,kind=kind_float) 
  write(unit=funit,fmt=*) 'z6 should be equal to', r_ref
!! taking the absolute difference
!! between test variable and reference value
!! testing if the difference is greater than machine precision
!! (defined by the constant eps)
  if (abs(r_test-r_ref).gt.eps) then
!! if true
!! writing the test failed to the output file
!! wriitng the test failed to standard output      
    write(unit=funit,fmt=*) 'test base_minus_base failed'
    print *, 'test base_minus_base failed'
  else
!! if wrong
!! writing the test succeeded to the output file
!! writing the test tested to standard output
    write(unit=funit,fmt=*) 'test base_minus_base succeeded'
    print *, 'tested base_minus_base'
end if


!! testing base_times_base
!! writing start base_times_base and test input (unformatted) to output file 
  write(unit=funit,fmt=*) 'test type(base)',&
  &',calculate multiplication operator base_times_base'
!! assigning real number 53.82 to z5
!! assigning real number 62.91 to z6
  z5 = real(53.82,kind=kind_float)
  z6 = real(62.91,kind=kind_float) 
!! writing the operation function and test input(unformatted) to output file
  write(unit=funit,fmt=*) 'operation', z5, '*', z6 
!! running base_times_base and assigning test input onto test output
  z7 = z5 * z6
!! writing the test output to the output file
  write(unit=funit,fmt=*) '= ', z7
!! assigning the test output to z7
!! to a real(kind_float) test variable r_test
  r_test = z7
!! assigning a reference value (real(kind_float))
!! from the operation on real(kind_float) numbers
  r_ref = real(53.82,kind=kind_float) * real(62.91,kind=kind_float)
  write(unit=funit,fmt=*) 'z7 should be equal to', r_ref
!! taking the absolute difference
!! between test variable and reference value
!! testing if the difference is greater than machine precision
!! (defined by the constant eps)
  if (abs(r_test-r_ref).gt.eps) then
!! if true
!! writing the test failed to the output file
!! writing the test failed to standard output      
    write(unit=funit,fmt=*) 'test base_times_base failed'
    print *, 'test base_times_base failed'
  else
!! if wrong
!! writing the test succeeded to the output file
!! writing the test tested to standard output
    write(unit=funit,fmt=*) 'test base_times_base succeeded'
    print *, 'tested base_times_base'
  end if


!! testing base_by_base
!! writing start base_by_base and test input (unformatted) to output file
  write(unit=funit,fmt=*) 'test type(base)',&
  &', calculate division operator base_by_base'
!! assigning real number 62.91 to z6
!! assigning real number 78.23 to z7
  z6 = real(62.91,kind=kind_float)
  z7 = real(78.23,kind=kind_float)
!! writing the operation function and test input(unformatted) to output file
  write(unit=funit,fmt=*) 'operation', z7, '/', z6
!! running the base_by_base and assigning test input onto test output
  z8 = z7 / z6
!! writing the test output to the output file
  write(unit=funit,fmt=*) '= ', z8 
!! assigning the test output z8
!! to a real(kind_float) test variable t_test
  r_test = z8
!! assigning a reference value (real(kind_float))
!! from the operation on real(kind_float) numbers
  r_ref = real(78.23,kind=kind_float) / real(62.91,kind=kind_float)
  write(unit=funit,fmt=*) 'z8 should be equal to', r_ref
!! taking the absolute difference
!! between test variable and reference value
!! testing if the difference is greater than machined precision
!! (defined by the constant eps)
  if (abs(r_test-r_ref).gt.eps) then      
!! if true
!! writing the test failed to the output file
!! writing the test failed to standard output
    write(unit=funit,fmt=*) 'test base_by_base failed'
    print *, 'test base_by_base failed'
  else
!! if wrong
!! writing the test succeeded to the output file
!! writing the test tested to standard output
    write(unit=funit,fmt=*) 'test base_by_base succeeded'
    print *, 'tested base_by_base'
 end if


!! testintg base_minus_real
!! writing start base_minus_real and test input (unformatted) to output file
  write(unit=funit,fmt=*) 'test type(base)',&
  &', calculate subtraction opeartor base_minus_real'
!! assigning real number 82.93 to z8
!! assigning real number 20 to x1
  z8 = real(82.93,kind=kind_float)
  x1 = real(20,kind=kind_float)
!! writing the operation function and test input(unformatted) to output file
  write(unit=funit,fmt=*) 'operation', z8, '-', x1
!! running base_minus_real and assigning test input onto test output
  z9 = z8 - x1
!! writing the test output to the output file
  write(unit=funit,fmt=*) '= ', z9
!! assigning the test output z9
!! to a real(kind_float) test variable r_test
  r_test = z9
!! assigning a reference value (real(kind_float))
!! from the operation on real(kind_float) numbers
  r_ref = real(82.93,kind=kind_float) - real(20,kind=kind_float)
  write(unit=funit,fmt=*) 'z9 should be equal to', r_ref
!! taking the absolute difference 
!! between test variable and reference value
!! testing if the difference is greater than machine precision
!! (defined by the constant eps)
  if (abs(r_test-r_ref).gt.eps) then
!! if true
!! writing the test failed to the output file
!! writing the test failed to standard output      
     write(unit=funit,fmt=*) 'test base_minus_real failed'
     print *, 'tested base_minus_real failed'
  else
!! if wrong
!! writing the test succeeded to the output file
!! writing the test tested to standard output
     write(unit=funit,fmt=*) 'test base_minus_real succeeded'
     print *, 'tested base_minus_real'
  end if


!! testing base_times_real
!! writing start base_times_real and test input (unformatted) output file
  write(unit=funit,fmt=*) 'test type(base)',&
  &', calculate multiplication operator base_times_real' 
!! assigning real number 91.43 to z9 
!! assigning real number 20 to x1
  z9 = real(91.43,kind=kind_float)
  x1 = real(20,kind=kind_float)
!! writing the operation function and test input(unformatted) to output file
  write(unit=funit,fmt=*) 'operation', z9, '*', x1 
!! running base_times_real and assigning test input onto test output
  z10 = z9 * x1
!! writing the test output to the output file
  write(unit=funit,fmt=*) '= ', z10
!! assigning the test output z6
!! to a real(kind_float) test variable  r_test
  r_test = z10
!! assigning a reference value (real(kind_float))
!! from the operation on real(kind_float) numbers
  r_ref = real(91.43,kind=kind_float) * real(20,kind=kind_float)
  write(unit = funit,fmt=*) 'z10 should be equal to', r_ref
!! taking the absolute difference 
!! between test variable and reference value
!! testing if the difference is greater than machine precision
!! (defined by the constant eps)
  if (abs(r_test-r_ref).gt.eps) then
!! if true
!! writing the test failed to the output file
!! writing the test failed to standard output
     write(unit=funit,fmt=*) 'test base_times_real failed'
     print *, 'test base_times_real failed'
  else
!! if wrong
!! writing the test succeeded to the output file
!! writing the test tested to standard output
     write(unit=funit,fmt=*) 'test base_times_real succeeded'
     print *, 'tested base_times_real'
  end if


!! testing base_by_real
!! writing start base_by_real and test input (unformatted) output file
  write(unit=funit,fmt=*) 'test type(base)',&
  &', calculate divison operator base_by_real'
!! assigning real number 102.53 to z20
!! assigning real number 5.87 to x2 
  z10 = real(102.53,kind=kind_float)
  x2 = real(5.87,kind=kind_float)
!! writing the operation function and test input(unformatted) to output file
  write(unit=funit,fmt=*) 'operation', z10, '/', x2 
!! running base_by_real and assignng test input onto test output
  z11 = z10 / x2
!! writing the test output to the output file
  write(unit=funit,fmt=*) '= ', z11
!! assigning the test output z11
!! to a real(kind_float) test variable r_test
  r_test = z11
!! assigning a reference value (real(kind_float))
!! from the operation on real(kind_float) numbers
  r_ref = real(102.53,kind=kind_float) / real(5.87,kind=kind_float)
  write(unit=funit,fmt=*) 'z11 should be equal to', r_ref
!! taking the absolute difference
!! between test variable and reference value 
!! testing if the difference is greater than machine precision
!! (defined by the constant eps)
  if (abs(r_test-r_ref).gt.eps) then
!! if true
!! writing the test failed to the output file
!! writing the test failed to standard output
    write(unit=funit,fmt=*) 'test base_by_real failed'
    print *, 'test base_by_real failed'
  else
!! if wrong
!! writing the test succeeded to the output file
!! writing the test tested tp standard output
    write(unit=funit,fmt=*) 'test base_by_real succeeded'
    print *, 'tested base_by_real'
  end if
  print *, 'tested base_by_real'


!! close file
  close(unit=funit,iostat=ierr,status='keep')

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program test_basetypes
!--------------------------------------------------------------------
!--------------------------------------------------------------------
