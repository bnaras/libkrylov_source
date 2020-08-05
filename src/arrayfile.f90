!--------------------------------------------------------------------
!--------------------------------------------------------------------
module arrayfile
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This module defines the printing and reading 
!< of JSON dictionaries containing
!< arrays with type(base) or real(kind_float)
!< defined in basetypes.
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! define kind_integer and other kind parameters
  use basekinds
! define format string for floats
  use floatformat
! define type(base) and kind_float
  use basetypes
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------

contains

!--------------------------------------------------------------------
! Subroutines for printing arrays of base or real(kind_float) type
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine array_read_base_size(name_string,val1,val2,&
  & type_string,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This routine reads in the dimensions of 
!< an array from file, to prepare for reading in an array
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
! Input/Output Parameters
!--------------------------------------------------------------------
!! name of file to be read
    character(len=*), intent(in) :: name_string
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! size of obj
    integer(kind_integer), intent(out) :: val1, val2
!! type of data to be read, used for logic checks
    character(len=32), intent(out) :: type_string
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! logic for file existence inquiry
    logical :: file_exists = .false.
!! file unit
    integer(kind_integer) :: funit = 0
    character(len=32) :: fname = ''
!! string for reading extra lines
    character(len=32) :: dummy_string = ''
!--------------------------------------------------------------------

!!  find free unit numbers for files
    call find_free_file_unit(funit,ierr)
    if (ierr.ne.0) then
      print *, 'No free file units!'
      ierr = -9
      return
    end if 

!! define fname
    fname = trim(name_string)//'.json'

!! inquire if file exists
    inquire(file=fname,exist=file_exists)
    if (.not.file_exists) then
      print *, 'file to be read does not exist!'
      ierr = -7
      return
    end if

!! open file
    open(unit=funit,file=fname,action='read',iostat=ierr)

!! appropriate checks on file start
    read(unit=funit,fmt='(a22)', &
  &       iostat=ierr) dummy_string
!! Check file header here
    if (ierr.ne.0) then
      print *, 'file does not have header set!'
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -7
      return
    end if
    if (dummy_string.ne.'{ "type(base)array": {') then
      print *, 'file does not have correct header!'
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -7
      return
    end if
    read(unit=funit,fmt='(10x,a32,2x)', &
  &       iostat=ierr) dummy_string
!! name of array moved to output string
    type_string = trim(dummy_string)
    read(unit=funit,fmt='(17x,i10,2x,i10,2x)', &
  &       iostat=ierr) val1,val2
!! Check size of file here
    if (ierr.ne.0) then
      print *, 'file does not have dimensions set!'
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -7
      return
    end if
!! reading precision
    read(unit=funit,fmt='(18x,a32,2x)', &
  &       iostat=ierr) dummy_string
!! check precision
    if (ierr.ne.0) then
      print *, 'file does not have precision header!'
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -7
      return
    else if (dummy_string.ne.base_print_string) then
      print *, 'file precision does not match library!'
      print *, dummy_string
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -7
      return
    end if
    read(unit=funit,fmt=*, &
  &       iostat=ierr)
    if (ierr.ne.0) then
      print *, 'file missing legend line!'
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -7
      return
    end if

!! close file
    close(unit=funit,iostat=ierr,status='keep')

!--------------------------------------------------------------------
  end subroutine array_read_base_size
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine array_read_base(name_string,n1,n2,obj,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This routine reads in an array from file to type(base)
!< with already allocated dimensions 
!< (which can be obtained from array_read_size)
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
! Input Parameters
!--------------------------------------------------------------------
!! name of file
    character(len=*), intent(in) :: name_string
!! rows of obj1
    integer(kind_integer), intent(in) :: n1
!! columns of obj1
    integer(kind_integer), intent(in) :: n2 
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! obj to be filled
    type(base), intent(out) :: obj(n1,n2)
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! dummy indexes
    integer(kind_integer) :: k1 = 0
    integer(kind_integer) :: k2 = 0
!! temp array for values read in
    type(base) :: dummy
!! logic for file existence inquiry
    logical :: file_exists = .false.
!! file unit
    integer(kind_integer) :: funit = 0
    character(len=32) :: fname = ''
!! integer for iostat in read statement
    integer(kind_integer) :: read_err = 0
!--------------------------------------------------------------------

!!  find free unit numbers for files
    call find_free_file_unit(funit,ierr)
    if (ierr.ne.0) then
      print *, 'No free file units!'
      ierr = -9
      return
    end if 

!! define fname
    fname = trim(name_string)//'.json'

!! inquire if file exists
    inquire(file=fname,exist=file_exists)
    if (.not.file_exists) then
      print *, 'file to be read does not exist!'
      ierr = -7
      return
    end if

!! open file
    open(unit=funit,file=fname,action='read',iostat=ierr)
    if (ierr.ne.0) then
      print *, 'read error in ',fname
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -9
      return
    end if 

!! skipping lines,
!! skipping file header
    read(unit=funit,fmt=*, &
  &       iostat=ierr)
    if (ierr.ne.0) then
      print *, 'read error in ',fname
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -9
      return
    end if 
!! skipping name of array
    read(unit=funit,fmt=*, &
  &       iostat=ierr)
    if (ierr.ne.0) then
      print *, 'read error in ',fname
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -9
      return
    end if 
!! Skipping dimensions of file
    read(unit=funit,fmt=*, &
  &       iostat=ierr)
    if (ierr.ne.0) then
      print *, 'read error in ',fname
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -9
      return
    end if 
!! Skipping element type
    read(unit=funit,fmt=*, &
  &       iostat=ierr)
    if (ierr.ne.0) then
      print *, 'read error in ',fname
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -9
      return
    end if 
!! skip array header
    read(unit=funit,fmt=*, &
  &       iostat=ierr)
    if (ierr.ne.0) then
      print *, 'read error in ',fname
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -9
      return
    end if 
!! skip label of columns here !!SWAP WITH ABOVE SKIP
    read(unit=funit,fmt=*, &
  &       iostat=ierr)
    if (ierr.ne.0) then
      print *, 'read error in ',fname
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -9
      return
    end if 

!!! loop to read values
!    do
!      read(unit=funit,&
!  &     fmt='(13x,i10,1x,i10,2x,'//base_format_string//',6x)', &
!  &       iostat=ierr) k1,k2,dummy
!      if (read_err.gt.0) then
!        ierr = read_err
!      else if (read_err.lt.0) then
!        exit
!      else if (k1.gt.n1) then
!      else if (k2.gt.n2) then
!      else if (k1.eq.0) then
!        exit
!      else
!        obj(k1,k2) = dummy
!      end if
!    end do

!! loop to read values
    do
      read(unit=funit,&
  &      fmt='(11x,i10,7x,i10,1x)', &
  &         iostat=ierr) k1,k2
      if (read_err.ne.0) then
        ierr = read_err
        exit
      else if (k1.eq.0) then ! reading last entry
        exit
      end if
      read(unit=funit,&
  &      fmt='(13x,'//base_format_string//',3x)', &
  &         iostat=ierr) dummy
      if (k1.gt.n1) then
      else if (k2.gt.n2) then
      else ! assign value only if space is allocated
        obj(k1,k2) = dummy
      end if
    end do

!! close file after reading
    close(unit=funit,iostat=ierr,status='keep')


!--------------------------------------------------------------------
  end subroutine array_read_base
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine array_print_base(name_string,n1,n2,obj,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This routine prints an array to file from a type(base) obj
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
! Input Parameters
!--------------------------------------------------------------------
!! name of file
    character(len=32), intent(in) :: name_string
!! rows of obj1
    integer(kind_integer), intent(in) :: n1
!! columns of obj1
    integer(kind_integer), intent(in) :: n2 
!! obj to be printed
    type(base), intent(in) :: obj(n1,n2)
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! dummy indexes
    integer(kind_integer) :: k1 = 0
    integer(kind_integer) :: k2 = 0
!! file unit
    integer(kind_integer) :: funit = 0
    character(len=32) :: fname = ''
!--------------------------------------------------------------------

!!  find free unit numbers for files
    call find_free_file_unit(funit,ierr)
    if (ierr.ne.0) then
      print *, 'No free file units!'
      ierr = -9
      return
    end if 

!! define fname
    fname = trim(name_string)//'.json'

!! no inquiry if file exists since overwriting of old files is default
!    inquire(file=fname,exist=file_exists)

!! open file
    open(unit=funit,file=fname,action='write',status='replace',iostat=ierr)

!! writing file header
    write(unit=funit,fmt='(a22)', &
  &       iostat=ierr) '{ "type(base)array": {'
    write(unit=funit,fmt='(a10,a32,a2)', &
  &       iostat=ierr) '  "name":"',name_string,'",'
    write(unit=funit,fmt='(a17,i10,a2,i10,a2)', &
  &       iostat=ierr) '  "dimensions":[ ', n1,', ',n2,'],'
    write(unit=funit,fmt='(a18,a32,a2)', &
  &       iostat=ierr) '  "element_type":"',base_print_string,'",'
    write(unit=funit,fmt='(a17,a32,a3)', &
  &   iostat=ierr) '"legend":{"val":"',base_legend_string,'"},'
    write(unit=funit,fmt='(a12)', &
  &       iostat=ierr) '  "array": ['
!    write(unit=funit,fmt='(a2,18x,a3,5x,a6,3x,a8,a32)', &
!  &   iostat=ierr) '//','row','column','element:',base_legend_string

!! loop to print values
    do k2 = 1, n2
      do k1 = 1, n1
!        write(unit=funit,&
!  &      fmt='(4x,a9,i10,a1,i10,a2,'//base_format_string//',a6)', &
!  &         iostat=ierr) '{ "val":[',k1,',',k2,',"',obj(k1,k2),'" ] },'
        write(unit=funit,&
  &      fmt='(4x,a7,i10,a7,i10,a1)', &
  &         iostat=ierr) '{"row":',k1,',"col":',k2,','
        write(unit=funit,&
  &      fmt='(6x,a7,'//base_format_string//',a3)', &
  &         iostat=ierr) '"val":"',obj(k1,k2),'"},'
      end do
    end do

!! print closing lines include dummy matrix element, for formating
!    write(unit=funit,&
!  &  fmt='(4x,a9,i10,a1,i10,a10)', &
!  &       iostat=ierr) '{ "val":[',0,',',0,', null ] }'
    write(unit=funit,&
  &      fmt='(4x,a7,i10,a7,i10,a1)', &
  &         iostat=ierr) '{"row":',0,',"col":',0,','
     write(unit=funit,&
  &      fmt='(6x,a13)', &
  &         iostat=ierr) '"val": null }'
    write(unit=funit,fmt='(a3)', &
  &       iostat=ierr) '  ]'
    write(unit=funit,fmt='(a1)', &
  &       iostat=ierr) '}'
    write(unit=funit,fmt='(a1)', &
  &       iostat=ierr) '}'

!! close file after reading
    close(unit=funit,iostat=ierr,status='keep')


!--------------------------------------------------------------------
  end subroutine array_print_base
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine array_read_float_size(name_string,val,&
  & type_string,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This routine reads in the dimensions of 
!< an array from file, to prepare for reading in an array
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
! Input/Output Parameters
!--------------------------------------------------------------------
!! name of file to be read
    character(len=*), intent(in) :: name_string
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! size of obj
    integer(kind_integer), intent(out) :: val
!! type of data to be read, used for logic checks
    character(len=32), intent(out) :: type_string
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! logic for file existence inquiry
    logical :: file_exists = .false.
!! file unit
    integer(kind_integer) :: funit = 0
    character(len=32) :: fname = ''
!! string for reading extra lines
    character(len=64) :: dummy_string = ''
!--------------------------------------------------------------------

!!  find free unit numbers for files
    call find_free_file_unit(funit,ierr)
    if (ierr.ne.0) then
      print *, 'No free file units!'
      ierr = -9
      return
    end if 
 
!! define fname
    fname = trim(name_string)//'.json'
!! inquire if file exists
    inquire(file=fname,exist=file_exists)
    if (.not.file_exists) then
      print *, 'file to be read does not exist!'
      ierr = -7
      return
    end if

!! open file
    open(unit=funit,file=fname,action='read',iostat=ierr)


!! appropriate checks on file start
    read(unit=funit,fmt='(a28)', &
  &       iostat=ierr) dummy_string
!! Check file header here
    if (ierr.ne.0) then
      print *, 'file does not have header set!'
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -7
      return
    end if
    if (dummy_string.ne.'{ "real(kind_float)array": {') then
      print *, 'file does not have correct header!'
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -7
      return
    end if
    read(unit=funit,fmt='(10x,a32,2x)', &
  &       iostat=ierr) dummy_string
!! name of arry moved to output string
    type_string = trim(dummy_string)
    read(unit=funit,fmt='(17x,i10,2x)', &
  &       iostat=ierr) val
!! Check size of file here
    if (ierr.ne.0) then
      print *, 'file does not have dimensions set!'
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -7
      return
    end if
!! reading precision
    read(unit=funit,fmt='(15x,a32,2x)', &
  &       iostat=ierr) dummy_string
!! check precision
    if (ierr.ne.0) then
      print *, 'file does not have precision header!'
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -7
      return
    else if (dummy_string.ne.float_print_string) then
      print *, 'file precision does not match library!'
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -7
      return
    end if
    read(unit=funit,fmt=*, &
  &       iostat=ierr)
    if (ierr.ne.0) then
      print *, 'file missing legend line!'
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -7
      return
    end if

!! close file
    close(unit=funit,iostat=ierr,status='keep')

!--------------------------------------------------------------------
  end subroutine array_read_float_size
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine array_read_float(name_string,n,obj,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This routine reads in an array from file to a real(kind_float)
!< with already allocated dimensions 
!< (which can be obtained from array_read_size)
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
! Input Parameters
!--------------------------------------------------------------------
!! name of file
    character(len=*), intent(in) :: name_string
!! rows of obj1
    integer(kind_integer), intent(in) :: n
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! obj to be filled
    real(kind_float), intent(out) :: obj(n)
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! dummy indexes
    integer(kind_integer) :: k = 0
!! temp array for values read in
    real(kind_float) :: dummy
!! logic for file existence inquiry
    logical :: file_exists = .false.
!! file unit
    integer(kind_integer) :: funit = 0
    character(len=32) :: fname = ''
!! integer for iostat in read statement
    integer(kind_integer) :: read_err = 0
!--------------------------------------------------------------------

!!  find free unit numbers for files
    call find_free_file_unit(funit,ierr)
    if (ierr.ne.0) then
      print *, 'No free file units!'
      ierr = -9
      return
    end if 

!! define fname
    fname = trim(name_string)//'.json'

!! inquire if file exists
    inquire(file=fname,exist=file_exists)
    if (.not.file_exists) then
      print *, 'file to be read does not exist!'
      ierr = -7
      return
    end if

!! open file
    open(unit=funit,file=fname,action='read',iostat=ierr)
    if (ierr.ne.0) then
      print *, 'Not able to open ',fname
      ierr = -9
      return
    end if 

!! skipping lines,
!! skipping file header
    read(unit=funit,fmt=*, &
  &       iostat=ierr) 
    if (ierr.ne.0) then
      print *, 'read error in ',fname
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -9
      return
    end if 
!! skipping name of array
    read(unit=funit,fmt=*, &
  &       iostat=ierr) 
    if (ierr.ne.0) then
      print *, 'read error in ',fname
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -9
      return
    end if 
!! Skipping dimensions of file
    read(unit=funit,fmt=*, &
  &       iostat=ierr) 
    if (ierr.ne.0) then
      print *, 'read error in ',fname
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -9
      return
    end if 
!! Skipping precision header
    read(unit=funit,fmt=*, &
  &       iostat=ierr) 
    if (ierr.ne.0) then
      print *, 'read error in ',fname
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -9
      return
    end if 
!! Skipping array start 
    read(unit=funit,fmt=*, &
  &       iostat=ierr) 
    if (ierr.ne.0) then
      print *, 'read error in ',fname
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -9
      return
    end if 
!! skip header of columns !! SWAP WITH ABOVE SKIP
    read(unit=funit,fmt=*, &
  &       iostat=ierr)
    if (ierr.ne.0) then
      print *, 'read error in ',fname
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -9
      return
    end if 

!!! loop to read values
!    do
!      read(unit=funit, &
!  &     fmt='(13x,i10,2x,'//float_format_string//',6x)', &
!  &     iostat=read_err) k,dummy
!      if (read_err.gt.0) then
!        ierr = read_err
!      else if (read_err.lt.0) then
!        exit
!      else if (k.gt.n) then
!      else if (k.eq.0) then
!        exit
!      else
!        obj(k) = dummy
!      end if
!    end do

!! loop to read values
    do
      read(unit=funit,&
  &      fmt='(11x,i10,1x)', &
  &         iostat=ierr) k
      if (read_err.ne.0) then
        ierr = read_err
        exit
      else if (k.eq.0) then ! reading last entry
        exit
      end if
      read(unit=funit,&
  &      fmt='(13x,'//float_format_string//',3x)', &
  &         iostat=ierr) dummy
      if (k.gt.n) then
      else ! only read in if space is allocated
        obj(k) = dummy
      end if
    end do

!! close file after reading
    close(unit=funit,iostat=ierr,status='keep')


!--------------------------------------------------------------------
  end subroutine array_read_float
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine array_print_float(name_string,n,obj,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This routine prints an array to file from a real float obj vector
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
! Input Parameters
!--------------------------------------------------------------------
!! name of file
    character(len=32), intent(in) :: name_string
!! rows of obj
    integer(kind_integer), intent(in) :: n
!! obj to be printed
    real(kind_float), intent(in) :: obj(n)
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! dummy indexes
    integer(kind_integer) :: k = 0
!! file unit
    integer(kind_integer) :: funit = 0
    character(len=32) :: fname = ''
!--------------------------------------------------------------------

!!  find free unit numbers for files
    call find_free_file_unit(funit,ierr)
    if (ierr.ne.0) then
      print *, 'No free file units!'
      ierr = -9
      return
    end if 

!! define fname
    fname = trim(name_string)//'.json'

!! no inquiry if file exists, it will be replaced

!! open file
    open(unit=funit,file=fname,action='write',status='replace',iostat=ierr)

!! writing file header
    write(unit=funit,fmt='(a28)', &
  &       iostat=ierr) '{ "real(kind_float)array": {'
    write(unit=funit,fmt='(a10,a32,a2)', &
  &       iostat=ierr) '  "name":"',name_string,'",'
    write(unit=funit,fmt='(a17,i10,a2)', &
  &       iostat=ierr) '  "dimensions":[ ', n,'],'
    write(unit=funit,fmt='(a15,a32,a2)', &
  &       iostat=ierr) '  "precision":"',float_print_string,'",'
    write(unit=funit,fmt='(a24)', &
  &   iostat=ierr) '"legend":{"val":"real"},'
    write(unit=funit,fmt='(a12)', &
  &       iostat=ierr) '  "array": ['
!    write(unit=funit,fmt='(a2,15x,a6,3x,a4)', &
!  &   iostat=ierr) '//','column','real'

!! loop to print values
    do k = 1, n
!      write(unit=funit,&
!  &    fmt='(4x,a9,i10,a2,'//float_format_string//',a6)', &
!  &       iostat=ierr) '{ "val":[',k,',"',obj(k),'" ] },'
        write(unit=funit,&
  &      fmt='(4x,a7,i10,a1)', &
  &         iostat=ierr) '{"col":',k,','
        write(unit=funit,&
  &      fmt='(6x,a7,'//float_format_string//',a3)', &
  &         iostat=ierr) '"val":"',obj(k),'"},'
    end do

!! print closing lines include dummy matrix element, for formating
!    write(unit=funit,&
!  &  fmt='(4x,a9,i10,a10)', &
!  &       iostat=ierr) '{ "val":[',0,', null ] }'
    write(unit=funit,&
  &      fmt='(4x,a7,i10,a1)', &
  &         iostat=ierr) '{"col":',0,','
    write(unit=funit,&
  &      fmt='(6x,a13)', &
  &         iostat=ierr) '"val": null }'
    write(unit=funit,fmt='(a3)', &
  &       iostat=ierr) '  ]'
    write(unit=funit,fmt='(a1)', &
  &       iostat=ierr) '}'
    write(unit=funit,fmt='(a1)', &
  &       iostat=ierr) '}'

!! close file after reading
    close(unit=funit,iostat=ierr,status='keep')


!--------------------------------------------------------------------
  end subroutine array_print_float
!--------------------------------------------------------------------

!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module arrayfile
!--------------------------------------------------------------------
!--------------------------------------------------------------------
